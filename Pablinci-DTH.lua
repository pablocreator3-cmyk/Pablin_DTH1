-- 👑 PABLO_DTHPRIME HUB FINAL FUNCIONAL + UI

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")

-- 🔁 CHAR FIX
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
    AutoZone=false,
    AutoKills=false
}

local KillRange = 25
local lastSell,lastRebirth = 0,0

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(),workspace.CurrentCamera.CFrame)
end)

-- 🧠 ZONAS
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

-- ================= UI =================

local gui = Instance.new("ScreenGui", game.CoreGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.5,-250,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,120,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(12,12,12)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,0)
content.Position = UDim2.new(0,120,0,0)

local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1,0,0,40)
    btn.Text = name

    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
    end)

    tabs[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabs) do f.Visible=false end
        frame.Visible=true
    end)

    return frame
end

local function toggle(parent,name)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-10,0,35)
    b.Text = name.." : OFF"
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)

    b.MouseButton1Click:Connect(function()
        Config[name]=not Config[name]
        b.Text = name.." : "..(Config[name] and "ON" or "OFF")
    end)
end

-- TABS
local farm = createTab("Farm")
local combat = createTab("Combat")
tabs["Farm"].Visible = true

-- BOTONES
toggle(farm,"AutoFarmAI")
toggle(farm,"AutoLift")
toggle(farm,"FastLift")
toggle(farm,"AutoSell")
toggle(farm,"AutoRebirth")
toggle(farm,"AutoZone")
toggle(farm,"AutoRock")

toggle(combat,"AutoKills")

-- ================= LOOP =================

task.spawn(function()
    while true do
        local char = getChar()
        if not char:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end

        if Config.AutoFarmAI then
            Config.AutoLift=true
            Config.FastLift=true
            Config.AutoZone=true
            Config.AutoRock=true
            Config.AutoSell=true
            Config.AutoRebirth=true
        end

        -- LIFT
        if Config.AutoLift then
            local speed = Config.FastLift and 5 or 1
            for i=1,speed do
                pcall(function()
                    rs.rEvents.liftWeight:FireServer()
                end)
            end
        end

        -- ROCK / ZONA
        local rock,dist=getRock(char)

        if Config.AutoRock and rock and dist<80 then
            char:MoveTo(rock.Position)
            pcall(function()
                rs.rEvents.punchEvent:FireServer()
            end)
        elseif Config.AutoZone then
            char:MoveTo(bestZone().pos)
        end

        -- SELL
        if Config.AutoSell and getStrength()>100000 and tick()-lastSell>3 then
            pcall(function()
                rs.rEvents.sellStrength:FireServer()
            end)
            lastSell=tick()
        end

        -- REBIRTH
        if Config.AutoRebirth and tick()-lastRebirth>10 then
            pcall(function()
                rs.rEvents.rebirthRemote:InvokeServer()
            end)
            lastRebirth=tick()
        end

        -- COMBAT
        if Config.AutoKills then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v~=player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (char.HumanoidRootPart.Position-v.Character.HumanoidRootPart.Position).Magnitude<KillRange then
                        rs.rEvents.punchEvent:FireServer()
                    end
                end
            end
        end

        task.wait(0.2)
    end
end)
