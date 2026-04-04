-- [[ PABLO_DTH HUB v2 - MUSCLE LEGENDS FULL ]] --

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local coreGui = game:GetService("CoreGui")

-- Evitar duplicados
if coreGui:FindFirstChild("PabloDTH_Hub") then coreGui["PabloDTH_Hub"]:Destroy() end

-- CONTENEDOR PRINCIPAL
local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "PabloDTH_Hub"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.4, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- BARRA SUPERIOR AMARILLA
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "👤 PABLO_DTH Hub | Pro Script Edition"
title.TextColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- PESTAÑAS (TABS)
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(1, 0, 0, 30)
tabsFrame.Position = UDim2.new(0, 0, 0, 35)
tabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabsFrame.BorderSizePixel = 0

local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 2)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -10, 1, -80)
contentFrame.Position = UDim2.new(0, 5, 0, 75)
contentFrame.BackgroundTransparency = 1

local pages = {}
local function createTab(name)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.BorderSizePixel = 0

    local page = Instance.new("ScrollingFrame", contentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 2, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 3
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)

    pages[name] = page
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
    return page
end

-- Función para Toggles
local function addToggle(page, text, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, -5, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = "[ OFF ] " .. text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "[ ON ] " .. text or "[ OFF ] " .. text
        btn.TextColor3 = state and Color3.new(0,1,0) or Color3.new(1,1,1)
        callback(state)
    end)
end

-- Función para Botones Simples (Teleport)
local function addButton(page, text, callback)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    btn.MouseButton1Click:Connect(callback)
end

-- --- CREACIÓN DE CONTENIDO ---

local fPage = createTab("Farm")
local sPage = createTab("Stats")
local kPage = createTab("Kills OP")
local tPage = createTab("TP Areas")
local cPage = createTab("Crystals")

pages["Farm"].Visible = true

-- PESTAÑA: FARM
addToggle(fPage, "Auto Lift (Fuerza)", function(v) _G.Lift = v end)
addToggle(fPage, "Auto Agility (Caminadora)", function(v) _G.Agility = v end)
addToggle(fPage, "Auto Durability (Piedras)", function(v) _G.Dura = v end)

-- PESTAÑA: STATS (Visualizador e Info)
local statLabel = Instance.new("TextLabel", sPage)
statLabel.Size = UDim2.new(1, 0, 0, 50)
statLabel.BackgroundTransparency = 1
statLabel.TextColor3 = Color3.new(1,1,1)
statLabel.Text = "Cargando Stats..."
task.spawn(function()
    while task.wait(1) do
        local str = player.leaderstats.Strength.Value
        statLabel.Text = "Fuerza Actual: " .. tostring(str) .. "\nRebirths: " .. tostring(player.leaderstats.Rebirths.Value)
    end
end)

-- PESTAÑA: KILLS OP
addToggle(kPage, "Auto Kill (Jugador más cercano)", function(v) _G.AutoKill = v end)
addToggle(kPage, "Auto Punch (Sin Animación)", function(v) _G.FastPunch = v end)

-- PESTAÑA: TP AREAS
addButton(tPage, "Teleport: Spawn", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 4, 0) end)
addButton(tPage, "Teleport: Frost Gym (Rebirth 1+)", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(-2600, 4, -400) end)
addButton(tPage, "Teleport: Mythical Gym", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(2400, 4, 1000) end)
addButton(tPage, "Teleport: Eternal Gym", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(-60, 4, 1600) end)

-- PESTAÑA: CRYSTALS
addToggle(cPage, "Auto Buy Blue Crystal", function(v) _G.BuyBlue = v end)
addToggle(cPage, "Auto Buy Red Crystal", function(v) _G.BuyRed = v end)

-- --- LÓGICA DE BACKEND ---

task.spawn(function()
    while task.wait(0.1) do
        if _G.Lift then game.ReplicatedStorage.muscleEvent:FireServer("liftWeight", "Weight") end
        if _G.Agility then game.ReplicatedStorage.muscleEvent:FireServer("runOnTreadmill") end
        if _G.Dura then game.ReplicatedStorage.muscleEvent:FireServer("trainDurability", "Rock") end
        
        if _G.AutoKill then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 20 then
                        game.ReplicatedStorage.muscleEvent:FireServer("punch", "Right")
                    end
                end
            end
        end
        
        if _G.BuyBlue then game.ReplicatedStorage.muscleEvent:FireServer("openCrystal", "Blue Crystal") end
    end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("Pablo_DTH Hub v2 cargado con éxito.")
