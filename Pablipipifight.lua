--[[
    DTH HUB - Versión Oficial
    Funciones: Lock Position, Anti-AFK
    Estilo: Venyx (Elerium)
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reallibrary.lua"))()
local Window = Library.new("DTH HUB - PABLITO", 5013109572)

--// Configuración Global
local Settings = {
    LockPos = false,
    AntiAFK = false,
    LockedCFrame = nil
}

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

--// Interfaz
local MainTab = Window:addPage("Inicio", 5012544693)
local MovementSection = MainTab:addSection("Movimiento")
local MiscSection = MainTab:addSection("Varios")

--// Lógica de Lock Position
MovementSection:addToggle("Fijar Posición (Lock)", false, function(state)
    Settings.LockPos = state
    if state then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Settings.LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        Settings.LockedCFrame = nil
    end
end)

--// Lógica de Anti-AFK
MiscSection:addToggle("Evitar Expulsión (Anti-AFK)", false, function(state)
    Settings.AntiAFK = state
end)

--// Loop de ejecución constante
RunService.Heartbeat:Connect(function()
    if Settings.LockPos and Settings.LockedCFrame then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Settings.LockedCFrame
        end
    end
end)

--// Evento Anti-AFK (Roblox nativo)
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Notificación de carga
print("----------------------------")
print("DTH HUB Cargado con éxito")
print("Desarrollado por Pablo")
print("----------------------------")
