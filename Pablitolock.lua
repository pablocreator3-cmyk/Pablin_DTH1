--// Cargando Librería (Asegúrate de tener tu librería Elerium/Venyx cargada antes)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reallibrary.lua"))()
local Window = Library.new("DTH HUB - Pablo", 5013109572)

--// Variables de Control
local _G = {
    PositionLocked = false,
    AntiAfkEnabled = false
}

local LockedCFrame = nil
local Player = game.Players.LocalPlayer

--// Pestaña Principal
local MainTab = Window:addPage("Main", 5012544693)
local Section = MainTab:addSection("Automatización")

--// Toggle para Lock Position
Section:addToggle("Lock Position", false, function(state)
    _G.PositionLocked = state
    if state then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        LockedCFrame = nil
    end
end)

--// Toggle para Anti-AFK
Section:addToggle("Anti-AFK", false, function(state)
    _G.AntiAfkEnabled = state
end)

--// Bucle Lógico (Ejecución en segundo plano)
game:GetService("RunService").Heartbeat:Connect(function()
    -- Lógica de Lock Position
    if _G.PositionLocked and LockedCFrame and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = LockedCFrame
    end
end)

--// Lógica Anti-AFK (Evita el Kick por inactividad)
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    if _G.AntiAfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

print("Interfaz de DTH HUB cargada correctamente")
