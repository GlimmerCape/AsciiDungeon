local fx = require("com.ponywolf.ponyfx")
local composer = require("composer")
local vjoy = require("com.ponywolf.vjoy")

-- Define module
local M = {}

function M.new(instance, options)
    -- Get the current scene
    local scene = composer.getScene(composer.getSceneName("current"))
    local sounds = scene.sounds

    -- Default options for instance
    options = options or {}

    -- Store map placement and hide placeholder
    instance.isVisible = true
    local parent = instance.parent
    local x, y = instance.x, instance.y

    -- Load spritesheet
    local sheetData = { width = 100,
        height = 100,
        numFrames = 64,
    }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset.png", sheetData)
    local sequenceData = {
        { name = "idle", frames = { 5 } },
    }
    local debugSequenceData = { { name = "idle", frames = { 1 } } }
    instance = display.newSprite(sheet, sequenceData)
    instance.x, instance.y = display.contentCenterX, display.contentCenterY
    lightDir = display.newSprite(sheet, debugSequenceData)
    lightDir:setSequence("idle")
    lightDir.alpha = 0
    instance:setSequence("idle")


    -- Add physics
    physics.addBody(instance, "dynamic",
        { radius = 30, density = 3, bounce = 0, friction = 1.0, filter = { groupIndex = -1 } })
    instance.isFixedRotation = true

    -- Keyboard control
    local max, acceleration, angularSpeed, left, right, down, up, flip = 375, -350, 5, 0, 0, 0, 0, 0
    local lastEvent = {}

    -- local function key(event)
    --     local phase = event.phase
    --     local name = event.keyName
    --     if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
    --     if phase == "down" then
    --         if "left" == name or "a" == name then
    --             left = -angularSpeed
    --         end
    --         if "right" == name or "d" == name then
    --             right = angularSpeed
    --         elseif "space" == name or "buttonA" == name or "button1" == name then
    --         end
    --         if "up" == name or "w" == name then
    --             up = -acceleration
    --         end
    --         if "down" == name or "s" == name then
    --             down = acceleration
    --         end
    --     elseif phase == "up" then
    --         if "left" == name or "a" == name then left = 0 end
    --         if "right" == name or "d" == name then right = 0 end
    --         if "up" == name or "w" == name then up = 0 end
    --         if "down" == name or "s" == name then down = 0 end
    --     end
    --     lastEvent = event
    -- end
    local axisX, axisY = 0, 0
    local function onAxisEvent(event)
        if (event.axis.number == 3) then
            axisX = event.normalizedValue
        else
            axisY = event.normalizedValue
        end
    end

    local function enterFrame()
        local dx = math.atan2((axisY - 0), (axisX - 0))
        if axisX ~= 0 and axisX ~= 0 and dx ~= 0 then
            instance.rotation = dx * (180 / math.pi) - 180
        end

        local dy = 0
        if axisX ~= 0 and axisX ~= 0 then
            dy = -(math.abs(axisX) + math.abs(axisY)) * acceleration
        end
        instance.vx = math.cos(math.rad(instance.rotation - 180))
        instance.vy = math.sin(math.rad(instance.rotation - 180))
        instance:setLinearVelocity(instance.vx * dy, instance.vy * dy, instance.x, instance.y)

    end

    function instance:finalize()
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    -- Add a finalize listener (for display objects only, comment out for non-visual)
    instance:addEventListener("finalize")

    -- Add our enterFrame listener
    Runtime:addEventListener("enterFrame", enterFrame)

    -- Add our key/joystick listeners
    -- Runtime:addEventListener("key", key)

    Runtime:addEventListener("axis", onAxisEvent)


    -- Return instance
    instance.name = "player"
    instance.type = "player"
    return instance
end

return M
