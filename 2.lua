-- [[ PABLO_DTH HUB v25 - RED EDITION ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV25") then pgui.PabloV25:Destroy() end

-- --- INTERFAZ PRINCIPAL ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV25"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

-- --- PESTAÑAS ---
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local farmPage = Instance.new("ScrollingFrame", main)
farmPage.Size = UDim2.new(1, -20, 1, -50)
farmPage.Position = UDim2.new(0, 10, 0, 45)
farmPage.BackgroundTransparency = 1
farmPage.Visible = true

local miscPage = Instance.new("ScrollingFrame", main)
miscPage.Size = farmPage.Size
miscPage.Position = farmPage.Position
miscPage.BackgroundTransparency = 1
miscPage.Visible = false

-- Botones de Pestaña
local function makeTab(txt, x, target)
    local b = Instance.new("TextButton", tabContainer)
    b.Size = UDim2.new(0.5, 0, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.MouseButton1Click:Connect(function()
        farmPage.Visible = false
        miscPage.Visible = false
        target.Visible = true
    end)
end
makeTab("FARM", 0, farmPage)
makeTab("MISC / POS", 0.5, miscPage)

local function addToggle(txt, parent, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.Text = act and "[ ON ] " .. txt or "[ OFF ] " .. txt
        b.TextColor3 = act and Color3.new(255, 0, 0) or Color3.new(1,1,1)
        callback(act)
    end)
    Instance.new("UIListLayout", parent).Padding = UDim.new(0, 5)
end

-- --- VARIABLES ---
_G.AutoWeight = false
_G.LockPos = false
local lockedCFrame = nil

-- --- BOTONES ---
addToggle("Auto Equip Pesa + Click", farmPage, function(v) _G.AutoWeight = v end)
addToggle("Lock Position (Congelar)", miscPage, function(v) 
    _G.LockPos = v 
    if v and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        lockedCFrame = Player.Character.HumanoidRootPart.CFrame
    end
end)

-- --- MOTOR DEL SCRIPT ---
task.spawn(function()
    while task.wait(0.01) do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Lógica Lock Position
            if _G.LockPos and lockedCFrame then
                char.HumanoidRootPart.CFrame = lockedCFrame
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            
            -- Lógica Auto Pesa
            if _G.AutoWeight then
                local tool = Player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                    tool:Activate()
                    Remote:FireServer("liftWeight", tool.Name)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
        end
    end
end)

-- Anti-AFK
Player.Idled:Connect(function() VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
