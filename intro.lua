local composer = require("composer")
local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")
local plr = require("scene.scripts.player")
require("dynLight")

local map, player

local scene = composer.newScene()

function scene:create(event)

    --display.setDrawMode("wireframe", true)
    sceneGroup = self.view
    -- add sounds

    d = display:captureScreen()
    d.contentHeight, d.contentWidth = display.contentWidth, display.contentHeight
    physics.start()
    physics.setGravity(0, 0)
    local filename = event.params.map or "scene/game/map/Intro.json"
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, "scene/game/map")
    map.extensions = "scene.scripts."

    player = plr.new(self)
    player.filename = filename
    map.x, map.y = display.contentCenterX - 700, display.contentCenterY - 700
    map.alpha = 0.5
    player.x, player.y = display.contentCenterX, display.contentCenterY

    --map.x = display.contentCenterX - map.designedWidth / 2
    --map.y = display.contentCenterY - map.designedHeight / 2
    sceneGroup:insert(map)
end

local function cameraFollow()
    local dx, dy = sceneGroup.x - player.x, sceneGroup.y - player.y
    sceneGroup.x, sceneGroup.y = sceneGroup.x + dx, sceneGroup.y + dy
    print(sceneGroup.x, sceneGroup.y)
end

local function key(event)
    phase = event.phase
    key = event.keyName
    if (phase == "down") then
        if (key == "down") then
            -- doesnt work at all    cameraFollow()
        end
    end
end

local i = 0
local function enterFrame(event)
    local elapsed = event.time

    d:removeSelf()
    d = display:captureScreen()
    d.contentHeight, d.contentWidth = display.contentWidth, display.contentHeight
    d.x, d.y = display.contentCenterX, display.contentCenterY
    --    d.fill.effect = "filter.bloom"
    --    d.fill.effect.blur.horizontal.blurSize = 10
    --    d.fill.effect.blur.horizontal.sigma = 70
    --    d.fill.effect.blur.vertical.blurSize = 10
    --    d.fill.effect.blur.vertical.sigma = 120
    d.fill.effect = "filter.custom.dynLight"
    print(player.rotation)
    d.fill.effect.playerX, d.fill.effect.playerY = player.x / 1200, player.y / 800
    if (player.rotation > 360) then
        player.rotation = player.rotation % 360
    end
    if (player.rotation < 0) then
        player.rotation = player.rotation + 360
    end
    d.fill.effect.lightAngle = player.rotation
    d:toFront()
end

function scene:show(event)

    local phase = event.phase
    if (phase == "will") then
        -- add vfx
        Runtime:addEventListener("enterFrame", enterFrame)
    elseif (phase == "did") then
        -- bg music
    end
end

function scene:hide(event)

    local phase = event.phase
    if (phase == "will") then
        audio.fadeOut({ time = 1000 })
    elseif (phase == "did") then
        Runtime:removeEventListener("enterFrame", enterFrame)
    end
end

function scene:destroy(event)

    audio.stop() -- Stop all audio
    for s, v in pairs(self.sounds) do -- Release all audio handles
        audio.dispose(v)
        self.sounds[s] = nil
    end
end

Runtime:addEventListener("key", key)
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
