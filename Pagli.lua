-- Cargando Librería Elerium/Venyx Optimizada
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Steventhebest/Venyx-UI-Library/main/Source"))()
local venyx = library.new("Pablito_DTH HUB", 5013109572)

-- Configuración de Páginas
local page = venyx:addPage("Farm", 5012544693)
local section = page:addSection("Estadísticas y Combate")

-- Variables Globales
getgenv().autoStrength = false
getgenv().autoDurability = false
getgenv().autoChakra = false
getgenv().autoSword = false
getgenv().autoQuest = false

-- FUNCIÓN AUTO CLICKER (ESPADA)
section:addToggle("Auto Sword / Clicker", false, function(state)
    getgenv().autoSword = state
    spawn(function()
        while getgenv().autoSword do
            -- Simula el uso de la espada equipada
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            game:GetService("ReplicatedStorage").RSPackage.Events.StatUpdate:FireServer("Attack", "Sword")
            task.wait(0.1)
        end
    end)
end)

-- FUNCIÓN AUTO QUEST (MISIONES)
section:addToggle("Auto Quest (Boomer)", false, function(state)
    getgenv().autoQuest = state
    spawn(function()
        while getgenv().autoQuest do
            -- Evento para aceptar la misión inicial automáticamente
            game:GetService("ReplicatedStorage").RSPackage.Events.Quest:FireServer("Quest", "Boomer", 1)
            task.wait(5) -- Espera para no saturar el servidor
        end
    end)
end)

-- AUTO FARM DE STATS
section:addToggle("Auto Strength", false, function(state)
    getgenv().autoStrength = state
    spawn(function()
        while getgenv().autoStrength do
            game:GetService("ReplicatedStorage").RSPackage.Events.StatUpdate:FireServer("Attack", "Strength")
            task.wait(0.1)
        end
    end)
end)

section:addToggle("Auto Durability", false, function(state)
    getgenv().autoDurability = state
    spawn(function()
        while getgenv().autoDurability do
            game:GetService("ReplicatedStorage").RSPackage.Events.StatUpdate:FireServer("Attack", "Durability")
            task.wait(0.1)
        end
    end)
end)

-- SECCIÓN DE PERSONALIZACIÓN
local settingsPage = venyx:addPage("Config", 5012544693)
local themeSection = settingsPage:addSection("Visuales")

themeSection:addColorPicker("Color Principal", Color3.fromRGB(0, 102, 255), function(color)
    venyx:setTheme("Primary", color)
end)

themeSection:addKeybind("Cerrar Menú", Enum.KeyCode.RightControl, function()
    venyx:toggle()
end)

-- Inicio
venyx:SelectPage(venyx.pages[1], true)
