-- [[ PABLO_DTH HUB v30 - AUTO-EQUIP & CLICK ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpieza de interfaz
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV30") then pgui.PabloV30:Destroy() end

-- --- INTERFAZ TIPO SUPERNOVA ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV30"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 480, 0, 320)
main.Position = UDim2.new(0.5, -240, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

-- Tabs Header
local tabsHeader = Instance.new("Frame", main)
tabsHeader.Size = UDim2.new(1, 0, 0, 40)
tabsHeader.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

-- Contenedores de Páginas
local function createPage()
    local p = Instance.new("ScrollingFrame", main)
    p.Size = UDim2.new(1, -20, 1, -50)
    p.Position = UDim2.new(0, 10, 0, 45)
    p.BackgroundTransparency = 1
    p.CanvasSize = UDim2.new(0, 0, 2, 0)
    p.Visible = false
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    return p
end

local farmPage = createPage()
local rocksPage = createPage()
local miscPage = createPage()
farmPage.Visible = true

-- Botones de Navegación
local function makeTab(txt, x, target)
    local b = Instance.new("TextButton", tabsHeader)
    b.Size = UDim2.new(0.33, 0, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function()
        farmPage.Visible = false; rocksPage.Visible = false; miscPage.Visible = false
        target.Visible = true
    end)
end

makeTab("FARM", 0, farmPage)
makeTab("ROCKS", 0.33, rocksPage)
makeTab("MISC", 0.66, miscPage)

-- --- LÓGICA DE CONTROL ---
_G.AutoFarm = false
_G.RockType = "None"
_G.LockPos = false
local lCFrame = nil

local function addToggle(txt, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.98, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    
    b.MouseButton1Click:Connect(function()
        _G[callback] = not _G[callback]
        b.Text = _G[callback] and "[ ON ] " .. txt or "[ OFF ] " .. txt
        b.TextColor3 = _G[callback] and Color3.new(255, 0, 0) or Color3.new(1, 1, 1)
        
        if callback == "LockPos" and _G.LockPos then
            if Player.Character then lCFrame = Player.Character.HumanoidRootPart.CFrame end
        end
    end)
end

-- Botones de Farm
addToggle("AUTO EQUIPAR + CLICK PESA", farmPage, "AutoFarm")

-- Botones de Misc
addToggle("LOCK POSITION", miscPage, "LockPos")

-- Botones de Rocks (Lista del video)
local rocas = {"Tiny Island", "Starter Island", "Legend Beach", "Frost Gym", "Mythical Gym", "Muscle King Gym"}
for _, rname in pairs(rocas) do
    local rb = Instance.new("TextButton", rocksPage)
    rb.Size = UDim2.new(0.98, 0, 0, 35)
    rb.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    rb.Text = rname .. " Rock"
    rb.TextColor3 = Color3.new(1, 1, 1)
    rb.MouseButton1Click:Connect(function()
        _G.RockType = rname
        for _, v in pairs(rocksPage:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end end
        rb.TextColor3 = Color3.new(255, 255, 0)
    end)
end

-- --- MOTOR DE EJECUCIÓN ---
task.spawn(function()
    while task.wait(0.01) do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            
            -- Lógica Lock Pos
            if _G.LockPos and lCFrame then
                char.HumanoidRootPart.CFrame = lCFrame
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end

            -- Lógica Auto Pesa + Click
            if _G.AutoFarm then
                local tool = Player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    -- 1. Equipar si no la tiene
                    if tool.Parent ~= char then
                        char.Humanoid:EquipTool(tool)
                    end
                    -- 2. Click Infinito (Activa la herramienta y envía el evento)
                    tool:Activate()
                    Remote:FireServer("liftWeight", tool.Name)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end

            -- Lógica Rocas
            if _G.RockType ~= "None" then
                Remote:FireServer("trainDurability", _G.RockType)
            end
        end
    end
end)

-- Anti-AFK
Player.Idled:Connect(function() VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
