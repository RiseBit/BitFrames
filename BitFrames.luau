--!strict
--[[
    =========  BITFRAMES  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Simple animation library - wraps Effects modules for convenient API.
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

--[[
    =========  TYPES  =========
]]
type EntranceConfig = Types.EntranceConfig
type ExitConfig = Types.ExitConfig
type AttentionConfig = Types.AttentionConfig
type LoopConfig = Types.LoopConfig
type TypewriterConfig = Types.TypewriterConfig
type ScrambleConfig = Types.ScrambleConfig
type ColorCycleConfig = Types.ColorCycleConfig
type ColorPulseConfig = Types.ColorPulseConfig
type GlitchConfig = Types.GlitchConfig
type EffectController = Types.EffectController

export type BitFramesObject = {
    -- Entrance
    fadeIn: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    fadeInUp: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    fadeInDown: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    scaleIn: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    scaleInBounce: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    zoomIn: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,
    dropIn: (self: BitFramesObject, config: EntranceConfig?) -> EffectController,

    -- Exit
    fadeOut: (self: BitFramesObject, config: ExitConfig?) -> EffectController,
    fadeOutUp: (self: BitFramesObject, config: ExitConfig?) -> EffectController,
    fadeOutDown: (self: BitFramesObject, config: ExitConfig?) -> EffectController,
    scaleOut: (self: BitFramesObject, config: ExitConfig?) -> EffectController,
    shrinkOut: (self: BitFramesObject, config: ExitConfig?) -> EffectController,
    zoomOut: (self: BitFramesObject, config: ExitConfig?) -> EffectController,

    -- Attention
    pulse: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    shake: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    bounce: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    wiggle: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    flash: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    heartbeat: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,
    jello: (self: BitFramesObject, config: AttentionConfig?) -> EffectController,

    -- Loop
    spin: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    spinReverse: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    float: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    breathe: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    glow: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    swing: (self: BitFramesObject, config: LoopConfig?) -> EffectController,
    sway: (self: BitFramesObject, config: LoopConfig?) -> EffectController,

    -- Text
    typewriter: (self: BitFramesObject, text: string, config: TypewriterConfig?) -> EffectController,
    scramble: (self: BitFramesObject, text: string, config: ScrambleConfig?) -> EffectController,
    colorCycle: (self: BitFramesObject, config: ColorCycleConfig?) -> EffectController,
    colorPulse: (self: BitFramesObject, config: ColorPulseConfig?) -> EffectController,
    glitch: (self: BitFramesObject, config: GlitchConfig?) -> EffectController,
    fadeColor: (self: BitFramesObject, toColor: Color3, config: Types.TransitionConfig?) -> EffectController,
}

--[[
    =========  MAIN MODULE  =========
]]
local BitFrames = {}

BitFrames.Easing = Config.Easing
BitFrames.Spring = Config.Spring
BitFrames.Preset = Config.Preset
BitFrames.Transition = Transition
BitFrames.Interaction = Interaction

function BitFrames.new(instance: GuiObject): BitFramesObject
    Check._assertGuiObject(instance, "instance")

    return {
        -- Entrance
        fadeIn = function(self, config) return Entrance.fadeIn(instance, config) end,
        fadeInUp = function(self, config) return Entrance.fadeInUp(instance, config) end,
        fadeInDown = function(self, config) return Entrance.fadeInDown(instance, config) end,
        scaleIn = function(self, config) return Entrance.scaleIn(instance, config) end,
        scaleInBounce = function(self, config) return Entrance.scaleInBounce(instance, config) end,
        zoomIn = function(self, config) return Entrance.zoomIn(instance, config) end,
        dropIn = function(self, config) return Entrance.dropIn(instance, config) end,

        -- Exit
        fadeOut = function(self, config) return Exit.fadeOut(instance, config) end,
        fadeOutUp = function(self, config) return Exit.fadeOutUp(instance, config) end,
        fadeOutDown = function(self, config) return Exit.fadeOutDown(instance, config) end,
        scaleOut = function(self, config) return Exit.scaleOut(instance, config) end,
        shrinkOut = function(self, config) return Exit.shrinkOut(instance, config) end,
        zoomOut = function(self, config) return Exit.zoomOut(instance, config) end,

        -- Attention
        pulse = function(self, config) return Attention.pulse(instance, config) end,
        shake = function(self, config) return Attention.shake(instance, config) end,
        bounce = function(self, config) return Attention.bounce(instance, config) end,
        wiggle = function(self, config) return Attention.wiggle(instance, config) end,
        flash = function(self, config) return Attention.flash(instance, config) end,
        heartbeat = function(self, config) return Attention.heartbeat(instance, config) end,
        jello = function(self, config) return Attention.jello(instance, config) end,

        -- Loop
        spin = function(self, config) return Loop.spin(instance, config) end,
        spinReverse = function(self, config) return Loop.spinReverse(instance, config) end,
        float = function(self, config) return Loop.float(instance, config) end,
        breathe = function(self, config) return Loop.breathe(instance, config) end,
        glow = function(self, config) return Loop.glow(instance, config) end,
        swing = function(self, config) return Loop.swing(instance, config) end,
        sway = function(self, config) return Loop.sway(instance, config) end,

        -- Text
        typewriter = function(self, text, config) return TextEffect.typewriter(instance :: any, text, config) end,
        scramble = function(self, text, config) return TextEffect.scramble(instance :: any, text, config) end,
        colorCycle = function(self, config) return TextEffect.colorCycle(instance :: any, config) end,
        colorPulse = function(self, config) return TextEffect.colorPulse(instance :: any, config) end,
        glitch = function(self, config) return TextEffect.glitch(instance :: any, config) end,
        fadeColor = function(self, toColor, config) return TextEffect.fadeColor(instance :: any, toColor, config) end,
    }
end

BitFrames.Entrance = Entrance
BitFrames.Exit = Exit
BitFrames.Attention = Attention
BitFrames.Loop = Loop
BitFrames.TextEffect = TextEffect
BitFrames.Transition = Transition
BitFrames.Interaction = Interaction
BitFrames.Config = Config

return BitFrames