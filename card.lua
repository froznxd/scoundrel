local constants = require("constants")
local utils = require("utils")

local Card = {}
Card.__index = Card

function Card.new(sheet, suit, rank, class, x, y)
    local self = setmetatable({}, Card)
    self.sheet = sheet
    self.suit = suit
    self.rank = rank
    self.class = class
    self.quad = sheet.quads[suit][rank]
    self.x = x
    self.y = y
    self.scale = constants.CARD_BASE_SCALE
    self.targetX = x
    self.targetY = y
    self.dragging = { active = false, diffX = 0, diffY = 0 }
    self.isDraggable = true
    self.width = sheet.cardW * constants.CARD_BASE_SCALE
    self.height = sheet.cardH * constants.CARD_BASE_SCALE
    self.faceUp = false
    return self
end

function Card:draw()
    local quad = self.faceUp and self.quad or self.sheet.back
    local w = self.sheet.cardW * self.scale
    local h = self.sheet.cardH * self.scale
    local ox = self.sheet.cardW / 2
    local oy = self.sheet.cardH / 2
    love.graphics.draw(self.sheet.image, quad, self.x + w / 2, self.y + h / 2, 0, self.scale, self.scale, ox, oy)
end

function Card:update(dt)
    if self.dragging.active then
        self.targetX = love.mouse.getX() - self.dragging.diffX
        self.targetY = love.mouse.getY() - self.dragging.diffY
    end

    local t = math.min(1, constants.CARD_LERP_SPEED * dt)
    self.x = utils.lerp(self.x, self.targetX, t)
    self.y = utils.lerp(self.y, self.targetY, t)
end

function Card:snapToSlot(slots)
    local cardCX = self.targetX + self.width / 2
    local cardCY = self.targetY + self.height / 2

    local closestDist = constants.CARD_SNAP_RADIUS
    local closestSlot = nil

    for _, slot in ipairs(slots) do
        local slotCX = slot.x + slot.w / 2
        local slotCY = slot.y + slot.h / 2
        local d = utils.distBetweenTwoPoints(cardCX, cardCY, slotCX, slotCY)
        if d < closestDist then
            closestDist = d
            closestSlot = slot
        end
    end

    if closestSlot then
        self.targetX = closestSlot.x
        self.targetY = closestSlot.y
    end
end

function Card:getCardWidth(sheet)
    return sheet.cardW * constants.CARD_BASE_SCALE
end

function Card:getCardHeight(sheet)
    return sheet.cardH * constants.CARD_BASE_SCALE
end

function Card:moveCardToPosition(x, y)
    self.targetX = x
    self.targetY = y
    self.dragging.active = false
    self.dragging.diffX = 0
    self.dragging.diffY = 0
end

function Card:flipCardUp()
    self.faceUp = true
end

function Card:flipCardDown()
    self.faceUp = false
end

return Card
