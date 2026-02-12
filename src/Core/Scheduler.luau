--!native
--!strict
--[[
    =========  SERVICES  =========
    Made by @RiseBit, Discord: risebit, Github: https://github.com/RiseBit
]]
local RunService = game:GetService("RunService")

--[[
    =========  MODULES  =========
]]
local Types = require(script.Parent.Types)

--[[
    =========  TYPES  =========
]]
type Animation = Types.Animation

--[[
    =========  CONSTANTS  =========
]]

--[[
    =========  VARIABLES  =========
]]
local guiObjectState = setmetatable({}, { __mode = "k" }) -- [guiObject] = { [animationName] = Animation }

local activeAnimations: { [number]: Animation } = {}
local animationCount = 0
local connection: RBXScriptConnection? = nil
local Check = require(script.Parent.Parent.Utils.Check)
local assertArg = Check._assertArg

local function startLoop()
    if connection then return end
    
    connection = RunService.RenderStepped:Connect(function(dt: number)
        local toComplete: { Animation } = {}
        
        for id, animation in activeAnimations do
            if animation.state == "paused" then continue end
            
            local completed = animation:step(dt)
            
            if completed then
                animation.state = "completed"
                activeAnimations[id] = nil
                animationCount -= 1
                table.insert(toComplete, animation)
            end
        end
        
        for _, animation in toComplete do
            animation:_fireComplete()
        end
        
        if animationCount == 0 then
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end

--[[
    =========  MAIN MODULE  =========
]]
local Scheduler = {}

function Scheduler._add(animation: Animation)
	assertArg(animation, "animation", "table")

	local target = animation.targetObject
	local animType = animation.animationType
	if target and animType then
		if guiObjectState[target] and guiObjectState[target][animType] then
			local oldAnimation = guiObjectState[target][animType]
			if oldAnimation and oldAnimation.animationType == animType then
				Scheduler._remove(oldAnimation)
			end
		end
		
		if not guiObjectState[target] then
			guiObjectState[target] = {}
		end
		guiObjectState[target][animType] = animation
	end
	
	animationCount += 1
	(animation :: any)._scheduleIndex = animationCount
	activeAnimations[animationCount] = animation
	animation.state = "playing"
	
	startLoop()
end

function Scheduler._remove(animation: Animation)
	assertArg(animation, "animation", "table")
	local index = (animation :: any)._scheduleIndex
	if not index or not activeAnimations[index] then return end
	
	activeAnimations[index] = nil
	animationCount -= 1
	
	local target = animation.targetObject
	local animType = animation.animationType
	if target and animType and guiObjectState[target] then
		if guiObjectState[target][animType] == animation then
			 guiObjectState[target][animType] = nil
		end
		if next(guiObjectState[target]) == nil then
			 guiObjectState[target] = nil
		end
	end

	animation:_fireInterrupt()
end

function Scheduler._pause(animation: Animation)
	assertArg(animation, "animation", "table")
	local index = (animation :: any)._scheduleIndex
	if index and activeAnimations[index] then
		animation.state = "paused"
	end
end

function Scheduler._resume(animation: Animation)
	assertArg(animation, "animation", "table")
	local index = (animation :: any)._scheduleIndex
	if index and activeAnimations[index] then
		animation.state = "playing"
	end
end

function Scheduler._stop(animation: Animation)
	assertArg(animation, "animation", "table")
	local index = (animation :: any)._scheduleIndex
	if not index or not activeAnimations[index] then return end
	
	animation.state = "stopped"
	activeAnimations[index] = nil
	animationCount -= 1
	
	local target = animation.targetObject
	local animType = animation.animationType
	if target and animType and guiObjectState[target] then
		if guiObjectState[target][animType] == animation then
			 guiObjectState[target][animType] = nil
		end
		if next(guiObjectState[target]) == nil then
			 guiObjectState[target] = nil
		end
	end

	animation:_fireInterrupt()
end

function Scheduler._stopByElement(element: Instance, animationType: string)
	if guiObjectState[element] and guiObjectState[element][animationType] then
		local animation = guiObjectState[element][animationType]
		if animation then
			Scheduler._remove(animation)
		end
	end
end

return table.freeze(Scheduler)
