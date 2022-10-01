local composer = require("composer")

local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")

local camera = require("scene.scripts.camera")
local plr = require("scene.scripts.player")
require("dynLight")

scene = composer.newScene()

local map, player, backgroundGroup

function scene:create(event)
    local sceneGroup = self.view
    backgroundGroup = display.newGroup()
    backgroundGroup.x, backgroundGroup.y = display.contentCenterX - display.contentWidth / 2,
        display.contentCenterY - display.contentHeight / 2
    backgroundGroup:toBack()

    uiGroup = display.newGroup()
    uiGroup.x, uiGroup.y = display.contentCenterX - display.contentWidth / 2,
        display.contentCenterY - display.contentHeight / 2

    physics.start()
    physics.setGravity(0, 0)

    local filename = event.params.map or "scene/game/map/Intro.json"
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, "scene/game/map")
    map.extensions = "scene.scripts."

    player = plr.new(self)
    player:scale(0.6, 0.6)
    player.x, player.y = display.contentCenterX, display.contentCenterY
    map:scale(0.7, 0.7)
    map.alpha = 0.5

    sceneGroup:insert(player)
    backgroundGroup:insert(map)
    uiGroup:insert(stick)
    uiGroup:insert(button)

    local cam = camera.new(player, backgroundGroup)

end

local function applyLightShader()
    if d ~= nil then
        d:removeSelf()
    end
    if b ~= nil then
        b:removeSelf()
    end

    uiGroup.isVisible = false

    d = display:captureScreen()

    d.contentHeight, d.contentWidth = display.contentWidth, display.contentHeight
    d.x, d.y = display.contentCenterX, display.contentCenterY

    uiGroup.isVisible = true
    uiGroup:toFront()

    local pX, pY = player.x, player.y
    d.fill.effect = "filter.custom.dynLight"
    d.fill.effect.playerX = pX / 64
    d.fill.effect.playerY = (750 - pY) / 64
    if (player.rotation > 180) then
        player.rotation = player.rotation % 360
    end
    if (player.rotation < 0) then
        player.rotation = player.rotation + 360
    end
    d.fill.effect.lightAngle = math.rad(player.rotation)
end

local function enterFrame(event)
    applyLightShader()

end

scene:addEventListener("create")
Runtime:addEventListener("enterFrame", enterFrame)

return scene
