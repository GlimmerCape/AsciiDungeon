local composer = require("composer")

local prevScene = composer.getSceneName("previous")

local scene = composer.newScene()

function scene:show(event)

    local phase = event.phase
    local options = { params = event.params }
    if (phase == "will") then
        composer.removeScene(prevScene)
    elseif (phase == "did") then
        composer.gotoScene(prevScene, options)
    end
end

scene:addEventListener("show", scene)

return scene
