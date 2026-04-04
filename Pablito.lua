-- [[ PABLO_DTH HUB v3 - FIXED FINAL LOGIC ]] --
local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")

-- 1. BUSCADOR DE EVENTOS (Muscle Legends cambia nombres a veces)
local remote = ReplicatedStorage:FindFirstChild("muscleEvent") or ReplicatedStorage:FindFirstChild("repEvent")

-- Limpiar interfaz anterior para evitar conflictos
if game:GetService("CoreGui"):FindFirstChild("PabloFixV3") then 
    game:GetService("CoreGui").PabloFixV3:Destroy() 
end

-- 2. INTERFAZ ESTILO SUPERNOVA (PABLO_DTH)
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "PabloFixV3"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 200)
main.Position = UDim2.new(0.5, -175, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true

local bar = Instance.new("Frame", main)
bar.Size = UDim2.new(1, 0, 0, 35)
bar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

local title = Instance.new("TextLabel", bar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "PABLO_DTH HUB v3 (LOGIC FIXED)"
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.new(0,0,0)
title.TextSize = 16

-- --- VARIABLES DE ESTADO ---
_G.autoLift = false

-- 3. LÓGICA DE BOTÓN REPARADA (Evita el bucle ON/OFF)
local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.9, 0, 0, 45)
btn.Position = UDim2.new(0.05, 0, 0, 50) -- Debajo de la barra amarilla
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.Text = "[ OFF ] AUTO LIFT (TODAS LAS PESAS)"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold

-- CONTROL DEL CLIC (Lógica Anti-Spam)
btn.MouseButton1Click:Connect(function()
    _G.autoLift = not _G.autoLift -- Cambia el estado (True/False)
    
    if _G.autoLift then
        btn.Text = "[ ON ] AUTO LIFT (TODAS LAS PESAS)"
        btn.TextColor3 = Color3.new(0,1,0) -- Verde para encendido
    else
        btn.Text = "[ OFF ] AUTO LIFT (TODAS LAS PESAS)"
        btn.TextColor3 = Color3.new(1,1,1) -- Blanco para apagado
    end
end)

-- --- BUCLE DE FARM (Se mantiene independiente) ---
task.spawn(function()
    while true do
        if _G.autoLift then
            local char = player.Character
            if char then
                -- Busca CUALQUIER herramienta que sea una pesa
                local tool = player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                
                if tool then
                    -- Equipamiento automático
                    if tool.Parent == player.Backpack then
                        tool.Parent = char
                    end
                    
                    -- DISPARO DOBLE (Registro en Servidor)
                    if remote then
                        -- Intento 1: Evento estándar (Lo que da puntos)
                        remote:FireServer("liftWeight", tool.Name)
                        -- Intento 2: Simulacro de click local
                        tool:Activate()
                    end
                end
            end
        end
        task.wait(0.05) -- Velocidad rápida pero segura
    end
end)

-- ANTI-KICK POR INACTIVIDAD (20 Minutos)
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("PABLO_DTH v3 FIXED FINAL: Lógica de botones reparada. ¡A farmear!")
