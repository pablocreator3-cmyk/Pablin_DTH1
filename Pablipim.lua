--// Limpiar ejecuciones previas
if _G.DTH_Loaded then
    _G.DTH_Loaded = false -- Reset para permitir re-ejecución si falló
end

--// Intentar cargar la librería con manejo de errores (pcall)
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reallibrary.lua"))()
end)

if not success or not Library then
    warn("DTH HUB: No se pudo cargar la librería desde GitHub.")
    return
end

--// Configuración de Ventana
local Window = Library.new("DTH HUB - PABLITO", 5013109572)
_G.DTH_Loaded = true

--// Variables de Control (Garantizamos que inicien en falso)
local Settings = {
    LockPos = false,
    AntiAFK = false,
    LockedCFrame = nil
}

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

--// Pestañas
local MainTab = Window:addPage("Principal", 5012544693)
local Section = MainTab:addSection("Funciones")

--// Toggle Lock Position
-- El segundo argumento 'false' asegura que inicie apagado
Section:addToggle("Fijar Posición", false, function(state)
    Settings.LockPos = state
    if state then
        -- Solo captura la posición en el momento exacto del click
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Settings.LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        Settings.LockedCFrame = nil
    end
end)

--// Toggle Anti-AFK
Section:addToggle("Anti-AFK", false, function(state)
    Settings.AntiAFK = state
end)

--// Bucle de Movimiento
RunService.Heartbeat:Connect(function()
    if Settings.LockPos and Settings.LockedCFrame then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Settings.LockedCFrame
        end
    end
end)

--// Anti-AFK
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--// Mensaje final
print("DTH HUB: Cargado con éxito. Arrastra desde la parte superior.")
