-- [[ PABLO_DTH HUB v13 - FIX DEFINITIVO ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")

-- Localizar el evento maestro del juego
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior para evitar lag
local pgui = player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloFinalV13") then pgui.PabloFinalV13:Destroy() end

-- --- INTERFAZ ROJA PROFESIONAL ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloFinalV13"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 35)
top.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "PABLO_DTH HUB v13 [ULTRA BYPASS]"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1

-- --- LÓGICA DE BOTONES ---
local function createBtn(text, pos, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = UDim2.new(0.05, 0, 0, pos)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = "[ OFF ] " .. text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = active and "[ ON ] " .. text or "[ OFF ] " .. text
        b.TextColor3 = active and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- --- FUNCIONES MAESTRAS ---
_G.FarmFuerza = false
_G.FarmRocas = false

createBtn("AUTO STRENGTH (FORZAR)", 50, function(v) _G.FarmFuerza = v end)
createBtn("AUTO ROCKS (DURABILIDAD)", 105, function(v) _G.FarmRocas = v end)
createBtn("AUTO REBIRTH (INSTANT)", 160, function(v) muscleEvent:FireServer("rebirthRequest") end)

-- --- EL NÚCLEO QUE SÍ FUNCIONA (BYPASS) ---
task.spawn(function()
    while true do
        if _G.FarmFuerza then
            local char = player.Character
            if char then
                -- 1. Buscamos cualquier herramienta (pesa)
                local tool = char:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
                
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- 2. Equipar si no está en la mano
                    if tool.Parent == player.Backpack then tool.Parent = char end
                    
                    -- 3. TRIPLE DISPARO (Bypass de seguridad)
                    -- Disparo 1: Al servidor directamente
                    muscleEvent:FireServer("liftWeight", tool.Name)
                    -- Disparo 2: Activación local de la herramienta
                    tool:Activate()
                    -- Disparo 3: Simulación de clic de ratón físico
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end
        
        if _G.FarmRocas then
            -- Para las rocas usamos el evento directo de durabilidad
            muscleEvent:FireServer("trainDurability", "Rock")
        end
        
        task.wait(0.01) -- Velocidad máxima permitida
    end
end)

-- ANTI-KICK POR INACTIVIDAD
player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton1(Vector2.new())
end)

print("PABLO_DTH v13: Modo Bypass activado. ¡Esto debe funcionar!")
