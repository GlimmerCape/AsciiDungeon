local items = require("scene.scripts.item")
local itemsUI = require("scene.scripts.itemUI")

local M = {}

function M.new(instance, items)
    local container = items

    local sheetData = { width = 100,
        height = 100,
        numFrames = 64, }
    local sheet = graphics.newImageSheet("scene/game/map/asciiTileset.png", sheetData)
    local sequenceData = { { name = "idle", frames = { 4 } } }
    instance:setFillColor(1, 0.9, 1)
    instance.fill.effect = "filter.brightness"
    instance.fill.effect.intensity = 0.6
    local UI

    physics.addBody(instance, "static")
    local function onLocalCollision(event)
        UI = itemsUI.new(items)
        if event.phase == "ended" then
            print("af")
            UI:removeSelf()
            UI = nil
        end
    end

    instance.collision = onLocalCollision
    instance:addEventListener("collision")
    instance.name = "chest"
    instance.type = "chest"
    return instance
end

return M
