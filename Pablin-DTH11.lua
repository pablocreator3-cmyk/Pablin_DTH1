-- [[ MUSCLE LEGENDS GUI - PABLIN_DTH EDITION ]] --

local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")

-- Limpiar versiones anteriores para evitar errores
if coreGui:FindFirstChild("PablinHub") then
    coreGui.PablinHub:Destroy()
end

-- Contenedor Principal
local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "PablinHub"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.4, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- Fondo más oscuro
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Puedes moverlo por la pantalla

-- Barra Superior (Estilo SuperNova Amarilla)
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Amarillo Oro
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "👤 PABLIN_DTH Hub | Bienvenido " .. player.Name
title.TextColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Menú de Pestañas (Debajo de la barra amarilla)
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabFrame.BorderSizePixel = 0

local tabText = Instance.new("TextLabel", tabFrame)
tabText.Size = UDim2.new(1, 0, 1, 0)
tabText.Text = "Farm   |   Stats   |   Kills OP   |   TP Areas"
tabText.TextColor3 = Color3.fromRGB(200, 200, 200)
tabText.Font = Enum.Font.SourceSans
tabText.TextSize = 14
tabText.BackgroundTransparency = 1

-- Contenedor de Opciones
local content = Instance.new("ScrollingFrame", mainFrame)
content.Size = UDim2.new(1, -20, 1, -85)
content.Position = UDim2.new(0, 10, 0, 75)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 2, 0)
content.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 6)

-- Función para Crear Checkboxes/Toggles
local function addToggle(text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Text = "  [ OFF ] " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "  [ ON ] " .. text or "  [ OFF ] " .. text
        btn.TextColor3 = state and Color3.fromRGB(255, 215, 0) or Color3.new(1, 1, 1)
        callback(state)
    end)
end

-- --- FUNCIONES DE FARM ---
_G.AutoStrength = false

addToggle("Auto Farm Fuerza (Weight)", function(val)
    _G.AutoStrength = val
end)

addToggle("Auto Agility (Treadmill)", function(val)
    _G.AutoAgility = val
end)

addToggle("Auto Kill (Safe Mode)", function(val)
    _G.AutoKill = val
    print("Auto Kill en Muscle Legends activado")
end)

-- Bucle Lógico (Farm)
task.spawn(function()
    while true do
        if _G.AutoStrength then
            local char = player.Character
            if char then
                -- Intenta usar la pesa y disparar el evento
                game:GetService("Players").LocalPlayer.muscleEvent:FireServer("liftWeight", "Weight")
            end
        end
        
        if _G.AutoAgility then
             game:GetService("Players").LocalPlayer.muscleEvent:FireServer("runOnTreadmill")
        end
        
        task.wait(0.1)
    end
end)

-- Anti-AFK (Imprescindible para farmear de noche)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("PABLIN_DTH Hub cargado con éxito.")
