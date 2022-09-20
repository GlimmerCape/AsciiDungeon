local fx = require("com.ponywolf.ponyfx")
local composer = require("composer")

-- Define module
local M = {}

function M.new(instance, options)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))
    local sounds = scene.sounds

    -- Default options for instance
    options = options or {}

    -- Store map placement and hide placeholder
    instance.isVisible = false
    local parent = instance.parent
    local x, y = instance.x, instance.y

    -- Load spritesheet
    local sheetData = { width = 64, height = 64, numFrames = 256, sheetContentWidth = 1024, sheetContentHeight = 1024 }
    local sheet = graphics.newImageSheet("scene/game/map/SbQR9Q2.png", sheetData)
    local sequenceData = {
        { name = "idle", frames = { 16 } },
    }
    instance = display.newSprite(parent, sheet, sequenceData)
    instance.x, instance.y = x, y
    instance:setSequence("idle")

    -- Add physics
    physics.addBody(instance, "dynamic", { radius = 16, density = 3, bounce = 0, friction = 1.0 })
    instance.isFixedRotation = false


    -- Keyboard control
    local max, acceleration, left, right = 375, 5000, 0, 0
    local lastEvent = {}
    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
        if phase == "down" then
            if "left" == name or "a" == name then
                left = -acceleration
            end
            if "right" == name or "d" == name then
                right = acceleration
            elseif "space" == name or "buttonA" == name or "button1" == name then
                -- add shooting mechanic
            end
        elseif phase == "up" then
            if "left" == name or "a" == name then left = 0 end
            if "right" == name or "d" == name then right = 0 end
        end
        lastEvent = event
    end

    local function enterFrame()
        local vx, vy = instance:getLinearVelocity()
        local dx = left + right
        if instance.jumping then dx = dx / 4 end
        if (dx < 0 and vx > -max) or (dx > 0 and vx < max) then
            instance:applyForce(dx or 0, 0, instance.x, instance.y)
        end
        -- Turn around
        -- instance.xScale = math.min(1, math.max(instance.xScale + flip, -1))
    end

    function instance:finalize()
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    -- Add a finalize listener (for display objects only, comment out for non-visual)
    instance:addEventListener("finalize")

    -- Add our enterFrame listener
    Runtime:addEventListener("enterFrame", enterFrame)

    -- Add our key/joystick listeners
    Runtime:addEventListener("key", key)


    -- Return instance
    instance.name = "player"
    instance.type = "player"
    return instance
end

return M
