local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reallibrary.lua"))()
local venyx = library.new("DTH HUB | Anime Fighting", 5013109572)

-- Configuración de Páginas
local page = venyx:addPage("Farm", 5012544693)
local section = page:addSection("Auto Farm")

-- Variables de Control
getgenv().autoStrength = false
getgenv().autoDurability = false

-- Función Auto Fuerza
section:addToggle("Auto Strength", false, function(value)
    getgenv().autoStrength = value
    spawn(function()
        while getgenv().autoStrength do
            local args = {[1] = "Attack", [2] = "Strength"}
            game:GetService("Players").LocalPlayer.Character.Powers.Strength:Activate()
            game:GetService("ReplicatedStorage").RSPackage.Events.StatUpdate:FireServer(unpack(args))
            wait(0.1)
        end
    end)
end)

-- Función Auto Durabilidad
section:addToggle("Auto Durability", false, function(value)
    getgenv().autoDurability = value
    spawn(function()
        while getgenv().autoDurability do
            local args = {[1] = "Attack", [2] = "Durability"}
            game:GetService("Players").LocalPlayer.Character.Powers.Durability:Activate()
            game:GetService("ReplicatedStorage").RSPackage.Events.StatUpdate:FireServer(unpack(args))
            wait(0.1)
        end
    end)
end)

-- Sección de Ajustes de Interfaz
local themePage = venyx:addPage("Config", 5012544693)
local themeSection = themePage:addSection("Visual")

themeSection:addColorPicker("Theme Color", Color3.fromRGB(0, 170, 255), function(color)
    venyx:setTheme("Primary", color)
end)

themeSection:addKeybind("Ocultar Menú", Enum.KeyCode.RightControl, function()
    venyx:toggle()
end)

-- Notificación de Inicio
venyx:SelectPage(venyx.pages[1], true)
