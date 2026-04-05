local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Creamos la ventana con un tamaño más reducido
local Window = Library.CreateLib("Pablo_DTH Hub v2", "Midnight")

-- VARIABLES
local _G = {
    AutoPunch = false,
    AutoWeights = false,
    AutoRebirth = false,
    AutoEvolve = false,
    AutoBrawl = false
}

-- PESTAÑA COMPACTA DE FARM
local FarmTab = Window:NewTab("Farm")
local FarmSection = FarmTab:NewSection("Entrenamiento")

FarmSection:NewToggle("Auto Punch", "Golpea solo", function(state)
    _G.AutoPunch = state
    while _G.AutoPunch do
        task.wait(0.1)
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch") or game.Players.LocalPlayer.Character:FindFirstChild("Punch")
        if tool then tool:Activate() end
    end
end)

FarmSection:NewToggle("Auto Pesas", "Entrena fuerza", function(state)
    _G.AutoWeights = state
    while _G.AutoWeights do
        task.wait(0.1)
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight") or game.Players.LocalPlayer.Character:FindFirstChild("Weight")
        if tool then tool:Activate() end
    end
end)

-- PESTAÑA DE AUTO-ACCIONES
local AutoTab = Window:NewTab("Auto")
local AutoSection = AutoTab:NewSection("Automatización")

AutoSection:NewToggle("Auto Rebirth", "Renacer solo", function(state)
    _G.AutoRebirth = state
    while _G.AutoRebirth do
        task.wait(1)
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
    end
end)

AutoSection:NewToggle("Join Brawl", "Entra a peleas solo", function(state)
    _G.AutoBrawl = state
    while _G.AutoBrawl do
        task.wait(2)
        game:GetService("ReplicatedStorage").rEvents.brawlEvent:FireServer("joinBrawl")
    end
end)

-- PESTAÑA DE JUGADOR (MÁS PEQUEÑA)
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Stats")

PlayerSection:NewSlider("Speed", "Velocidad", 200, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- PESTAÑA DE CRÉDITOS
local Config = Window:NewTab("Config")
local ConfigSection = Config:NewSection("Pablo_DTH - Compact")

ConfigSection:NewKeybind("Cerrar Menú", "Ocultar", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
