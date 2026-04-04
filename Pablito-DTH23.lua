-- [[ PABLO_DTH HUB - MUSCLE LEGENDS ]] --

local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")

-- Evitar duplicados
if coreGui:FindFirstChild("PabloDTH_Hub") then
    coreGui["PabloDTH_Hub"]:Destroy()
end

-- CONTENEDOR PRINCIPAL (Interfaz)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PabloDTH_Hub"
screenGui.Parent = coreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Gris oscuro
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -250, 0.4, -150)
mainFrame.Size = UDim2.new(0, 500, 0, 300) -- Tamaño similar al vídeo
mainFrame.Active = true
mainFrame.Draggable = true -- Se puede mover

-- BARRA SUPERIOR AMARILLA
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Amarillo Oro
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 35)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = topBar
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 0)
title.Size = UDim2.new(1, -10, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.Text = "👤 PABLO_DTH Hub | Usuario: " .. player.Name
title.TextColor3 = Color3.fromRGB(40, 40, 40) -- Texto oscuro sobre amarillo
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left

-- CONTENEDOR DE PESTAÑAS (TABS)
local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "TabsFrame"
tabsFrame.Parent = mainFrame
tabsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Gris medio
tabsFrame.BorderSizePixel = 0
tabsFrame.Position = UDim2.new(0, 0, 0, 35)
tabsFrame.Size = UDim2.new(1, 0, 0, 30)

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.Parent = tabsFrame
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Padding = UDim.new(0, 2)

-- CONTENEDOR DE CONTENIDO (Páginas)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Parent = mainFrame
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 5, 0, 70)
contentFrame.Size = UDim2.new(1, -10, 1, -75)

-- FUNCIÓN PARA CREAR PESTAÑAS Y PÁGINAS
local pages = {}
local function createTab(name, order)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Parent = tabsFrame
    tabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(0, 70, 1, 0) -- Tamaño de pestaña
    tabButton.Font = Enum.Font.SourceSans
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    tabButton.TextSize = 14
    tabButton.LayoutOrder = order

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Parent = contentFrame
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 2, 0) -- Scroll vertical
    page.ScrollBarThickness = 3
    page.Visible = false
    page.BorderSizePixel = 0
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.Padding = UDim.new(0, 5)

    pages[name] = page

    tabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
        for _, b in pairs(tabsFrame:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(55, 55, 55) end
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Destacar pestaña activa
    end)
end

-- CREAR LAS PESTAÑAS (Mismos nombres que en el vídeo)
createTab("Farm", 1)
createTab("Stats", 2)
createTab("Kills OP", 3)
createTab("TP Areas", 4)
createTab("Crystals", 5)
createTab("Credits", 6)

-- Mostrar 'Farm' por defecto
pages["Farm"].Visible = true
tabsFrame:FindFirstChild("FarmTab").BackgroundColor3 = Color3.fromRGB(70, 70, 70)

-- FUNCIÓN PARA CREAR BOTONES DE TOGGLE (ON/OFF)
local function createToggle(parentPage, text, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = text .. "Toggle"
    toggleBtn.Parent = parentPage
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleBtn.Size = UDim2.new(1, -5, 0, 35)
    toggleBtn.Font = Enum.Font.SourceSans
    toggleBtn.Text = "  [ OFF ] " .. text
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 16
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        toggleBtn.Text = state and "  [ ON ] " .. text or "  [ OFF ] " .. text
        toggleBtn.TextColor3 = state and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
    end)
end

-- --- AÑADIR FUNCIONES A LA PÁGINA 'FARM' ---

_G.AutoStrength = false
_G.AutoAgility = false

createToggle(pages["Farm"], "Auto Farm Fuerza (Pesa)", function(state)
    _G.AutoStrength = state
end)

createToggle(pages["Farm"], "Auto Agilidad (Caminadora)", function(state)
    _G.AutoAgility = state
end)

-- --- LÓGICA DE BACKEND (Farm y Anti-AFK) ---

-- Bucle de Farm
task.spawn(function()
    while true do
        if _G.AutoStrength then
            -- Muscle Legends usa este evento para la fuerza
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("liftWeight", "Weight")
        end
        
        if _G.AutoAgility then
            -- Y este para la caminadora
            game:GetService("Players").LocalPlayer.muscleEvent:FireServer("runOnTreadmill")
        end
        
        task.wait(0.1) -- Velocidad del farm (no poner en 0)
    end
end)

-- Anti-AFK (Evita que Roblox te saque a los 20 min)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("PABLO_DTH Hub cargado con éxito. Usa las pestañas para navegar.")
