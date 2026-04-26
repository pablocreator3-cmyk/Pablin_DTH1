-- [[ ⚡ DTH HUB V19 FINAL - ELERIUM EDITION ⚡ ]]
-- Autor: Pablo_DTH

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

-- [[ PESTAÑAS ]]
local Tab1 = UI:addPage("Entrenamiento", 5012544693)
local Tab2 = UI:addPage("Rocas", 5012544693)
local Tab3 = UI:addPage("Teleports", 5012544693)
local Tab4 = UI:addPage("Combate OP", 5012544693)
local Tab5 = UI:addPage("Gifts & Misc", 5012544693)

-- 1. ENTRENAMIENTO
local Section1 = Tab1:addSection("Auto-Clicker")
Section1:addToggle("Auto Fuerza (Pesas)", false, function(v) getgenv().fastWeight = v end)
Section1:addToggle("Auto Puño (Golpes)", false, function(v) getgenv().
