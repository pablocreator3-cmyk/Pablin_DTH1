--// Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--// Variables de Estado
local PositionLocked = true
local AntiAnchor = true -- Anti-Afk / Anti-Freeze funcional

--// Guardar Posición Inicial
local LockedCFrame = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame

--// Bucle Principal
RunService.Heartbeat:Connect(function()
    if PositionLocked and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LockedCFrame then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LockedCFrame
        else
            LockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
    
    -- Anti-Anchored (Para evitar que scripts externos te congelen)
    if AntiAnchor and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end
    end
end)

-- Mensaje de Confirmación en Consola
print("Lock Position & Anti-Freeze Cargado")
