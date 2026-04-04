-- [[ PABLO_DTH HUB - FUNCIONAL 2026 ]] --
local player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz vieja
if game:GetService("CoreGui"):FindFirstChild("PabloDTH_Hub") then
    game:GetService("CoreGui").PabloDTH_Hub:Destroy()
end

-- Interfaz (Simplificada para asegurar que cargue)
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "PabloDTH_Hub"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- Cabecera Amarilla
local head = Instance.new("Frame", main)
head.Size = UDim2.new(1, 0, 0, 35)
head.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
local title = Instance.new("TextLabel", head)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "👤 PABLO_DTH - REAL FARM"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Botones de Función Real
local function createRealButton(txt, pos, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "[ OFF ] " .. txt
    btn.TextColor3 = Color3.new(1, 1, 1)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = active and "[ ON ] " .. txt or "[ OFF ] " .. txt
        btn.TextColor3 = active and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- --- LÓGICA DE FUERZA (PABLO_DTH) ---
local lifting = false
createRealButton("Auto-Lift Fuerza", 50, function(state) lifting = state end)

task.spawn(function()
    while true do
        if lifting then
            local char = player.Character
            if char then
                -- 1. Buscar la pesa (ajustar nombre si tienes una mejor)
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                
                if tool and (string.find(tool.Name, "Weight") or string.find(tool.Name, "Pesa")) then
                    -- 2. Equipar forzosamente
                    if tool.Parent == player.Backpack then
                        tool.Parent = char
                    end
                    -- 3. Disparar Evento de Servidor (Lo que da los puntos)
                    muscleEvent:FireServer("liftWeight", tool.Name)
                    -- 4. Activar herramienta localmente
                    tool:Activate()
                end
            end
        end
        task.wait(0.05) -- Velocidad máxima segura
    end
end)

-- --- LÓGICA DE VELOCIDAD (AGILITY) ---
local running = false
createRealButton("Auto-Agilidad (Treadmill)", 100, function(state) running = state end)

task.spawn(function()
    while true do
        if running then
            -- Para que esto sirva, DEBES estar parado sobre una caminadora
            muscleEvent:FireServer("runOnTreadmill")
        end
        task.wait(0.05)
    end
end)

-- --- ANTI-AFK REAL ---
-- Evita que el servidor te desconecte por falta de movimiento de cámara
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("Pablo_DTH: Script activo. Asegúrate de tener tu Pesa en el inventario.")
