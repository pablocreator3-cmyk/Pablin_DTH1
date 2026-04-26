--[[
    DTH HUB - UNIVERSAL VERSION
    Compatible con: Delta, Fluxus, Hydrogen, Arceus X
    Funciones: Lock Position, Anti-AFK
]]

-- Prevenir múltiples ejecuciones
if _G.DTH_Loaded then 
    print("DTH HUB ya está ejecutándose.")
    return 
end
_G.DTH_Loaded = true

--// Cargador de Librería (Kavo es una de las más estables y universales)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    warn("Error crítico: No se pudo conectar con los servidores de la interfaz.")
    return
end

--// Configuración
local Window = Library.CreateLib("DTH HUB - PABLITO", "DarkTheme")
local Main = Window:NewTab("Principal")
local Section = Main:NewSection("Controles Universales")

local Settings = {
    LockPos = false,
    AntiAFK = false,
    LockedCFrame = nil
}

local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

--// Toggle Lock Position
Section:NewToggle("Fijar Posición (Lock)", "Te mantiene en el mismo lugar", function(state)
    Settings.LockPos = state
    if state then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Settings.LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        Settings.LockedCFrame = nil
    end
end)

--// Toggle Anti-AFK
Section:NewToggle("Anti-AFK", "Evita que el juego te saque por inactividad", function(state)
    Settings.AntiAFK = state
end)

--// Lógica Lock Position (Bucle de alto rendimiento)
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.LockPos and Settings.LockedCFrame then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Settings.LockedCFrame
        end
    end
end)

--// Lógica Anti-AFK (Método Universal)
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("DTH HUB: Anti-AFK activado para evitar kick.")
    end
end)

-- Botón para cerrar la interfaz
Section:NewKeybind("Cerrar Interfaz", "Presiona una tecla para ocultar", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

print("DTH HUB Universal cargado con éxito.")
