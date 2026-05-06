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
    self.resolved = false
    self.slotIndex = nil

    -- Animation state
    self.flipProgress = 1      -- 1 = fully showing current side, 0 = midpoint
    self.flipping = false
    self.flipTarget = false     -- what faceUp should become after flip
    self.alpha = 1
    self.fadeSpeed = 0
    self.shakeX = 0
    self.shakeTimer = 0
    self.shakeIntensity = 0

    return self
end

function Card:draw()
    local quad = self.faceUp and self.quad or self.sheet.back
    local scaleX = self.scale * self.flipProgress
    local scaleY = self.scale
    local ox = self.sheet.cardW / 2
    local oy = self.sheet.cardH / 2
    local drawX = self.x + self.width / 2 + self.shakeX
    local drawY = self.y + self.height / 2

    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.sheet.image, quad, drawX, drawY, 0, scaleX, scaleY, ox, oy)
    love.graphics.setColor(1, 1, 1, 1)
end

function Card:update(dt)
    if self.dragging.active then
        self.targetX = love.mouse.getX() - self.dragging.diffX
        self.targetY = love.mouse.getY() - self.dragging.diffY
    end

    local t = math.min(1, constants.CARD_LERP_SPEED * dt)
    self.x = utils.lerp(self.x, self.targetX, t)
    self.y = utils.lerp(self.y, self.targetY, t)

    -- Flip animation
    if self.flipping then
        local flipSpeed = 4
        if self.flipProgress > 0 then
            self.flipProgress = self.flipProgress - flipSpeed * dt
            if self.flipProgress <= 0 then
                self.flipProgress = 0
                self.faceUp = self.flipTarget
            end
        else
            self.flipProgress = self.flipProgress + flipSpeed * dt
            if self.flipProgress >= 1 then
                self.flipProgress = 1
                self.flipping = false
            end
        end
    end

    -- Fade animation
    if self.fadeSpeed > 0 then
        self.alpha = self.alpha - self.fadeSpeed * dt
        if self.alpha <= 0 then
            self.alpha = 0
            self.fadeSpeed = 0
        end
    end

    -- Shake animation
    if self.shakeTimer > 0 then
        self.shakeTimer = self.shakeTimer - dt
        self.shakeX = (math.random() - 0.5) * 2 * self.shakeIntensity
        if self.shakeTimer <= 0 then
            self.shakeX = 0
            self.shakeTimer = 0
        end
    end
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
    self.flipping = false
    self.flipProgress = 1
end

function Card:flipCardDown()
    self.faceUp = false
    self.flipping = false
    self.flipProgress = 1
end

function Card:animateFlipUp()
    if not self.faceUp then
        self.flipping = true
        self.flipTarget = true
        self.flipProgress = 1
    end
end

function Card:animateFlipDown()
    if self.faceUp then
        self.flipping = true
        self.flipTarget = false
        self.flipProgress = 1
    end
end

function Card:fadeOut(speed)
    self.fadeSpeed = speed or 2
end

function Card:shake(intensity, duration)
    self.shakeIntensity = intensity or 6
    self.shakeTimer = duration or 0.3
end

return Card
