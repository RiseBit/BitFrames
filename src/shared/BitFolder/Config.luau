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
local Defaults = {
    TWEEN_DURATION = 0.3,
    EASING = "OutQuad",
    SPRING_DAMPING = 1,
    SPRING_FREQUENCY = 1,
    DELAY = 0,
}

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
})