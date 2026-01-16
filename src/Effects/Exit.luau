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
local Config = require(script.Parent.Parent.Config)
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Helpers = require(script.Parent.Parent.Utils.Helpers)
local Transform = require(script.Parent.Parent.Utils.Transform)
local Types = require(script.Parent.Parent.Core.Types)
local spr = require(script.Parent.Parent.Dependencies.spr)

local assertArg = Check._assertArg
local setTransparency = Helpers._setTransparency
local getEasing = Helpers._getEasing
local isValidElement = Helpers._isValidElement
local Defaults = Config.Defaults

--[[
    =========  TYPES  =========
]]
type ExitConfig = Types.ExitConfig
type EffectController = Types.EffectController

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
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY
        local cancelled = false

        task.delay(delay, function()
            if cancelled or not isValidElement(element) then return end
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
            stop = function()
                cancelled = true
                spr.stop(element)
            end,
            pause = function()
                warn("[BitFrames] pause() is not supported for spring animations")
            end,
            resume = function()
                warn("[BitFrames] resume() is not supported for spring animations")
            end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local animation = AnimationFactory._create(
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
        nil,
        "fadeOut",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, nil)
end

function Exit.fadeOutUp(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = -20

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY
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
            stop = function()
                spr.stop(element)
                element.Position = originalPosition
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        element.Position = originalPosition
    end

    local animation = AnimationFactory._create(
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
        reset,
        "fadeOutUp",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Exit.fadeOutDown(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = 20

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY
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
            stop = function()
                spr.stop(element)
                element.Position = originalPosition
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        element.Position = originalPosition
    end

    local animation = AnimationFactory._create(
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
        reset,
        "fadeOutDown",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Exit.scaleOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

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
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory._create(
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
        reset,
        "scaleOut",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Exit.shrinkOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

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
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory._create(
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
        reset,
        "shrinkOut",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Exit.zoomOut(element: GuiObject, config: ExitConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

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
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                uiScale.Scale = originalScale
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        uiScale.Scale = originalScale
    end

    local animation = AnimationFactory._create(
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
        reset,
        "zoomOut",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

return table.freeze(Exit)
