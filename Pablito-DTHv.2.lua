-- [[ PABLO_DTH HUB v16 - EL ÚLTIMO INTENTO ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- 1. BUSCAR EL EVENTO (Si esto falla, el script no corre)
local Remote = RS:FindFirstChild("muscleEvent") or RS:WaitForChild("muscleEvent", 5)

-- 2. CREAR INTERFAZ (Rojo Intenso)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PabloRedFinal"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 250)
Main.Position = UDim2.new(0.5, -175, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.Text = "PABLO_DTH HUB v16 [RED]"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- --- LÓGICA DE BOTONES ---
local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    btn.Text = "[ OFF ] " .. text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = active and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = active and Color3.new(255, 0, 0) or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- --- FUNCIONES ---
_G.AutoStrength = false
_G.AutoRocks = false

CreateButton("AUTO FUERZA (PESAS)", 50, function(v) _G.AutoStrength = v end)
CreateButton("AUTO ROCAS (DURAB)", 105, function(v) _G.AutoRocks = v end)
CreateButton("AUTO REBIRTH", 160, function(v) Remote:FireServer("rebirthRequest") end)

-- --- BUCLE DE ACCIÓN (BACKEND) ---
task.spawn(function()
    while true do
        if _G.AutoStrength then
            local char = Player.Character
            local tool = char and char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
            if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                if tool.Parent == Player.Backpack then tool.Parent = char end
                Remote:FireServer("liftWeight", tool.Name)
                tool:Activate()
            end
        end
        if _G.AutoRocks then
            Remote:FireServer("trainDurability", "Rock")
        end
        task.wait(0.01)
    end
end)

-- ANTI-AFK
Player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton1(Vector2.new())
end)

print("PABLO_DTH HUB v16: Si ves esto en la consola F9, el script SI ejecutó.")
