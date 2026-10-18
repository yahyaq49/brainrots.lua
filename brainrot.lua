-- Meowl Menu UI v2 (LocalScript in StarterPlayerScripts)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Palette
local DARK_BROWN = Color3.fromRGB(110, 72, 42)
local LIGHT_BROWN = Color3.fromRGB(222, 192, 150)
local GREEN = Color3.fromRGB(110, 200, 90)
local BLACK = Color3.fromRGB(20, 20, 20)
local WHITE = Color3.fromRGB(255, 255, 255)
local GREY = Color3.fromRGB(140, 140, 140)
local FONT = Enum.Font.FredokaOne

-- Helpers
local function corner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p end
local function stroke(p, t, col) local s = Instance.new("UIStroke"); s.Thickness = t or 3; s.Color = col or BLACK; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p end
local function gradient(p, top, bottom)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(top, bottom)
    g.Rotation = 90
    g.Parent = p
end
local function bubbleText(o, size)
    o.Font = FONT; o.TextSize = size or 22; o.TextColor3 = WHITE
    local s = Instance.new("UIStroke"); s.Thickness = 2.5; s.Color = BLACK; s.Parent = o
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MeowlMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local OPEN_SIZE = UDim2.fromOffset(560, 620)

-- Drop shadow
local shadow = Instance.new("Frame")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 8, 0.5, 10)
shadow.Size = OPEN_SIZE
shadow.BackgroundColor3 = BLACK
shadow.BackgroundTransparency = 0.6
shadow.Parent = gui
corner(shadow, 26)

-- Outer frame (dark brown)
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = OPEN_SIZE
main.BackgroundColor3 = WHITE
main.Parent = gui
corner(main, 26)
stroke(main, 5)
gradient(main, Color3.fromRGB(135, 92, 56), DARK_BROWN)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Position = UDim2.fromOffset(14, 14)
titleBar.Size = UDim2.new(1, -28, 0, 72)
titleBar.BackgroundColor3 = WHITE
titleBar.Parent = main
corner(titleBar, 20)
stroke(titleBar, 3)
gradient(titleBar, Color3.fromRGB(140, 220, 115), Color3.fromRGB(70, 150, 60))

-- Gloss highlight on the title bar
local gloss = Instance.new("Frame")
gloss.Position = UDim2.fromOffset(8, 5)
gloss.Size = UDim2.new(1, -16, 0.4, 0)
gloss.BackgroundColor3 = WHITE
gloss.BackgroundTransparency = 0.75
gloss.Parent = titleBar
corner(gloss, 14)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(20, 0)
title.Size = UDim2.new(1, -100, 1, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "🐱 Meowl Menu"
title.Parent = titleBar
bubbleText(title, 36)

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -16, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(48, 48)
closeBtn.BackgroundColor3 = BLACK
closeBtn.Text = "X"
closeBtn.Parent = titleBar
corner(closeBtn, 24)
stroke(closeBtn, 3, WHITE)
bubbleText(closeBtn, 26)

-- Inner panel (light brown)
local inner = Instance.new("Frame")
inner.Position = UDim2.fromOffset(14, 100)
inner.Size = UDim2.new(1, -28, 1, -160)
inner.BackgroundColor3 = WHITE
inner.Parent = main
corner(inner, 20)
stroke(inner, 3)
gradient(inner, Color3.fromRGB(238, 214, 178), LIGHT_BROWN)

local list = Instance.new("ScrollingFrame")
list.BackgroundTransparency = 1
list.Size = UDim2.fromScale(1, 1)
list.ScrollBarThickness = 8
list.ScrollBarImageColor3 = DARK_BROWN
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()
list.BorderSizePixel = 0
list.Parent = inner

local pad = Instance.new("UIPadding")
pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 14), UDim.new(0, 14)
pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 14), UDim.new(0, 14)
pad.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.Parent = list

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 0, 1, -52)
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Text = "Press M to hide / show"
footer.Parent = main
bubbleText(footer, 20)

-- Toggle row: grey when off, white when on
local function addToggle(labelText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 64)
    row.BackgroundColor3 = WHITE
    row.Parent = list
    corner(row, 16)
    stroke(row, 3)
    gradient(row, Color3.fromRGB(45, 45, 45), BLACK)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(18, 0)
    label.Size = UDim2.new(1, -120, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelText
    label.Parent = row
    bubbleText(label, 26)

    local switch = Instance.new("TextButton")
    switch.AnchorPoint = Vector2.new(1, 0.5)
    switch.Position = UDim2.new(1, -16, 0.5, 0)
    switch.Size = UDim2.fromOffset(80, 40)
    switch.BackgroundColor3 = GREY
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row
    corner(switch, 20)
    stroke(switch, 3, BLACK)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(32, 32)
    knob.Position = UDim2.fromOffset(4, 4)
    knob.BackgroundColor3 = GREEN
    knob.Parent = switch
    corner(knob, 16)
    stroke(knob, 2, BLACK)

    local on = false
    switch.MouseButton1Click:Connect(function()
        on = not on
        local info = TweenInfo.new(0.25, Enum.EasingStyle.Back)
        TweenService:Create(knob, info, { Position = UDim2.fromOffset(on and 44 or 4, 4) }):Play()
        TweenService:Create(switch, info, { BackgroundColor3 = on and WHITE or GREY }):Play()
        callback(on)
    end)
end

-- FPS counter
local fpsLabel = Instance.new("TextLabel")
fpsLabel.BackgroundColor3 = DARK_BROWN
fpsLabel.Position = UDim2.fromOffset(12, 12)
fpsLabel.Size = UDim2.fromOffset(130, 40)
fpsLabel.Visible = false
fpsLabel.Parent = gui
corner(fpsLabel, 12)
stroke(fpsLabel, 3)
bubbleText(fpsLabel, 22)

local frames, elapsed = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1; elapsed += dt
    if elapsed >= 0.5 then
        fpsLabel.Text = "FPS: " .. math.floor(frames / elapsed)
        frames, elapsed = 0, 0
    end
end)

-- Features (client-side only)
local originalClock = Lighting.ClockTime
addToggle("Show FPS", function(on) fpsLabel.Visible = on end)
addToggle("Night Mode", function(on) Lighting.ClockTime = on and 0 or originalClock end)
addToggle("Meowl Mode 🐱", function(on) title.Text = on and "🐱 MEOWL MODE 🐱" or "🐱 Meowl Menu" end)

-- Open / close
local function setOpen(open)
    if open then
        main.Visible, shadow.Visible = true, true
        main.Size, shadow.Size = UDim2.new(), UDim2.new()
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back)
        TweenService:Create(main, info, { Size = OPEN_SIZE }):Play()
        TweenService:Create(shadow, info, { Size = OPEN_SIZE }):Play()
    else
        local t = TweenService:Create(main, TweenInfo.new(0.2), { Size = UDim2.new() })
        TweenService:Create(shadow, TweenInfo.new(0.2), { Size = UDim2.new() }):Play()
        t:Play(); t.Completed:Wait()
        main.Visible, shadow.Visible = false, false
    end
end

closeBtn.MouseButton1Click:Connect(function() setOpen(false) end)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.M then setOpen(not main.Visible) end
end)

-- Dragging (shadow follows the window)
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        shadow.Position = main.Position + UDim2.fromOffset(8, 10)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

setOpen(true)
