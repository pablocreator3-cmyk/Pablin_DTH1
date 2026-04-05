-- [[ PABLO_DTH HUB v32 - DELTA & SUPERNOVA STYLE ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpieza para evitar errores en Delta
if p.PlayerGui:FindFirstChild("PabloV32") then p.PlayerGui.PabloV32:Destroy() end

-- --- INTERFAZ ESTILO SUPERNOVA ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV32"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 280)
main.Position = UDim2.new(0.5, -210, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Negro
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 200, 0) -- Dorado/Amarillo como el video
main.Active = true
main.Draggable = true

-- Contenedores de Pestañas
local f_farm = Instance.new("ScrollingFrame", main)
f_farm.Size = UDim2.new(1, -10, 1, -45)
f_farm.Position = UDim2.new(0, 5, 0, 42)
f_farm.BackgroundTransparency = 1
f_farm.ScrollBarThickness = 4

local f_rocks = f_farm:Clone()
f_rocks.Parent = main
f_rocks.Visible = false

local function makeTab(name, x, target)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.5, 0, 0, 40)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    b.Text = name
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(0,0,0)
    b.MouseButton1Click:Connect(function()
        f_farm.Visible = false; f_rocks.Visible = false; target.Visible = true
    end)
end
makeTab("MAIN FARM", 0, f_farm)
makeTab("ROCKS LIST", 0.5, f_rocks)

local function layout(p)
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0, 5)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
end
layout(f_farm)
layout(f_rocks)

-- --- LÓGICA DE CONTROL ---
_G.AutoEquipClick = false
_G.Lock = false
_G.Rock = "None"
local lPos = nil

local function btn(txt, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then 
            _G.Rock = txt:gsub(" Rock", "")
            for _, v in pairs(parent:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end end
            b.TextColor3 = Color3.new(255, 200, 0)
        else
            _G[var] = not _G[var]
            b.Text = _G[var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[var] and Color3.new(255, 200, 0) or Color3.new(1,1,1)
            if var == "Lock" and _G.Lock then lPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Botones Pestaña 1
btn("AUTO PESA (EQUIP + CLICK)", f_farm, "AutoEquipClick")
btn("CONGELAR POSICION (LOCK)", f_farm, "Lock")

-- Botones Pestaña 2 (Rocas del video)
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Eternal Gym", "Legend Gym", "Muscle King Gym", "Ancient Jungle"}
for _, r in pairs(rocas) do btn(r .. " Rock", f_rocks, "Rock") end

-- --- MOTOR DEL SCRIPT ---
task.spawn(function()
    while task.wait(0.01) do
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            -- 1. Lock Pos
            if _G.Lock and lPos then
                c.HumanoidRootPart.CFrame = lPos
                c.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            
            -- 2. Auto Equip + Click (Tu petición especial)
            if _G.AutoEquipClick then
                local tool = p.Backpack:FindFirstChildOfClass("Tool") or c:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- Equipado Automático
                    if tool.Parent ~= c then c.Humanoid:EquipTool(tool) end
                    -- Auto Click + Evento de Fuerza
                    tool:Activate()
                    event:FireServer("liftWeight", tool.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            
            -- 3. Farm de Rocas
            if _G.Rock ~= "None" then
                event:FireServer("trainDurability", _G.Rock)
            end
        end
    end
end)
