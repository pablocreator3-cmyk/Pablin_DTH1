--[[ 
    DTH HUB - UNIVERSAL FIX
    Desarrollado para: Pablo
    Librería: Kavo (Modificada para estabilidad)
]]

--// Asegurar que no se duplique
if _G.DTH_Executed then return end
_G.DTH_Executed = true

--// Cargador Seguro
local function LoadLib()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end

local success, Library = pcall(LoadLib)
if not success then
    warn("Error al cargar la librería. El enlace de GitHub podría estar caído.")
    return
end

--// Configuración inicial
local Window = Library.CreateLib("DTH HUB - PABLITO", "Midnight")
local Tab = Window:NewTab("Principal")
local Section = Tab:NewSection("Controles")

local Settings = {
    LockPos = false,
    AntiAFK = false,
    LockedCFrame = nil
}

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

--// TOGGLE LOCK POSITION
Section:NewToggle("Lock Position", "Te congela en el lugar actual", function(state)
    Settings.LockPos = state
    if state then
        -- Captura la posición SOLO cuando activas el botón
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Settings.LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        Settings.LockedCFrame = nil
    end
end)

--// TOGGLE ANTI-AFK
Section:NewToggle("Anti-AFK", "Evita que te saquen del juego", function(state)
    Settings.AntiAFK = state
end)

--// BUCLE DE POSICIÓN (Optimizado para no laggear)
RunService.Heartbeat:Connect(function()
    if Settings.LockPos and Settings.LockedCFrame then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Settings.LockedCFrame
        end
    end
end)

--// ANTI-AFK (Método de seguridad)
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--// NOTA: Esta librería permite mover la ventana arrastrando el título
print("DTH HUB Cargado Correctamente")
