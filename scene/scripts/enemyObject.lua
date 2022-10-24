local calc = require("scene.scripts.calculate")
local M = {}

function M.new(x, y, target, isWandering, initAngle)

    local fov = 45
    local rangeOV = 600
    --range of hearing
    local rangeOH = 150
    local isEngaged = false

    if isWandering == nil then
        isWandering = false
    end

    local attackCD = 0.8
    local attackIsReady = true
    local attackRange = 150
    local speed = 150

    local wanderCD = 0
    local wanderCDlowerBound = 2
    local wanderCDupperBound = 4
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
    enemy.angularDamping = 0.90
    enemy.objectLinearDamping = 0.99

    local function rechargeWander(event)
        wanderIsReady = true
    end

    local function moveTowardsWayPoint(wayPoint, velocity)
        -- transition.to(enemy, { time = 400, rotation = calc.angle(wayPoint, enemy) })
        enemy.rotation = calc.angle(wayPoint, enemy)
        local angleInRad = math.rad(enemy.rotation)
        local xComp, yComp = math.cos(angleInRad), math.sin(angleInRad)
        enemy:setLinearVelocity(xComp * velocity, yComp * velocity)
    end

    local function destroyCollider()
        physics.removeBody(enemy)
    end

    local function targetIsVisible()
        target.debugText.text = tostring(calc.isInFov(target, enemy, fov))
        target.debugText.text = target.debugText.text ..
            tostring(math.abs(enemy.rotation - calc.angle(target, enemy)))
        if ((calc.distance(target, enemy) < rangeOV) and (isEngaged or calc.isInFov(target, enemy, fov)))
            or calc.distance(target, enemy) < rangeOH then
            local hits = physics.rayCast(enemy.x, enemy.y, target.x, target.y, "sorted")
            if hits == nil then return false end
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
        wanderCD = math.random(wanderCDlowerBound, wanderCDupperBound)
        timer.performWithDelay(wanderCD * 1000, rechargeWander)
        local rPoint = { x, y }
        rPoint.x, rPoint.y = math.random(enemy.x - 500, enemy.x + 500), math.random(enemy.y - 500, enemy.y + 500)
        for i = 0, 3 do
            local angle = i * 90
            rPoint.x = math.cos(angle) * (rPoint.x - enemy.x) - math.sin(angle) * (rPoint.y - enemy.y) + enemy.x
            rPoint.y = math.sin(angle) * (rPoint.x - enemy.x) + math.cos(angle) * (rPoint.y - enemy.y) + enemy.y
            local hits = physics.rayCast(enemy.x, enemy.y, rPoint.x, rPoint.y)
            if hits == nil then
                break
            end
        end
        moveTowardsWayPoint(rPoint, speed / 2)
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
            if calc.distance(target, enemy) < attackRange * 0.8 and calc.isInFov(target, enemy, fov) then
                target:gameOver()
            end
            event.target:setSequence("idle")
            event.target:play()
        end
    end

    enemy:addEventListener("sprite", onAttackEnd)


    local function enterFrame(event)
        if targetIsVisible() then
            -- moveTowardsWayPoint(target, speed)
            fov = 70
            isEngaged = true
            enemy:setFillColor(1, 0, 0)
            if attackIsReady and calc.distance(target, enemy) < attackRange then
                attack()
            end

            return
        end

        if isEngaged == true then
            isEngaged = false
        end

        if isWandering and wanderIsReady then
            enemy:setFillColor(0, 0.8, 0.8)
            wander()
            return
        end
        -- if idle
        local velX, velY = enemy:getLinearVelocity()
        if velX == 0 and velY == 0 then
            enemy:setFillColor(0, 0.6, 0.6)
        end
    end

    function enemy:collision(event)
        if event.other.type == "projectile" and event.phase == "ended" then
            Runtime:removeEventListener("enterFrame", enterFrame)
            enemy:removeEventListener("collision")
            enemy:removeEventListener("sprite", onAttackEnd)
            enemy:setFillColor(0.3, 0.0, 0.0)
            isAlive = false
            timer.performWithDelay(100, destroyCollider)
        else
            enemy:setLinearVelocity(0, 0)
        end
    end

    function enemy:finalize(event)
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    enemy:addEventListener("collision")
    enemy:addEventListener("finalize")
    Runtime:addEventListener("enterFrame", enterFrame)
    enemy.name = "enemy"
    enemy.type = "enemy"
    return enemy
end

return M
