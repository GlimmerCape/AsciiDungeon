composer = require("composer")

local M = {}


function M.new(target, background)

    local scene = composer.getScene(composer.getSceneName("current"))

    local camera = {}

    local dx, dy = 0, 0

    function camera:attachTarget(object)
        target = object
    end

    local function findDiff()
        dx = target.x - display.contentCenterX
        dy = target.y - display.contentCenterY
        target.x = display.contentCenterX
        target.y = display.contentCenterY
        return dx, dy
    end

    local function enterFrame()
        dx, dy = findDiff()
        if (dx == 0 and dy == 0) then
            return
        else
            background.x = background.x - dx
            background.y = background.y - dy
        end
        -- background.x = background.x + 100
    end

    Runtime:addEventListener("enterFrame", enterFrame)


    return camera
end

return M
