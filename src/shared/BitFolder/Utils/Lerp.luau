--!strict
--[[
    =========  LERP FUNCTIONS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Interpolation functions for each supported UI property type.
    All functions: lerp(a, b, t) where t is 0-1
]]
--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Check)
local assertArg = Check.assertArg

--[[
    =========  MAIN MODULE  =========
]]
local Lerp = {}

--[[
    =========  PRIMITIVES  =========
]]
function Lerp.number(a: number, b: number, t: number): number
    return a + (b - a) * t
end

function Lerp.boolean(a: boolean, b: boolean, t: number): boolean
    return t >= 0.5 and b or a
end

--[[
    =========  UDIM  =========
]]
function Lerp.UDim(a: UDim, b: UDim, t: number): UDim
    return UDim.new(
        a.Scale + (b.Scale - a.Scale) * t,
        math.round(a.Offset + (b.Offset - a.Offset) * t)
    )
end

function Lerp.UDim2(a: UDim2, b: UDim2, t: number): UDim2
    return UDim2.new(
        a.X.Scale + (b.X.Scale - a.X.Scale) * t,
        math.round(a.X.Offset + (b.X.Offset - a.X.Offset) * t),
        a.Y.Scale + (b.Y.Scale - a.Y.Scale) * t,
        math.round(a.Y.Offset + (b.Y.Offset - a.Y.Offset) * t)
    )
end

--[[
    =========  VECTORS  =========
]]
function Lerp.Vector2(a: Vector2, b: Vector2, t: number): Vector2
    return a:Lerp(b, t)
end

function Lerp.Vector3(a: Vector3, b: Vector3, t: number): Vector3
    return a:Lerp(b, t)
end

--[[
    =========  COLOR  =========
]]
function Lerp.Color3(a: Color3, b: Color3, t: number): Color3
    return a:Lerp(b, t)
end

--[[
    =========  RECT  =========
]]
function Lerp.Rect(a: Rect, b: Rect, t: number): Rect
    return Rect.new(
        a.Min:Lerp(b.Min, t),
        a.Max:Lerp(b.Max, t)
    )
end

--[[
    =========  NUMBER RANGE  =========
]]
function Lerp.NumberRange(a: NumberRange, b: NumberRange, t: number): NumberRange
    return NumberRange.new(
        a.Min + (b.Min - a.Min) * t,
        a.Max + (b.Max - a.Max) * t
    )
end

--[[
    =========  SEQUENCES (START/END ONLY)  =========
]]
function Lerp.NumberSequence(a: NumberSequence, b: NumberSequence, t: number): NumberSequence
    local aKeypoints = a.Keypoints
    local bKeypoints = b.Keypoints
    
    local startValue = aKeypoints[1].Value + (bKeypoints[1].Value - aKeypoints[1].Value) * t
    local endValue = aKeypoints[#aKeypoints].Value + (bKeypoints[#bKeypoints].Value - aKeypoints[#bKeypoints].Value) * t
    
    return NumberSequence.new(startValue, endValue)
end

function Lerp.ColorSequence(a: ColorSequence, b: ColorSequence, t: number): ColorSequence
    local aKeypoints = a.Keypoints
    local bKeypoints = b.Keypoints
    
    local startColor = aKeypoints[1].Value:Lerp(bKeypoints[1].Value, t)
    local endColor = aKeypoints[#aKeypoints].Value:Lerp(bKeypoints[#bKeypoints].Value, t)
    
    return ColorSequence.new(startColor, endColor)
end

--[[
    =========  AUTO DETECT  =========
]]
function Lerp.auto(a: any, b: any, t: number): any
    assertArg(t, "t", "number")
    local valueType = typeof(a)
    
    local lerpFn = (Lerp :: any)[valueType]
    if lerpFn then
        return lerpFn(a, b, t)
    end
    
    if t >= 0.5 then
        return b
    end
    return a
end

return Lerp
