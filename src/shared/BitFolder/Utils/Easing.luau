--!strict
--[[
    =========  EASING FUNCTIONS  =========
	Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    All functions take t (0-1) and return eased value (0-1)
    Based on: https://easings.net/
]]

local pi = math.pi
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local pow = math.pow
local abs = math.abs

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Check)
local assertArg = Check.assertArg

--[[
    =========  MAIN MODULE  =========
]]
local Easing = {}

--[[
    =========  LINEAR  =========
]]
function Easing.Linear(t: number): number
    assertArg(t, "t", "number")
    return t
end

--[[
    =========  QUAD  =========
]]
function Easing.InQuad(t: number): number
    assertArg(t, "t", "number")
    return t * t
end

function Easing.OutQuad(t: number): number
    assertArg(t, "t", "number")
    return t * (2 - t)
end

function Easing.InOutQuad(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 2 * t * t
    end
    return -1 + (4 - 2 * t) * t
end

--[[
    =========  CUBIC  =========
]]
function Easing.InCubic(t: number): number
    assertArg(t, "t", "number")
    return t * t * t
end

function Easing.OutCubic(t: number): number
    assertArg(t, "t", "number")
    local t1 = t - 1
    return t1 * t1 * t1 + 1
end

function Easing.InOutCubic(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 4 * t * t * t
    end
    local t1 = 2 * t - 2
    return 0.5 * t1 * t1 * t1 + 1
end

--[[
    =========  QUART  =========
]]
function Easing.InQuart(t: number): number
    assertArg(t, "t", "number")
    return t * t * t * t
end

function Easing.OutQuart(t: number): number
    assertArg(t, "t", "number")
    local t1 = t - 1
    return 1 - t1 * t1 * t1 * t1
end

function Easing.InOutQuart(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 8 * t * t * t * t
    end
    local t1 = t - 1
    return 1 - 8 * t1 * t1 * t1 * t1
end

--[[
    =========  QUINT  =========
]]
function Easing.InQuint(t: number): number
    assertArg(t, "t", "number")
    return t * t * t * t * t
end

function Easing.OutQuint(t: number): number
    assertArg(t, "t", "number")
    local t1 = t - 1
    return 1 + t1 * t1 * t1 * t1 * t1
end

function Easing.InOutQuint(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 16 * t * t * t * t * t
    end
    local t1 = 2 * t - 2
    return 0.5 * t1 * t1 * t1 * t1 * t1 + 1
end

--[[
    =========  SINE  =========
]]
function Easing.InSine(t: number): number
    assertArg(t, "t", "number")
    return 1 - cos(t * pi / 2)
end

function Easing.OutSine(t: number): number
    assertArg(t, "t", "number")
    return sin(t * pi / 2)
end

function Easing.InOutSine(t: number): number
    assertArg(t, "t", "number")
    return 0.5 * (1 - cos(pi * t))
end

--[[
    =========  EXPO  =========
]]
function Easing.InExpo(t: number): number
    assertArg(t, "t", "number")
    if t == 0 then return 0 end
    return pow(2, 10 * (t - 1))
end

function Easing.OutExpo(t: number): number
    assertArg(t, "t", "number")
    if t == 1 then return 1 end
    return 1 - pow(2, -10 * t)
end

function Easing.InOutExpo(t: number): number
    assertArg(t, "t", "number")
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    if t < 0.5 then
        return 0.5 * pow(2, 20 * t - 10)
    end

    return 1 - 0.5 * pow(2, -20 * t + 10)
end

--[[
    =========  CIRC  =========
]]
function Easing.InCirc(t: number): number
    assertArg(t, "t", "number")
    return 1 - sqrt(1 - t * t)
end

function Easing.OutCirc(t: number): number
    assertArg(t, "t", "number")
    local t1 = t - 1
    return sqrt(1 - t1 * t1)
end

function Easing.InOutCirc(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 0.5 * (1 - sqrt(1 - 4 * t * t))
    end
    local t1 = 2 * t - 2
    return 0.5 * (sqrt(1 - t1 * t1) + 1)
end

--[[
    =========  ELASTIC  =========
]]
local C4 = (2 * pi) / 3
local C5 = (2 * pi) / 4.5

function Easing.InElastic(t: number): number
    assertArg(t, "t", "number")
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    return -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * C4)
end

function Easing.OutElastic(t: number): number
    assertArg(t, "t", "number")
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    return pow(2, -10 * t) * sin((t * 10 - 0.75) * C4) + 1
end

function Easing.InOutElastic(t: number): number
    assertArg(t, "t", "number")
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    if t < 0.5 then
        return -0.5 * pow(2, 20 * t - 10) * sin((20 * t - 11.125) * C5)
    end
    return 0.5 * pow(2, -20 * t + 10) * sin((20 * t - 11.125) * C5) + 1
end

--[[
    =========  BACK  =========
]]
local C1 = 1.70158
local C2 = C1 * 1.525
local C3 = C1 + 1

function Easing.InBack(t: number): number
    assertArg(t, "t", "number")
    return C3 * t * t * t - C1 * t * t
end

function Easing.OutBack(t: number): number
    assertArg(t, "t", "number")
    local t1 = t - 1
    return 1 + C3 * t1 * t1 * t1 + C1 * t1 * t1
end

function Easing.InOutBack(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 0.5 * (4 * t * t * ((C2 + 1) * 2 * t - C2))
    end
    local t1 = 2 * t - 2
    return 0.5 * (t1 * t1 * ((C2 + 1) * t1 + C2) + 2)
end

--[[
    =========  BOUNCE  =========
]]
local N1 = 7.5625
local D1 = 2.75

function Easing.OutBounce(t: number): number
    assertArg(t, "t", "number")
    if t < 1 / D1 then
        return N1 * t * t
    elseif t < 2 / D1 then
        local t1 = t - 1.5 / D1
        return N1 * t1 * t1 + 0.75
    elseif t < 2.5 / D1 then
        local t1 = t - 2.25 / D1
        return N1 * t1 * t1 + 0.9375
    else
        local t1 = t - 2.625 / D1
        return N1 * t1 * t1 + 0.984375
    end
end

function Easing.InBounce(t: number): number
    assertArg(t, "t", "number")
    return 1 - Easing.OutBounce(1 - t)
end

function Easing.InOutBounce(t: number): number
    assertArg(t, "t", "number")
    if t < 0.5 then
        return 0.5 * (1 - Easing.OutBounce(1 - 2 * t))
    end
    return 0.5 * (1 + Easing.OutBounce(2 * t - 1))
end

--[[
    =========  LOOKUP  =========
]]
function Easing.get(name: string): ((t: number) -> number)?
    assertArg(name, "name", "string")
    return (Easing :: any)[name]
end

return Easing
