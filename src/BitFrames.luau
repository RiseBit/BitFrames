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
type EffectController = Types.EffectController
type EntranceConfig = Types.EntranceConfig
type ExitConfig = Types.ExitConfig
type AttentionConfig = Types.AttentionConfig
type LoopConfig = Types.LoopConfig
type RippleConfig = Types.RippleConfig
type PressConfig = Types.PressConfig
type HighlightConfig = Types.HighlightConfig
type TransitionConfig = Types.TransitionConfig
type TypewriterConfig = Types.TypewriterConfig
type ScrambleConfig = Types.ScrambleConfig
type RollValueConfig = Types.RollValueConfig
type ColorCycleConfig = Types.ColorCycleConfig
type ColorPulseConfig = Types.ColorPulseConfig
type GlitchConfig = Types.GlitchConfig

type TargetInput = GuiObject | { GuiObject }
type TextTargetInput = TextLabel | TextButton | TextBox | { TextLabel | TextButton | TextBox }
type DisconnectHandle = { disconnect: () -> () }

export type WrappedEntrance = {
	fadeIn: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	fadeInUp: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	fadeInDown: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	scaleIn: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	scaleInBounce: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	zoomIn: (element: TargetInput, config: EntranceConfig?) -> EffectController,
	dropIn: (element: TargetInput, config: EntranceConfig?) -> EffectController,
}

export type WrappedExit = {
	fadeOut: (element: TargetInput, config: ExitConfig?) -> EffectController,
	fadeOutUp: (element: TargetInput, config: ExitConfig?) -> EffectController,
	fadeOutDown: (element: TargetInput, config: ExitConfig?) -> EffectController,
	scaleOut: (element: TargetInput, config: ExitConfig?) -> EffectController,
	shrinkOut: (element: TargetInput, config: ExitConfig?) -> EffectController,
	zoomOut: (element: TargetInput, config: ExitConfig?) -> EffectController,
}

export type WrappedAttention = {
	pulse: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	shake: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	bounce: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	wiggle: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	flash: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	heartbeat: (element: TargetInput, config: AttentionConfig?) -> EffectController,
	jello: (element: TargetInput, config: AttentionConfig?) -> EffectController,
}

export type WrappedLoop = {
	spin: (element: TargetInput, config: LoopConfig?) -> EffectController,
	spinReverse: (element: TargetInput, config: LoopConfig?) -> EffectController,
	float: (element: TargetInput, config: LoopConfig?) -> EffectController,
	breathe: (element: TargetInput, config: LoopConfig?) -> EffectController,
	glow: (element: TargetInput, config: LoopConfig?) -> EffectController,
	swing: (element: TargetInput, config: LoopConfig?) -> EffectController,
	sway: (element: TargetInput, config: LoopConfig?) -> EffectController,
}

export type WrappedTextEffect = {
	typewriter: (element: TextTargetInput, text: string, config: TypewriterConfig?) -> EffectController,
	scramble: (element: TextTargetInput, text: string, config: ScrambleConfig?) -> EffectController,
	rollValue: (element: TextTargetInput, targetValue: number, config: RollValueConfig?) -> EffectController,
	fadeColor: (element: TextTargetInput, toColor: Color3, config: TransitionConfig?) -> EffectController,
	colorCycle: (element: TextTargetInput, config: ColorCycleConfig?) -> EffectController,
	colorPulse: (element: TextTargetInput, config: ColorPulseConfig?) -> EffectController,
	glitch: (element: TextTargetInput, config: GlitchConfig?) -> EffectController,
}

export type WrappedTransition = {
	slide: (element: TargetInput, direction: Types.SlideDirection?, config: TransitionConfig?) -> EffectController,
	crossfade: (fromElement: GuiObject, toElement: GuiObject, config: TransitionConfig?) -> EffectController,
	morph: (element: TargetInput, targetProps: { [string]: any }, config: TransitionConfig?) -> EffectController,
	flipX: (element: TargetInput, config: TransitionConfig?) -> EffectController,
	flipY: (element: TargetInput, config: TransitionConfig?) -> EffectController,
}

export type WrappedInteraction = {
	ripple: (element: TargetInput, position: Vector2?, config: RippleConfig?) -> EffectController,
	press: (element: TargetInput, position: Vector2?, config: PressConfig?) -> EffectController,
	highlight: (element: TargetInput, config: HighlightConfig?) -> EffectController,
	bindRipple: (element: GuiButton, config: RippleConfig?) -> DisconnectHandle,
	bindPress: (element: GuiObject, config: PressConfig?) -> DisconnectHandle,
}

