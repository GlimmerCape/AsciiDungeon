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
    instance.isVisible = true
    local parent = instance.parent
    local x, y = instance.x, instance.y

    -- Load spritesheet
    local sheetData = { width = 64,
        height = 64,
        numFrames = 256,
        sheetContentWidth = 1024, --width of original 1x size of entire sheet
        sheetContentHeight = 1024
    }
    local sheet = graphics.newImageSheet("scene/game/map/SbQR9Q2.png", sheetData)
    local sequenceData = {
        { name = "idle", frames = { 65 } },
    }
    local debugSequenceData = { { name = "idle", frames = { 5 } } }
    instance = display.newSprite(sheet, sequenceData)
    instance.x, instance.y = display.contentCenterX, display.contentCenterY
    lightDir = display.newSprite(sheet, debugSequenceData)
    lightDir:setSequence("idle")
    instance:setSequence("idle")

    -- Add physics
    physics.addBody(instance, "dynamic", { radius = 30, density = 3, bounce = 0, friction = 1.0 })
    instance.isFixedRotation = false

    local function flashLight(vx, vy)
        --  local hits = physics.rayCast(instance.x, instance.y, instance.x - (300 * vx), instance.y - (300 * vy), "sorted")
        lightDir.x, lightDir.y = instance.x - (300 * vx), instance.y - (300 * vy)
        --        if hits ~= nil then
        --           print("Hit count" .. tostring(#hits))
        --          for i, v in ipairs(hits) do
        --             print(v.x, " ", v.y)
        --        end
        --   end
    end

    -- Keyboard control
    local max, acceleration, angularSpeed, left, right, down, up, flip = 375, 350, 5, 0, 0, 0, 0, 0
    local lastEvent = {}
    local function key(event)
        local phase = event.phase
        local name = event.keyName
        if (phase == lastEvent.phase) and (name == lastEvent.keyName) then return false end -- Filter repeating keys
        if phase == "down" then
            if "left" == name or "a" == name then
                left = -angularSpeed
            end
            if "right" == name or "d" == name then
                right = angularSpeed
            elseif "space" == name or "buttonA" == name or "button1" == name then
                -- add shooting mechanic
            end
            if "up" == name or "w" == name then
                up = -acceleration
            end
            if "down" == name or "s" == name then
                down = acceleration
            end
        elseif phase == "up" then
            if "left" == name or "a" == name then left = 0 end
            if "right" == name or "d" == name then right = 0 end
            if "up" == name or "w" == name then up = 0 end
            if "down" == name or "s" == name then down = 0 end
        end
        lastEvent = event
    end

    local function enterFrame()
        local dx = left + right
        instance.rotation = instance.rotation + dx

        dx = math.rad(instance.rotation + 180)
        local dy = up + down
        local vx = math.cos(dx)
        local vy = math.sin(dx)
        instance:setLinearVelocity(vx * dy, vy * dy, instance.x, instance.y)



        flashLight(vx, vy)
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
