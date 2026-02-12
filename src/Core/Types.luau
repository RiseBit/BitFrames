--!strict
--[[
    =========  CORE TYPES  =========
    Centralized type definitions for the BitFrames library.
]]

--[[
    =========  ANIMATION STATE  =========
]]
export type AnimationState = "idle" | "playing" | "paused" | "completed" | "stopped"

--[[
    =========  ANIMATION TYPES  =========
]]
export type Animation = {
    state: AnimationState,
    animationType: string,
    targetObject: Instance?,

    step: (self: Animation, dt: number) -> boolean,
    _fireStart: (self: Animation) -> (),
    _fireUpdate: (self: Animation) -> (),
    _fireComplete: (self: Animation) -> (),
    _fireInterrupt: (self: Animation) -> (),
}

--[[
    =========  CONTROLLER TYPES  =========
]]
export type EffectController = {
    stop: () -> (),
    pause: () -> (),
    resume: () -> (),
}

--[[
    =========  EFFECT CONFIG TYPES  =========
]]
export type EntranceConfig = {
	duration: number?,
	easing: string?,
	delay: number?,
	spring: boolean?,
	damping: number?,
	frequency: number?,
	onComplete: (() -> ())?,
	transparencyProperties: {string}?,
	distance: number?,
	initialScale: number?,
}

export type ExitConfig = {
	duration: number?,
	easing: string?,
	delay: number?,
	spring: boolean?,
	damping: number?,
	frequency: number?,
	onComplete: (() -> ())?,
	transparencyProperties: {string}?,
	distance: number?,
	targetScale: number?,
}

export type AttentionConfig = {
	duration: number?,
	loops: number?,
	intensity: number?,
	onComplete: (() -> ())?,
	transparencyProperties: {string}?,
}

export type LoopConfig = {
	speed: number?,
	intensity: number?,
	transparencyProperties: {string}?,
}

export type TypewriterConfig = {
    speed: number?,
    cursor: string?,
    onComplete: (() -> ())?,
    sound: (Sound | Folder)?, 
}

export type ScrambleConfig = {
    duration: number?,
    chars: string?,
    onComplete: (() -> ())?,
}

export type RollValueConfig = {
    duration: number?,
    easing: string?,
    startValue: number?,
    format: ((value: number) -> string)?,
    onComplete: (() -> ())?,
}

export type ColorCycleConfig = {
    speed: number?,
    saturation: number?,
    brightness: number?,
}

export type ColorPulseConfig = {
    fromColor: Color3?,
    toColor: Color3?,
    speed: number?,
}

export type GlitchConfig = {
    intensity: number?,
    speed: number?,
}

export type TransitionConfig = {
	duration: number?,
	easing: string?,
	spring: boolean?,
	damping: number?,
	frequency: number?,
	onComplete: (() -> ())?,
	transparencyProperties: {string}?,
	distance: number?,
}

export type TweenConfig = {
    duration: number?,
    easing: string?,
    delay: number?,
    onComplete: (() -> ())?,
}

export type SpringConfig = {
    damping: number?,
    frequency: number?,
    delay: number?,
    onComplete: (() -> ())?,
}

export type RippleConfig = {
    duration: number?,
    color: Color3?,
    transparency: number?,
    maxSize: number?,
    onComplete: (() -> ())?,
}

export type PressConfig = {
	duration: number?,
	color: Color3?,
	transparency: number?,
	size: number?,
	onComplete: (() -> ())?,
}

export type HighlightConfig = {
    duration: number?,
    color: Color3?,
    transparency: number?,
}

export type HoverConfig = {
    scale: number?,
    duration: number?,
    easing: string?,
    spring: boolean?,
    damping: number?,
    frequency: number?,
}

--[[
    =========  UTILITY TYPES  =========
]]
export type EasingFunction = (t: number) -> number
export type SlideDirection = "left" | "right" | "up" | "down"

--[[
    =========  CHAIN API TYPES  =========
]]
export type ChainClassImpl = {
	_instance: GuiObject,
	_queue: any,
	_isPlaying: boolean,
	_currentController: EffectController?,
	_delayThread: thread?,
	_addEffect: (self: ChainClassImpl, effectFn: () -> EffectController, duration: number) -> ChainClassImpl,
	
	-- Core chain methods
	wait: (self: ChainClassImpl, seconds: number) -> ChainClassImpl,
	play: (self: ChainClassImpl, onComplete: (() -> ())?) -> EffectController,
	stop: (self: ChainClassImpl) -> (),
	
	-- Entrance effects
	fadeIn: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	fadeInUp: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	fadeInDown: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	scaleIn: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	scaleInBounce: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	zoomIn: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	dropIn: (self: ChainClassImpl, config: EntranceConfig?) -> ChainClassImpl,
	
	-- Exit effects
	fadeOut: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	fadeOutUp: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	fadeOutDown: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	scaleOut: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	shrinkOut: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	zoomOut: (self: ChainClassImpl, config: ExitConfig?) -> ChainClassImpl,
	
	-- Attention effects
	pulse: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	shake: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	bounce: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	wiggle: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	flash: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	heartbeat: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	jello: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	confetti: (self: ChainClassImpl, config: AttentionConfig?) -> ChainClassImpl,
	
	-- Loop effects
	spin: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	spinReverse: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	float: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	breathe: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	glow: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	swing: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	sway: (self: ChainClassImpl, config: LoopConfig?) -> ChainClassImpl,
	
	-- Text effects
	typewriter: (self: ChainClassImpl, text: string, config: TypewriterConfig?) -> ChainClassImpl,
	scramble: (self: ChainClassImpl, text: string, config: ScrambleConfig?) -> ChainClassImpl,
	rollValue: (self: ChainClassImpl, targetValue: number, config: RollValueConfig?) -> ChainClassImpl,
	colorCycle: (self: ChainClassImpl, config: ColorCycleConfig?) -> ChainClassImpl,
	colorPulse: (self: ChainClassImpl, config: ColorPulseConfig?) -> ChainClassImpl,
	glitch: (self: ChainClassImpl, config: GlitchConfig?) -> ChainClassImpl,
}

return {}
