local constants = require("src.constants")

---returns the next room button config
---@param onClick function gets called when user clicks on the button
---@return table
local function getNextRoomButton(onClick)
    return {
        text = "Next room!",
        w = 120,
        h = 40,
        x = love.graphics.getWidth() - 120 - 20,
        y = 20,
        color = constants.GREEN_COLOR,
        hoverColor = constants.GREEN_HOVER_COLOR,
        textColor = constants.WHITE_COLOR,
        hovered = false,
        onClick = onClick
    }
end

return {
    nextRoom = getNextRoomButton
}
