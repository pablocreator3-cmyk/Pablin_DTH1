-- [[ PABLO_DTH HUB v37 - EJECUCIÓN INSTANTÁNEA ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpieza de interfaces previas para evitar conflictos
if p.PlayerGui:FindFirstChild("PabloV37") then p.PlayerGui.PabloV37:Destroy() end

-- --- INTERFAZ SUPERNOVA (OPTIMIZADA) ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV37"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 280)
main.Position = UDim2.new(0.5, -200, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Dorado/Amarillo
main.Active = true
main.Draggable = true

-- Cabecera con Nombre Personalizado
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
header.Text = "PABLO_DTH HUB | REPLICA SUPERNOVA"
header.TextColor3 = Color3.new(0,0,0)
header.Font = Enum.Font.GothamBold

-- Sistema de Pestañas (Igual a los videos)
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -10, 1, -40)
container.Position = UDim2.new(0, 5, 0, 35)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 5)

-- --- LÓGICA DE FUNCIONAMIENTO ---
_G.AutoFarm = false
_G.RockSelected = "None"
_G.LockPosition = false
local currentPos = nil

local function addOption(txt, var)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then
            _G.RockSelected = txt:gsub(" Rock", "")
            for _, v in pairs(container:GetChildren()) do 
                if v:IsA("TextButton") and v.Text:find("Rock") then v.TextColor3 = Color3.new(1,1,1) end 
            end
            b.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            _G[var] = not _G[var]
            b.Text = _G[var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[var] and Color3.fromRGB(255, 215, 0) or Color3.new(1,1,1)
            if var == "LockPosition" and _G.LockPosition then currentPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- --- AGREGAR FUNCIONES (Basadas en los videos) ---
addOption("AUTO EQUIP + CLICK PESA", "AutoFarm") --
addOption("CONGELAR POSICION (LOCK)", "LockPosition") --

-- Lista Completa de Rocas de SuperNova
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Eternal Gym", "Muscle King Gym", "Ancient Jungle"}
for _, r in pairs(rocas) do addOption(r .. " Rock", "Rock") end

-- --- MOTOR DE EJECUCIÓN (Bucle Infinito) ---
task.spawn(function()
    while task.wait(0.01) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Fuerza + Autoclick (Tú pedido especial)
            if _G.AutoFarm then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end -- Equipado automático
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) -- Click forzado
                end
            end
            -- Farmeo de Durabilidad en Rocas
            if _G.RockSelected ~= "None" then
                event:FireServer("trainDurability", _G.RockSelected)
            end
            -- Bloqueo de posición para evitar empujones
            if _G.LockPosition and currentPos then
                char.HumanoidRootPart.CFrame = currentPos
            end
        end
    end
end)
