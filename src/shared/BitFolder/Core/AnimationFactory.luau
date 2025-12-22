--!strict
--[[
    =========  ANIMATION FACTORY  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Centralized factory for creating Animation objects and controllers.
    All Effects modules use this to avoid code duplication.
]]

--[[
    =========  MODULES  =========
]]
local Scheduler = require(script.Parent.Scheduler)
local Types = require(script.Parent.Types)

--[[
    =========  TYPES  =========
]]
type Animation = Types.Animation
type AnimationState = Types.AnimationState
type EffectController = Types.EffectController

--[[
    =========  MAIN MODULE  =========
]]
local AnimationFactory = {}

function AnimationFactory.create(
    stepFn: (dt: number) -> boolean,
    onComplete: (() -> ())?,
    onInterrupt: (() -> ())?
): Animation
    local animation = {
        id = Scheduler._generateId(),
        state = "idle" :: AnimationState,
        elapsed = 0,
        delayRemaining = 0,
        progress = 0,
    }

    function animation:step(dt: number): boolean
        return stepFn(dt)
    end

    function animation:_fireStart() end
    function animation:_fireUpdate() end

    function animation:_fireComplete()
        if onComplete then onComplete() end
    end

    function animation:_fireInterrupt()
        if onInterrupt then onInterrupt() end
    end

    return animation :: Animation
end

function AnimationFactory.createController(animation: Animation, onStop: (() -> ())?): EffectController
    return {
        stop = function(self)
            Scheduler._stop(animation)
            if onStop then onStop() end
        end,
        pause = function(self)
            Scheduler._pause(animation)
        end,
        resume = function(self)
            Scheduler._resume(animation)
        end,
    }
end

function AnimationFactory.start(animation: Animation)
    Scheduler._add(animation)
end

return AnimationFactory
