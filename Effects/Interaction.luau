--!strict
--[[
    =========  INTERACTION EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Interactive feedback effects for click/tap, hover, and press.
    These are typically triggered by user input events.
]]

--[[
    =========  SERVICES  =========
]]
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Transform = require(script.Parent.Parent.Utils.Transform)
local Types = require(script.Parent.Parent.Core.Types)

local assertArg = Check._assertArg

--[[
    =========  TYPES  =========
]]
type RippleConfig = Types.RippleConfig
type PressConfig = Types.PressConfig
type HighlightConfig = Types.HighlightConfig
type EffectController = Types.EffectController

--[[
    =========  CONSTANTS  =========
]]
local DEFAULT_RIPPLE_DURATION = 0.5
local DEFAULT_RIPPLE_COLOR = Color3.new(1, 1, 1)
local DEFAULT_RIPPLE_TRANSPARENCY = 0.6
local DEFAULT_RIPPLE_MAX_SIZE = 2
local DEFAULT_PRESS_SCALE = 0.95
local DEFAULT_PRESS_DURATION = 0.1
local DEFAULT_HIGHLIGHT_DURATION = 0.2

--[[
    =========  HELPER FUNCTIONS  =========
]]
local function cloneCorner(element: GuiObject, parent: GuiObject)
    local corner = element:FindFirstChildOfClass("UICorner")
    if corner then
        local cloned = corner:Clone()
        cloned.Parent = parent
    end
end

--[[
    =========  MAIN MODULE  =========
]]
local Interaction = {}

function Interaction.ripple(element: GuiObject, position: Vector2?, config: RippleConfig?): EffectController
    assertArg(element, "element", "Instance")

    local duration = config and config.duration or DEFAULT_RIPPLE_DURATION
    local color = config and config.color or DEFAULT_RIPPLE_COLOR
    local transparency = config and config.transparency or DEFAULT_RIPPLE_TRANSPARENCY
    local maxSize = config and config.maxSize or DEFAULT_RIPPLE_MAX_SIZE
    local onComplete = config and config.onComplete

    local absPos = element.AbsolutePosition
    local absSize = element.AbsoluteSize

    if absSize.X <= 0 or absSize.Y <= 0 then
        return {
            stop = function() end,
            pause = function() end,
            resume = function() end,
        }
    end

    local clickPos: Vector2
    if position and position.X and position.Y then
        local guiInset = GuiService:GetGuiInset()
        clickPos = Vector2.new(position.X, position.Y - (guiInset.Y or 0))
    else
        clickPos = Vector2.new(absPos.X + absSize.X / 2, absPos.Y + absSize.Y / 2)
    end

    local relativeX = math.clamp((clickPos.X - absPos.X) / absSize.X, 0, 1)
    local relativeY = math.clamp((clickPos.Y - absPos.Y) / absSize.Y, 0, 1)

    local rippleContainer = Instance.new("Frame")
    rippleContainer.Name = "_BitFramesRipple"
    rippleContainer.Size = UDim2.new(1, 0, 1, 0)
    rippleContainer.BackgroundTransparency = 1
    rippleContainer.ClipsDescendants = true
    rippleContainer.ZIndex = element.ZIndex + 1
    rippleContainer.Parent = element

    cloneCorner(element, rippleContainer)

    local maxDimension = math.max(absSize.X, absSize.Y) * maxSize
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(relativeX, 0, relativeY, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3 = color
    ripple.BackgroundTransparency = transparency
    ripple.BorderSizePixel = 0
    ripple.Parent = rippleContainer

    local rippleUICorner = Instance.new("UICorner")
    rippleUICorner.CornerRadius = UDim.new(1, 0)
    rippleUICorner.Parent = ripple

    local elapsed = 0

    local function cleanup()
        if rippleContainer and rippleContainer.Parent then
            rippleContainer:Destroy()
        end
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            if not rippleContainer or not rippleContainer.Parent then
                return true
            end
            
            elapsed = elapsed + dt
            local t = math.clamp(elapsed / duration, 0, 1)

            local size = maxDimension * t
            ripple.Size = UDim2.new(0, size, 0, size)
            ripple.BackgroundTransparency = transparency + (1 - transparency) * t

            if t >= 1 then
                cleanup()
                return true
            end
            return false
        end,
        onComplete,
        cleanup
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, cleanup)
end

