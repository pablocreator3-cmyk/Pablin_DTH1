local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Interfaz de color ROJO (BloodTheme)
local Window = Library.CreateLib("Pablo_DTH Hub | Muscle Legends", "BloodTheme")

-- VARIABLES
local _G = {
    AutoPunch = false,
    AutoWeights = false,
    AutoRebirth = false
}

-- FUNCIÓN PARA EQUIPAR Y USAR AUTOMÁTICAMENTE
local function equipAndUse(toolName)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local tool = player.Backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
    
    if tool then
        if not character:FindFirstChild(toolName) then
            character.Humanoid:EquipTool(tool)
        end
        tool:Activate()
    end
end

-- PESTAÑA FARM
local FarmTab = Window:NewTab("Farm")
local FarmSection = FarmTab:NewSection("Auto Entrenamiento")

FarmSection:NewToggle("Auto Punch", "Equipa puño y golpea solo", function(state)
    _G.AutoPunch = state
    while _G.AutoPunch do
        task.wait(0.1)
        equipAndUse("Punch")
    end
end)

FarmSection:NewToggle("Auto Pesas", "Equipa pesa y entrena solo", function(state)
    _G.AutoWeights = state
    while _G.AutoWeights do
        task.wait(0.1)
        -- Busca cualquier objeto que contenga "Weight" (Pesa)
        equipAndUse("Weight") 
    end
end)

-- PESTAÑA PROGRESO
local AutoTab = Window:NewTab("Auto")
local AutoSection = AutoTab:NewSection("Progreso")

AutoSection:NewToggle("Auto Rebirth", "Renacer automáticamente", function(state)
    _G.AutoRebirth = state
    while _G.AutoRebirth do
        task.wait(1)
        game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
    end
end)

-- PESTAÑA DE CONFIGURACIÓN Y BOTÓN DE CERRAR
local Config = Window:NewTab("Menu")
local ConfigSection = Config:NewSection("Opciones de Interfaz")

ConfigSection:NewButton("Cerrar Interfaz (Ocultar)", "Esconde el menú de Pablo_DTH", function()
    Library:ToggleUI()
end)

ConfigSection:NewKeybind("Tecla para abrir/cerrar", "Default: RightControl", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Notificación roja de éxito
game.StarterGui:SetCore("SendNotification", {
    Title = "Pablo_DTH Hub";
    Text = "Interfaz Roja Cargada. ¡A entrenar!";
    Duration = 5;
})
