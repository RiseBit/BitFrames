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

function AnimationFactory._create(
    stepFn: (dt: number) -> boolean,
    onComplete: (() -> ())?,
    onInterrupt: (() -> ())?
): Animation
    local _stepFn: ((dt: number) -> boolean)? = stepFn
    local _onComplete: (() -> ())? = onComplete
    local _onInterrupt: (() -> ())? = onInterrupt
    
    local animation = {
        id = Scheduler._generateId(),
        state = "idle" :: AnimationState,
        elapsed = 0,
        delayRemaining = 0,
        progress = 0,
    }

    function animation:step(dt: number): boolean
        if _stepFn then
            return _stepFn(dt)
        end
        return true
    end

    function animation:_fireStart() end
    function animation:_fireUpdate() end

    function animation:_fireComplete()
        if _onComplete then
            local callback = _onComplete
            task.spawn(function()
                local success, err = pcall(callback)
                if not success then
                    warn("[BitFrames] onComplete callback error:", err)
                end
            end)
        end
        _stepFn = nil
        _onComplete = nil
        _onInterrupt = nil
    end

    function animation:_fireInterrupt()
        if _onInterrupt then
            local callback = _onInterrupt
            task.spawn(function()
                local success, err = pcall(callback)
                if not success then
                    warn("[BitFrames] onInterrupt callback error:", err)
                end
            end)
        end
        _stepFn = nil
        _onComplete = nil
        _onInterrupt = nil
    end

    return animation :: Animation
end

function AnimationFactory._createController(animation: Animation, onStop: (() -> ())?): EffectController
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

function AnimationFactory._start(animation: Animation)
    Scheduler._add(animation)
end

return table.freeze(AnimationFactory)
