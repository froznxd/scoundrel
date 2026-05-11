local constants = require("src.constants")

local BUTTON_WIDTH = 120
local BUTTON_HEIGHT = 40
local PADDING_X = 32
local PADDING_Y = 16
local OFFSET_X = 50
local OFFSET_Y = 20
local BUTTON_GAP = 10
local MIN_BUTTON_WIDTH = 200

---returns the next room button config
---@param onClick function gets called when user clicks on the button
---@return table
local function getNextRoomButton(onClick)
    local font = love.graphics.getFont()
    local buttonText = "NEXT ROOM!"

    local buttonWidth = math.max(font:getWidth(buttonText) + (PADDING_X * 2), MIN_BUTTON_WIDTH)
    local buttonHeight = font:getHeight() + (PADDING_Y * 2)
    local screenWidth = love.graphics.getWidth()

    local buttonX = screenWidth - buttonWidth - OFFSET_X
    local buttonY = (love.graphics.getHeight() / 2) - (buttonHeight / 2 + BUTTON_GAP)

    local textX = buttonX + (buttonWidth - font:getWidth(buttonText)) / 2
    local textY = buttonY + PADDING_Y + 2

    return {
        text = buttonText,
        w = buttonWidth,
        h = buttonHeight,
        x = buttonX,
        y = buttonY,
        textX = textX,
        textY = textY,
        color = constants.GREEN_COLOR,
        hoverColor = constants.GREEN_HOVER_COLOR,
        textColor = constants.GREEN_TEXT_COLOR,
        hovered = false,
        onClick = onClick
    }
end

---returns the skip room button config
---@param onClick function gets called when user clicks on the button
---@return table
local function getSkipRoomButton(onClick)
    local font = love.graphics.getFont()
    local buttonText = "RUN AWAY!"

    local buttonWidth = math.max(font:getWidth(buttonText) + (PADDING_X * 2), MIN_BUTTON_WIDTH)
    local buttonHeight = font:getHeight() + (PADDING_Y * 2)
    local screenWidth = love.graphics.getWidth()

    local buttonX = screenWidth - buttonWidth - OFFSET_X
    local buttonY = (love.graphics.getHeight() / 2) + (buttonHeight / 2 + BUTTON_GAP)
    local textX = buttonX + (buttonWidth - font:getWidth(buttonText)) / 2
    local textY = buttonY + PADDING_Y + 2

    return {
        text = buttonText,
        w = buttonWidth,
        h = buttonHeight,
        x = buttonX,
        y = buttonY,
        textX = textX,
        textY = textY,
        color = constants.BLUE_COLOR,
        hoverColor = constants.BLUE_HOVER_COLOR,
        textColor = constants.BLUE_TEXT_COLOR,
        hovered = false,
        onClick = onClick
    }
end

return {
    nextRoom = getNextRoomButton,
    skipRoom = getSkipRoomButton
}
