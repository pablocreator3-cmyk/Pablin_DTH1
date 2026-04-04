-- [[ PABLO_DTH HUB v28 - COMPATIBILIDAD MÁXIMA ]] --
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local event = rs:WaitForChild("muscleEvent")

-- Limpiar si ya existe
if p.PlayerGui:FindFirstChild("PabloV28") then p.PlayerGui.PabloV28:Destroy() end

-- --- INTERFAZ ---
local sg = Instance.new("ScreenGui", p.PlayerGui)
sg.Name = "PabloV28"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 380, 0, 250)
main.Position = UDim2.new(0.5, -190, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.new(1,0,0)
main.Active = true
main.Draggable = true

-- Pestañas
local f_farm = Instance.new("Frame", main)
f_farm.Size = UDim2.new(1, 0, 1, -40)
f_farm.Position = UDim2.new(0,0,0,40)
f_farm.BackgroundTransparency = 1

local f_rocks = f_farm:Clone()
f_rocks.Parent = main
f_rocks.Visible = false

local function tab(txt, x, target)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.5, 0, 0, 40)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        f_farm.Visible = false
        f_rocks.Visible = false
        target.Visible = true
    end)
end
tab("FARM / POS", 0, f_farm)
tab("ROCAS", 0.5, f_rocks)

-- --- LÓGICA ---
_G.Fuerza = false
_G.Rock = "None"
_G.Lock = false
local lPos = nil

local function btn(txt, y, parent, var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        if var == "Rock" then 
            _G.Rock = txt:gsub(" Rock", "")
            print("Roca: " .. _G.Rock)
        else
            _G[var] = not _G[var]
            b.BackgroundColor3 = _G[var] and Color3.new(1,0,0) or Color3.fromRGB(50,0,0)
            if var == "Lock" and _G.Lock then lPos = p.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Botones Farm
btn("AUTO PESA (EQUIP + CLICK)", 10, f_farm, "Fuerza")
btn("LOCK POSITION", 55, f_farm, "Lock")

-- Botones Rocas (Lista del video)
local rlist = {"Tiny Island", "Starter Island", "Frost Gym", "Mythical Gym", "Muscle King Gym"}
for i, r in ipairs(rlist) do btn(r .. " Rock", (i-1)*38, f_rocks, "Rock") end

-- --- MOTOR ---
task.spawn(function()
    while task.wait(0.01) do
        local c = p.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            if _G.Lock and lPos then c.HumanoidRootPart.CFrame = lPos end
            if _G.Fuerza then
                local t = p.Backpack:FindFirstChildOfClass("Tool") or c:FindFirstChildOfClass("Tool")
                if t and (t.Name:find("Weight") or t.Name:find("Pesa")) then
                    if t.Parent ~= c then c.Humanoid:EquipTool(t) end
                    t:Activate()
                    event:FireServer("liftWeight", t.Name)
                    vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            if _G.Rock ~= "None" then event:FireServer("trainDurability", _G.Rock) end
        end
    end
end)
