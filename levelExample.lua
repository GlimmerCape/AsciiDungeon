local composer = require("composer")

local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")

local chest = require("scene.scripts.chest")
local item = require("scene.scripts.item")
local camera = require("com.perspective")
local plr = require("scene.scripts.player")
local enemy = require("scene.scripts.enemyObject")
local projectile = require("scene.scripts.projectile")
require("dynLight")

scene = composer.newScene()

local map, player

function scene:create(event)
    -- display.setDrawMode("wireframe", true)
    sceneGroup = self.view
    bgMusic = audio.loadStream("2nd_track.wav")
    audio.reserveChannels(1)
    audio.play(bgMusic, { loops = -1 })
    audio.setVolume(0.3)

    uiGroup = display.newGroup()
    uiGroup.x, uiGroup.y = display.contentCenterX - display.contentWidth / 2,
        display.contentCenterY - display.contentHeight / 2

    physics.start()
    physics.setGravity(0, 0)

    local filename = event.params.map or "scene/game/map/testingSite.json"
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, "scene/game/map")
    map.extensions = "scene.scripts."
    map.x, map.y = 0
    map.alpha = 1.5

    player = plr.new(self)
    player:scale(0.8, 0.8)
    player.x, player.y = 0, 500
    player.rotation = 180


    local items = {}
    for i = 1, 3 do
        items[i] = item.new("item " .. i)
    end
    -- local chest1 = chest.new(900, 200, items)
    local enemies = { enemy.new(1100, 700, player, true), enemy.new(900, 700, player, true),
        enemy.new(1000, 700, player, true)
        , enemy.new(200, 200, player, false), enemy.new(300, 100, player, false),
        enemy.new(1800, 400, player, false) }
    local fovLineExample = display.newLine(enemies[4].x, enemies[4].y, enemies[4].x + math.cos(math.rad(45)) * 600,
        enemies[4].y + math.sin(math.rad(45)) * 600)
    local fovLineExample2 = display.newLine(enemies[4].x, enemies[4].y, enemies[4].x + math.cos(math.rad(45)) * 600
        ,
        enemies[4].y - math.sin(math.rad(45)) * 600)
    local fovLines = { fovLineExample, fovLineExample2 }


    uiGroup:insert(button)
    uiGroup:insert(fakeButton)
    uiGroup:insert(leftButton)
    uiGroup:insert(rightButton)
    uiGroup:insert(upButton)
    uiGroup:insert(downButton)
    uiGroup:insert(player.debugText)
    -- map:insert(chest1)
    for i, v in pairs(enemies) do
        map:insert(v)
    end

    for i, v in pairs(fovLines) do
        map:insert(v)
        v:setStrokeColor(1, 1, 1)
        v.strokeWidth = 4
    end

    cam = camera.createView()
    cam:add(player, 1)
    cam:prependLayer()
    cam:appendLayer()
    cam:add(map, 2)

    cam.damping = 1
    cam:setFocus(player)
    cam:track()

    cam:setMask(player.lightMask)
    cam.maskX = display.contentWidth / 2
    cam.maskY = display.contentHeight / 2
    cam.maskScaleX = 2.0
    cam.maskScaleY = 2.0
    uiGroup:toFront()
end

local function applyLightShader()
    if d ~= nil then
        d:removeSelf()
    end


    uiGroup.alpha = 0
    d = display:captureScreen()

    d.contentHeight, d.contentWidth = display.contentWidth, display.contentHeight
    d.x, d.y = display.contentCenterX, display.contentCenterY

    uiGroup.alpha = 1
    uiGroup:toFront()

    local pX, pY = display.contentCenterX, display.contentCenterY
    d.fill.effect = "filter.custom.dynLight"
    if (player.rotation > 180) then
        player.rotation = player.rotation % 360
    end
    if (player.rotation < 0) then
        player.rotation = player.rotation + 360
    end
    local dir = math.rad(player.rotation)
    d.fill.effect.playerX = pX
    d.fill.effect.playerY = pY
    d.fill.effect.lightAngle = dir

end

local function enterFrame(event)
    -- applyLightShader()
    cam.maskRotation = player.rotation - 180
end

local function key(event)
    if event.phase == "down" then
        if event.keyName == "space" or event.keyName == "buttonA" then
            local proj = projectile.new(player.vx, player.vy,
                player.x, player.y)
            cam:add(proj, 0)
        end
    end
end

function scene:hide(event)
    Runtime:removeEventListener("key", key)
    Runtime:removeEventListener("enterFrame", enterFrame)
    cam:destroy()
    for i, v in ipairs(map) do
        for j, vv in ipairs(v) do
            vv:removeSelf()
        end
    end
    player:removeSelf()
    map:removeSelf()
    map = nil
end

scene:addEventListener("create")
scene:addEventListener("hide")
Runtime:addEventListener("key", key)
Runtime:addEventListener("enterFrame", enterFrame)

return scene
