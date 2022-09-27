local composer = require("composer")
local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")
local plr = require("scene.scripts.player")
require("dynamicLighting")

local map, player

local scene = composer.newScene()

function scene:create(event)

    --display.setDrawMode("wireframe", true)
    local sceneGroup = self.view
    -- add sounds

    d = display:captureScreen()
    physics.start()
    physics.setGravity(0, 0)
    local filename = event.params.map or "scene/game/map/Intro.json"
    local mapData = json.decodeFile(system.pathForFile(filename, system.ResourceDirectory))
    map = tiled.new(mapData, "scene/game/map")
    map.extensions = "scene.scripts."

    player = plr.new(self)
    player.filename = filename

    --map.x = display.contentCenterX - map.designedWidth / 2
    --map.y = display.contentCenterY - map.designedHeight / 2

    sceneGroup:insert(map)
    print(map.numChildren)
end

local i = 0
local function enterFrame(event)
    local elapsed = event.time
    if i == 10 then
        print(display.fps)
        i = 0
    else
        i = i + 1
    end
    --TRY TO APPLY THIS SHADER ONLY TO MAP, might fix bug with blacking out, save to git
    --before trying naturally
    d:removeSelf()
    d = display:captureScreen()
    d.x, d.y = display.contentCenterX, display.contentCenterY
    d.contentHeight, d.contentWidth = display.contentHeight, display.contentWidth
    d.fill.effect = "filter.bloom"
    d.fill.effect.blur.horizontal.blurSize = 10
    d.fill.effect.blur.horizontal.sigma = 70
    d.fill.effect.blur.vertical.blurSize = 10
    d.fill.effect.blur.vertical.sigma = 120
    d.fill.effect = "filter.custom.dynamicLighting"
    d.fill.effect.playerData = { player.x % 64, player.y % 64 }
    d.fill.effect.lightDir = { player.rotation }
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

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
