-- [[ PABLO_DTH HUB v8 - RAINBOW EDITION ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Limpiar versiones anteriores
if game:GetService("CoreGui"):FindFirstChild("PabloRainbow") then
    game:GetService("CoreGui").PabloRainbow:Destroy()
end

-- --- INTERFAZ ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "PabloRainbow"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 380)
main.Position = UDim2.new(0.5, -225, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- BARRA SUPERIOR (RAINBOW)
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "🌈 PABLO_DTH HUB v8 | RAINBOW EDITION"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 17
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- EFECTO RAINBOW (CICLO RGB)
task.spawn(function()
    while task.wait() do
        local hue = tick() % 5 / 5 -- Cambia la velocidad aquí (más alto = más lento)
        local color = Color3.fromHSV(hue, 1, 1)
        topBar.BackgroundColor3 = color
    end
end)

-- --- CONTENEDOR ---
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
container.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 8)

-- --- FUNCIÓN DE BOTONES ---
local function addToggle(text, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "[ OFF ] " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = enabled and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
        callback(enabled)
    end)
end

-- --- FUNCIONES DEL JUEGO (PROBADAS) ---
_G.AutoLift = false
_G.AutoRocks = false
_G.AutoRebirth = false

addToggle("Auto Strength (Pesas)", function(v) _G.AutoLift = v end)
addToggle("Auto Rocks (Durabilidad)", function(v) _G.AutoRocks = v end)
addToggle("Auto Rebirth (Multiplicador)", function(v) _G.AutoRebirth = v end)

-- --- BUCLE DE ACCIÓN ---
task.spawn(function()
    while true do
        local char = player.Character
        
        -- Fuerza
        if _G.AutoLift and char then
            local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
            if tool and (string.find(tool.Name, "Weight") or string.find(tool.Name, "Pesa")) then
                if tool.Parent == player.Backpack then tool.Parent = char end
                muscleEvent:FireServer("liftWeight", tool.Name)
                tool:Activate()
            end
        end

        -- Rocas (Pega a la roca de la isla inicial por defecto)
        if _G.AutoRocks then
            muscleEvent:FireServer("trainDurability", "Rock")
        end
        
        -- Rebirth
        if _G.AutoRebirth then
            muscleEvent:FireServer("rebirthRequest")
        end

        task.wait(0.05)
    end
end)

-- ANTI-AFK
player.Idled:Connect(function()
    VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("PABLO_DTH Rainbow Hub Cargado!")
