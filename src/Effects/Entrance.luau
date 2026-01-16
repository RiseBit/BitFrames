--!strict
--[[
    =========  ENTRANCE EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made entrance animations using centralized Scheduler.
    Supports both time-based (easing) and spring-based animation.
]]

--[[
    =========  MODULES  =========
]]
local Config = require(script.Parent.Parent.Config)
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Easing = require(script.Parent.Parent.Utils.Easing)
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
type EntranceConfig = Types.EntranceConfig
type EffectController = Types.EffectController

--[[
    =========  MAIN MODULE  =========
]]
local Entrance = {}

function Entrance.fadeIn(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete

    setTransparency(element, 1)

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY
        local cancelled = false

        task.delay(delay, function()
            if cancelled or not isValidElement(element) then return end
            spr.target(element, damping, frequency, { BackgroundTransparency = 0 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                cancelled = true
                spr.stop(element)
                if isValidElement(element) then
                    setTransparency(element, 0)
                end
            end,
            pause = function()
                warn("[BitFrames] pause() is not supported for spring animations")
            end,
            resume = function()
                warn("[BitFrames] resume() is not supported for spring animations")
            end,
        }
    end

    local duration = math.max(config and config.duration or Defaults.DURATION, 0.001)
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        if isValidElement(element) then
            setTransparency(element, 0)
        end
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            if not isValidElement(element) then return true end
            
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            setTransparency(element, 1 - easingFn(t))

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "fadeIn",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.fadeInUp(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = 20

    setTransparency(element, 1)
    element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, {
                BackgroundTransparency = 0,
                Position = originalPosition,
            })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                setTransparency(element, 0)
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
        setTransparency(element, 0)
        element.Position = originalPosition
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, 1 - eased)
            element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY * (1 - eased))

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "fadeInUp",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.fadeInDown(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = -20

    setTransparency(element, 1)
    element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, {
                BackgroundTransparency = 0,
                Position = originalPosition,
            })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                setTransparency(element, 0)
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
        setTransparency(element, 0)
        element.Position = originalPosition
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, 1 - eased)
            element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY * (1 - eased))

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "fadeInDown",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.scaleIn(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)

    setTransparency(element, 1)
    uiScale.Scale = 0.8

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 0 })
            spr.target(uiScale, damping, frequency, { Scale = 1 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                setTransparency(element, 0)
                uiScale.Scale = 1
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        setTransparency(element, 0)
        uiScale.Scale = 1
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, 1 - eased)
            uiScale.Scale = 0.8 + 0.2 * eased

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "scaleIn",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.scaleInBounce(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)

    setTransparency(element, 1)
    uiScale.Scale = 0.5

    if useSpring then
        local damping = config and config.damping or 0.6
        local frequency = config and config.frequency or 4

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 0 })
            spr.target(uiScale, damping, frequency, { Scale = 1 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                setTransparency(element, 0)
                uiScale.Scale = 1
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or 0.5
    local easingFn = Easing.OutBack
    local elapsed = -delay

    local function reset()
        setTransparency(element, 0)
        uiScale.Scale = 1
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            setTransparency(element, 1 - t)
            uiScale.Scale = 0.5 + 0.5 * easingFn(t)

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "scaleInBounce",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.zoomIn(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local uiScale = Transform._getUIScale(element)

    setTransparency(element, 1)
    uiScale.Scale = 0

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

        task.delay(delay, function()
            spr.target(element, damping, frequency, { BackgroundTransparency = 0 })
            spr.target(uiScale, damping, frequency, { Scale = 1 })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                spr.stop(uiScale)
                setTransparency(element, 0)
                uiScale.Scale = 1
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = -delay

    local function reset()
        setTransparency(element, 0)
        uiScale.Scale = 1
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(element, 1 - eased)
            uiScale.Scale = eased

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "zoomIn",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Entrance.dropIn(element: GuiObject, config: EntranceConfig?): EffectController
    assertArg(element, "element", "Instance")

    local useSpring = config and config.spring
    local delay = config and config.delay or 0
    local onComplete = config and config.onComplete
    local originalPosition = element.Position
    local offsetY = -100

    setTransparency(element, 1)
    element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY)

    if useSpring then
        local damping = config and config.damping or 0.5
        local frequency = config and config.frequency or 3

        task.delay(delay, function()
            spr.target(element, damping, frequency, {
                BackgroundTransparency = 0,
                Position = originalPosition,
            })
            if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
                spr.target(element, damping, frequency, { TextTransparency = 0 })
            end
            if element:IsA("ImageLabel") or element:IsA("ImageButton") then
                spr.target(element, damping, frequency, { ImageTransparency = 0 })
            end
            if onComplete then
                spr.completed(element, onComplete)
            end
        end)

        return {
            stop = function()
                spr.stop(element)
                setTransparency(element, 0)
                element.Position = originalPosition
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or 0.5
    local easingFn = Easing.OutBounce
    local elapsed = -delay

    local function reset()
        setTransparency(element, 0)
        element.Position = originalPosition
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            if elapsed < 0 then return false end

            local t = math.clamp(elapsed / duration, 0, 1)
            setTransparency(element, 1 - t)
            element.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY * (1 - easingFn(t)))

            if t >= 1 then
                reset()
                return true
            end
            return false
        end,
        onComplete,
        reset,
        "dropIn",
        element
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

return table.freeze(Entrance)
