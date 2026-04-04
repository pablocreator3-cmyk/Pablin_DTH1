-- [[ PABLO_DTH HUB v6 - ROCKS & ISLANDS UPDATE ]] --
local player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local muscleEvent = RS:WaitForChild("muscleEvent")

-- Limpiar versiones previas
if game:GetService("CoreGui"):FindFirstChild("PabloRocksHub") then
    game:GetService("CoreGui").PabloRocksHub:Destroy()
end

-- --- INTERFAZ ESTILO SUPERNOVA ---
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "PabloRocksHub"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 480, 0, 350)
main.Position = UDim2.new(0.5, -240, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.Active = true
main.Draggable = true

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "💪 PABLO_DTH HUB v6 | ROCKS & FARM"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(0,0,0)

-- --- SISTEMA DE PESTAÑAS ---
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(1, 0, 0, 30)
tabs.Position = UDim2.new(0, 0, 0, 35)
tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -10, 1, -75)
container.Position = UDim2.new(0, 5, 0, 70)
container.BackgroundTransparency = 1

local pages = {}
local function createTab(name, pos)
    local btn = Instance.new("TextButton", tabs)
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, pos, 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    
    local pg = Instance.new("ScrollingFrame", container)
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.Visible = false
    pg.BackgroundTransparency = 1
    pg.CanvasSize = UDim2.new(0,0,2,0)
    
    local layout = Instance.new("UIListLayout", pg)
    layout.Padding = UDim.new(0, 5)
    
    pages[name] = pg
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pg.Visible = true
    end)
    return pg
end

local farmPg = createTab("Main Farm", 0)
local rockPg = createTab("Rocks (Islands)", 125)

pages["Main Farm"].Visible = true

-- --- FUNCIONES DE ROCAS ---
_G.RockFarm = false
_G.CurrentRock = "Rock"

local function addRockToggle(pg, name, rockName, tpPos)
    local btn = Instance.new("TextButton", pg)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = "[ OFF ] " .. name
    btn.TextColor3 = Color3.new(1,1,1)
    
    btn.MouseButton1Click:Connect(function()
        _G.RockFarm = not _G.RockFarm
        if _G.RockFarm then
            _G.CurrentRock = rockName
            player.Character.HumanoidRootPart.CFrame = tpPos
            btn.Text = "[ ON ] " .. name
            btn.TextColor3 = Color3.new(0,1,0)
        else
            btn.Text = "[ OFF ] " .. name
            btn.TextColor3 = Color3.new(1,1,1)
        end
    end)
end

-- --- CONFIGURACIÓN DE ROCAS POR ISLA ---
-- Coordenadas aproximadas para Muscle Legends 2026
addRockToggle(rockPg, "Tiny Island Rock (Durability)", "Rock", CFrame.new(-40, 5, 1140))
addRockToggle(rockPg, "Legends Island Rock", "Legendary Rock", CFrame.new(4620, 1005, 560))
addRockToggle(rockPg, "Eternal Island Rock", "Eternal Rock", CFrame.new(-70, 5, 1640))
addRockToggle(rockPg, "Mythical Island Rock", "Mythical Rock", CFrame.new(2450, 5, 1050))

-- --- FUNCIÓN DE FUERZA (PESTAÑA PRINCIPAL) ---
local function addToggle(pg, text, callback)
    local btn = Instance.new("TextButton", pg)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = "[ OFF ] " .. text
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        btn.Text = s and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = s and Color3.new(0,1,0) or Color3.new(1,1,1)
        callback(s)
    end)
end

addToggle(farmPg, "Auto Lift Strength", function(v) _G.Lift = v end)
addToggle(farmPg, "Auto Rebirth", function(v) _G.Rebirth = v end)

-- --- BUCLE MAESTRO (BACKEND) ---
task.spawn(function()
    while true do
        -- Farm de Fuerza
        if _G.Lift then
            local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
            if tool and string.find(tool.Name, "Weight") then
                if tool.Parent == player.Backpack then tool.Parent = player.Character end
                muscleEvent:FireServer("liftWeight", tool.Name)
            end
        end
        
        -- Farm de Rocas (Durabilidad)
        if _G.RockFarm then
            -- Muscle Legends requiere disparar trainDurability con el nombre de la roca
            muscleEvent:FireServer("trainDurability", _G.CurrentRock)
        end
        
        if _G.Rebirth then muscleEvent:FireServer("rebirthRequest") end
        
        task.wait(0.05)
    end
end)

-- ANTI-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("PABLO_DTH HUB v6: Pestaña de Rocas añadida. ¡A entrenar durabilidad!")
