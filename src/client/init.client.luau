--!strict
--[[
    =========  BITFRAMES TEST CLIENT  =========
    Comprehensive test UI for all BitFrames features.
]]

--[[
    =========  SERVICES  =========
]]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[
    =========  MODULES  =========
]]
local BitFrames = require(ReplicatedStorage.Shared.BitFolder.BitFrames)

--[[
    =========  VARIABLES  =========
]]
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currentController: any = nil

--[[
    =========  UI CREATION  =========
]]
local function createTestUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BitFramesTest"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Text = "BitFrames Test"
    title.Parent = mainFrame

    local testFrame = Instance.new("Frame")
    testFrame.Name = "TestFrame"
    testFrame.Size = UDim2.new(0, 180, 0, 180)
    testFrame.Position = UDim2.new(0.5, -90, 0, 70)
    testFrame.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    testFrame.BorderSizePixel = 0
    testFrame.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = testFrame

    local testLabel = Instance.new("TextLabel")
    testLabel.Name = "TestLabel"
    testLabel.Size = UDim2.new(1, 0, 1, 0)
    testLabel.BackgroundTransparency = 1
    testLabel.TextColor3 = Color3.new(1, 1, 1)
    testLabel.TextSize = 20
    testLabel.Font = Enum.Font.GothamBold
    testLabel.Text = "Test Element"
    testLabel.Parent = testFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "Categories"
    scrollFrame.Size = UDim2.new(1, -40, 0, 400)
    scrollFrame.Position = UDim2.new(0, 20, 0, 270)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 15)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.Parent = scrollFrame

    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        testFrame = testFrame,
        testLabel = testLabel,
        scrollFrame = scrollFrame,
    }
end

local function createCategory(parent: ScrollingFrame, name: string): Frame
    local category = Instance.new("Frame")
    category.Name = name
    category.Size = UDim2.new(1, 0, 0, 0)
    category.AutomaticSize = Enum.AutomaticSize.Y
    category.BackgroundTransparency = 1
    category.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = category

    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 25)
    header.BackgroundTransparency = 1
    header.TextColor3 = Color3.fromRGB(150, 180, 255)
    header.TextSize = 16
    header.Font = Enum.Font.GothamBold
    header.Text = name
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = category

    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(1, 0, 0, 0)
    buttonContainer.AutomaticSize = Enum.AutomaticSize.Y
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = category

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 100, 0, 32)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    grid.Parent = buttonContainer

    return buttonContainer
end

local function createButton(parent: Frame, name: string, callback: () -> ())
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 100, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(50, 55, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.BorderSizePixel = 0
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)
    BitFrames.Interaction.bindRipple(button, { color = Color3.new(1, 1, 1), transparency = 0.7 })
    return button
end

local function stopCurrent()
    if currentController then
        currentController:stop()
        currentController = nil
    end
end

local function resetElement(testFrame: Frame, testLabel: TextLabel)
    testFrame.BackgroundTransparency = 0
    testFrame.Rotation = 0
    testFrame.Position = UDim2.new(0.5, -90, 0, 70)
    testLabel.Text = "Test Element"
    testLabel.TextColor3 = Color3.new(1, 1, 1)
    testLabel.TextTransparency = 0
    local uiScale = testFrame:FindFirstChild("_BitFramesScale") :: UIScale?
    if uiScale then uiScale.Scale = 1 end
end

--[[
    =========  MAIN  =========
]]
local ui = createTestUI()
local anim = BitFrames.new(ui.testFrame)
local textAnim = BitFrames.new(ui.testLabel)

local entranceButtons = createCategory(ui.scrollFrame, "ENTRANCE")
createButton(entranceButtons, "fadeIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:fadeIn({ duration = 0.5 })
end)
createButton(entranceButtons, "fadeInUp", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:fadeInUp({ duration = 0.5 })
end)
createButton(entranceButtons, "fadeInDown", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:fadeInDown({ duration = 0.5 })
end)
createButton(entranceButtons, "scaleIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:scaleIn({ duration = 0.5 })
end)
createButton(entranceButtons, "scaleInBounce", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:scaleInBounce()
end)
createButton(entranceButtons, "zoomIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:zoomIn({ duration = 0.4 })
end)
createButton(entranceButtons, "dropIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:dropIn()
end)
createButton(entranceButtons, "Spring fadeIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:fadeIn({ spring = true, damping = 0.6, frequency = 4 })
end)
createButton(entranceButtons, "Spring dropIn", function()
    stopCurrent()
    ui.testFrame.BackgroundTransparency = 1
    ui.testLabel.TextTransparency = 1
    currentController = anim:dropIn({ spring = true, damping = 0.5, frequency = 3 })
end)

