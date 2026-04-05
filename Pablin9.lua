-- [[ PABLO_DTH HUB v33 - REPLICA TOTAL ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar interfaz previa para Delta
if p.PlayerGui:FindFirstChild("PabloV33") then p.PlayerGui.PabloV33:Destroy() end

-- --- INTERFAZ ESTILO SUPERNOVA (AMARILLO/NEGRO) ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV33"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.5, -210, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 215, 0) -- Dorado de SuperNova
main.Active = true
main.Draggable = true

-- Contenedores de Páginas
local function createPage()
    local f = Instance.new("ScrollingFrame", main)
    f.Size = UDim2.new(1, -10, 1, -50)
    f.Position = UDim2.new(0, 5, 0, 45)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 3
    f.Visible = false
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 5)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return f
end

local f_farm = createPage()
local f_rocks = createPage()
f_farm.Visible = true

-- Pestañas Superiores
local function makeTab(name, x, target)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.5, 0, 0, 40)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    b.Text = name
    b.TextColor3 = Color3.new(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function()
        f_farm.Visible = false; f_rocks.Visible = false; target.Visible = true
    end)
end
makeTab("FARM & MAIN", 0, f_farm)
makeTab("ROCK FARMING", 0.5, f_rocks)

-- --- LÓGICA DE CONTROL ---
_G.AutoMode = false
_G.LockPos = false
_G.SelectedRock = "None"
local savedPos = nil

local function addToggle(txt, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then
            _G.SelectedRock = txt:gsub(" Rock", "")
            for _, v in pairs(parent:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end end
            b.TextColor3 = Color3.fromRGB(255, 215, 0)
        else
            _G[var] = not _G[var]
            b.Text = _G[var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[var] and Color3.fromRGB(255, 215, 0) or Color3.new(1,1,1)
            if var == "LockPos" and _G.LockPos then savedPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- --- BOTONES ---
addToggle("AUTO EQUIP + CLICK PESA", f_farm, "AutoMode") -- Petición especial
addToggle("LOCK POSITION", f_farm, "LockPos")

-- Lista de Rocas del video
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Eternal Gym", "Legend Gym", "Muscle King Gym", "Ancient Jungle"}
for _, r in pairs(rocas) do addToggle(r .. " Rock", f_rocks, "Rock") end

-- --- MOTOR DE EJECUCIÓN (OPTIMIZADO DELTA) ---
task.spawn(function()
    while task.wait(0.01) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- Lock Pos
            if _G.LockPos and savedPos then
                char.HumanoidRootPart.CFrame = savedPos
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            
            -- Auto Equip + Click Pesa
            if _G.AutoMode then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- Equipar automáticamente si está en mochila
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                    -- Click de alta velocidad
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            
            -- Rock Farm
            if _G.SelectedRock ~= "None" then
                event:FireServer("trainDurability", _G.SelectedRock)
            end
        end
    end
end)
