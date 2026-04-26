-- [[ ⚡ DTH HUB V19.2 - FULL ELERIUM EDITION ⚡ ]]
-- REPARADO: Entrenamiento + Rocas + TP Kill + Todas las Islas + Regalos

local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UI = Venyx.new("Pablo_DTH HUB V19")

-- [[ VARIABLES GLOBALES ]]
getgenv().fWeight = false
getgenv().fPunch = false
getgenv().aKill = false
getgenv().aFarm = false
getgenv().lPos = false
local lockedCF = nil
local targetPlr = nil
local gAmt = 0

local p = game.Players.LocalPlayer
local re = game.ReplicatedStorage.rEvents

-- --- PESTAÑAS ---
local T1 = UI:addPage("Entrenamiento", 5012544693)
local T2 = UI:addPage("Rocas (Todas)", 5012544693)
local T3 = UI:addPage("Teleports", 5012544693)
local T4 = UI:addPage("Combate OP", 5012544693)
local T5 = UI:addPage("Gifts & Misc", 5012544693)

-- 1. SECCIÓN ENTRENAMIENTO
local S1 = T1:addSection("Auto-Clicker")
S1:addToggle("Auto Pesas", false, function(v) getgenv().fWeight = v end)
S1:addToggle("Auto Puños", false, function(v) getgenv().fPunch = v end)

-- 2. SECCIÓN ROCAS (LISTA COMPLETA)
local S2 = T2:addSection("Farm Durabilidad")
local function AddRock(name, dur)
    S2:addToggle(name .. " (" .. dur .. ")", false, function(v)
        getgenv().aFarm = v
        if v then
            task.spawn(function()
                while getgenv().aFarm do
                    task.wait(0.01)
                    pcall(function()
                        for _, m in pairs(workspace.machinesFolder:GetDescendants()) do
                            if m.Name == "neededDurability" and m.Value == dur then
                                local r = m.Parent:FindFirstChild("Rock")
                                if r and p.Character:FindFirstChild("RightHand") then
                                    firetouchinterest(r, p.Character.RightHand, 0)
                                    firetouchinterest(r, p.Character.RightHand, 1)
                                    re.punchEvent:FireServer("punchClick")
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end)
end
AddRock("Starter", 100); AddRock("Beach", 5000); AddRock("Diamond", 20000); 
AddRock("Frost", 150000); AddRock("Mythical", 400000); AddRock("Ancient", 10000000)

-- 3. SECCIÓN TELEPORTS
local S3 = T3:addSection("Islas Disponibles")
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -538
