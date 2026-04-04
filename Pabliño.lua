-- [[ PABLO_DTH HUB v18 - VERSIÓN DE EMERGENCIA ]] --
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RS = game:GetService("ReplicatedStorage")

-- Intentar localizar el evento de Muscle Legends
local Remote = RS:FindFirstChild("muscleEvent") or RS:WaitForChild("muscleEvent", 5)

-- Eliminar interfaces viejas
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV18") then pgui.PabloV18:Destroy() end

-- --- INTERFAZ ROJA SIMPLE (PARA QUE NO FALLE) ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV18"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 30)
label.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
label.Text = "PABLO_DTH HUB v18"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.SourceSansBold

-- --- BOTÓN DE AUTOCLICK + EQUIP ---
_G.FuerzaActiva = false

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0, 60)
btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
btn.Text = "ACTIVAR AUTO-FUERZA"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold

btn.MouseButton1Click:Connect(function()
    _G.FuerzaActiva = not _G.FuerzaActiva
    btn.Text = _G.FuerzaActiva and "ON - FARMEANDO" or "OFF - DETENIDO"
    btn.BackgroundColor3 = _G.FuerzaActiva and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
end)

-- --- MOTOR DEL SCRIPT ---
task.spawn(function()
    while task.wait(0.01) do
        if _G.FuerzaActiva then
            local char = Player.Character
            if char then
                -- 1. BUSCAR PESA
                local tool = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
                
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- 2. EQUIPAR SIEMPRE
                    if tool.Parent ~= char then
                        tool.Parent = char
                    end
                    -- 3. ACTIVAR Y ENVIAR FUERZA
                    tool:Activate()
                    if Remote then
                        Remote:FireServer("liftWeight", tool.Name)
                    end
                end
            end
        end
    end
end)

print("Si el menú no sale, abre el chat y escribe /console para ver errores.")
