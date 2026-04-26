--// Prevenir ejecuciones dobles
if _G.DTH_Loaded then return end
_G.DTH_Loaded = true

--// Cargar Librería
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reallibrary.lua"))()
local Window = Library.new("DTH HUB - PABLITO", 5013109572)

--// Variables de Control
local Settings = {
    LockPos = false,
    AntiAFK = false,
    LockedCFrame = nil
}

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

--// Hacer la interfaz movible manualmente (Fix para móviles)
local UserInputService = game:GetService("UserInputService")
local gui = game:GetService("CoreGui"):FindFirstChild("Venyx") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Venyx")

if gui then
    local frame = gui:FindFirstChild("Main")
    if frame then
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end

--// Páginas
local MainTab = Window:addPage("Principal", 5012544693)
local Section = MainTab:addSection("Funciones")

--// Toggle Lock Position (Corregido para que NO se auto-active)
Section:addToggle("Fijar Posición", false, function(state)
    Settings.LockPos = state
    if state then
        -- Solo guarda la posición cuando el usuario activa el toggle
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Settings.LockedCFrame = Player.Character.HumanoidRootPart.CFrame
        end
    else
        -- Limpia la posición cuando se desactiva
        Settings.LockedCFrame = nil
    end
end)

--// Toggle Anti-AFK
Section:addToggle("Anti-AFK", false, function(state)
    Settings.AntiAFK = state
end)

--// Bucle de Movimiento (Lock Position)
RunService.Heartbeat:Connect(function()
    if Settings.LockPos and Settings.LockedCFrame then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Settings.LockedCFrame
        end
    end
end)

--// Lógica Anti-AFK
Player.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

print("DTH HUB Cargado: Movible y sin auto-activación.")
