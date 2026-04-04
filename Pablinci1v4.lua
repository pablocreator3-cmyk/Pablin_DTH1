-- [[ PABLO_DTH HUB v27 - THE ULTIMATE UPDATE ]] --
local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VU = game:GetService("VirtualUser")
local Remote = RS:WaitForChild("muscleEvent")

-- Limpiar interfaz anterior
local pgui = Player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("PabloV27") then pgui.PabloV27:Destroy() end

-- --- INTERFAZ PRINCIPAL (ROJO) ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "PabloV27"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 350)
main.Position = UDim2.new(0.5, -225, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

-- --- SISTEMA DE PESTAÑAS ---
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

local pages = {}
local function createPage(name, isVisible)
    local pg = Instance.new("ScrollingFrame", main)
    pg.Size = UDim2.new(1, -20, 1, -55)
    pg.Position = UDim2.new(0, 10, 0, 45)
    pg.BackgroundTransparency = 1
    pg.CanvasSize = UDim2.new(0, 0, 1.5, 0) -- Para que quepan todas las rocas
    pg.ScrollBarThickness = 4
    pg.Visible = isVisible
    Instance.new("UIListLayout", pg).Padding = UDim.new(0, 5)
    pages[name] = pg
    return pg
end

local farmPage = createPage("Farm", true)
local rocksPage = createPage("Rocks", false)
local miscPage = createPage("Misc", false)

local function makeTabBtn(txt, x, targetName)
    local b = Instance.new("TextButton", tabContainer)
    b.Size = UDim2.new(0.33, 0, 1, 0)
    b.Position = UDim2.new(x, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[targetName].Visible = true
    end)
end

makeTabBtn("FARM", 0, "Farm")
makeTabBtn("ROCKS", 0.33, "Rocks")
makeTabBtn("MISC", 0.66, "Misc")

-- --- FUNCION PARA BOTONES ---
_G.RockType = "None"
_G.AutoWeight = false
_G.LockPos = false
local lockedCFrame = nil

local function addToggle(txt, parent, callback_var)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    b.Text = "[ OFF ] " .. txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    
    b.MouseButton1Click:Connect(function()
        if typeof(callback_var) == "string" then
            _G[callback_var] = not _G[callback_var]
            b.Text = _G[callback_var] and "[ ON ] " .. txt or "[ OFF ] " .. txt
            b.TextColor3 = _G[callback_var] and Color3.new(255, 0, 0) or Color3.new(1,1,1)
            
            if callback_var == "LockPos" and _G.LockPos then
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    lockedCFrame = Player.Character.HumanoidRootPart.CFrame
                end
            end
        else -- Para seleccion de rocas
            _G.RockType = txt
            for _, v in pairs(parent:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.new(1,1,1) end
            end
            b.TextColor3 = Color3.new(255, 255, 0)
        end
    end)
end

-- --- CONTENIDO ---
-- Farm Page
addToggle("Auto Pesa (Equip + Click)", farmPage, "AutoWeight")

-- Misc Page
addToggle("Lock Position (Congelar)", miscPage, "LockPos")

-- Rocks Page (Lista exacta del video)
local rocas = {
    "Tiny Island Rock", "Starter Island Rock", "Legend Beach Rock", 
    "Frost Gym Rock", "Mythical Gym Rock", "Eternal Gym Rock", 
    "Legend Gym Rock", "Muscle King Gym Rock", "Ancient Jungle Rock"
}
for _, r in pairs(rocas) do addToggle(r, rocksPage, nil) end

-- --- MOTOR DEL SCRIPT ---
task.spawn(function()
    while task.wait(0.01) do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Lock Pos
            if _G.LockPos and lockedCFrame then
                char.HumanoidRootPart.CFrame = lockedCFrame
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
            -- Auto Weight
            if _G.AutoWeight then
                local tool = Player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool")
                if tool and (tool.Name:find("Weight") or tool.Name:find("Pesa")) then
                    if tool.Parent ~= char then char.Humanoid:EquipTool(tool) end
                    tool:Activate()
                    Remote:FireServer("liftWeight", tool.Name)
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end
            -- Rock Farm
            if _G.RockType ~= "None" then
                Remote:FireServer("trainDurability", _G.RockType:gsub(" Rock", ""))
            end
        end
    end
end)

-- Anti-AFK
Player.Idled:Connect(function() VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
