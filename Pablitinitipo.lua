-- [[ ⚡ DTH HUB V19 - VERSIÓN COMPLETA ELERIUM ⚡ ]]
-- REPARADO: Entrenamiento + Rocas + TP Kill + Gifts + Lock Pos

local Venyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Venyx-UI-Library/main/source2.lua"))()
local UI = Venyx.new("Pablo_DTH HUB V19")

-- [[ VARIABLES GLOBALES ]]
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().lockPos = false
local lockedCFrame = nil
local targetPlayer = nil
local giftAmount = 0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- PESTAÑAS
local Tab1 = UI:addPage("Entrenamiento", 5012544693)
local Tab2 = UI:addPage("Rocas", 5012544693)
local Tab3 = UI:addPage("Teleports", 5012544693)
local Tab4 = UI:addPage("Combate OP", 5012544693)
local Tab5 = UI:addPage("Gifts & Config", 5012544693)

-- 1. SECCIÓN ENTRENAMIENTO
local Section1 = Tab1:addSection("Auto-Clicker")
Section1:addToggle("Auto Fuerza (Pesa)", false, function(v) getgenv().fastWeight = v end)
Section1:addToggle("Auto Puño (Punch)", false, function(v) getgenv().fastPunch = v end)

-- 2. SECCIÓN ROCAS (LISTA COMPLETA)
local Section2 = Tab2:addSection("Farm de Durabilidad")
local function AddRock(name, dur)
    Section2:addToggle(name .. " (" .. dur .. ")", false, function(v)
        getgenv().autoFarm = v
        if v then
            task.spawn(function()
                while getgenv().autoFarm do
                    task.wait(0.01)
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
    end)
end

AddRock("Starter", 100); AddRock("Beach", 5000); AddRock("Diamond", 20000); 
AddRock("Frost", 150000); AddRock("Mythical", 400000); AddRock("Ancient", 10000000)

-- 3. SECCIÓN TELEPORTS
local Section3 = Tab3:addSection("Islas")
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Muscle King (Boss)"] = CFrame.new(-8646, 17, -5738)
}
for n, cf in pairs(locs) do
    Section3:addButton(n, function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end)
end

-- 4. SECCIÓN COMBATE (TP KILL)
local Section4 = Tab4:addSection("Asesino Automático")
Section4:addToggle("Activar TP Kill", false, function(v) getgenv().autoKill = v end)

task.spawn(function()
    while true do
        task.wait(0.1)
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

-- 5. SECCIÓN GIFTS & MISC
local Section5 = Tab5:addSection("Especiales")
Section5:addToggle("Fijar Posición (Lock)", false, function(v)
    if v then lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
    getgenv().lockPos = v
end)

local Section6 = Tab5:addSection("Regalar Protein Eggs")
local playerList = {}
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(playerList, p.Name) end end

Section6:addDropdown("Seleccionar Jugador", playerList, function(selected)
    targetPlayer = Players:FindFirstChild(selected)
end)

Section6:addTextbox("Cantidad", "0", function(text, focusLost)
    if focusLost then giftAmount = tonumber(text) or 0 end
end)

Section6:addButton("Enviar Regalo", function()
    if targetPlayer and giftAmount > 0 then
        for i = 1, giftAmount do
            local item = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
            if item then 
                ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", targetPlayer, item)
                task.wait(0.1)
            end
        end
    end
end)

-- MOTOR PRINCIPAL (Bucle de fondo)
task.spawn(function()
    while true do
        task.wait(0.01)
        -- Loop de Entrenamiento
        if getgenv().fastWeight or getgenv().fastPunch then
            pcall(function()
                local toolName = getgenv().fastWeight and "Weight" or "Punch"
                local event = getgenv().fastWeight and "weightEvent" or "punchEvent"
                local click = getgenv().fastWeight and "weightClick" or "punchClick"
                
                local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or LocalPlayer.Character:FindFirstChild(toolName)
                if tool then
                    if tool.Parent ~= LocalPlayer.Character then tool.Parent = LocalPlayer.Character end
                    ReplicatedStorage.rEvents[event]:FireServer(click)
                end
            end)
        end
        -- Loop de Lock Position
        if getgenv().lockPos and lockedCFrame then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedCFrame
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

UI:SelectPage(Tab1, true)
