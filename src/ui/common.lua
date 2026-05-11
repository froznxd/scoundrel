local constants = require "src.constants"

local function drawHP(hp)
    local hpFont = love.graphics.newFont(constants.FONT_PATH, constants.FONT_SIZE_2)
    love.graphics.setFont(hpFont)
    love.graphics.setColor(constants.GRAY_COLOR)
    local screenHeight = love.graphics.getHeight()
    local finalHPText = "HP: " .. hp .. "/" .. constants.PLAYER_MAX_HP
    local th = love.graphics.getFont():getHeight()
    love.graphics.print(finalHPText, 20, screenHeight - th - 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(constants.FONT_PATH, constants.FONT_SIZE_1))
end

return {
    drawHP = drawHP
}
