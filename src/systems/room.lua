local constants = require("src.constants")
---@param slotStartX number
---@param slotStartY number
---@param cardWidth number
---@param cardHeight number
---@param slotSpacing number
local function createSlots(slotStartX, slotStartY, cardWidth, cardHeight, slotSpacing)
    local slots = {}
    for i = 0, 3 do
        slots[i + 1] = {
            x = slotStartX + i * (cardWidth + slotSpacing),
            y = slotStartY,
            w = cardWidth,
            h = cardHeight,
            card = nil
        }
    end

    return slots
end

local function createWeaponSlot(x, y, cardWidth, cardHeight)
    return {
        x = x,
        y = y,
        w = cardWidth,
        h = cardHeight,
    }
end

local function drawSlots(slotsToDraw)
    love.graphics.setColor(1, 1, 1, 0.3)
    for _, slot in ipairs(slotsToDraw) do
        love.graphics.rectangle("line", slot.x, slot.y, slot.w, slot.h, 6, 6)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawCardClassOnSlot(slots)
    local font = love.graphics.getFont()
    for _, slot in ipairs(slots) do
        if slot.card ~= nil then
            local tw = font:getWidth(slot.card.class)
            love.graphics.print(slot.card.class, slot.x + (slot.w - tw) / 2,
                slot.y + slot.h + 20)
        end
    end
end

local function drawWeaponSlot(weaponSlot)
    love.graphics.setColor(constants.BLUE_COLOR)
    love.graphics.rectangle("line", weaponSlot.x, weaponSlot.y, weaponSlot.w, weaponSlot.h, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
end

return {
    createSlots = createSlots,
    drawSlots = drawSlots,
    drawCardClassOnSlot = drawCardClassOnSlot,
    createWeaponSlot = createWeaponSlot,
    drawWeaponSlot = drawWeaponSlot
}
