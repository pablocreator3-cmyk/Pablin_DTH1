-- [[ PABLO_DTH HUB v23 - FINAL AUTO-EQUIP WEIGHT ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpieza de interfaces anteriores para evitar errores
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV23") then pgui.PabloV23:Destroy() end

-- --- INTERFAZ ESTILO SUPERNOVA (ROJO) ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV23"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

-- Barra Superior
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 40)
top.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "PABLO_DTH v23 | AUTO-EQUIP PESA"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1

-- --- BOTÓN DE FUERZA (PESA) ---
_G.FarmPesa = false

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.9, 0, 0, 60)
btn.Position = UDim2.new(0.05, 0, 0, 70)
btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
btn.Text = "EQUIPAR PESA + AUTO-CLICK"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18

btn.MouseButton1Click:Connect(function()
    _G.FarmPesa = not _G.FarmPesa
    btn.Text = _G.FarmPesa and "ON - ENTRENANDO" or "OFF - DETENIDO"
    btn.BackgroundColor3 = _G.FarmPesa and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(40, 0, 0)
end)

-- --- MOTOR DE ACCIÓN (FORZADO) ---
task.spawn(function()
    while task.wait(0.01) do
        if _G.FarmPesa then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                -- 1. BUSCAR PESA EN MOCHILA O MANO
                local tool = Player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                
                -- Filtrar solo pesas (como se ve en tus videos anteriores)
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- 2. FORZAR EQUIPAMIENTO REAL
                    if tool.Parent ~= char then
                        char.Humanoid:EquipTool(tool)
                    end
                    
                    -- 3. ACCIÓN DE ENTRENAMIENTO
                    tool:Activate()
                    Remote:FireServer("liftWeight", tool.Name)
                    -- Simular clic físico para evitar detecciones (Bypass)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end
    end
end)

-- ANTI-AFK
Player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton1(Vector2.new())
end)
