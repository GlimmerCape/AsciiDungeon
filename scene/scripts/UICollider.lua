local fx = require("com.ponywolf.ponyfx")
local composer = require("composer")
local M = {}

function M.new(instance, name)

    local function nextScene()
        Score = Score + LocalScore
        Level = Level + 1
        local nextLevel = "scene/game/map/" .. Level .. "level.json"
        composer.gotoScene("scene.refresh", { params = { map = nextLevel } })
    end

    local function exit()
        native.requestExit()
    end

    function instance:collision(event)
        print("data")
        if event.other.type == "player" then
            if name == "exit" then
                timer.performWithDelay(10, exit)
            else
                instance:removeEventListener("collision")
                timer.performWithDelay(10, nextScene)
            end

        end
    end

    instance:addEventListener("collision")
    instance.name = "UICollider"
    instance.type = "UICollider"
    return UICollider
end

return M
