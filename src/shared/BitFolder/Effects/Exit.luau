--!strict
--[[
    =========  EXIT EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made exit animations using centralized Scheduler.
    Supports both time-based (easing) and spring-based animation.
]]

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Helpers = require(script.Parent.Parent.Utils.Helpers)
local Transform = require(script.Parent.Parent.Utils.Transform)
local Types = require(script.Parent.Parent.Core.Types)
local spr = require(script.Parent.Parent.Dependencies.spr)

local assertArg = Check.assertArg
local setTransparency = Helpers.setTransparency
local getEasing = Helpers.getEasing

--[[
    =========  TYPES  =========
]]
type ExitConfig = Types.ExitConfig
type EffectController = Types.EffectController

--[[
    =========  CONSTANTS  =========
]]
local DEFAULT_DURATION = 0.3
local DEFAULT_EASING = "OutQuad"
local DEFAULT_DAMPING = 0.8
local DEFAULT_FREQUENCY = 3

--[[
    =========  MAIN MODULE  =========
]]
local Exit = {}

function Exit.fadeOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            setTransparency(element, easingFn(t))

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        nil
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, nil)
end

function Exit.fadeOutUp(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = -20

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY
        local targetPos = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1, Position = targetPos })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
                element.Position = originalPosition
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local function reset()
        element.Position = originalPosition
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, eased)
            element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY * eased)

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function Exit.fadeOutDown(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = 20

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY
        local targetPos = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1, Position = targetPos })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
                element.Position = originalPosition
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local function reset()
        element.Position = originalPosition
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, eased)
            element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY * eased)

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function Exit.scaleOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform.getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1 })
            spr.target(uiScale, damping, frequency, { Scale = 0.8 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, eased)
            uiScale.Scale = originalScale * (1 - 0.2 * eased)

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function Exit.shrinkOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform.getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1 })
            spr.target(uiScale, damping, frequency, { Scale = 0 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, eased)
            uiScale.Scale = originalScale * (1 - eased)

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function Exit.zoomOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform.getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or DEFAULT_DAMPING
        local frequency = config and config.frequency or DEFAULT_FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 1 })
            spr.target(uiScale, damping, frequency, { Scale = 1.5 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 1 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 1 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function(self)
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function(self) end,
            resume = function(self) end,
        }
    end

    local duration = config and config.duration or DEFAULT_DURATION
    local easingFn = getEasing(config and config.easing or DEFAULT_EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, eased)
            uiScale.Scale = originalScale * (1 + 0.5 * eased)

            if t >= 1 then
                setTransparency(element, 1)
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

return Exit
