--!strict
--[[
    =========  TRANSITION EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made transition animations between UI states using centralized Scheduler.
    Supports both time-based (easing) and spring-based animation.
]]

--[[
    =========  MODULES  =========
]]
local Config = require(script.Parent.Parent.Config)
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Helpers = require(script.Parent.Parent.Utils.Helpers)
local Types = require(script.Parent.Parent.Core.Types)
local spr = require(script.Parent.Parent.Dependencies.spr)

local assertArg = Check._assertArg
local setTransparency = Helpers._setTransparency
local getEasing = Helpers._getEasing
local Defaults = Config.Defaults

--[[
    =========  TYPES  =========
]]
type TransitionConfig = Types.TransitionConfig
type EffectController = Types.EffectController
type SlideDirection = Types.SlideDirection

local VALID_DIRECTIONS: {[string]: boolean} = {
    left = true,
    right = true,
    up = true,
    down = true,
}

--[[
    =========  MAIN MODULE  =========
]]
local Transition = {}

function Transition.crossfade(fromElement: GuiObject, toElement: GuiObject, config: TransitionConfig?): EffectController
    assertArg(fromElement, "fromElement", "Instance")
    assertArg(toElement, "toElement", "Instance")

    local useSpring = config and config.spring
    local onComplete = config and config.onComplete

    setTransparency(toElement, 1)
    toElement.Visible = true

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY

        spr.target(fromElement, damping, frequency, { BackgroundTransparency = 1 })
        spr.target(toElement, damping, frequency, { BackgroundTransparency = 0 })

        if fromElement:IsA("TextLabel") or fromElement:IsA("TextButton") or fromElement:IsA("TextBox") then
            spr.target(fromElement, damping, frequency, { TextTransparency = 1 })
        end
        if fromElement:IsA("ImageLabel") or fromElement:IsA("ImageButton") then
            spr.target(fromElement, damping, frequency, { ImageTransparency = 1 })
        end
        if toElement:IsA("TextLabel") or toElement:IsA("TextButton") or toElement:IsA("TextBox") then
            spr.target(toElement, damping, frequency, { TextTransparency = 0 })
        end
        if toElement:IsA("ImageLabel") or toElement:IsA("ImageButton") then
            spr.target(toElement, damping, frequency, { ImageTransparency = 0 })
        end

        spr.completed(fromElement, function()
            fromElement.Visible = false
            if onComplete then onComplete() end
        end)

        local function reset()
            setTransparency(toElement, 0)
            toElement.Visible = true
            fromElement.Visible = false
        end

        return {
            stop = function()
                spr.stop(fromElement)
                spr.stop(toElement)
                reset()
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = 0

    local function reset()
        setTransparency(toElement, 0)
        toElement.Visible = true
        fromElement.Visible = false
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            setTransparency(fromElement, eased)
            setTransparency(toElement, 1 - eased)

            if t >= 1 then
                setTransparency(fromElement, 1)
                setTransparency(toElement, 0)
                fromElement.Visible = false
                return true
            end
            return false
        end,
        onComplete,
        nil
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

function Transition.slideReplace(fromElement: GuiObject, toElement: GuiObject, direction: SlideDirection?, config: TransitionConfig?): EffectController
    assertArg(fromElement, "fromElement", "Instance")
    assertArg(toElement, "toElement", "Instance")

    local dir = direction or "left"
    if not VALID_DIRECTIONS[dir] then
        warn(`[BitFrames] Invalid direction '{dir}', using default 'left'`)
        dir = "left"
    end
    local useSpring = config and config.spring
    local onComplete = config and config.onComplete

    local fromOriginal = fromElement.Position
    local toOriginal = toElement.Position

    local offsetX, offsetY = 0, 0
    if dir == "left" then offsetX = -50
    elseif dir == "right" then offsetX = 50
    elseif dir == "up" then offsetY = -50
    elseif dir == "down" then offsetY = 50
    end

    toElement.Position = UDim2.new(toOriginal.X.Scale, toOriginal.X.Offset - offsetX, toOriginal.Y.Scale, toOriginal.Y.Offset - offsetY)
    toElement.Visible = true

    if useSpring then
        local damping = config and config.damping or Defaults.DAMPING
        local frequency = config and config.frequency or Defaults.FREQUENCY
        local fromTarget = UDim2.new(fromOriginal.X.Scale, fromOriginal.X.Offset + offsetX, fromOriginal.Y.Scale, fromOriginal.Y.Offset + offsetY)

        spr.target(fromElement, damping, frequency, { Position = fromTarget })
        spr.target(toElement, damping, frequency, { Position = toOriginal })

        spr.completed(toElement, function()
            fromElement.Visible = false
            fromElement.Position = fromOriginal
            if onComplete then onComplete() end
        end)

        local function reset()
            toElement.Position = toOriginal
            toElement.Visible = true
            fromElement.Visible = false
            fromElement.Position = fromOriginal
        end

        return {
            stop = function()
                spr.stop(fromElement)
                spr.stop(toElement)
                reset()
            end,
            pause = function() end,
            resume = function() end,
        }
    end

    local duration = config and config.duration or Defaults.DURATION
    local easingFn = getEasing(config and config.easing or Defaults.EASING)
    local elapsed = 0

    local function reset()
        toElement.Position = toOriginal
        toElement.Visible = true
        fromElement.Visible = false
        fromElement.Position = fromOriginal
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local t = math.clamp(elapsed / duration, 0, 1)
            local eased = easingFn(t)

            fromElement.Position = UDim2.new(fromOriginal.X.Scale, fromOriginal.X.Offset + offsetX * eased, fromOriginal.Y.Scale, fromOriginal.Y.Offset + offsetY * eased)
            toElement.Position = UDim2.new(toOriginal.X.Scale, toOriginal.X.Offset - offsetX * (1 - eased), toOriginal.Y.Scale, toOriginal.Y.Offset - offsetY * (1 - eased))

            if t >= 1 then
                fromElement.Visible = false
                fromElement.Position = fromOriginal
                toElement.Position = toOriginal
                return true
            end
            return false
        end,
        onComplete,
        nil
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

return table.freeze(Transition)
