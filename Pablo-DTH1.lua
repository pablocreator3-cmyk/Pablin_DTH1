-- 👑 PABLO_DTHPRIME ULTRA HUB (UI + FARM COMPLETO)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local tpService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- CONFIG
getgenv().Config = {
    AutoFarmAI=false,
    AutoLift=false,
    AutoSell=false,
    AutoKills=false,
    AutoRebirth=false,
    AutoRock=false,
    AutoZone=false,
    Stealth=false
}

getgenv().KillRange = 25

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- GUI BASE
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 340)
main.Position = UDim2.new(0.05,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- DRAG
local drag=false
local dragStart,startPos
main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag=true
        dragStart=i.Position
        startPos=main.Position
    end
end)

main.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag=false
    end
end)

UIS.InputChanged:Connect(function(i)
    if drag then
        local delta=i.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.Text = "👑 Pablo_DTHPRIME ULTRA"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1
title.TextScaled = true

-- 📏 COMPACT MODE
local compact=false
local normal=UDim2.new(0,400,0,340)
local small=UDim2.new(0,200,0,120)

local resizeBtn=Instance.new("TextButton", main)
resizeBtn.Size=UDim2.new(0,110,0,25)
resizeBtn.Position=UDim2.new(1,-115,0,5)
resizeBtn.Text="Compact"

local function resize(size)
    TweenService:Create(main,TweenInfo.new(0.25),{Size=size}):Play()
end

resizeBtn.MouseButton1Click:Connect(function()
    compact=not compact
    if compact then
        resize(small)
        resizeBtn.Text="Expand"
        for _,v in pairs(main:GetChildren()) do
            if v~=title and v~=resizeBtn then
                v.Visible=false
            end
        end
    else
        resize(normal)
        resizeBtn.Text="Compact"
        for _,v in pairs(main:GetChildren()) do
            v.Visible=true
        end
    end
end)

-- TABS
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,35)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-65)
content.Position = UDim2.new(0,0,0,65)

local tabs={}

local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0,100,1,0)
    btn.Text = name

    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.ScrollBarThickness = 5
    frame.Visible=false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+15)
    end)

    tabs[name]=frame

    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabs) do f.Visible=false end
        frame.Visible=true
    end)

    return frame
end

-- UI ELEMENTS
local function section(parent,text)
    local s=Instance.new("TextLabel",parent)
    s.Size=UDim2.new(1,-10,0,25)
    s.Text="   "..text
    s.TextColor3=Color3.fromRGB(0,255,150)
    s.BackgroundColor3=Color3.fromRGB(20,20,20)
end

local function toggle(parent,name)
    local holder=Instance.new("Frame",parent)
    holder.Size=UDim2.new(1,-10,0,40)
    holder.BackgroundColor3=Color3.fromRGB(30,30,30)

    local label=Instance.new("TextLabel",holder)
    label.Size=UDim2.new(0.7,0,1,0)
    label.Text=name
    label.BackgroundTransparency=1
    label.TextColor3=Color3.new(1,1,1)

    local btn=Instance.new("TextButton",holder)
    btn.Size=UDim2.new(0,50,0,22)
    btn.Position=UDim2.new(1,-60,0.5,-11)
    btn.Text=""

    local circle=Instance.new("Frame",btn)
    circle.Size=UDim2.new(0,20,0,20)
    circle.Position=UDim2.new(0,1,0,1)

    local state=false

    btn.MouseButton1Click:Connect(function()
        state=not state
        Config[name]=state

        if state then
            btn.BackgroundColor3=Color3.fromRGB(0,200,120)
            circle:TweenPosition(UDim2.new(1,-21,0,1),"Out","Quad",0.2,true)
        else
            btn.BackgroundColor3=Color3.fromRGB(50,50,50)
            circle:TweenPosition(UDim2.new(0,1,0,1),"Out","Quad",0.2,true)
        end
    end)
end

-- CREATE TABS
local farm=createTab("Farm")
local combat=createTab("Combat")
local misc=createTab("Misc")
tabs["Farm"].Visible=true

-- FARM UI
section(farm,"💪 Farming")
toggle(farm,"AutoLift")
toggle(farm,"AutoSell")
toggle(farm,"AutoRebirth")

section(farm,"🧠 Inteligente")
toggle(farm,"AutoFarmAI")
toggle(farm,"AutoZone")
toggle(farm,"AutoRock")

-- COMBAT
section(combat,"⚔️ Combat")
toggle(combat,"AutoKills")

-- MISC
section(misc,"⚙️ Misc")
toggle(misc,"Stealth")

local hop=Instance.new("TextButton",misc)
hop.Size=UDim2.new(1,-10,0,35)
hop.Text="Server Hop"
hop.MouseButton1Click:Connect(function()
    local s=game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
    for _,v in pairs(s.data) do
        if v.playing<v.maxPlayers then
            tpService:TeleportToPlaceInstance(game.PlaceId,v.id)
        end
    end
end)

-- AI
task.spawn(function()
    while true do
        if Config.AutoFarmAI then
            Config.AutoLift=true
            Config.AutoSell=true
            Config.AutoRebirth=true
            Config.AutoZone=true
            Config.AutoRock=true
        end
        task.wait(5)
    end
end)

-- STEALTH
task.spawn(function()
    while true do
        if Config.Stealth then
            char.Humanoid.WalkSpeed=12
        else
            char.Humanoid.WalkSpeed=16
        end
        task.wait(2)
    end
end)

-- SYSTEMS
task.spawn(function()
    while true do
        if Config.AutoLift then
            rs.rEvents.liftWeight:FireServer()
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoSell then
            rs.rEvents.sellStrength:FireServer()
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoRebirth then
            pcall(function()
                rs.rEvents.rebirthRemote:InvokeServer()
            end)
        end
        task.wait(10)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoKills then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v~=player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d=(char.HumanoidRootPart.Position-v.Character.HumanoidRootPart.Position).Magnitude
                    if d<KillRange then
                        rs.rEvents.punchEvent:FireServer()
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- ZONAS + ROCAS
local zones={
    {pos=Vector3.new(0,10,0),req=0},
    {pos=Vector3.new(-2600,20,-600),req=5000},
    {pos=Vector3.new(800,20,2500),req=50000},
    {pos=Vector3.new(-8600,20,-6000),req=500000}
}

local function strength()
    local s=player:FindFirstChild("leaderstats")
    return s and s:FindFirstChild("Strength") and s.Strength.Value or 0
end

local function bestZone()
    local s=strength()
    local best=zones[1]
    for _,z in pairs(zones) do
        if s>=z.req then best=z end
    end
    return best
end

task.spawn(function()
    while true do
        if Config.AutoZone then
            char:MoveTo(bestZone().pos)
        end
        task.wait(10)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoRock or Config.AutoZone then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name:lower():find("rock") then
                    char:MoveTo(v.Position)
                    rs.rEvents.punchEvent:FireServer()
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.3)
    end
end)
