local calculate = {}

function calculate.isInFov(target, firstPos, fov)
    local angleDiff = math.abs(firstPos.rotation - calculate.angle(target, firstPos))
    print(angleDiff)
    if angleDiff > 360 - fov then
        return true
    else
        return angleDiff < fov
    end
end

function calculate.angle(target, firstPos)
    return math.deg(math.atan2(firstPos.y - target.y, firstPos.x - target.x)) - 180
end

function calculate.distance(target, firstPos)
    return math.sqrt((target.x - firstPos.x) ^ 2 + (target.y - firstPos.y) ^ 2)
end

return calculate
