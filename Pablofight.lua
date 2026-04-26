--// Verificación de carga para evitar errores
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if not success then 
    warn("Error al cargar la interfaz. Reintentando con fuente alternativa...")
    -- Fuente alternativa si la primera falla
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/VynixuLib/main/VynixuLib.lua"))()
end

--// Configuración de la Ventana
local Window = Library:CreateWindow({
   Name = "DTH HUB - PABLITO",
   LoadingTitle = "Cargando Configuración...",
   LoadingSubtitle = "by Pablo",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DTH_Configs"
   }
})

--// Variables
local _G = {
    PositionLocked = false,
    AntiAfkEnabled = false
}
local LockedCFrame = nil
local Player = game.Players.LocalPlayer

--// Pestaña Principal
local Tab = Window:CreateTab("Principal", 4483345998)

--// Toggle Lock Position
Tab:CreateToggle({
   Name = "Lock Position",
   CurrentValue = false,
   Callback = function(Value)
      _G.PositionLocked = Value
      if Value and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
          LockedCFrame = Player.Character.HumanoidRootPart.CFrame
      end
   end,
})

--// Toggle Anti-AFK
Tab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Callback = function(Value)
      _G.AntiAfkEnabled = Value
   end,
})

--// Lógica en Segundo Plano
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.PositionLocked and LockedCFrame and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = LockedCFrame
    end
end)

-- Lógica Anti-AFK mejorada
Player.Idled:Connect(function()
    if _G.AntiAfkEnabled then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
