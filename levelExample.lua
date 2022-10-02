local composer = require("composer")

local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")

local chest = require("scene.scripts.chest")
local item = require("scene.scripts.item")
local camera = require("com.perspective")
local plr = require("scene.scripts.player")
require("dynLight")

scene = composer.newScene()

local map, player

function scene:create(event)
    -- display.setDrawMode("wireframe", true)
    sceneGroup = self.view

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
    player:scale(0.8, 0.8)
    player.x, player.y = display.contentCenterX, display.contentCenterY
    map.alpha = 0.5
    local items = {}
    for i = 1, 3 do
        items[i] = item.new("item " .. i)
    end
    chest1 = chest.new(500, 200, items)


    uiGroup:insert(stick)
    uiGroup:insert(button)
    map:insert(chest1)

    local cam = camera.createView()
    cam:add(player, 1)
    cam:prependLayer()
    cam:appendLayer()
    cam:add(map, 2)

    cam.damping = 1
    cam:setFocus(player)
    cam:track()

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
    d.fill.effect.playerX = (pX + 70) / 64
    d.fill.effect.playerY = (760 - pY) / 64
    d.fill.effect.lightAngle = dir

end

local function enterFrame(event)
    applyLightShader()
end

scene:addEventListener("create")
Runtime:addEventListener("enterFrame", enterFrame)

return scene
