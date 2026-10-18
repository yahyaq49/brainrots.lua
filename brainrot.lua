-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
mainFrame.Parent = screenGui

local brainrotList = Instance.new("TextBox")
brainrotList.Size = UDim2.new(1, 0, 0.8, 0)
brainrotList.Position = UDim2.new(0, 0, 0.1, 0)
brainrotList.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
brainrotList.Parent = mainFrame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.5, 0, 0.1, 0)
teleportButton.Position = UDim2.new(0.25, 0, 0.9, 0)
teleportButton.Text = "Teleport to Base"
teleportButton.Parent = mainFrame

local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(0.5, 0, 0.1, 0)
stealButton.Position = UDim2.new(0, 0, 0.9, 0)
stealButton.Text = "Steal Best Brainrot"
stealButton.Parent = mainFrame

-- Variables
local player = Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local bestBrainrot = nil
local brainrotTable = {}

-- Functions
local function getBestBrainrot()
    for _, brainrot in pairs(workspace:GetDescendants()) do
        if brainrot.Name == "Brainrot" then
            if not bestBrainrot or brainrot.Value > bestBrainrot.Value then
                bestBrainrot = brainrot
            end
        end
    end
    return bestBrainrot
end

local function stealBrainrot()
    local best = getBestBrainrot()
    if best then
        local target = best.Parent
        if target:FindFirstChild("Humanoid") then
            local targetCharacter = target.Character
            if targetCharacter:FindFirstChild("Brainrot") then
                local brainrot = targetCharacter.Brainrot
                brainrot.Parent = character
                table.insert(brainrotTable, brainrot.Name)
                brainrotList.Text = table.concat(brainrotTable, ", ")
            end
        end
    end
end

local function teleportToBase(target)
    local targetCharacter = target.Character
    if targetCharacter then
        local targetPosition = targetCharacter.HumanoidRootPart.Position
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(humanoid.RootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
        tween:Play()
    end
end

local function xrayBases()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= character then
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Glass
                        part.Transparency = 0.5
                    end
                end
            end
        end
    end
end

-- Event handlers
stealButton.MouseButton1Click:Connect(stealBrainrot)
teleportButton.MouseButton1Click:Connect(function()
    local target = Players.LocalPlayer
    local targetName = ""
    local teleportMenu = Instance.new("TextEntry")
    teleportMenu.Size = UDim2.new(0.5, 0, 0.1, 0)
    teleportMenu.Position = UDim2.new(0.25, 0, 0.95, 0)
    teleportMenu.Parent = mainFrame
    teleportMenu.FocusLost:Connect(function()
        targetName = teleportMenu.Text
        local target = Players:FindFirstChild(targetName)
        if target then
            teleportToBase(target)
        end
        teleportMenu:Destroy()
    end)
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        xrayBases()
    end
end)

RunService.RenderStepped:Connect(function()
    local best = getBestBrainrot()
    if best then
        local progress = best.Value / 100
        -- progress bar
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(progress, 0, 0.05, 0)
        progressBar.Position = UDim2.new(0, 0, 0.05, 0)
        progressBar.BackgroundColor3 = Color3.new(1, 0, 0)
        progressBar.Parent = mainFrame
    end
end)