local exitButtons = createCategory(ui.scrollFrame, "EXIT")
createButton(exitButtons, "fadeOut", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:fadeOut({ duration = 0.5 })
end)
createButton(exitButtons, "fadeOutUp", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:fadeOutUp({ duration = 0.5 })
end)
createButton(exitButtons, "fadeOutDown", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:fadeOutDown({ duration = 0.5 })
end)
createButton(exitButtons, "scaleOut", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:scaleOut({ duration = 0.5 })
end)
createButton(exitButtons, "shrinkOut", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:shrinkOut({ duration = 0.5 })
end)
createButton(exitButtons, "zoomOut", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:zoomOut({ duration = 0.5 })
end)

local attentionButtons = createCategory(ui.scrollFrame, "ATTENTION")
createButton(attentionButtons, "pulse", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:pulse({ loops = 3, intensity = 0.15 })
end)
createButton(attentionButtons, "shake", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:shake({ loops = 5, intensity = 8 })
end)
createButton(attentionButtons, "bounce", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:bounce({ loops = 2, intensity = 15 })
end)
createButton(attentionButtons, "wiggle", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:wiggle({ loops = 3, intensity = 12 })
end)
createButton(attentionButtons, "flash", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:flash({ loops = 3 })
end)
createButton(attentionButtons, "heartbeat", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:heartbeat({ loops = 2 })
end)
createButton(attentionButtons, "jello", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:jello({ loops = 2 })
end)
createButton(attentionButtons, "rubberBand", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:rubberBand({ loops = 2 })
end)

local loopButtons = createCategory(ui.scrollFrame, "LOOP")
createButton(loopButtons, "spin", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:spin({ speed = 0.5 })
end)
createButton(loopButtons, "spinReverse", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:spinReverse({ speed = 0.5 })
end)
createButton(loopButtons, "float", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:float({ speed = 0.5, intensity = 8 })
end)
createButton(loopButtons, "breathe", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:breathe({ speed = 0.4, intensity = 0.08 })
end)
createButton(loopButtons, "glow", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:glow({ speed = 0.5, intensity = 0.4 })
end)
createButton(loopButtons, "swing", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:swing({ speed = 1, intensity = 20 })
end)
createButton(loopButtons, "sway", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = anim:sway({ speed = 0.5, intensity = 15 })
end)

local textButtons = createCategory(ui.scrollFrame, "TEXT EFFECTS")
createButton(textButtons, "typewriter", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:typewriter("Hello BitFrames!", { speed = 0.08 })
end)
createButton(textButtons, "scramble", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:scramble("BitFrames!", { duration = 1.5 })
end)
createButton(textButtons, "colorCycle", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:colorCycle({ speed = 0.5 })
end)
createButton(textButtons, "colorPulse", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:colorPulse({
        fromColor = Color3.new(1, 1, 1),
        toColor = Color3.new(1, 0.3, 0.3),
        speed = 1
    })
end)
createButton(textButtons, "glitch", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:glitch({ intensity = 0.3, speed = 1000 })
end)
createButton(textButtons, "fadeColor", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
    currentController = textAnim:fadeColor(Color3.fromRGB(255, 200, 100), { duration = 0.5 })
end)

local interactionButtons = createCategory(ui.scrollFrame, "INTERACTION")
createButton(interactionButtons, "ripple", function()
    BitFrames.Interaction.ripple(ui.testFrame, nil, { duration = 0.6, color = Color3.new(1, 1, 1) })
end)
createButton(interactionButtons, "press", function()
    BitFrames.Interaction.press(ui.testFrame, { scale = 0.9, duration = 0.15 })
end)
createButton(interactionButtons, "highlight", function()
    BitFrames.Interaction.highlight(ui.testFrame, { duration = 0.3 })
end)

local controlButtons = createCategory(ui.scrollFrame, "CONTROLS")
createButton(controlButtons, "STOP", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
end)
createButton(controlButtons, "RESET", function()
    stopCurrent()
    resetElement(ui.testFrame, ui.testLabel)
end)

print("BitFrames Test Suite loaded! All", 36 + 3, "effects ready to test.")
