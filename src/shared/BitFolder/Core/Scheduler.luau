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
local GENERATE_ID_LENGTH = 8
local GENERATE_ID_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

--[[
    =========  VARIABLES  =========
]]
local activeAnimations: { [string]: Animation } = {}
local animationCount = 0
local random = Random.new()
local connection: RBXScriptConnection? = nil
local Check = require(script.Parent.Parent.Utils.Check)
local assertArg = Check.assertArg

local function startLoop()
    if connection then return end
    
    connection = RunService.RenderStepped:Connect(function(dt: number)
        for id, animation in activeAnimations do
            if animation.state == "paused" then continue end
            
            local completed = animation:step(dt)
            
            if completed then
                animation.state = "completed"
                activeAnimations[id] = nil
                animationCount -= 1
                animation:_fireComplete()
            end
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

function Scheduler._generateId(): string
    local id = ""
    for _ = 1, GENERATE_ID_LENGTH do
        local index = random:NextInteger(1, #GENERATE_ID_CHARS)
        id ..= string.sub(GENERATE_ID_CHARS, index, index)
    end
    return id
end

function Scheduler._add(animation: Animation)
    assertArg(animation, "animation", "table")
    if not animation.id then
        error("Animation must have an id", 2)
    end
    
    activeAnimations[animation.id] = animation
    animation.state = "playing"
    animationCount += 1
    
    startLoop()
end

function Scheduler._remove(animation: Animation)
    assertArg(animation, "animation", "table")
    if not activeAnimations[animation.id] then return end
    
    activeAnimations[animation.id] = nil
    animationCount -= 1
    animation:_fireInterrupt()
end

function Scheduler._pause(animation: Animation)
    assertArg(animation, "animation", "table")
    if activeAnimations[animation.id] then
        animation.state = "paused"
    end
end

function Scheduler._resume(animation: Animation)
    assertArg(animation, "animation", "table")
    if activeAnimations[animation.id] then
        animation.state = "playing"
    end
end

function Scheduler._stop(animation: Animation)
    assertArg(animation, "animation", "table")
    if not activeAnimations[animation.id] then return end
    
    animation.state = "stopped"
    activeAnimations[animation.id] = nil
    animationCount -= 1
    animation:_fireInterrupt()
end

function Scheduler._pauseAll()
    for _, animation in activeAnimations do
        animation.state = "paused"
    end
end

function Scheduler._resumeAll()
    for _, animation in activeAnimations do
        animation.state = "playing"
    end
end

function Scheduler._stopAll()
    for _, animation in activeAnimations do
        animation.state = "stopped"
        animation:_fireInterrupt()
    end
    activeAnimations = {}
    animationCount = 0
end

function Scheduler._getActiveCount(): number
    return animationCount
end

function Scheduler._isActive(animation: Animation): boolean
    assertArg(animation, "animation", "table")
    return activeAnimations[animation.id] ~= nil
end

return Scheduler

