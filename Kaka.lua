-- [[ PABLO_DTH HUB v31 - OPTIMIZADO PARA DELTA ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar rastro anterior
if p.PlayerGui:FindFirstChild("PabloV31") then p.PlayerGui.PabloV28:Destroy() end

-- --- INTERFAZ COMPATIBLE CON DELTA ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV31"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(0.5, -180, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.new(1,0,0)
main.Active = true
main.Draggable = true

-- Títulos y Pestañas Simples
local f_farm = Instance.new("Frame", main)
f_farm.Size = UDim2.new(1, 0, 1, -40)
f_farm.Position = UDim2.new(0,0,0,40)
f_farm.BackgroundTransparency = 1

local f_rocks = f_farm:Clone()
f_rocks.Parent = main
f_rocks.Visible = false

local function tab(name, x, target)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.5, 0, 0, 40)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.MouseButton1Click:Connect(function()
        f_farm.Visible = false; f_rocks.Visible = false; target.Visible = true
    end)
end
tab("FARM & LOCK", 0, f_farm)
tab("ROCAS", 0.5, f_rocks)

-- --- LÓGICA DE FUNCIONAMIENTO ---
_G.Auto = false
_G.Rock = "None"
_G.Lock = false
local lPos = nil

local function btn(txt, y, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then 
            _G.Rock = txt:gsub(" Rock", "")
        else
            _G[var] = not _G[var]
            b.BackgroundColor3 = _G[var] and Color3.new(1,0,0) or Color3.fromRGB(45,0,0)
            if var == "Lock" and _G.Lock then lPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Controles Farm
btn("EQUIPAR + AUTOCLICK PESA", 10, f_farm, "Auto")
btn("CONGELAR POSICION (LOCK)", 55, f_farm, "Lock")

-- Controles Rocas (Las más importantes del video)
local rocas = {"Tiny Island", "Starter Island", "Frost Gym", "Mythical Gym", "Muscle King Gym"}
for i, r in ipairs(rocas) do btn(r .. " Rock", (i-1)*36, f_rocks, "Rock") end

-- --- EL MOTOR (Optimizado para evitar lag en Delta) ---
task.spawn(function()
    while task.wait(0.01) do
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            -- Bloqueo de posición
            if _G.Lock and lPos then c.HumanoidRootPart.CFrame = lPos end
            
            -- Auto Pesa + Click
            if _G.Auto then
                local t = p.Backpack:FindFirstChildOfClass("Tool") or c:FindFirstChildOfClass("Tool")
                if t and (t.Name:find("Weight") or t.Name:find("Pesa")) then
                    if t.Parent ~= c then c.Humanoid:EquipTool(t) end
                    t:Activate()
                    event:FireServer("liftWeight", t.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            
            -- Farm de Rocas
            if _G.Rock ~= "None" then event:FireServer("trainDurability", _G.Rock) end
        end
    end
end)
