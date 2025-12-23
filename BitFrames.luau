--!strict
--[[
    =========  BITFRAMES  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Simple animation library with method chaining support.
]]

--[[
    =========  SERVICES  =========
]]
local RunService = game:GetService("RunService")

if not RunService:IsClient() then
    error("[BitFrames] This library can only be used on the client", 2)
end

--[[
    =========  MODULES  =========
]]
local Config = require(script.Parent.Config)
local Check = require(script.Parent.Utils.Check)
local Entrance = require(script.Parent.Effects.Entrance)
local Exit = require(script.Parent.Effects.Exit)
local Attention = require(script.Parent.Effects.Attention)
local Loop = require(script.Parent.Effects.Loop)
local TextEffect = require(script.Parent.Effects.TextEffect)
local Transition = require(script.Parent.Effects.Transition)
local Interaction = require(script.Parent.Effects.Interaction)
local Types = require(script.Parent.Core.Types)
local Chain = require(script.Parent.Core.Chain)
local Tween = require(script.Parent.Core.Tween)

--[[
    =========  TYPES  =========
]]
export type BitFramesChain = {
    fadeIn: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    fadeInUp: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    fadeInDown: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    scaleIn: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    scaleInBounce: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    zoomIn: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,
    dropIn: (self: BitFramesChain, config: Types.EntranceConfig?) -> BitFramesChain,

    fadeOut: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,
    fadeOutUp: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,
    fadeOutDown: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,
    scaleOut: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,
    shrinkOut: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,
    zoomOut: (self: BitFramesChain, config: Types.ExitConfig?) -> BitFramesChain,

    pulse: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    shake: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    bounce: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    wiggle: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    flash: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    heartbeat: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,
    jello: (self: BitFramesChain, config: Types.AttentionConfig?) -> BitFramesChain,

    spin: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    spinReverse: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    float: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    breathe: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    glow: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    swing: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,
    sway: (self: BitFramesChain, config: Types.LoopConfig?) -> BitFramesChain,

    typewriter: (self: BitFramesChain, text: string, config: Types.TypewriterConfig?) -> BitFramesChain,
    scramble: (self: BitFramesChain, text: string, config: Types.ScrambleConfig?) -> BitFramesChain,
    rollValue: (self: BitFramesChain, targetValue: number, config: Types.RollValueConfig?) -> BitFramesChain,
    colorCycle: (self: BitFramesChain, config: Types.ColorCycleConfig?) -> BitFramesChain,
    colorPulse: (self: BitFramesChain, config: Types.ColorPulseConfig?) -> BitFramesChain,
    glitch: (self: BitFramesChain, config: Types.GlitchConfig?) -> BitFramesChain,
    fadeColor: (self: BitFramesChain, toColor: Color3, config: Types.TransitionConfig?) -> BitFramesChain,

    delay: (self: BitFramesChain, seconds: number) -> BitFramesChain,
    play: (self: BitFramesChain, onComplete: (() -> ())?) -> Types.EffectController,
    stop: (self: BitFramesChain) -> (),
}

--[[
    =========  CONSTANTS  =========
]]
local DEFAULT_DURATION = 0.3
local DEFAULT_ATTENTION_DURATION = 0.5
local DEFAULT_LOOP_DURATION = 1

local EFFECT_MODULES = {
    { module = Entrance, effects = {"fadeIn", "fadeInUp", "fadeInDown", "scaleIn", "scaleInBounce", "zoomIn", "dropIn"}, duration = DEFAULT_DURATION },
    { module = Exit, effects = {"fadeOut", "fadeOutUp", "fadeOutDown", "scaleOut", "shrinkOut", "zoomOut"}, duration = DEFAULT_DURATION },
    { module = Attention, effects = {"pulse", "shake", "bounce", "wiggle", "flash", "heartbeat", "jello"}, duration = DEFAULT_ATTENTION_DURATION, usesLoops = true },
    { module = Loop, effects = {"spin", "spinReverse", "float", "breathe", "glow", "swing", "sway"}, duration = DEFAULT_LOOP_DURATION },
}

local TEXT_LOOP_EFFECTS = {"colorCycle", "colorPulse", "glitch"}

local TEXT_SPECIAL = {
    typewriter = { default = 1, getDuration = function(arg: string, cfg: any) return #arg * (cfg and cfg.speed or 0.05) end },
    scramble = { default = 1 },
    rollValue = { default = 1 },
    fadeColor = { default = DEFAULT_DURATION },
}

--[[
    =========  DYNAMIC METHOD REGISTRATION  =========
]]
for name, info in TEXT_SPECIAL do
    (Chain :: any)[name] = function(self: Chain.ChainClassImpl, arg: any, config: any)
        local duration = if info.getDuration then info.getDuration(arg, config)
            elseif config and config.duration then config.duration
            else info.default
        return self:_addEffect(function()
            return TextEffect[name](self._instance :: any, arg, config)
        end, duration)
    end
end

for _, group in EFFECT_MODULES do
    for _, effectName in group.effects do
        (Chain :: any)[effectName] = function(self: Chain.ChainClassImpl, config: any)
            local duration = group.duration
            if config and config.duration then
                duration = config.duration
            end
            if group.usesLoops and config and config.loops then
                duration = duration * config.loops
            end
            return self:_addEffect(function()
                return group.module[effectName](self._instance, config)
            end, duration)
        end
    end
end

for _, effectName in TEXT_LOOP_EFFECTS do
    (Chain :: any)[effectName] = function(self: Chain.ChainClassImpl, config: any)
        return self:_addEffect(function()
            return TextEffect[effectName](self._instance :: any, config)
        end, DEFAULT_LOOP_DURATION)
    end
end

--[[
    =========  MAIN MODULE  =========
]]
local BitFrames = {}

BitFrames.Easing = Config.Easing
BitFrames.SpringPresets = Config.Spring
BitFrames.Entrance = Entrance
BitFrames.Exit = Exit
BitFrames.Attention = Attention
BitFrames.Loop = Loop
BitFrames.TextEffect = TextEffect
BitFrames.Transition = Transition
BitFrames.Interaction = Interaction
BitFrames.Tween = Tween

function BitFrames.new(instance: GuiObject): BitFramesChain
    Check._assertGuiObject(instance, "instance")
    return Chain._new(instance) :: any
end

return BitFrames