-- [[ PABLO_DTH HUB v21 - TABS & AUTO-EQUIP ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV21") then pgui.PabloV21:Destroy() end

-- --- INTERFAZ PRINCIPAL ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV21"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

-- --- SISTEMA DE PESTAÑAS (TABS) ---
local tabButtons = Instance.new("Frame", main)
tabButtons.Size = UDim2.new(1, 0, 0, 40)
tabButtons.BackgroundColor3 = Color3.fromRGB(40, 0, 0)

local function createTabBtn(name, pos, target)
    local btn = Instance.new("TextButton", tabButtons)
    btn.Size = UDim2.new(0.33, 0, 1, 0)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(main:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        target.Visible = true
    end)
end

-- Contenedores de cada pestaña
local farmTab = Instance.new("ScrollingFrame", main)
farmTab.Size = UDim2.new(1, -20, 1, -50)
farmTab.Position = UDim2.new(0, 10, 0, 45)
farmTab.BackgroundTransparency = 1
farmTab.Visible = true

local rocksTab = Instance.new("ScrollingFrame", main)
rocksTab.Size = farmTab.Size
rocksTab.Position = farmTab.Position
rocksTab.BackgroundTransparency = 1
rocksTab.Visible = false

createTabBtn("FARM FUERZA", 0, farmTab)
createTabBtn("FARM ROCAS", 0.33, rocksTab)
createTabBtn("REBIRTH/MISC", 0.66, farmTab) -- Puedes añadir más pestañas luego

local layout1 = Instance.new("UIListLayout", farmTab)
local layout2 = Instance.new("UIListLayout", rocksTab)

-- --- FUNCIÓN PARA CREAR BOTONES ---
local function addToggle(txt, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = active and "[ ON ] " .. txt or "[ OFF ] " .. txt
        b.TextColor3 = active and Color3.new(255, 0, 0) or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- --- LÓGICA DE LAS OPCIONES ---
_G.AutoWeight = false
_G.AutoRocks = false

-- Pestaña Fuerza
addToggle("Auto Pesa (Equipar + Click)", farmTab, function(v) _G.AutoWeight = v end)

-- Pestaña Rocas
addToggle("Tiny Island Rock", rocksTab, function(v) _G.AutoRocks = v end)

-- --- MOTOR DEL SCRIPT ---
task.spawn(function()
    while task.wait(0.01) do
        local char = Player.Character
        if char then
            -- Lógica de Pesa
            if _G.AutoWeight then
                local weight = char:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
                if weight and (weight.Name:find("Weight") or weight.Name:find("Pesa")) then
                    if weight.Parent ~= char then weight.Parent = char end
                    weight:Activate()
                    Remote:FireServer("liftWeight", weight.Name)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            -- Lógica de Rocas
            if _G.AutoRocks then
                Remote:FireServer("trainDurability", "Rock")
            end
        end
    end
end)
