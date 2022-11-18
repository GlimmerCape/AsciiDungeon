---@diagnostic disable: undefined-global, lowercase-global
local composer = require("composer")

local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")

local chest = require("scene.scripts.chest")
local camera = require("com.perspective")
local plr = require("scene.scripts.player")
local enemy = require("scene.scripts.enemyObject")
local uiCollider = require("scene.scripts.UICollider")
local projectile = require("scene.scripts.projectile")

scene = composer.newScene()

map, player = {}, {}

function scene:create(event)
    -- display.setDrawMode("wireframe", true)
    LocalScore = 0
    sceneGroup = self.view
    audio.reserveChannels(1)
    pwaw = audio.loadSound("pwaw.wav")

    uiGroup.x, uiGroup.y = display.contentCenterX - display.contentWidth / 2,
        display.contentCenterY - display.contentHeight / 2

    physics.start()
    physics.setGravity(0, 0)

    filename = event.params.map or "scene/game/map/0level.json"
    print(event.params.map)
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, "scene/game/map")
    map.extensions = "scene.scripts."
    map:extend("enemyObject")
    map:extend("UICollider")
    -- map:extend("chest")
    local enemies = map:findObjects("enemy")
    local UIColliders = map:findObjects("UICollider")
    local chests = map:findObjects("chest")
    map.x, map.y = 0
    map.alpha = 1.5

    player = plr.new(self)
    player:scale(0.8, 0.8)
    player.x, player.y = 1900, 1900
    player.rotation = 180

    for i, v in ipairs(enemies) do
        v = enemy.new(v, player)
    end
    for i, v in ipairs(UIColliders) do
        v = uiCollider.new(v, v.type)
    end
    for i, v in ipairs(chests) do
        v = chest.new(v, v.last)
    end



    uiGroup:insert(button)
    uiGroup:insert(TopTextGroup)
    uiGroup:insert(fakeButton)
    uiGroup:insert(leftButton)
    uiGroup:insert(rightButton)
    uiGroup:insert(upButton)
    uiGroup:insert(downButton)
    -- uiGroup:insert(player.debugText)
    -- map:insert(chest1)


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

function scene:show(event)

    local phase = event.phase
    if (phase == "will") then
        fx.fadeIn()
    end
end

local function applyLightShader()
    if d ~= nil then
        d:removeSelf()
    end


    uiGroup.alpha = 0
    player.aplha = 0
    d = display:captureScreen()

    d.contentHeight, d.contentWidth = display.contentWidth, display.contentHeight
    d.x, d.y = display.contentCenterX, display.contentCenterY

    uiGroup.alpha = 1
    player.alpha = 1
    uiGroup:toFront()

    d.fill.effect = "filter.bloom"
    d.fill.effect.levels.white = 0.55
    d.fill.effect.levels.black = 0.4
    d.fill.effect.levels.gamma = 0.8
    d.fill.effect.add.alpha = 0.4
    d.fill.effect.blur.horizontal.blurSize = 3
    d.fill.effect.blur.horizontal.sigma = 500
    d.fill.effect.blur.vertical.blurSize = 3
    d.fill.effect.blur.vertical.sigma = 500
end

local function enterFrame(event)
    applyLightShader()
    cam.maskRotation = player.rotation - 180
    player.debugText.text = ""
end

local function key(event)
    if event.phase == "down" then
        if event.keyName == "space" or event.keyName == "buttonA" then
            audio.play(pwaw)
            local proj = projectile.new(player.vx, player.vy,
                player.x, player.y)
            cam:add(proj, 0)
        end
    end
end

function scene:hide(event)
    Runtime:removeEventListener("key", key)
    Runtime:removeEventListener("enterFrame", enterFrame)
    local phase = event.phase
    if (phase == "will") then
    end
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
