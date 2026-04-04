-- 👑 PABLO_DTHPRIME SPEED HUB GOD

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local tpService = game:GetService("TeleportService")
local vu = game:GetService("VirtualUser")

-- CONFIG
getgenv().Config = {
    GodMode=false,
    AutoFarmAI=false,
    AutoLift=false,
    FastLift=false,
    AutoSell=false,
    AutoRebirth=false,
    AutoRock=false,
    AutoZone=false,
    AutoKills=false,
    Stealth=false
}

local KillRange = 25
local lastSell,lastRebirth=0,0

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

-- 👑 UI SPEED HUB
local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,500,0,320)
main.Position = UDim2.new(0.5,-250,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Instance.new("UICorner",main).CornerRadius=UDim.new(0,10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,255,150)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,120,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(12,12
