-- [[ PABLO_DTH HUB v22 - FORCE EQUIP & AUTO-FARM ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpiar interfaces anteriores
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV22") then pgui.PabloV22:Destroy() end

-- --- INTERFAZ ESTILO TABS (ROJO) ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV22"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 280)
main.Position = UDim2.new(0.5, -200, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

-- Barra de Pestañas
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(1, 0, 0, 40)
tabs.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local tabTitle = Instance.new("TextLabel", tabs)
tabTitle.Size = UDim2.new(1, 0, 1, 0)
tabTitle.Text = "PABLO_DTH v22 | SELECCIÓN DE PESA"
tabTitle.TextColor3 = Color3.new(1,1,1)
tabTitle.Font = Enum.Font.SourceSansBold
tabTitle.BackgroundTransparency = 1

-- Contenedor
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, 0, 1, -40)
container.Position = UDim2.new(0, 0, 0, 40)
container.BackgroundTransparency = 1

-- --- BOTÓN MAESTRO DE PESA ---
_G.FarmPesa = false

local btn = Instance.new("TextButton", container)
btn.Size = UDim2.new(0.9, 0, 0, 60)
btn.Position = UDim2.new(0.05, 0, 0.1, 0)
btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
btn.Text = "ACTIVAR: EQUIPAR PESA + AUTO-CLICK"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18

btn.MouseButton1Click:Connect(function()
    _G.FarmPesa = not _G.FarmPesa
    btn.Text = _G.FarmPesa and "ON - ENTRENANDO" or "OFF - DETENIDO"
    btn.BackgroundColor3 = _G.FarmPesa and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 0, 0)
end)

-- --- LÓGICA DE EQUIPADO FORZADO (V22) ---
task.spawn(function()
    while task.wait(0.01) do
        if _G.FarmPesa then
            local char = Player.Character
            if char then
                -- Busca cualquier pesa en la mochila
                local tool = Player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                
                -- Verificamos que sea una Pesa (Weight)
                if tool and (string.find(tool.Name, "Weight") or string.find(tool.Name, "Pesa")) then
                    -- FORZAR AL PERSONAJE A SOSTENERLA
                    if tool.Parent ~= char then
                        char.Humanoid:EquipTool(tool)
                    end
                    
                    -- EJECUTAR ENTRENAMIENTO
                    tool:Activate()
                    Remote:FireServer("liftWeight", tool.Name)
                    -- Clic virtual para bypass de seguridad
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end
    end
end)

-- Anti-AFK para evitar desconexiones
Player.Idled:Connect(function()
    VU:CaptureController()
    VU:ClickButton1(Vector2.new())
end)
