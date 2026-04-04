-- [[ PABLO_DTH HUB v26 - ULTIMATE FIX ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior para evitar crasheos
if p.PlayerGui:FindFirstChild("PabloV26") then p.PlayerGui.PabloV26:Destroy() end

-- --- INTERFAZ ULTRA-COMPATIBLE ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV26"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 220)
main.Position = UDim2.new(0.5, -175, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
title.Text = "PABLO_DTH v26 [LOCK POS]"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

-- --- VARIABLES DE ESTADO ---
_G.Fuerza = false
_G.Lock = false
local posLock = nil

-- --- FUNCIÓN DE BOTONES ---
local function crearBoton(txt, y, callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    
    b.MouseButton1Click:Connect(function()
        local estado = not _G[callback]
        _G[callback] = estado
        b.Text = estado and "[ ON ] " .. txt or "[ OFF ] " .. txt
        b.TextColor3 = estado and Color3.new(255, 0, 0) or Color3.new(1, 1, 1)
        
        -- Guardar posición si se activa Lock
        if callback == "Lock" and estado then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                posLock = p.Character.HumanoidRootPart.CFrame
            end
        end
    end)
end

crearBoton("AUTO EQUIPAR PESA + CLICK", 50, "Fuerza")
crearBoton("LOCK POSITION (CONGELAR)", 110, "Lock")

-- --- MOTOR DEL SCRIPT (EL CORAZÓN) ---
task.spawn(function()
    while task.wait(0.01) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- 1. BLOQUEO DE POSICIÓN (No te mueven)
            if _G.Lock and posLock then
                char.HumanoidRootPart.CFrame = posLock
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            
            -- 2. AUTO EQUIPAR Y FARMEAR
            if _G.Fuerza then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- Forzar a que la tenga en la mano
                    if tool.Parent ~= char then
                        char.Humanoid:EquipTool(tool)
                    end
                    -- Usar la pesa
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end
    end
end)

-- ANTI-AFK
p.Idled:Connect(function() vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
