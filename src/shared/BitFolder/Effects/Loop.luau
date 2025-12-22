--!strict
--[[
    =========  LOOP EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made continuous/infinite loop animations using centralized Scheduler.
]]

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Transform = require(script.Parent.Parent.Utils.Transform)
local Types = require(script.Parent.Parent.Core.Types)

local assertArg = Check.assertArg

--[[
    =========  TYPES  =========
]]
type LoopConfig = Types.LoopConfig
type EffectController = Types.EffectController

type LoopStepFn = (elapsed: number, speed: number, intensity: number) -> number

--[[
    =========  HELPER FUNCTIONS  =========
]]
local function createLoopEffect(
    element: GuiObject,
    property: string,
    getOriginal: (GuiObject) -> any,
    setProperty: (GuiObject, any, number) -> (),
    stepFn: LoopStepFn,
    config: LoopConfig?,
    defaultSpeed: number?,
    defaultIntensity: number?
): EffectController
    local speed = config and config.speed or defaultSpeed or 1
    local intensity = config and config.intensity or defaultIntensity or 1
    local original = getOriginal(element)
    local elapsed = 0

    local function reset()
        setProperty(element, original, 0)
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local value = stepFn(elapsed, speed, intensity)
            setProperty(element, original, value)
            return false
        end,
        nil,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

--[[
    =========  MAIN MODULE  =========
]]
local Loop = {}

function Loop.spin(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createLoopEffect(
        element, "Rotation",
        function(el) return 0 end,
        function(el, _, value) el.Rotation = value end,
        function(elapsed, speed, _) return (elapsed * speed * 360) % 360 end,
        config, 1, 1
    )
end

function Loop.spinReverse(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createLoopEffect(
        element, "Rotation",
        function(el) return 0 end,
        function(el, _, value) el.Rotation = value end,
        function(elapsed, speed, _) return 360 - (elapsed * speed * 360) % 360 end,
        config, 1, 1
    )
end

function Loop.float(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    local originalPosition = element.Position
    return createLoopEffect(
        element, "Position",
        function(el) return el.Position end,
        function(el, orig, offset)
            el.Position = UDim2.new(orig.X.Scale, orig.X.Offset, orig.Y.Scale, orig.Y.Offset + offset)
        end,
        function(elapsed, speed, intensity)
            return math.sin(elapsed * speed * math.pi * 2) * intensity
        end,
        config, 0.5, 5
    )
end

function Loop.breathe(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    local uiScale = Transform.getUIScale(element)
    local originalScale = uiScale.Scale
    return createLoopEffect(
        element, "Scale",
        function(_) return originalScale end,
        function(_, orig, delta) uiScale.Scale = orig + delta end,
        function(elapsed, speed, intensity)
            return math.sin(elapsed * speed * math.pi * 2) * intensity
        end,
        config, 0.5, 0.05
    )
end

function Loop.glow(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createLoopEffect(
        element, "BackgroundTransparency",
        function(el) return el.BackgroundTransparency end,
        function(el, orig, delta)
            el.BackgroundTransparency = math.clamp(orig + delta, 0, 1)
        end,
        function(elapsed, speed, intensity)
            return (math.sin(elapsed * speed * math.pi * 2) + 1) / 2 * intensity
        end,
        config, 0.67, 0.3
    )
end

function Loop.swing(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createLoopEffect(
        element, "Rotation",
        function(el) return el.Rotation end,
        function(el, orig, delta) el.Rotation = orig + delta end,
        function(elapsed, speed, intensity)
            return math.sin(elapsed * speed * math.pi * 2) * intensity
        end,
        config, 1, 15
    )
end

function Loop.sway(element: GuiObject, config: LoopConfig?): EffectController
    assertArg(element, "element", "Instance")
    return createLoopEffect(
        element, "Position",
        function(el) return el.Position end,
        function(el, orig, offset)
            el.Position = UDim2.new(orig.X.Scale, orig.X.Offset + offset, orig.Y.Scale, orig.Y.Offset)
        end,
        function(elapsed, speed, intensity)
            return math.sin(elapsed * speed * math.pi * 2) * intensity
        end,
        config, 0.5, 10
    )
end

return Loop
