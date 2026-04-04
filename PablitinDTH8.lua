-- [[ PABLO_DTH HUB v9 - RAINBOW FIXED ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Intentar cargar en PlayerGui si CoreGui falla
local targetParent = player:WaitForChild("PlayerGui")

if targetParent:FindFirstChild("PabloRainbow") then
    targetParent.PabloRainbow:Destroy()
end

-- --- INTERFAZ PRINCIPAL ---
local sg = Instance.new("ScreenGui", targetParent)
sg.Name = "PabloRainbow"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

-- EFECTO RAINBOW EN BORDE Y BARRA
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "🌈 PABLO_DTH HUB v9 [RAINBOW]"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

task.spawn(function()
    while task.wait() do
        local color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        topBar.BackgroundColor3 = color
        main.BorderColor3 = color
    end
end)

-- --- CONTENEDOR DE BOTONES ---
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
container.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 10)

-- --- FUNCIÓN DE BOTONES ---
local function addToggle(text, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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

-- --- FUNCIONES REALES ---
_G.AutoLift = false
_G.AutoRocks = false
_G.AutoRebirth = false

addToggle("Auto Lift Strength", function(v) _G.AutoLift = v end)
addToggle("Auto Rocks (Initial Island)", function(v) _G.AutoRocks = v end)
addToggle("Auto Rebirth", function(v) _G.AutoRebirth = v end)

-- --- BUCLE DE FUNCIONAMIENTO ---
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
            muscleEvent:FireServer("trainDurability", "Rock")
        end
        
        if _G.AutoRebirth then
            muscleEvent:FireServer("rebirthRequest")
        end
        task.wait(0.05)
    end
end)

-- ANTI-AFK
player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new())
end)

print("PABLO_DTH HUB: Ejecutado en PlayerGui con éxito.")
