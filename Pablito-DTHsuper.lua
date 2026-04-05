local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Pablo_DTH Hub 🚀 | Muscle Legends", "Midnight")

-- VARIABLES DE CONTROL
local _G = {
    AutoPunch = false,
    AutoWeights = false,
    AutoRebirth = false,
    AutoEvolve = false
}

-- PESTAÑA DE FARM
local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Entrenamiento Automático")

FarmSection:NewToggle("Auto Punch (Fuerza)", "Entrena puños sin parar", function(state)
    _G.AutoPunch = state
    while _G.AutoPunch do
        task.wait(0.1)
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch") or game.Players.LocalPlayer.Character:FindFirstChild("Punch")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            tool:Activate()
        end
    end
end)

FarmSection:NewToggle("Auto Pesas (Fuerza)", "Usa las pesas automáticamente", function(state)
    _G.AutoWeights = state
    while _G.AutoWeights do
        task.wait(0.1)
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Weight") or game.Players.LocalPlayer.Character:FindFirstChild("Weight")
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            tool:Activate()
        end
    end
end)

-- PESTAÑA DE PROGRESO
local ProgressTab = Window:NewTab("Progreso")
local ProgressSection = ProgressTab:NewSection("Evolución Automática")

ProgressSection:NewToggle("Auto Rebirth", "Renace apenas tengas la fuerza necesaria", function(state)
    _G.AutoRebirth = state
    while _G.AutoRebirth do
        task.wait(1)
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
    end
end)

ProgressSection:NewToggle("Auto Evolve Pets", "Evoluciona tus mascotas automáticamente", function(state)
    _G.AutoEvolve = state
    while _G.AutoEvolve do
        task.wait(2)
        game:GetService("ReplicatedStorage").rEvents.petEvolveEvent:FireServer("evolvePetRequest")
    end
end)

-- PESTAÑA DE JUGADOR
local PlayerTab = Window:NewTab("Jugador")
local PlayerSection = PlayerTab:NewSection("Habilidades")

PlayerSection:NewSlider("Velocidad", "Corre como un flash", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlayerSection:NewSlider("Salto", "Llega a la luna", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- PESTAÑA DE CRÉDITOS
local CreditTab = Window:NewTab("Créditos")
local CreditSection = CreditTab:NewSection("Creado por Pablo_DTH")

CreditSection:NewKeybind("Cerrar/Abrir Menú", "Tecla: RightControl", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Notificación de Bienvenida
game.StarterGui:SetCore("SendNotification", {
    Title = "Pablo_DTH Hub";
    Text = "¡Listo para dominar Muscle Legends!";
    Duration = 5;
})
