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

local slotFont = love.graphics.newFont(constants.FONT_PATH, constants.FONT_SIZE_0)
local defaultFont = love.graphics.newFont(constants.FONT_PATH, constants.FONT_SIZE_1)

local function drawCardClassOnSlot(slots)
    love.graphics.setFont(slotFont)
    love.graphics.setColor(constants.GRAY_COLOR)
    for _, slot in ipairs(slots) do
        if slot.card ~= nil then
            local tw = slotFont:getWidth(slot.card.class)
            love.graphics.print(slot.card.class, slot.x + (slot.w - tw) / 2,
                slot.y + slot.h + 20)
        end
    end
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawWeaponSlot(weaponSlot, isWeaponEquipped)
    local r, g, b = constants.GOLD_COLOR[1], constants.GOLD_COLOR[2], constants.GOLD_COLOR[3]
    local glowLayers = { { spread = 12, alpha = 0.05 }, { spread = 8, alpha = 0.1 }, { spread = 4, alpha = 0.15 } }

    -- draw glow around weapon slot if weapon is equipped
    if (isWeaponEquipped) then
        for _, layer in ipairs(glowLayers) do
            local s = layer.spread
            love.graphics.setColor(r, g, b, layer.alpha)
            love.graphics.rectangle("fill",
                weaponSlot.x - s, weaponSlot.y - s,
                weaponSlot.w + s * 2, weaponSlot.h + s * 2,
                6 + s, 6 + s)
        end
    end

    -- draw weapon slot border
    love.graphics.setColor(r, g, b, 1)
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
