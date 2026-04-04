-- 👑 PABLO_DTHPRIME GOD HUB FINAL

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local tpService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- CONFIG
getgenv().Config = {
    GodMode=false,
    AutoFarmAI=false,
    AutoLift=false,
    AutoSell=false,
    AutoRebirth=false,
    AutoRock=false,
    AutoZone=false,
    AutoKills=false,
    Stealth=false
}

local KillRange = 25
local lastSell,lastRebirth = 0,0

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- GUI
