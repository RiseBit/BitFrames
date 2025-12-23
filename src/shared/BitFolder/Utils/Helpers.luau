--!strict
--[[
    =========  HELPERS  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Centralized helper functions used across Effects modules.
]]

--[[
    =========  MODULES  =========
]]
local Easing = require(script.Parent.Easing)

--[[
    =========  MAIN MODULE  =========
]]
local Helpers = {}

function Helpers._setTransparency(element: GuiObject, alpha: number)
    element.BackgroundTransparency = alpha
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        (element :: TextLabel).TextTransparency = alpha
    end
    if element:IsA("ImageLabel") or element:IsA("ImageButton") then
        (element :: ImageLabel).ImageTransparency = alpha
    end
end

function Helpers._getEasing(name: string): (number) -> number
    local fn = Easing.get(name)
    if not fn then
        warn(`[BitFrames] Unknown easing '{name}', using default 'OutQuad'`)
        return Easing.OutQuad
    end
    return fn
end

function Helpers._isValidElement(element: Instance): boolean
    return element ~= nil and element.Parent ~= nil
end

return table.freeze(Helpers)
