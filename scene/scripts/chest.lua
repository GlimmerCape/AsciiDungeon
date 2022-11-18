local calc = require("scene.scripts.calculate")

local fx = require("com.ponywolf.ponyfx")

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
    local gold = math.random(5, 10) * 100
    local empty = false
    local cashRegister = audio.loadSound("cashRegister.mp3")
    local victorySound = audio.loadSound("victory.wav")

    last = false or last
    physics.addBody(instance, "static")
    -- local function onLocalCollision(event)
    --     UI = itemsUI.new(items)
    --     if event.phase == "ended" then
    --         UI:removeSelf()
    --         UI = nil
    --     end
    -- end
    local loopCount = 1
    local animate = function(obj, ref)
        if ref then
            obj.transitionLoop = ref
        end

        if loopCount == 1 then
            transition.to(obj, {
                -- x = obj.x + 10,
                y = obj.y + 30,
                rotation = obj.rotation + 5,
                onComplete = obj.transitionLoop
            })
        elseif loopCount % 2 == 0 then

            transition.to(obj, {
                -- x = obj.x - 60,
                y = obj.y - 60,
                rotation = obj.rotation - 10,
                onComplete = obj.transitionLoop
            })
        else
            transition.to(obj, {
                -- x = obj.x + 60,
                y = obj.y + 60,
                rotation = obj.rotation + 10,
                onComplete = obj.transitionLoop
            })
        end
        loopCount = loopCount + 1
    end

    local function onObjectTouch(event)
        if (event.phase == "began") then
            if (calc.distance(instance, player) < range and last) then
                last = false
                local bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth,
                    display.contentHeight)
                bg:toFront()
                bg:setFillColor(0, 0, 0)
                gameComplete.alpha = 1
                gameComplete:toFront()
                scoreText.alpha = 1
                scoreText.text = Score
                scoreText:toFront()
                audio.play(victorySound)
                player.alpha = 0
                uiGroup.alpha = 0

                -- animate(gameComplete, animate)
                -- animate(scoreText, animate)
                fx.breath(gameComplete, 0.02, 2500)

                fakeButton:removeSelf()
                upButton:removeSelf()
                downButton:removeSelf()
                leftButton:removeSelf()
                rightButton:removeSelf()
                button:removeSelf()
                map.alpha = 0
            elseif (calc.distance(instance, player) < range and empty) then
                transition.cancel(TopTextGroup)
                TopText.text = "Chest is empty"
                TopTextGroup.alpha = 1
                transition.to(TopTextGroup, { time = 2000, alpha = 0, transition = easing.inQuart })
            elseif (calc.distance(instance, player) < range) then
                transition.cancel(TopTextGroup)
                TopText.text = "You got " .. gold .. " gold"
                audio.play(cashRegister)
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
