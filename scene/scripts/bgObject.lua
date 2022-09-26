local composer = require("composer")
local M = {}

function M.new(instance, options)

    physics.addBody(instance, "static", { density = 3, bounce = 0, friction = 1.0 })
    instance:setFillColor(red)
    function self.lightup()
        self.alpha = 1
        time.performWithDelay(16, goOut)
    end

    local function goOut()
        self.alpha = 0.5
    end

    instance.name = "bgObject"
    instance.type = "bgObject"
    return instance
end

return M
