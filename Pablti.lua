-- [[ PABLO_DTH HUB v20 - ONLY WEIGHT EQUIP ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- Localizar evento de Muscle Legends
local Remote = RS:WaitForChild("muscleEvent", 10)

-- Limpiar interfaz anterior
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV20") then pgui.PabloV20:Destroy() end

-- --- INTERFAZ ROJA ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV20"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
title.Text = "PABLO_DTH v20 [PESA ONLY]"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold

-- --- BOTÓN DE CONTROL ---
_G.AutoWeight = false

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 60)
btn.Position = UDim2.new(0.05, 0, 0, 70)
btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
btn.Text = "ACTIVAR: EQUIPAR PESA + CLICK"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16

btn.MouseButton1Click:Connect(function()
    _G.AutoWeight = not _G.AutoWeight
    btn.Text = _G.AutoWeight and "ON - ENTRENANDO PESA" or "OFF - DETENIDO"
    btn.BackgroundColor3 = _G.AutoWeight and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
end)

-- --- MOTOR DE EQUIPADO DE PESA ---
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoWeight then
            local char = Player.Character
            if char then
                -- 1. BUSCAR ESPECÍFICAMENTE UNA PESA (WEIGHT)
                local tool = nil
                
                -- Primero busca en la mochila
                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:find("Weight") or item.Name:find("Pesa")) then
                        tool = item
                        break
                    end
                end
                
                -- Si no está en la mochila, mira si ya está en la mano
                if not tool then
                    local heldItem = char:FindFirstChildOfClass("Tool")
                    if heldItem and (heldItem.Name:find("Weight") or heldItem.Name:find("Pesa")) then
                        tool = heldItem
                    end
                end

                -- 2. SI ENCONTRÓ UNA PESA, EQUIPAR Y USAR
                if tool then
                    if tool.Parent ~= char then
                        tool.Parent = char
                    end
                    
                    -- ACCIÓN DE ENTRENAMIENTO
                    tool:Activate()
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    if Remote then
                        Remote:FireServer("liftWeight", tool.Name)
                    end
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
