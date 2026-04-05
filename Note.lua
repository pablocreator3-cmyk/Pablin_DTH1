-- [[ PABLO_DTH HUB v34 - THE SUPERNOVA REPLICA ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior
if p.PlayerGui:FindFirstChild("PabloV34") then p.PlayerGui.PabloV34:Destroy() end

-- --- INTERFAZ ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV34"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 320)
main.Position = UDim2.new(0.5, -225, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 200, 0)
main.Active = true
main.Draggable = true

-- Título personalizado
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
title.Text = "PABLO_DTH HUB By Johan | Cracked By PABLO"
title.TextColor3 = Color3.new(0, 0, 0)
title.Font = Enum.Font.GothamBold

-- Contenedor de Páginas
local function createPage()
    local f = Instance.new("ScrollingFrame", main)
    f.Size = UDim2.new(1, -10, 1, -75)
    f.Position = UDim2.new(0, 5, 0, 70)
    f.BackgroundTransparency = 1
    f.ScrollBarThickness = 3
    f.Visible = false
    local l = Instance.new("UIListLayout", f)
    l.Padding = UDim.new(0, 5)
    return f
end

local f_farm = createPage()
local f_rocks = createPage()
local f_misc = createPage()
f_farm.Visible = true

-- Barra de Pestañas (Igual al video)
local function tab(txt, x, target)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.33, 0, 0, 35)
    b.Position = UDim2.new(x, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function()
        f_farm.Visible = false; f_rocks.Visible = false; f_misc.Visible = false
        target.Visible = true
    end)
end
tab("Farm", 0, f_farm)
tab("Rocks", 0.33, f_rocks)
tab("Misc", 0.66, f_misc)

-- --- FUNCIONES ---
_G.AutoPesa = false
_G.Lock = false
_G.SelRock = "None"
local lPos = nil

local function addToggle(txt, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then
            _G.SelRock = txt:gsub(" Rock", "")
            for _, v in pairs(parent:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end end
            b.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            _G[var] = not _G[var]
            b.Text = _G[var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[var] and Color3.fromRGB(255, 200, 0) or Color3.new(1,1,1)
            if var == "Lock" and _G.Lock then lPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Pestaña Farm
addToggle("Auto Strength (Equip + Click)", f_farm, "AutoPesa")
addToggle("Lock Position", f_farm, "Lock")

-- Pestaña Rocks (Todas las del video de SuperNova)
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Eternal Gym", "Legend Gym", "Muscle King Gym", "Ancient Jungle"}
for _, r in pairs(rocas) do addToggle(r .. " Rock", f_rocks, "Rock") end

-- Pestaña Misc
local t_afk = Instance.new("TextLabel", f_misc)
t_afk.Size = UDim2.new(1, 0, 0, 30)
t_afk.Text = "Anti-AFK: Habilitado Automáticamente"
t_afk.TextColor3 = Color3.new(1,1,1)
t_afk.BackgroundTransparency = 1

-- --- MOTOR DE EJECUCIÓN ---
task.spawn(function()
    while task.wait(0.01) do
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Fuerza + Autoclick
            if _G.AutoPesa then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            -- Rocas
            if _G.SelRock ~= "None" then event:FireServer("trainDurability", _G.SelRock) end
            -- Lock Pos
            if _G.Lock and lPos then char.HumanoidRootPart.CFrame = lPos end
        end
    end
end)
