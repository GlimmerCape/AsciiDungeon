local calc = require("scene.scripts.calculate")
local M = {}

function M.new(x, y, target, isWandering, initAngle)

    local fov = 50
    local rangeOV = 600
    local isEngaged = false

    if isWandering == nil then
        isWandering = false
    end

    local attackCD = 0.8
    local attackIsReady = true
    local attackRange = 200
    local speed = 150

    local wanderCD = 0
    local wanderIsReady = true


    local sheetData = { width = 100,
        height = 100,
        numFrames = 64, }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset_.png", sheetData)

    local sequenceData = {
        { name = "idle", frames = { 7 } },
        { name = "attack", frames = { 7, 8, 9, 10, 11, 12 }, time = 300, loopCount = 1 }
    }

    local enemy = display.newSprite(sheet, sequenceData)

    enemy:setSequence("idle")
    enemy:play()

    enemy.x, enemy.y = x, y
    enemy.rotation = initAngle
    enemy:scale(1.5, 1.5)
    local isAlive = true

    physics.addBody(enemy, "dynamic", { density = 3.0, friction = 0.0, bounce = 0.1 })
    enemy.angularDamping = 0.95
    enemy.objectLinearDamping = 0.99

    local function rechargeWander(event)
        wanderIsReady = true
    end

    local function moveTowardsWayPoint(wayPoint)
        enemy.rotation = calc.angle(wayPoint, enemy)
        local angleInRad = math.rad(enemy.rotation - 90)
        local xComp, yComp = math.cos(angleInRad), math.sin(angleInRad)
        enemy:setLinearVelocity(xComp * speed, yComp * speed)
    end

    local function destroyCollider()
        physics.removeBody(enemy)
    end

    local function targetIsVisible()
        if (calc.distance(target, enemy) < rangeOV and (isEngaged or calc.isInFov(target, enemy, fov))) then
            local hits = physics.rayCast(enemy.x, enemy.y, target.x, target.y, "sorted")
            for i, v in ipairs(hits) do
                if v.object == target then
                    return true
                end
                if v.object.bodyType == "static" then
                    return false
                end
            end
        end
        return false
    end

    local function wander()
        wanderIsReady = false
        wanderCD = math.random(0.5, 1)
        timer.performWithDelay(wanderCD * 1000, rechargeWander)
        local rPoint = { x, y }
        for i = 1, 3 do
            rPoint.x, rPoint.y = math.random(enemy.x - 500, enemy.x + 500), math.random(enemy.y - 500, enemy.y + 500)
            local hits         = physics.rayCast(enemy.x, enemy.y, rPoint.x, rPoint.y)
            if hits == nil then
                break
            end
        end
        moveTowardsWayPoint(rPoint)
    end

    local function rechargeAttack(event)
        attackIsReady = true
    end

    local function attack()
        attackIsReady = false
        timer.performWithDelay(attackCD * 1000, rechargeAttack)
        enemy:setSequence("attack")
        enemy:play()
    end

    local function onAttackEnd(event)
        if (event.phase == "ended") then
            if calc.distance(target, enemy) < 150 then
                target:gameOver()
            end
            event.target:setSequence("idle")
            event.target:play()
        end
    end

    enemy:addEventListener("sprite", onAttackEnd)


    local function enterFrame(event)
        if targetIsVisible() then
            print(enemy.rotation)
            moveTowardsWayPoint(target)
            print(enemy.rotation)
            fov = 90
            isEngaged = true
            enemy:setFillColor(1, 1, 1)
            if attackIsReady and calc.distance(target, enemy) < attackRange then
                attack()
            end

            return
        end

        if isEngaged == true then
            isEngaged = false
            enemy:setLinearVelocity(0, 0)
        end

        if isWandering and wanderIsReady then
            enemy:setFillColor(0.7, 0, 0)
            wander()
            return
        end
        -- if idle
        enemy:setFillColor(0.7, 0, 0)
    end

    function enemy:collision(event)
        if event.other.type == "projectile" and event.phase == "ended" then
            Runtime:removeEventListener("enterFrame", enterFrame)
            enemy:removeEventListener("collision")
            enemy:removeEventListener("sprite", onAttackEnd)
            enemy:setFillColor(0.2, 0.8, 0.8)
            isAlive = false
            timer.performWithDelay(100, destroyCollider)
        end
    end

    enemy:addEventListener("collision")
    Runtime:addEventListener("enterFrame", enterFrame)
    enemy.name = "enemy"
    enemy.type = "enemy"
    return enemy
end

return M
