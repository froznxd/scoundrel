local function lerp(a, b, t)
    return a + (b - a) * t
end

local function distBetweenTwoPoints(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

return {
    lerp = lerp,
    distBetweenTwoPoints = distBetweenTwoPoints
}