function Interaction.tap(element: GuiObject, position: Vector2?, config: RippleConfig?): EffectController
    assertArg(element, "element", "Instance")

    local duration = config and config.duration or DEFAULT_RIPPLE_DURATION
    local color = config and config.color or DEFAULT_RIPPLE_COLOR
    local transparency = config and config.transparency or DEFAULT_RIPPLE_TRANSPARENCY
    local maxSize = config and config.maxSize or DEFAULT_RIPPLE_MAX_SIZE
    local onComplete = config and config.onComplete

    local absPos = element.AbsolutePosition
    local absSize = element.AbsoluteSize

    if absSize.X <= 0 or absSize.Y <= 0 then
        return {
            stop = function() end,
            pause = function() end,
            resume = function() end,
        }
    end

    local clickPos: Vector2
    if position then
        local guiInset = GuiService:GetGuiInset()
        clickPos = Vector2.new(position.X, position.Y - guiInset.Y)
    else
        clickPos = Vector2.new(absPos.X + absSize.X / 2, absPos.Y + absSize.Y / 2)
    end

    local relativeX = math.clamp((clickPos.X - absPos.X) / absSize.X, 0, 1)
    local relativeY = math.clamp((clickPos.Y - absPos.Y) / absSize.Y, 0, 1)

    local tapContainer = Instance.new("Frame")
    tapContainer.Name = "_BitFramesTap"
    tapContainer.Size = UDim2.new(1, 0, 1, 0)
    tapContainer.BackgroundTransparency = 1
    tapContainer.ClipsDescendants = true
    tapContainer.ZIndex = element.ZIndex + 1
    tapContainer.Parent = element

    cloneCorner(element, tapContainer)

    local maxDimension = math.max(absSize.X, absSize.Y) * maxSize
    local tap = Instance.new("Frame")
    tap.Name = "Tap"
    tap.AnchorPoint = Vector2.new(0.5, 0.5)
    tap.Position = UDim2.new(relativeX, 0, relativeY, 0)
    tap.Size = UDim2.new(0, maxDimension, 0, maxDimension)
    tap.BackgroundColor3 = color
    tap.BackgroundTransparency = transparency
    tap.BorderSizePixel = 0
    tap.Parent = tapContainer

    local tapUICorner = Instance.new("UICorner")
    tapUICorner.CornerRadius = UDim.new(1, 0)
    tapUICorner.Parent = tap

    local elapsed = 0

    local function cleanup()
        if tapContainer and tapContainer.Parent then
            tapContainer:Destroy()
        end
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            if not tapContainer or not tapContainer.Parent then
                return true
            end
            
            elapsed = elapsed + dt
            local t = math.clamp(elapsed / duration, 0, 1)

            local size = maxDimension * (1 - t)
            tap.Size = UDim2.new(0, size, 0, size)
            tap.BackgroundTransparency = transparency + (1 - transparency) * t

            if t >= 1 then
                cleanup()
                return true
            end
            return false
        end,
        onComplete,
        cleanup
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, cleanup)
end

function Interaction.press(element: GuiObject, config: PressConfig?): EffectController
    assertArg(element, "element", "Instance")

    local scale = config and config.scale or DEFAULT_PRESS_SCALE
    local duration = config and config.duration or DEFAULT_PRESS_DURATION

    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale
    local elapsed = 0
    local phase: "down" | "up" = "down"

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt

            if phase == "down" then
                local t = math.clamp(elapsed / duration, 0, 1)
                uiScale.Scale = originalScale + (scale - originalScale) * t

                if t >= 1 then
                    phase = "up"
                    elapsed = 0
                end
            else
                local t = math.clamp(elapsed / duration, 0, 1)
                uiScale.Scale = scale + (originalScale - scale) * t

                if t >= 1 then
                    reset()
                    return true
                end
            end

            return false
        end,
        nil,
        reset
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Interaction.highlight(element: GuiObject, config: HighlightConfig?): EffectController
    assertArg(element, "element", "Instance")

    local duration = config and config.duration or DEFAULT_HIGHLIGHT_DURATION
    local color = config and config.color or Color3.new(1, 1, 1)
    local transparency = config and config.transparency or 0.7

    local highlight = Instance.new("Frame")
    highlight.Name = "_BitFramesHighlight"
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.BackgroundColor3 = color
    highlight.BackgroundTransparency = 1
    highlight.BorderSizePixel = 0
    highlight.ZIndex = element.ZIndex + 1
    highlight.Parent = element

    cloneCorner(element, highlight)

    local elapsed = 0

    local function cleanup()
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local t = math.clamp(elapsed / duration, 0, 1)

            if t < 0.5 then
                highlight.BackgroundTransparency = 1 - (1 - transparency) * (t * 2)
            else
                highlight.BackgroundTransparency = transparency + (1 - transparency) * ((t - 0.5) * 2)
            end

            if t >= 1 then
                cleanup()
                return true
            end
            return false
        end,
        nil,
        cleanup
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, cleanup)
end

function Interaction.bindRipple(element: GuiButton, config: RippleConfig?): { disconnect: () -> () }
    assertArg(element, "element", "Instance")

    local connection = element.MouseButton1Click:Connect(function()
        local mouseLocation = UserInputService:GetMouseLocation()
        Interaction.ripple(element, mouseLocation, config)
    end)

    return {
        disconnect = function()
            connection:Disconnect()
        end,
    }
end

function Interaction.bindPress(element: GuiButton, config: PressConfig?): { disconnect: () -> () }
    assertArg(element, "element", "Instance")

    local connection = element.MouseButton1Down:Connect(function()
        Interaction.press(element, config)
    end)

    return {
        disconnect = function()
            connection:Disconnect()
        end,
    }
end

return table.freeze(Interaction)
