-- [[ PABLO_DTH HUB v19 - AUTO-EQUIP TOOL ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- Localizar evento de Muscle Legends
local Remote = RS:WaitForChild("muscleEvent", 10)

-- Limpiar interfaz anterior
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV19") then pgui.PabloV19:Destroy() end

-- --- INTERFAZ ROJA ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV19"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
title.Text = "PABLO_DTH v19 [AUTO-EQUIP]"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold

-- --- BOTÓN DE CONTROL ---
_G.AutoFarm = false

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0, 60)
btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
btn.Text = "ACTIVAR AUTO-EQUIP + CLICK"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold

btn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    btn.Text = _G.AutoFarm and "ON - FARMEANDO" or "OFF - DETENIDO"
    btn.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
end)

-- --- MOTOR DE AUTO-EQUIP Y CLICK ---
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm then
            local char = Player.Character
            if char then
                -- 1. BUSCAR EL PRIMER TOOL EN BACKPACK O PERSONAJE
                local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- 2. FORZAR EQUIPAR (Si está en la mochila, lo pasa al personaje)
                    if tool.Parent == Player.Backpack then
                        tool.Parent = char
                    end
                    
                    -- 3. EJECUTAR ACCIÓN
                    -- Activación física (Animación)
                    tool:Activate()
                    -- Clic virtual (Engaña al sistema de seguridad)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    -- Enviar puntos al servidor
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

print("PABLO_DTH v19 cargado. El primer objeto se equipará solo.")
