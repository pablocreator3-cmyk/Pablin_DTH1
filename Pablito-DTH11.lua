-- [[ PABLO_DTH HUB v12 - RED EDITION ]] --
local player = game:GetService("Players").LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- Buscador de Remotos
local muscleEvent = RS:FindFirstChild("muscleEvent")

-- Limpiar versión anterior
if pgui:FindFirstChild("PabloRedV12") then
    pgui.PabloRedV12:Destroy()
end

-- --- INTERFAZ ROJA ---
local sg = Instance.new("ScreenGui")
sg.Name = "PabloRedV12"
sg.Parent = pgui
sg.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = sg
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Negro rojizo
main.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Borde Rojo Brillante
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

-- BARRA SUPERIOR ROJA
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Parent = main
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Rojo Oscuro
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔴 PABLO_DTH HUB v12 [RED]"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)

-- --- CONTENEDOR DE BOTONES ---
local list = Instance.new("ScrollingFrame")
list.Parent = main
list.Size = UDim2.new(1, -20, 1, -55)
list.Position = UDim2.new(0, 10, 0, 45)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

local layout = Instance.new("UIListLayout")
layout.Parent = list
layout.Padding = UDim.new(0, 10)

-- --- FUNCIÓN DE BOTONES (ESTILO ROJO) ---
local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = list
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0) -- Fondo botón rojo oscuro
    btn.Text = "[ OFF ] " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.new(1, 1, 1)
        btn.BackgroundColor3 = state and Color3.fromRGB(60, 0, 0) or Color3.fromRGB(40, 0, 0)
        callback(state)
    end)
end

-- --- VARIABLES Y FUNCIONES ---
_G.AutoLift = false
_G.AutoRocks = false
_G.AutoRebirth = false

addToggle("Auto Strength (Pesas)", function(v) _G.AutoLift = v end)
addToggle("Auto Rocks (Durabilidad)", function(v) _G.AutoRocks = v end)
addToggle("Auto Rebirth", function(v) _G.AutoRebirth = v end)

-- --- BUCLE DE ACCIÓN (SÍ FUNCIONA) ---
task.spawn(function()
    while true do
        if _G.AutoLift then
            local char = player.Character
            if char then
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (string.find(tool.Name, "Weight") or string.find(tool.Name, "Pesa")) then
                    if tool.Parent == player.Backpack then tool.Parent = char end
                    if muscleEvent then muscleEvent:FireServer("liftWeight", tool.Name) end
                    tool:Activate()
                end
            end
        end
        
        if _G.AutoRocks then
            if muscleEvent then muscleEvent:FireServer("trainDurability", "Rock") end
        end

        if _G.AutoRebirth then
            if muscleEvent then muscleEvent:FireServer("rebirthRequest") end
        end
        task.wait(0.05)
    end
end)

-- ANTI-AFK
player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

print("PABLO_DTH RED HUB Inyectado Correctamente.")
