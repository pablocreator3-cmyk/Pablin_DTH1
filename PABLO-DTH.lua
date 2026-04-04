-- 👑 FIXED GOD HUB (FUNCIONA 100%)

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")

-- 🔁 CHARACTER FIX
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- CONFIG
getgenv().Config = {
    AutoFarmAI=false,
    AutoLift=false,
    FastLift=false,
    AutoSell=false,
    AutoRebirth=false,
    AutoRock=false,
    AutoZone=false
}

local lastSell,lastRebirth = 0,0

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

-- 🧠 ZONAS (FIX)
local zones={
    {pos=Vector3.new(0,10,0),req=0},
    {pos=Vector3.new(-2600,20,-600),req=5000},
    {pos=Vector3.new(800,20,2500),req=50000},
    {pos=Vector3.new(-8600,20,-6000),req=500000}
}

local function getStrength()
    local ls=player:FindFirstChild("leaderstats")
    return ls and ls:FindFirstChild("Strength") and ls.Strength.Value or 0
end

local function bestZone()
    local s=getStrength()
    local best=zones[1]
    for _,z in pairs(zones) do
        if s>=z.req then best=z end
    end
    return best
end

-- 🪨 ROCA
local function getRock(char)
    local best,dist=nil,math.huge
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name:lower():find("rock") then
            local d=(char.HumanoidRootPart.Position-v.Position).Magnitude
            if d<dist then dist=d best=v end
        end
    end
    return best,dist
end

-- 🎛️ UI SIMPLE (para que sí cargue)
local gui=Instance.new("ScreenGui",game.CoreGui)
local btn=Instance.new("TextButton",gui)
btn.Size=UDim2.new(0,150,0,50)
btn.Position=UDim2.new(0,10,0.5,0)
btn.Text="Toggle Farm"

btn.MouseButton1Click:Connect(function()
    Config.AutoFarmAI = not Config.AutoFarmAI
end)

-- 🚀 LOOP PRINCIPAL (FIX TOTAL)
task.spawn(function()
    while true do
        local char = getChar()
        
        if not char:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            continue
        end

        -- AI
        if Config.AutoFarmAI then
            Config.AutoLift=true
            Config.FastLift=true
            Config.AutoZone=true
            Config.AutoRock=true
            Config.AutoSell=true
            Config.AutoRebirth=true
        end

        -- 💪 LIFT
        if Config.AutoLift then
            local speed = Config.FastLift and 5 or 1
            for i=1,speed do
                pcall(function()
                    rs.rEvents.liftWeight:FireServer()
                end)
            end
        end

        -- 🪨 ROCK / ZONA
        local rock,dist=getRock(char)

        if Config.AutoRock and rock and dist<80 then
            char:MoveTo(rock.Position)
            pcall(function()
                rs.rEvents.punchEvent:FireServer()
            end)
        elseif Config.AutoZone then
            char:MoveTo(bestZone().pos)
        end

        -- 💰 SELL
        if Config.AutoSell and getStrength()>100000 and tick()-lastSell>3 then
            pcall(function()
                rs.rEvents.sellStrength:FireServer()
            end)
            lastSell=tick()
        end

        -- 🔁 REBIRTH
        if Config.AutoRebirth and tick()-lastRebirth>10 then
            pcall(function()
                rs.rEvents.rebirthRemote:InvokeServer()
            end)
            lastRebirth=tick()
        end

        task.wait(0.2)
    end
end)
