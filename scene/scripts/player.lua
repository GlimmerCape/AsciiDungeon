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
    instance.vx, instance.vy = math.cos(math.rad(instance.rotation - 180)), math.sin(math.rad(instance.rotation - 180))
    lightDir = display.newSprite(sheet, debugSequenceData)
    lightDir:setSequence("idle")
    lightDir.alpha = 0
    instance:setSequence("idle")


    instance.lightMask = graphics.newMask("javajava.png")

    instance.debugText = display.newText(" ", 300, 300, native.systemFont, 20)
    instance.debugText.x, instance.debugText.y = display.contentWidth * 0.7, 100

    -- Add physics
    physics.addBody(instance, "dynamic",
        { radius = 30, density = 3, bounce = 0, friction = 1.0, filter = { groupIndex = -1 } })
    instance.isFixedRotation = true

    -- Keyboard control
    local max, acceleration, angularSpeed, left, right, down, up, flip = 375, -350, 2.5, 0, 0, 0, 0, 0
    local lastEvent = {}

    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
        if phase == "down" then
            if "left" == name or "buttonL" == name then
                left = -angularSpeed
                right = 0
                instance.debugText.text = "L"
            end
            if "right" == name or "buttonR" == name then
                right = angularSpeed
                left = 0
                instance.debugText.text = "R"
            elseif "space" == name or "buttonA" == name or "button1" == name then
            end
            if "up" == name or "buttonU" == name then
                up = -acceleration
                down = 0
                instance.debugText.text = "U"
                print("up")
            end
            if "down" == name or "buttonD" == name then
                down = acceleration
                up = 0
                instance.debugText.text = "D"
            end
        elseif phase == "up" then
            if "left" == name or "buttonL" == name then left = 0 end
            if "right" == name or "buttonR" == name then right = 0 end
            if "up" == name or "buttonU" == name then up = 0 end
            if "down" == name or "buttonD" == name then down = 0 end
        end
        lastEvent = event
    end

    -- local axisX, axisY = 0, 0
    -- local function onAxisEvent(event)
    --     if (event.axis.number == 3) then
    --         axisX = event.normalizedValue
    --     else
    --         axisY = event.normalizedValue
    --     end
    -- end

    -- local dy = 0
    local function enterFrame()
        local dx = left + right
        instance.rotation = instance.rotation + dx

        dx = math.rad(instance.rotation + 180)
        local dy = up + down
        instance.vx = math.cos(dx)
        instance.vy = math.sin(dx)
        instance:setLinearVelocity(instance.vx * dy, instance.vy * dy, instance.x, instance.y)

        -- local dx = math.atan2((axisY - 0), (axisX - 0))
        -- if axisX ~= 0 and axisY ~= 0 and dx ~= 0 then
        --     instance.rotation = dx * (180 / math.pi) - 180
        -- end
        -- dy = 0
        -- if axisX ~= 0 and axisY ~= 0 then
        --     -- dy = -(math.abs(axisX) + math.abs(axisY)) * acceleration
        --     dy = -acceleration
        -- end
        -- instance.vx = axisX
        -- instance.vy = axisY
        -- instance:setLinearVelocity(instance.vx * dy, instance.vy * dy, instance.x, instance.y)

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

    -- Runtime:addEventListener("axis", onAxisEvent)


    -- Return instance
    instance.name = "player"
    instance.type = "player"
    return instance
end

return M
