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
-- Meowl Menu UI (LocalScript in StarterPlayerScripts)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Palette
local GREEN = Color3.fromRGB(110, 200, 90)
local DARK_GREEN = Color3.fromRGB(60, 140, 55)
local BLACK = Color3.fromRGB(20, 20, 20)
local WHITE = Color3.fromRGB(255, 255, 255)
local BROWN = Color3.fromRGB(205, 170, 125)
local FONT = Enum.Font.FredokaOne

-- Helpers
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
end

local function stroke(parent, thickness, color)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 3
    s.Color = color or BLACK
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

local function bubbleText(obj, size)
    obj.Font = FONT
    obj.TextSize = size or 20
    obj.TextColor3 = WHITE
    local s = Instance.new("UIStroke") -- outlined "bubbly" letters
    s.Thickness = 2
    s.Color = BLACK
    s.Parent = obj
end

local function bounce(obj)
    local base = obj.Size
    local grow = UDim2.new(base.X.Scale * 1.06, base.X.Offset * 1.06, base.Y.Scale * 1.06, base.Y.Offset * 1.06)
    TweenService:Create(obj, TweenInfo.new(0.08), { Size = grow }):Play()
    task.delay(0.08, function()
        TweenService:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Size = base }):Play()
    end)
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MeowlMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(360, 400)
main.BackgroundColor3 = BROWN
main.Parent = gui
corner(main, 18)
stroke(main, 4)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 56)
titleBar.BackgroundColor3 = GREEN
titleBar.Parent = main
corner(titleBar, 18)
stroke(titleBar, 3)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 0)
title.Size = UDim2.new(1, -80, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "🐱 Meowl Menu"
title.Parent = titleBar
bubbleText(title, 28)

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -12, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(38, 38)
closeBtn.BackgroundColor3 = BLACK
closeBtn.Text = "X"
closeBtn.Parent = titleBar
corner(closeBtn, 19)
stroke(closeBtn, 2, WHITE)
bubbleText(closeBtn, 22)

-- Feature list
local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(14, 70)
list.Size = UDim2.new(1, -28, 1, -110)
list.BackgroundColor3 = WHITE
list.ScrollBarThickness = 6
list.ScrollBarImageColor3 = DARK_GREEN
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()
list.Parent = main
corner(list, 14)
stroke(list, 3)

local pad = Instance.new("UIPadding")
pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 10), UDim.new(0, 10)
pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 10), UDim.new(0, 10)
pad.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 0, 1, -36)
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Text = "Press M to hide / show"
footer.Parent = main
bubbleText(footer, 16)

-- Toggle row builder
local function addToggle(labelText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundColor3 = BLACK
    row.Parent = list
    corner(row, 12)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(12, 0)
    label.Size = UDim2.new(1, -90, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText
    label.Parent = row
    bubbleText(label, 20)

    local switch = Instance.new("TextButton")
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -10, 0.5, 0)
    switch.Size = UDim2.fromOffset(60, 30)
    switch.BackgroundColor3 = BROWN
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row
    corner(switch, 15)
    stroke(switch, 2, WHITE)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(24, 24)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = WHITE
    knob.Parent = switch
    corner(knob, 12)

    local on = false
    switch.MouseButton1Click:Connect(function()
        on = not on
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Back)
        TweenService:Create(knob, info, { Position = UDim2.fromOffset(on and 33 or 3, 3) }):Play()
        TweenService:Create(switch, info, { BackgroundColor3 = on and GREEN or BROWN }):Play()
        bounce(row)
        callback(on)
    end)
end

-- FPS counter (used by the "Show FPS" toggle)
local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundColor3 = BLACK
fpsLabel.Position = UDim2.fromOffset(10, 10)
fpsLabel.Size = UDim2.fromOffset(100, 32)
fpsLabel.Visible = false
fpsLabel.Parent = gui
corner(fpsLabel, 10)
stroke(fpsLabel, 2, GREEN)
bubbleText(fpsLabel, 18)

local frames, elapsed = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 0.5 then
        fpsLabel.Text = "FPS: " .. math.floor(frames / elapsed)
        frames, elapsed = 0, 0
    end
end)

-- Features (safe, client-side only)
local originalClock = Lighting.ClockTime

addToggle("Show FPS", function(on)
    fpsLabel.Visible = on
end)

addToggle("Night Mode", function(on)
    Lighting.ClockTime = on and 0 or originalClock
end)

addToggle("Mute Sounds", function(on)
    game:GetService("SoundService").AmbientReverb = Enum.ReverbType.NoReverb
    for _, s in ipairs(workspace:GetDescendants()) do
        if s:IsA("Sound") then
            s.Volume = on and 0 or (s:GetAttribute("OrigVolume") or s.Volume)
            if on then s:SetAttribute("OrigVolume", s:GetAttribute("OrigVolume") or 0.5) end
        end
    end
end)

addToggle("Meowl Mode 🐱", function(on)
    title.Text = on and "🐱 MEOWL MODE 🐱" or "🐱 Meowl Menu"
    titleBar.BackgroundColor3 = on and DARK_GREEN or GREEN
end)

-- Open / close with bounce
local openSize = main.Size
local function setOpen(open)
    if open then
        main.Visible = true
        main.Size = UDim2.fromOffset(0, 0)
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), { Size = openSize }):Play()
    else
        local t = TweenService:Create(main, TweenInfo.new(0.2), { Size = UDim2.fromOffset(0, 0) })
        t:Play()
        t.Completed:Wait()
        main.Visible = false
    end
end

closeBtn.MouseButton1Click:Connect(function()
    setOpen(false)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.M then
        setOpen(not main.Visible)
    end
end)

-- Dragging by the title bar
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

setOpen(true)
