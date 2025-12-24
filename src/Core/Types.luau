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
    id: string,
    state: AnimationState,
    elapsed: number,
    delayRemaining: number,
    progress: number,

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
}

export type ExitConfig = {
    duration: number?,
    easing: string?,
    delay: number?,
    spring: boolean?,
    damping: number?,
    frequency: number?,
    onComplete: (() -> ())?,
}

export type AttentionConfig = {
    duration: number?,
    loops: number?,
    intensity: number?,
    onComplete: (() -> ())?,
}

export type LoopConfig = {
    speed: number?,
    intensity: number?,
}

export type TypewriterConfig = {
    speed: number?,
    cursor: string?,
    onComplete: (() -> ())?,
}

export type ScrambleConfig = {
    duration: number?,
    chars: string?,
    onComplete: (() -> ())?,
}

export type RollValueConfig = {
    duration: number?,
    easing: string?,
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

--[[
    =========  UTILITY TYPES  =========
]]
export type EasingFunction = (t: number) -> number
export type SlideDirection = "left" | "right" | "up" | "down"

return {}