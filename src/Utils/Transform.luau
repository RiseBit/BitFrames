--!strict
--[[
    =========  TRANSFORM UTILITIES  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit

    Helper functions for pre-made effects that work on any UI element.
]]

--[[
    =========  MODULES  =========
]]
local Check = require(script.Parent.Check)

local assertArg = Check._assertArg

--[[
    =========  MAIN MODULE  =========
]]
local Transform = {}

function Transform._getUIScale(element: GuiObject): UIScale
    assertArg(element, "element", "Instance")
    
    local existing = element:FindFirstChild("_BitFramesScale")
    if existing and existing:IsA("UIScale") then
        return existing :: UIScale
    end
    
    local uiScale = Instance.new("UIScale")
    uiScale.Name = "_BitFramesScale"
    uiScale.Parent = element
    return uiScale
end

function Transform._cleanup(element: GuiObject)
    assertArg(element, "element", "Instance")
    
    local scale = element:FindFirstChild("_BitFramesScale")
    if scale then
        scale:Destroy()
    end
end

return table.freeze(Transform)
