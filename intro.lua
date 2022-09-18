local composer = require("composer")
local fx = require("com.ponywolf.ponyfx")
local tiled = require("com.ponywolf.ponytiled")
local physics = require("physics")
local json = require("json")

local map, player

local scene = composer.newScene()

function scene:create(event)

    local sceneGroup = self.view

    -- add sounds

    physics.start()
    local filename = event.params.map or "scene/game/map/intro.json"
    local mapData = json.decodeFile(system.pathForFile(filename, sytem.ResourceDirectory))
    map = tiled.new(mapData, "scene/map/map")

    map.extensions = "scene.game.lib."
    map:extend("player")
    player = map:findObject("player")
    player.filename = filename

    sceneGroup:insert(map)
end

local function enterFrame(event)
    local elapsed = event.time

    if player and player.x and player.y and not player.isDead then
        local x, y = player:localToContent(0, 0)
        x, y = display.contentCenterX - x, display.contentCenterY - y
        map.x, map.y = map.x + x, map.y + y
    end
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
