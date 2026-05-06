local Slots = {}

local function createSlots(slotStartX, slotStartY, cardWidth, cardHeight, slotSpacing)
    for i = 0, 3 do
        Slots[i + 1] = {
            x = slotStartX + i * (cardWidth + slotSpacing),
            y = slotStartY,
            w = cardWidth,
            h = cardHeight,
            card = nil
        }
    end

    return Slots
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
        if slot.card ~= nil and not slot.card.resolved then
            local classColors = {
                monster = { 0.9, 0.3, 0.3, 1 },
                heal = { 0.3, 0.9, 0.3, 1 },
                weapon = { 0.3, 0.5, 0.9, 1 },
            }
            local color = classColors[slot.card.class] or { 1, 1, 1, 1 }
            love.graphics.setColor(color)
            local tw = font:getWidth(slot.card.class)
            love.graphics.print(slot.card.class, slot.x + (slot.w - tw) / 2,
                slot.y + slot.h + 20)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

return {
    createSlots = createSlots,
    drawSlots = drawSlots,
    drawCardClassOnSlot = drawCardClassOnSlot
}
