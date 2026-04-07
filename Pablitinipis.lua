-- [[ ⚡ DTH HUB V19 - ELERIUM EDITION ⚡ ]]
-- Estilo: Elerium / Old School
-- Optimizado para rendimiento y sin bugs de entrenamiento.

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Venyx = library.new("DTH HUB V19 - ELERIUM STYLE", 5013109572)

-- [[ VARIABLES GLOBALES ]]
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().lockPos = false
local lockedCFrame = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR DE ACCIÓN ---
task.spawn(function()
    while true do
        task.wait(0.05)
        local char = LocalPlayer.Character
        if not char then continue end

        if getgenv().fastWeight then
            local w = LocalPlayer.Backpack:FindFirstChild("Weight") or char:FindFirstChild("Weight")
            if w then 
                if w.Parent ~= char then w.Parent = char end
                ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick") 
            end
        end

        if getgenv().fastPunch then
            local p = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
            if p then 
                if p.Parent ~= char then p.Parent = char end
                ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick") 
            end
        end

        if getgenv().lockPos and char:FindFirstChild("HumanoidRootPart") and lockedCFrame then
            char.HumanoidRootPart.CFrame = lockedCFrame
            char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- PESTAÑAS (THEMES) ---
local Main = Venyx:addPage("Entrenamiento", 5012544693)
local Rocks = Venyx:addPage("Rocas", 5012544693)
local Teleport = Venyx:addPage("Teleports", 5012544693)
local Combat = Venyx:addPage("Combate", 5012544693)
local Settings = Venyx:addPage("Ajustes", 5012544693)

local TrainSection = Main:addSection("Auto Farm")
local RockSection = Rocks:addSection("Durabilidad")
local TPSection = Teleport:addSection("Islas")
local KillSection = Combat:addSection("TP Kill")
local MiscSection = Settings:addSection("Configuración")

-- --- FUNCIONES ---
TrainSection:addToggle("Auto Fuerza", false, function(v) getgenv().fastWeight = v end)
TrainSection:addToggle("Auto Puño", false, function(v) getgenv().fastPunch = v end)

-- --- SISTEMA DE ROCAS ---
local function CreateRock(name, dur)
    RockSection:addToggle(name .. " (" .. dur .. ")", false, function(v)
        getgenv().autoFarm = v
        while getgenv().autoFarm do task.wait(0.01)
            pcall(function()
                for _, m in pairs(workspace.machinesFolder:GetDescendants()) do
                    if m.Name == "neededDurability" and m.Value == dur then
                        local r = m.Parent:FindFirstChild("Rock")
                        if r and LocalPlayer.Character:FindFirstChild("RightHand") then
                            firetouchinterest(r, LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(r, LocalPlayer.Character.RightHand, 1)
                            ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                        end
                    end
                end
            end)
        end
    end)
end

CreateRock("Starter", 100)
CreateRock("Beach", 5000)
CreateRock("Diamond", 20000)
CreateRock("Frost", 150000)
CreateRock("Mythical", 400000)
CreateRock("Eternal", 750000)
CreateRock("Ancient Jungle", 10000000)

-- --- TELEPORTS ---
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Legend Island"] = CFrame.new(4604, 991, -3887)
}

for name, cf in pairs(locs) do
    TPSection:addButton(name, function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end)
end

-- --- COMBATE ---
KillSection:addToggle("Activar Kill Aura", false, function(v) getgenv().autoKill = v end)
task.spawn(function()
    while true do task.wait(0.1)
        if getgenv().autoKill then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                    end)
                end
            end
        end
    end
end)

-- --- MISC ---
MiscSection:addToggle("Fijar Posición", false, function(v)
    if v then lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
    getgenv().lockPos = v
end)

MiscSection:addButton("Destruir GUI", function()
    game:GetService("CoreGui"):FindFirstChild("DTH HUB V19 - ELERIUM STYLE"):Destroy()
end)

-- Notificación final
print("⚡ DTH HUB Cargado con estilo Elerium ⚡")
