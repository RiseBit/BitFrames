--!strict
--[[
    =========  TEXT EFFECTS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Pre-made text animations using centralized Scheduler.
]]

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Parent.Utils.Check)
local AnimationFactory = require(script.Parent.Parent.Core.AnimationFactory)
local Types = require(script.Parent.Parent.Core.Types)

local assertArg = Check.assertArg

--[[
    =========  TYPES  =========
]]
type TypewriterConfig = Types.TypewriterConfig
type ScrambleConfig = Types.ScrambleConfig
type ColorCycleConfig = Types.ColorCycleConfig
type ColorPulseConfig = Types.ColorPulseConfig
type GlitchConfig = Types.GlitchConfig
type EffectController = Types.EffectController

--[[
    =========  CONSTANTS  =========
]]
local DEFAULT_TYPEWRITER_SPEED = 0.05
local DEFAULT_CURSOR = "|"
local DEFAULT_SCRAMBLE_DURATION = 1
local DEFAULT_SCRAMBLE_CHARS = "!@#$%^&*()_+-=[]{}|;:,.<>?"

--[[
    =========  HELPER FUNCTIONS  =========
]]
local function isTextElement(element: Instance): boolean
    return element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox")
end

local function hsvToColor3(h: number, s: number, v: number): Color3
    return Color3.fromHSV(h % 1, s, v)
end

--[[
    =========  MAIN MODULE  =========
]]
local TextEffect = {}

function TextEffect.typewriter(element: TextLabel | TextButton | TextBox, text: string, config: TypewriterConfig?): EffectController
    assertArg(element, "element", "Instance")
    assertArg(text, "text", "string")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local speed = config and config.speed or DEFAULT_TYPEWRITER_SPEED
    local cursor = config and config.cursor or DEFAULT_CURSOR
    local onComplete = config and config.onComplete

    local elapsed = 0
    local charIndex = 0
    local totalChars = #text
    local showCursor = true
    local cursorTimer = 0

    textElement.Text = ""

    local function reset()
        textElement.Text = text
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            cursorTimer = cursorTimer + dt

            if cursorTimer >= 0.5 then
                cursorTimer = 0
                showCursor = not showCursor
            end

            local targetIndex = math.floor(elapsed / speed)
            if targetIndex > charIndex and charIndex < totalChars then
                charIndex = math.min(targetIndex, totalChars)
                local displayText = string.sub(text, 1, charIndex)
                if charIndex < totalChars then
                    displayText = displayText .. (showCursor and cursor or "")
                end
                textElement.Text = displayText
            end

            if charIndex >= totalChars then
                textElement.Text = text
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function TextEffect.scramble(element: TextLabel | TextButton | TextBox, text: string, config: ScrambleConfig?): EffectController
    assertArg(element, "element", "Instance")
    assertArg(text, "text", "string")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local duration = config and config.duration or DEFAULT_SCRAMBLE_DURATION
    local chars = config and config.chars or DEFAULT_SCRAMBLE_CHARS
    local onComplete = config and config.onComplete

    local elapsed = 0
    local totalChars = #text
    local random = Random.new()

    local function reset()
        textElement.Text = text
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local progress = math.clamp(elapsed / duration, 0, 1)

            local revealedCount = math.floor(progress * totalChars)
            local result = ""

            for i = 1, totalChars do
                if i <= revealedCount then
                    result = result .. string.sub(text, i, i)
                else
                    result = result .. string.sub(chars, random:NextInteger(1, #chars), random:NextInteger(1, #chars))
                end
            end

            textElement.Text = result

            if progress >= 1 then
                textElement.Text = text
                return true
            end
            return false
        end,
        onComplete,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function TextEffect.colorCycle(element: TextLabel | TextButton | TextBox, config: ColorCycleConfig?): EffectController
    assertArg(element, "element", "Instance")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local speed = config and config.speed or 1
    local saturation = config and config.saturation or 1
    local brightness = config and config.brightness or 1

    local originalColor = textElement.TextColor3
    local elapsed = 0

    local function reset()
        textElement.TextColor3 = originalColor
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt * speed
            textElement.TextColor3 = hsvToColor3(elapsed, saturation, brightness)
            return false
        end,
        nil,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function TextEffect.colorPulse(element: TextLabel | TextButton | TextBox, config: ColorPulseConfig?): EffectController
    assertArg(element, "element", "Instance")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local fromColor = config and config.fromColor or Color3.new(1, 1, 1)
    local toColor = config and config.toColor or Color3.new(1, 0, 0)
    local speed = config and config.speed or 1

    local originalColor = textElement.TextColor3
    local elapsed = 0

    local function reset()
        textElement.TextColor3 = originalColor
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt * speed
            local progress = (math.sin(elapsed * math.pi * 2) + 1) / 2
            textElement.TextColor3 = fromColor:Lerp(toColor, progress)
            return false
        end,
        nil,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function TextEffect.glitch(element: TextLabel | TextButton | TextBox, config: GlitchConfig?): EffectController
    assertArg(element, "element", "Instance")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local intensity = config and config.intensity or 0.3
    local speed = config and config.speed or 10

    local originalText = textElement.Text
    local originalColor = textElement.TextColor3
    local random = Random.new()
    local elapsed = 0
    local nextGlitch = 0

    local glitchChars = "!@#$%^&*()_+-=[]{}|;:,.<>?/\\~`"

    local function reset()
        textElement.Text = originalText
        textElement.TextColor3 = originalColor
    end

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt

            if elapsed >= nextGlitch then
                nextGlitch = elapsed + (1 / speed)

                if random:NextNumber() < intensity then
                    local result = ""
                    for i = 1, #originalText do
                        if random:NextNumber() < intensity then
                            local idx = random:NextInteger(1, #glitchChars)
                            result = result .. string.sub(glitchChars, idx, idx)
                        else
                            result = result .. string.sub(originalText, i, i)
                        end
                    end
                    textElement.Text = result
                    textElement.TextColor3 = Color3.new(
                        random:NextNumber(),
                        random:NextNumber(),
                        random:NextNumber()
                    )
                else
                    textElement.Text = originalText
                    textElement.TextColor3 = originalColor
                end
            end

            return false
        end,
        nil,
        reset
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, reset)
end

function TextEffect.fadeColor(element: TextLabel | TextButton | TextBox, toColor: Color3, config: Types.TransitionConfig?): EffectController
    assertArg(element, "element", "Instance")

    if not isTextElement(element) then
        error("Element must be TextLabel, TextButton, or TextBox", 2)
    end

    local textElement = element :: TextLabel
    local duration = config and config.duration or 0.3
    local onComplete = config and config.onComplete

    local fromColor = textElement.TextColor3
    local elapsed = 0

    local animation = AnimationFactory.create(
        function(dt: number): boolean
            elapsed = elapsed + dt
            local progress = math.clamp(elapsed / duration, 0, 1)
            textElement.TextColor3 = fromColor:Lerp(toColor, progress)

            if progress >= 1 then
                textElement.TextColor3 = toColor
                return true
            end
            return false
        end,
        onComplete,
        nil
    )

    AnimationFactory.start(animation)
    return AnimationFactory.createController(animation, nil)
end

return TextEffect
