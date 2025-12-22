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

function Helpers.setTransparency(element: GuiObject, alpha: number)
    element.BackgroundTransparency = alpha
    if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
        (element :: TextLabel).TextTransparency = alpha
    end
    if element:IsA("ImageLabel") or element:IsA("ImageButton") then
        (element :: ImageLabel).ImageTransparency = alpha
    end
end

function Helpers.getEasing(name: string): (number) -> number
    return Easing.get(name) or Easing.OutQuad
end

return Helpers
