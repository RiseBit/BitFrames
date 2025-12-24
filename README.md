# BitFrames

A powerful, fluent, and modular UI animation library for Roblox. Create stunning visual effects with ease.

**BitFrames** is designed to be a better replacement for `TweenService`, offering two different tweening engines (Spring and Easing) and a suite of pre-made, optimized animations.

**FULL-DOCUMENTATION**: https://bitframedocs-d2s277rq3-risebit-1871s-projects.vercel.app/

## Features

- **Fluent API**: Chainable methods for clean and readable code.
- **Batch Tweening**: You can tween multiple GuiObject at once.
- **Dual Tween**: Support for both physics-based `Spring` animations and standard `Easing` styles.
- **Pre-made Effects**: Includes a variety of built-in effects like Entrance, Exit, Attention, Loop, and Text animations.
- **Optimized**: Designed for performance with efficient memory management.
- **Full-Control with UI**: You got Pause, Resume, Stop, Oncompleted callback, Oninterrupted callback, and more.
- **Type Safe**: Full Luau type support for better autocomplete and strict typing.

## Installation

### Wally

Append the following to your `wally.toml`:

```toml
[dependencies]
BitFrames = "risebit/bitframe@0.1.7"
```

### Github ( Recommended )

https://github.com/RiseBit/BitFrames

## Usage

### Basic Example

```lua
local BitFrames = require(path.to.BitFrames)

local frame = script.Parent.Frame
local animator = BitFrames.new(frame)

animator:fadeIn({
    duration = 1,
    style = BitFrames.Easing.Quad,
    direction = BitFrames.Easing.Out,
}):play()
```

### Chaining Effects

```lua
animator
    :fadeInUp()
    :wait(1)
    :pulse({ infinite = true })
    :play()
```

### Text Effects

```lua
local textLabel = script.Parent.TextLabel
local textAnimator = BitFrames.new(textLabel)

textAnimator:typewriter("Hello, World!", {
    speed = 0.05,
    cursor = "_"
})
```

## API Overview

### Constructors

- `BitFrames.new(instance: GuiObject): BitFramesObject`

### Effect Categories

- **Entrance**: `fadeIn`, `fadeInUp`, `scaleIn`, `dropIn`, etc.
- **Exit**: `fadeOut`, `fadeOutDown`, `scaleOut`, `shrinkOut`, etc.
- **Attention**: `pulse`, `shake`, `bounce`, `flash`, `jello`, etc.
- **Loop**: `spin`, `float`, `breathe`, `glow`, etc.
- **Text**: `typewriter`, `scramble`, `colorCycle`, `glitch`, etc.

## Tween Type

You can switch between tweening in the configuration:

- **Easing**: Standard TweenService-like styles (Quad, Cubic, Elastic, etc.)
- **Spring**: Physics-based animations (damping, stiffness, mass) (Credit to Fractality for the Spring Module)
