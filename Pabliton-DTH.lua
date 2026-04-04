-- [[ PABLO_DTH HUB v10 - FINAL RAINBOW FIX ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Intentar usar CoreGui (Estándar para scripts)
local targetParent = game:GetService("CoreGui")

-- Limpiar si ya existe
if targetParent:FindFirstChild("PabloRainbowV10") then
    targetParent.PabloRainbowV10:Destroy()
end

-- --- CREACIÓN DE INTERFAZ ---
local sg = Instance.new("ScreenGui")
sg.Name = "PabloRainbowV10"
sg.Parent = targetParent
sg.IgnoreGuiInset = true

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Parent = sg
main.Size = UDim2.new(0, 420, 0, 350)
main.Position = UDim2.new(0.5, -210, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true -- Para que puedas moverlo

-- --- BARRA SUPERIOR RAINBOW ---
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Parent = main
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🌈 PABLO_DTH HUB | RAINBOW v10"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)

-- ANIMACIÓN RAINBOW (RGB)
task.spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        topBar.BackgroundColor3 = color
        main.BorderColor3 = color
    end
end)

-- --- CONTENEDOR DE FUNCIONES ---
local container = Instance.new("ScrollingFrame")
container.Parent = main
container.Size = UDim2.new(1, -20, 1, -55)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
container.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout")
layout.Parent = container
layout.Padding = UDim.new(0, 10)

-- --- FUNCIÓN PARA BOTONES ---
local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = container
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "[ OFF ] " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = enabled and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
        callback(enabled)
    end)
end

-- --- ESTADOS DE LAS FUNCIONES ---
_G.AutoLift = false
_G.AutoRocks = false
_G.AutoRebirth = false

-- AÑADIR FUNCIONES
addToggle("Auto Strength (Pesas)", function(v) _G.AutoLift = v end)
addToggle("Auto Rocks (Todas las Islas)", function(v) _G.AutoRocks = v end)
addToggle("Auto Rebirth", function(v) _G.AutoRebirth = v end)

-- --- BUCLE DE ACCIÓN REAL ---
task.spawn(function()
    while true do
        if _G.AutoLift then
            local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
            if tool and (string.find(tool.Name, "Weight") or string.find(tool.Name, "Pesa")) then
                if tool.Parent == player.Backpack then tool.Parent = player.Character end
                muscleEvent:FireServer("liftWeight", tool.Name)
                tool:Activate()
            end
        end

        if _G.AutoRocks then
            -- Farmea la roca básica por defecto (puedes cambiar "Rock" por "Crystal Rock" etc.)
            muscleEvent:FireServer("trainDurability", "Rock")
        end
        
        if _G.AutoRebirth then
            muscleEvent:FireServer("rebirthRequest")
        end
        task.wait(0.05)
    end
end)

-- ANTI-AFK (Evita el error de inactividad)
player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

print("PABLO_DTH HUB v10 Ejecutado con éxito.")
