--!strict
--[[
    =========  TYPE VALIDATION  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Centralized validation functions used across all BitFrames modules.
]]

local Check = {}

function Check.assertArg(value: any, argName: string, expectedType: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value == nil then
        error(string.format("Missing argument: '%s' (expected %s)", argName, expectedType), errorLevel)
    end
    if typeof(value) ~= expectedType then
        error(string.format("Invalid argument: '%s' (expected %s, got %s)", argName, expectedType, typeof(value)), errorLevel)
    end
end

function Check.assertType(value: any, expectedType: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value == nil then
        error(string.format("Expected %s, got nil", expectedType), errorLevel)
    end
    if typeof(value) ~= expectedType then
        error(string.format("Expected %s, got %s", expectedType, typeof(value)), errorLevel)
    end
end

function Check.assertInstance(value: any, argName: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value == nil then
        error(string.format("Missing argument: '%s' (expected Instance)", argName), errorLevel)
    end
    if typeof(value) ~= "Instance" then
        error(string.format("Invalid argument: '%s' (expected Instance, got %s)", argName, typeof(value)), errorLevel)
    end
end

function Check.assertGuiObject(value: any, argName: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value == nil then
        error(string.format("Missing argument: '%s' (expected GuiObject)", argName), errorLevel)
    end
    if typeof(value) ~= "Instance" or not value:IsA("GuiObject") then
        local actualType = typeof(value) == "Instance" and value.ClassName or typeof(value)
        error(string.format("Invalid argument: '%s' (expected GuiObject, got %s)", argName, actualType), errorLevel)
    end
end

function Check.assertInRange(value: number, min: number, max: number, argName: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value < min or value > max then
        error(string.format("Argument '%s' out of range: %s (expected %s to %s)", argName, tostring(value), tostring(min), tostring(max)), errorLevel)
    end
end

function Check.assertPositive(value: number, argName: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value <= 0 then
        error(string.format("Argument '%s' must be positive: %s", argName, tostring(value)), errorLevel)
    end
end

function Check.assertNonNegative(value: number, argName: string, level: number?)
    local errorLevel = (level or 2) + 1
    if value < 0 then
        error(string.format("Argument '%s' must be non-negative: %s", argName, tostring(value)), errorLevel)
    end
end

return Check