export type BitFramesChain = {
	fadeIn: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	fadeInUp: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	fadeInDown: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	scaleIn: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	scaleInBounce: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	zoomIn: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,
	dropIn: (self: BitFramesChain, config: EntranceConfig?) -> BitFramesChain,

	fadeOut: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,
	fadeOutUp: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,
	fadeOutDown: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,
	scaleOut: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,
	shrinkOut: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,
	zoomOut: (self: BitFramesChain, config: ExitConfig?) -> BitFramesChain,

	pulse: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	shake: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	bounce: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	wiggle: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	flash: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	heartbeat: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,
	jello: (self: BitFramesChain, config: AttentionConfig?) -> BitFramesChain,

	spin: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	spinReverse: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	float: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	breathe: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	glow: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	swing: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,
	sway: (self: BitFramesChain, config: LoopConfig?) -> BitFramesChain,

	typewriter: (self: BitFramesChain, text: string, config: TypewriterConfig?) -> BitFramesChain,
	scramble: (self: BitFramesChain, text: string, config: ScrambleConfig?) -> BitFramesChain,
	rollValue: (self: BitFramesChain, targetValue: number, config: RollValueConfig?) -> BitFramesChain,
	colorCycle: (self: BitFramesChain, config: ColorCycleConfig?) -> BitFramesChain,
	colorPulse: (self: BitFramesChain, config: ColorPulseConfig?) -> BitFramesChain,
	glitch: (self: BitFramesChain, config: GlitchConfig?) -> BitFramesChain,
	fadeColor: (self: BitFramesChain, toColor: Color3, config: TransitionConfig?) -> BitFramesChain,

	delay: (self: BitFramesChain, seconds: number) -> BitFramesChain,
	play: (self: BitFramesChain, onComplete: (() -> ())?) -> EffectController,
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
	=========  MODULE WRAPPER  =========
]]
local function isGuiObject(value: any): boolean
	return typeof(value) == "Instance" and value:IsA("GuiObject")
end

local function isTextElement(value: any): boolean
	return typeof(value) == "Instance" and (value:IsA("TextLabel") or value:IsA("TextButton") or value:IsA("TextBox"))
end

local function wrapModule<T>(module: T, isTextModule: boolean?): T
	return setmetatable({}, {
		__index = function(_, effectName: string)
			local originalFn = (module :: any)[effectName]
			if type(originalFn) ~= "function" then
				return originalFn
			end

			return function(instanceOrTable: GuiObject | { Instance }, ...)
				local inputType = typeof(instanceOrTable)

				if inputType == "table" then
					local controllers: { EffectController } = {}
					local validCount = 0

					for _, item in instanceOrTable :: { Instance } do
						local isValid = if isTextModule then isTextElement(item) else isGuiObject(item)
						if isValid then
							validCount += 1
							local controller = originalFn(item, ...)
							if controller then
								table.insert(controllers, controller)
							end
						end
					end

					if validCount == 0 then
						warn(string.format("[BitFrames] %s: No valid GuiObjects found in table", effectName))
					end

					return {
						stop = function()
							for _, ctrl in controllers do
								if ctrl.stop then ctrl.stop() end
							end
						end,
						pause = function()
							for _, ctrl in controllers do
								if ctrl.pause then ctrl.pause() end
							end
						end,
						resume = function()
							for _, ctrl in controllers do
								if ctrl.resume then ctrl.resume() end
							end
						end,
					}
				elseif inputType == "Instance" then
					local isValid = if isTextModule then isTextElement(instanceOrTable) else isGuiObject(instanceOrTable)
					if not isValid then
						local expectedType = if isTextModule then "TextLabel/TextButton/TextBox" else "GuiObject"
						error(string.format("[BitFrames] %s: Expected %s, got %s", effectName, expectedType, instanceOrTable.ClassName), 2)
					end
					return originalFn(instanceOrTable, ...)
				else
					error(string.format("[BitFrames] %s: Expected GuiObject or table, got %s", effectName, inputType), 2)
				end
			end
		end
	}) :: T
end

--[[
	=========  MAIN MODULE  =========
]]
local BitFrames = {}

BitFrames.Easing = Config.Easing
BitFrames.SpringPresets = Config.Spring
BitFrames.Entrance = wrapModule(Entrance, false) :: WrappedEntrance
BitFrames.Exit = wrapModule(Exit, false) :: WrappedExit
BitFrames.Attention = wrapModule(Attention, false) :: WrappedAttention
BitFrames.Loop = wrapModule(Loop, false) :: WrappedLoop
BitFrames.TextEffect = wrapModule(TextEffect, true) :: WrappedTextEffect
BitFrames.Transition = wrapModule(Transition, false) :: WrappedTransition
BitFrames.Interaction = wrapModule(Interaction, false) :: WrappedInteraction
BitFrames.Tween = Tween

function BitFrames.new(instance: GuiObject): BitFramesChain
	Check._assertGuiObject(instance, "instance")
	return Chain._new(instance) :: any
end

return BitFrames