local M = {}

function M.new(x, y)

    local sheetData = { width = 100,
        height = 100,
        numFrames = 64, }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset.png", sheetData)
    local sequenceData = { { name = "idle", frames = { 4 } } }
    local enemy = display.newSprite(sheet, sequenceData)
    enemy:setSequence("idle")
    enemy.x, enemy.y = x, y
    enemy:setFillColor(0.0, 1, 1)
    local isAlive = false

    physics.addBody(enemy, "dynamic")
    enemy.angularDamping = 0.95

    local function destroyCollider()
        physics.removeBody(enemy)
    end

    function enemy:collision(event)
        if event.other.type == "projectile" then
            Runtime:removeEventListener("enterFrame", patrol)
            enemy:removeEventListener("collision")
            enemy:setFillColor(1, 0, 0)
            isAlive = true
            timer.performWithDelay(100, destroyCollider)
        end
    end

    local function patrol(event)
        if not isAlive then
            if math.floor(event.time / 10000) % 2 == 0 then
                enemy:setLinearVelocity(0, 200)
            else
                enemy:setLinearVelocity(0, -200)
            end
        end

    end

    enemy:addEventListener("collision")
    Runtime:addEventListener("enterFrame", patrol)
    enemy.name = "enemy"
    enemy.type = "enemy"
    return enemy
end

return M
