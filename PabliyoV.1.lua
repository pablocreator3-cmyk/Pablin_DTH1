-- [[ PABLO_DTH HUB v17 - AUTO-EQUIP & CLICK ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior
local pgui = player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV17Red") then pgui.PabloV17Red:Destroy() end

-- --- INTERFAZ ROJA ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV17Red"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 380, 0, 280)
main.Position = UDim2.new(0.5, -190, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 35)
top.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "PABLO_DTH HUB v17 [EQUIP & CLICK]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1

-- --- LÓGICA DE AUTO-EQUIP Y CLICK ---
_G.AutoStrength = false

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.9, 0, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0, 60)
btn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
btn.Text = "[ OFF ] AUTO STRENGTH + EQUIP"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16

btn.MouseButton1Click:Connect(function()
    _G.AutoStrength = not _G.AutoStrength
    btn.Text = _G.AutoStrength and "[ ON ] AUTO STRENGTH + EQUIP" or "[ OFF ] AUTO STRENGTH + EQUIP"
    btn.TextColor3 = _G.AutoStrength and Color3.fromRGB(255, 0, 0) or Color3.new(1, 1, 1)
end)

-- --- EL MOTOR (ESTO ES LO QUE HACE EL TRABAJO) ---
task.spawn(function()
    while true do
        if _G.AutoStrength then
            local char = player.Character
            if char then
                -- 1. BUSCAR Y EQUIPAR LA PESA AUTOMÁTICAMENTE
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- Si la pesa está en la mochila, la equipa
                    if tool.Parent == player.Backpack then
                        tool.Parent = char
                    end
                    
                    -- 2. AUTOCLICK Y REGISTRO (TRES MÉTODOS A LA VEZ)
                    -- Envía la fuerza al servidor
                    muscleEvent:FireServer("liftWeight", tool.Name)
                    -- Hace la animación de la pesa
                    tool:Activate()
                    -- Simula un clic real del ratón en la pantalla
                    VU:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                end
            end
        end
        task.wait(0.01) -- Velocidad ultra rápida
    end
end)

-- ANTI-AFK (Para que no te saque el juego)
player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton1(Vector2.new())
end)

print("PABLO_DTH v17: ¡Activado! Ahora equipa y hace clic solo.")
