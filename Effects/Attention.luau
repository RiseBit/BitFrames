--!strict
--[[
    =========  ATTENTION EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made attention animations using centralized Scheduler.
]]

--[[
    =========  MODULES  =========
]]
local Config = require(script.Parent.Parent.Config)
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Transform = require(script.Parent.Parent.Utils.Transform)
local Helpers = require(script.Parent.Parent.Utils.Helpers)
local Types = require(script.Parent.Parent.Core.Types)

local assertArg = Check._assertArg
local isValidElement = Helpers._isValidElement
local AttentionDefaults = Config.AttentionDefaults

--[[
    =========  TYPES  =========
]]
type AttentionConfig = Types.AttentionConfig
type EffectController = Types.EffectController

type AttentionStepFn = (t: number, intensity: number) -> number



--[[
    =========  HELPER FUNCTIONS  =========
]]
local function createAttentionEffect(
    element: GuiObject,
    getOriginal: (GuiObject) -> any,
    setProperty: (GuiObject, any, number) -> (),
    stepFn: AttentionStepFn,
    config: AttentionConfig?,
    defaultDuration: number?,
    defaultLoops: number?,
    defaultIntensity: number?
): EffectController
    local duration = math.max(config and config.duration or defaultDuration or AttentionDefaults.DURATION, 0.001)
    local loops = config and config.loops or defaultLoops or AttentionDefaults.LOOPS
    local intensity = config and config.intensity or defaultIntensity or 0.1
    local onComplete = config and config.onComplete

    local original = getOriginal(element)
    local elapsed = 0
    local currentLoop = 0

    local function reset()
        if isValidElement(element) then
            setProperty(element, original, 0)
        end
    end

    local animation = AnimationFactory._create(
        function(dt: number): boolean
            if not isValidElement(element) then return true end
            
            elapsed = elapsed + dt
            local t = elapsed / duration

            if t >= 1 then
                currentLoop = currentLoop + 1
                elapsed = 0
                if loops > 0 and currentLoop >= loops then
                    reset()
                    return true
                end
            end

            local value = stepFn(t, intensity)
            setProperty(element, original, value)
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory._start(animation)
    return AnimationFactory._createController(animation, reset)
end

--[[
    =========  MAIN MODULE  =========
]]
local Attention = {}

function Attention.pulse(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale
    return createAttentionEffect(
        element,
        function(_) return originalScale end,
        function(_, orig, delta) uiScale.Scale = orig + delta end,
        function(t, intensity) return intensity * math.sin(t * math.pi * 2) end,
        config, 0.4, 1, 0.1
    )
end

function Attention.shake(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createAttentionEffect(
        element,
        function(el) return el.Rotation end,
        function(el, orig, delta) el.Rotation = orig + delta end,
        function(_, intensity) return intensity * (math.random() * 2 - 1) end,
        config, 0.1, 3, 5
    )
end

function Attention.bounce(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    local originalPosition = element.Position
    return createAttentionEffect(
        element,
        function(el) return el.Position end,
        function(el, orig, offsetY)
            el.Position = UDim2.new(orig.X.Scale, orig.X.Offset, orig.Y.Scale, orig.Y.Offset + offsetY)
        end,
        function(t, intensity) return -intensity * math.abs(math.sin(t * math.pi)) end,
        config, 0.3, 1, 10
    )
end

function Attention.wiggle(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createAttentionEffect(
        element,
        function(el) return el.Rotation end,
        function(el, orig, delta) el.Rotation = orig + delta end,
        function(t, intensity) return intensity * math.sin(t * math.pi * 4) end,
        config, 0.15, 2, 10
    )
end

function Attention.flash(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createAttentionEffect(
        element,
        function(el) return el.BackgroundTransparency end,
        function(el, orig, delta)
            el.BackgroundTransparency = math.clamp(orig + delta, 0, 1)
        end,
        function(t, intensity) return intensity * math.abs(math.sin(t * math.pi)) end,
        config, 0.2, 2, 0.5
    )
end

function Attention.heartbeat(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale
    return createAttentionEffect(
        element,
        function(_) return originalScale end,
        function(_, orig, delta) uiScale.Scale = orig + delta end,
        function(t, intensity)
            if t < 0.14 then
                return intensity * (t / 0.14)
            elseif t < 0.28 then
                return intensity * (1 - (t - 0.14) / 0.14 * 0.5)
            elseif t < 0.42 then
                return intensity * 0.5 + intensity * 0.5 * ((t - 0.28) / 0.14)
            elseif t < 0.7 then
                return intensity * (1 - (t - 0.42) / 0.28)
            else
                return 0
            end
        end,
        config, 0.6, 1, 0.15
    )
end

function Attention.jello(element: GuiObject, config: AttentionConfig?): EffectController
    assertArg(element, "element", "Instance")
    local uiScale = Transform._getUIScale(element)
    local originalScale = uiScale.Scale
    return createAttentionEffect(
        element,
        function(_) return originalScale end,
        function(_, orig, delta) uiScale.Scale = orig + delta end,
        function(t, intensity)
            local decay = math.exp(-t * 4)
            return math.sin(t * math.pi * 6) * decay * intensity
        end,
        config, 0.5, 1, 0.1
    )
end

return table.freeze(Attention)
