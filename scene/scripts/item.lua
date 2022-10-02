local M = {}

function M.new(name, type)
    local item = {}
    item.name = name
    item.type = type
    return item
end

return M
