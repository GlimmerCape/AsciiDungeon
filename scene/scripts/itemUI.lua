local composer = require("composer")

-- Define module
local M = {}

function M.new(items)
    local scene = composer.getScene(composer.getSceneName("current"))

    local windowGroup = display.newGroup()
    local window = display.newRoundedRect(windowGroup, 50, 100, 200, 200, 20)
    window:setFillColor(0.15, 0.15, 0.15)
    uiGroup:insert(windowGroup)

    function onObjectTouch(event)
        if (event.target ~= nil) then
            event.target:removeSelf()
            event.target = nil
        end
    end

    local function UpdateText()
        local j = 0
        for i = 1, #items do
            if (windowGroup[i + 1] ~= nil) then
                windowGroup[i + 1]:removeSelf()
                windowGroup[i + 1] = nil
                j = j + 1
            end
            windowGroup[i + 1] = display.newText(
                { parent = windowGroup,
                    text = items[i].name,
                    x = 50, y = i * 50 - (j * 50),
                    font = native.systemFont })
            windowGroup[i + 1]:addEventListener("touch", onObjectTouch)
        end
    end

    UpdateText()

    local function enterFrame(event)
        if ((windowGroup.numChildren - 1) < #items) then
            for i = 1, #items do
                if (windowGroup[i + 1] == nil) then
                    table.remove(items, i)
                    UpdateText()
                end
            end
        end
        if #items == 0 and window ~= nill then
            window:setFillColor(0, 0, 0)
            window = nil
        end
    end

    Runtime:addEventListener("enterFrame", enterFrame)
    return windowGroup
end

return M
