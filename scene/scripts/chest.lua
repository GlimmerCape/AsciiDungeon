local calc = require("scene.scripts.calculate")

local M = {}

function M.new(instance, last)

    local sheetData = { width = 100,
        height = 100,
        numFrames = 64, }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset.png", sheetData)
    local sequenceData = { { name = "idle", frames = { 4 } } }
    instance:setFillColor(1, 0.9, 0.3)
    instance.fill.effect = "filter.brightness"
    instance.fill.effect.intensity = 0.8
    local UI
    local range = 200;
    math.randomseed(os.time())
    local gold = math.random(100, 200)
    local empty = false

    last = false or last
    physics.addBody(instance, "static")
    -- local function onLocalCollision(event)
    --     UI = itemsUI.new(items)
    --     if event.phase == "ended" then
    --         UI:removeSelf()
    --         UI = nil
    --     end
    -- end

    local function onObjectTouch(event)
        if (event.phase == "began") then
            if (calc.distance(instance, player) < range and last) then
                last = false
                gameComplete.alpha = 1
                scoreText.alpha = 1
                scoreText.text = Score
                gameComplete:toFront()
                player.alpha = 0
                uiGroup.alpha = 0

            elseif (calc.distance(instance, player) < range and empty) then
                transition.cancel(TopTextGroup)
                TopText.text = "Chest is empty"
                TopTextGroup.alpha = 1
                transition.to(TopTextGroup, { time = 2000, alpha = 0, transition = easing.inQuart })
            elseif (calc.distance(instance, player) < range) then
                transition.cancel(TopTextGroup)
                TopText.text = "You got " .. gold .. " gold"
                LocalScore = LocalScore + gold
                empty = true
                TopTextGroup.alpha = 1
                instance.fill.effect.intensity = 0.5
                transition.to(TopTextGroup, { time = 2000, alpha = 0, transition = easing.inQuart })
            end
            if (calc.distance(instance, player) >= range) then
                transition.cancel(TopTextGroup)
                TopText.text = "Get closer to the chest"
                TopTextGroup.alpha = 1
                transition.to(TopTextGroup, { time = 1500, alpha = 0, transition = easing.inQuart })
            end
        end
    end

    -- instance.collision = onLocalCollision
    -- instance:addEventListener("collision")
    instance:addEventListener("touch", onObjectTouch)
    instance.name = "chest"
    instance.type = "chest"
    return instance
end

return M
