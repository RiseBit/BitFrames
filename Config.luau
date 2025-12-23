--!strict
--[[
    =========  HELPER FUNCTIONS  =========
]]
local function createEnum(name: string, values: { string }): { [string]: string }
    local enum = {}
    for _, value in values do
        enum[value] = value
    end

    return table.freeze(setmetatable(enum, {
        __index = function(_, key)
            error(string.format("Invalid %s: '%s'", name, tostring(key)), 2)
        end,
    }))
end

--[[
    =========  DEFAULTS  =========
]]
local Defaults = table.freeze({
    DURATION = 0.3,
    EASING = "OutQuad",
    DAMPING = 0.8,
    FREQUENCY = 3,
    DELAY = 0,
})

--[[
    =========  EASING ENUM  =========
]]
local Easing = createEnum("Easing", {
    "Linear",
    "InQuad", "OutQuad", "InOutQuad",
    "InCubic", "OutCubic", "InOutCubic",
    "InQuart", "OutQuart", "InOutQuart",
    "InQuint", "OutQuint", "InOutQuint",
    "InSine", "OutSine", "InOutSine",
    "InExpo", "OutExpo", "InOutExpo",
    "InCirc", "OutCirc", "InOutCirc",
    "InElastic", "OutElastic", "InOutElastic",
    "InBack", "OutBack", "InOutBack",
    "InBounce", "OutBounce", "InOutBounce",
})

--[[
    =========  SPRING PRESETS  =========
]]
local Spring = {
    Default = { damping = 1, frequency = 1 },
    Gentle = { damping = 0.9, frequency = 2 },
    Bouncy = { damping = 0.5, frequency = 4 },
    Stiff = { damping = 0.8, frequency = 8 },
    Slow = { damping = 0.9, frequency = 1 },
    Molasses = { damping = 1.2, frequency = 0.5 },
}

--[[
    =========  TEXT EFFECT DEFAULTS  =========
]]
local TextDefaults = table.freeze({
    TYPEWRITER_SPEED = 0.05,
    CURSOR = "|",
    SCRAMBLE_DURATION = 1,
    SCRAMBLE_CHARS = "!@#$%^&*()_+-=[]{}|;:,.<>?",
})

--[[
    =========  ATTENTION EFFECT DEFAULTS  =========
]]
local AttentionDefaults = table.freeze({
    DURATION = 0.4,
    LOOPS = 1,
})

--[[
    =========  PRESET ENUM  =========
]]
local Preset = createEnum("Preset", {
    "FadeIn", "FadeInUp", "FadeInDown", "FadeInLeft", "FadeInRight",
    "ScaleIn", "ScaleInBounce",
    "SlideInUp", "SlideInDown", "SlideInLeft", "SlideInRight",
    "ZoomIn", "DropIn", "FlipInX", "FlipInY",

    "FadeOut", "FadeOutUp", "FadeOutDown", "FadeOutLeft", "FadeOutRight",
    "ScaleOut", "ShrinkOut",
    "SlideOutUp", "SlideOutDown", "SlideOutLeft", "SlideOutRight",
    "ZoomOut",

    "Pulse", "Shake", "Bounce", "Wiggle", "Flash", "Heartbeat", "Jello", "RubberBand",

    "Spin", "SpinReverse", "Float", "Breathe", "Glow", "Swing", "Sway",

    "Wave", "Rainbow", "Typewriter", "Scramble", "Glitch",
})

return table.freeze({
    Defaults = Defaults,
    Easing = Easing,
    Spring = table.freeze(Spring),
    Preset = Preset,
    TextDefaults = TextDefaults,
    AttentionDefaults = AttentionDefaults,
})