local function drawHP(hp)
    local hpLable = "HP: "
    local screenHeight = love.graphics.getHeight()
    local font = love.graphics.getFont()
    local th = font:getWidth(hpLable)
    love.graphics.print(hpLable .. hp, 20, screenHeight - th - 30, 0, 2, 2)
end

return {
    drawHP = drawHP
}
