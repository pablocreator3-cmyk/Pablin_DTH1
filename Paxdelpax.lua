-- [[ PABLO_DTH HUB v36 - REPLICA EXACTA OPTIMIZADA ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar interfaz previa para evitar errores en Delta
if p.PlayerGui:FindFirstChild("PabloV36") then p.PlayerGui.PabloV36:Destroy() end

-- --- INTERFAZ ESTILO SUPERNOVA ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV36"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 480, 0, 320)
main.Position = UDim2.new(0.5, -240, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 190, 0) -- Amarillo SuperNova
main.Active = true
main.Draggable = true

-- Título Superior
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 35)
top.BackgroundColor3 = Color3.fromRGB(255, 190, 0)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "PABLO_DTH HUB | REPLICA SUPERNOVA"
title.TextColor3 = Color3.new(0, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Menú Lateral de Pestañas
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0, 120, 1, -35)
tabs.Position = UDim2.new(0, 0, 0, 35)
tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Contenedor de Páginas
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -120, 1, -35)
container.Position = UDim2.new(0, 120, 0, 35)
container.BackgroundTransparency = 1

local pages = {}
local function createPage(name)
    local f = Instance.new("ScrollingFrame", container)
    f.Size = UDim2.new(1, -10, 1, -10)
    f.Position = UDim2.new(0, 5, 0, 5)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ScrollBarThickness = 2
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 5)
    pages[name] = f
    return f
end

local f_main = createPage("Main")
local f_rocks = createPage("Rocks")
local f_misc = createPage("Misc")
f_main.Visible = true

-- Botones de Pestaña (Izquierda)
local function makeTab(txt, target)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.BorderSizePixel = 0
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UIListLayout", tabs)
    
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[target].Visible = true
    end)
end
makeTab("FARMING", "Main")
makeTab("ROCKS", "Rocks")
makeTab("MISC", "Misc")

-- --- LÓGICA DE CONTROL ---
_G.AutoFarm = false
_G.Lock = false
_G.RockType = "None"
local lockedPos = nil

local function addToggle(txt, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then
            _G.RockType = txt:gsub(" Rock", "")
            for _, v in pairs(parent:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end end
            b.TextColor3 = Color3.fromRGB(255, 190, 0)
        else
            _G[var] = not _G[var]
            b.Text = _G[var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[var] and Color3.fromRGB(255, 190, 0) or Color3.new(1, 1, 1)
            if var == "Lock" and _G.Lock then lockedPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Pestaña Principal
addToggle("Auto Equip + Click Pesa", f_main, "AutoFarm")
addToggle("Lock Position", f_main, "Lock")

-- Pestaña Rocas
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Eternal Gym", "Legend Gym", "Muscle King Gym", "Ancient Jungle"}
for _, r in pairs(rocas) do addToggle(r .. " Rock", f_rocks, "Rock") end

-- --- MOTOR DEL SCRIPT (OPTIMIZADO DELTA) ---
task.spawn(function()
    while task.wait(0.01) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Fuerza + Click
            if _G.AutoFarm then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            -- Rock Farm
            if _G.RockType ~= "None" then event:FireServer("trainDurability", _G.RockType) end
            -- Lock Position
            if _G.Lock and lockedPos then
                char.HumanoidRootPart.CFrame = lockedPos
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
end)
