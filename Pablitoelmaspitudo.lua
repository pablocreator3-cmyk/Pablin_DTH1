local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Configuración de la ventana principal con tu nombre
local Window = OrionLib:MakeWindow({
    Name = "Pablito_DTH | Script Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "PablitoDTHConfig",
    IntroText = "Cargando Pablito_DTH..."
})

-- PESTAÑA: FARM (Basada en el video)
local FarmTab = Window:MakeTab({
	Name = "Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

FarmTab:AddToggle({
	Name = "Strength Op (250 ms)",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
		while _G.AutoFarm do
			-- Evento de entrenamiento (ajustar según el juego)
			local args = {[1] = "Rep", [2] = "Weight"}
			game:GetService("Players").LocalPlayer.muscleEvent:FireServer(unpack(args))
			task.wait(0.25) -- Simula el delay de 250ms del video
		end
	end    
})

FarmTab:AddButton({
	Name = "Full Optimization (Anti-Lag)",
	Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Color = Color3.new(0.5, 0.5, 0.5)
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        print("Juego optimizado por Pablito_DTH")
  	end    
})

-- PESTAÑA: STATS
local StatsTab = Window:MakeTab({
	Name = "Stats",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

StatsTab:AddLabel("Visualizador de Stats")

-- PESTAÑA: KILLS OP
local KillsTab = Window:MakeTab({
	Name = "Kills OP",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

KillsTab:AddToggle({
	Name = "Auto Kill Target",
	Default = false,
	Callback = function(Value)
		_G.KillLoop = Value
        -- Lógica de ataque automático aquí
	end    
})

-- PESTAÑA: TP AREAS
local TPTab = Window:MakeTab({
	Name = "TP Areas",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Areas = {"Spawn", "Jungle Island", "Tiny Island", "Legend Beach"}
TPTab:AddDropdown({
	Name = "Seleccionar Area",
	Default = "Spawn",
	Options = Areas,
	Callback = function(Value)
		print("Teletransportando a: " .. Value)
        -- Aquí agregarías las coordenadas CFrame.new() para cada isla
	end    
})

-- Finalizar e inicializar
OrionLib:Init()
