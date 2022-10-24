local M = {}

function M.new(vx, vy, x, y)
    local sheetData = { width = 100,
        height = 100,
        numFrames = 64, }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset.png", sheetData)
    local sequenceData = { { name = "idle", frames = { 1 } } }
    local projectile = display.newSprite(sheet, sequenceData)
    projectile:setSequence("idle")
    projectile.x, projectile.y = x, y
    projectile:scale(0.8, 0.8)
    projectile:setFillColor(1.5, 1.5, 1)

    physics.addBody(projectile, "dynamic", { radius = 30, filter = { groupIndex = -1 } })
    projectile.isbullet = true

    projectile:setLinearVelocity(vx * 1900, vy * 1900)

    local function destroySelf()
        projectile:removeSelf()
    end

    function projectile:collision(event)
        if event.other ~= nil and event.other.type ~= "player" then
            projectile:removeEventListener("collision")
            timer.performWithDelay(50, destroySelf)
        end
    end

    projectile:addEventListener("collision")
    projectile.name = "projectile"
    projectile.type = "projectile"
    return projectile
end

return M
