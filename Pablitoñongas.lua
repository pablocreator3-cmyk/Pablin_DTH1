-- Cargar la librería de interfaz Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Crear la ventana principal
local Window = OrionLib:MakeWindow({Name = "Legends Hub | Auto Farm", HidePremium = false, SaveConfig = true, ConfigFolder = "LegendsConfig"})

-- Crear la pestaña de Auto Farm
local FarmTab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Crear la pestaña de Equipamiento
local EquipTab = Window:MakeTab({
	Name = "Equipamiento",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- VARIABLES GLOBALES
local getgenv = getgenv or function() return _G end
getgenv().AutoPunch = false
getgenv().FastPunch = false
getgenv().AutoStrength = false
getgenv().AutoFases = false
getgenv().AutoEquipFist = false
getgenv().AutoEquipPiece = false

local Player = game:GetService("Players").LocalPlayer

-------------------------------------------------------------------------
-- PESTAÑA: AUTO FARM (Combate y Stats)
-------------------------------------------------------------------------

FarmTab:AddToggle({
	Name = "Auto Punch (Golpe Normal)",
	Default = false,
	Callback = function(Value)
		getgenv().AutoPunch = Value
		while getgenv().AutoPunch do
			task.wait(0.5) -- Velocidad normal de golpe
			-- REEMPLAZA ESTO CON EL REMOTE DE TU JUEGO:
			-- Ejemplo: game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()
		end
	end    
})

FarmTab:AddToggle({
	Name = "Fast Punch (Golpe Rápido)",
	Default = false,
	Callback = function(Value)
		getgenv().FastPunch = Value
		while getgenv().FastPunch do
			task.wait() -- Sin tiempo de espera (spam)
			-- REEMPLAZA ESTO CON EL REMOTE DE TU JUEGO:
			-- Ejemplo: game:GetService("ReplicatedStorage").Remotes.Punch:FireServer()
		end
	end    
})

FarmTab:AddToggle({
	Name = "Auto Strength (Entrenar Fuerza)",
	Default = false,
	Callback = function(Value)
		getgenv().AutoStrength = Value
		while getgenv().AutoStrength do
			task.wait(0.1)
			-- REEMPLAZA ESTO CON EL REMOTE PARA FUERZA/STRENGTH:
			-- Ejemplo: game:GetService("ReplicatedStorage").Remotes.AddStrength:FireServer()
		end
	end    
})

FarmTab:AddToggle({
	Name = "Auto Fases / Transformaciones",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFases = Value
		while getgenv().AutoFases do
			task.wait(1)
			-- REEMPLAZA ESTO CON EL REMOTE DE TRANSFORMARSE:
			-- Ejemplo: game:GetService("ReplicatedStorage").Remotes.Transform:FireServer()
		end
	end    
})

-------------------------------------------------------------------------
-- PESTAÑA: EQUIPAMIENTO AUTOMÁTICO
-------------------------------------------------------------------------

-- Función para equipar herramientas por nombre
local function equipTool(toolName)
    local backpack = Player:FindFirstChild("Backpack")
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")

    if backpack and humanoid then
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            humanoid:EquipTool(tool)
        end
    end
end

EquipTab:AddToggle({
	Name = "Auto Equipar Puño (Fist)",
	Default = false,
	Callback = function(Value)
		getgenv().AutoEquipFist = Value
		while getgenv().AutoEquipFist do
			task.wait(0.5)
            -- Cambia "Fist" o "Combat" por el nombre exacto del arma en tu inventario
			equipTool("Combat") 
		end
	end    
})

EquipTab:AddToggle({
	Name = "Auto Equipar Pieza / Arma",
	Default = false,
	Callback = function(Value)
		getgenv().AutoEquipPiece = Value
		while getgenv().AutoEquipPiece do
			task.wait(0.5)
            -- Cambia "Sword", "Piece" o el nombre de tu herramienta aquí
			equipTool("Piece") 
		end
	end    
})

-- Iniciar la interfaz
OrionLib:Init()
