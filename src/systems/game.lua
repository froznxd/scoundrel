local Card = require("src.class.card")
local spritesheet = require("src.systems.spritesheet")
local constants = require("src.constants")
local buttons = require("src.ui.buttons")
local Deck = require("src.class.deck")
local Slots = require("src.systems.room")
local commonUi = require("src.ui.common")
local Player = require("src.class.player")

local Game = {}
Game.__index = Game

function Game.new()
    local self = setmetatable({}, Game)

    local sheet = spritesheet.load("assets/card_deck.png", "assets/card_back.png")
    local cardWidth = Card:getCardWidth(sheet)
    local cardHeight = Card:getCardHeight(sheet)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local slotSpacing = constants.SLOT_SPACING
    local totalSlotsWidth = (4 * cardWidth) + (3 * slotSpacing)
    local slotStartX = (screenWidth - totalSlotsWidth) / 2
    local slotStartY = screenHeight - cardHeight - 600

    local weaponSlotX = (screenWidth - cardWidth) / 2
    local weaponSlotY = screenHeight - cardHeight - 200

    self.roomSlots = Slots.createSlots(slotStartX, slotStartY, cardWidth, cardHeight, slotSpacing)
    self.weaponSlot = Slots.createWeaponSlot(weaponSlotX, weaponSlotY, cardWidth, cardHeight)

    self.deck = Deck.new(sheet)
    self.deck:shuffleDeck()
    self.player = Player.new(constants.PLAYER_MAX_HP, nil)

    self.discardedCards = {}
    self.draggedCard = nil

    self.background = love.graphics.newImage("assets/background.png")

    self.buttons = {}
    self.buttons.nextRoom = buttons.nextRoom(function() self:newRoom() end)
    self.buttons.skipRoom = buttons.skipRoom(function() self:skipRoom() end)

    return self
end

---draws the card to slots
function Game:newRoom()
    for _, slot in ipairs(self.roomSlots) do
        table.insert(self.discardedCards, slot.card)
        self.roomSlots.card = nil
    end

    for i = 1, 4 do
        if #self.deck.cards == 0 then
            self.roomSlots[i].card = nil
        else
            local card = table.remove(self.deck.cards, 1)
            card:moveCardToPosition(self.roomSlots[i].x, self.roomSlots[i].y)
            self.roomSlots[i].card = card
            card:flipCardUp()
            self.roomSlots[i].card = card
        end
    end
end

function Game:onSlotCardClicked(slotIndex, card)
    if card.class == constants.CLASSES.MONSTER then
        -- player takes damage
        self.player:takeDamage(card)
    elseif card.class == constants.CLASSES.HEALTH then
        -- heal the player
        self.player:heal(card)
    elseif card.class == constants.CLASSES.WEAPON then
        -- equip the weapon
        self.player:equipWeapon(card)
        self.player.weapon:moveCardToPosition(self.weaponSlot.x, self.weaponSlot.y)
    end
    -- remove card from slot after interaction
    self.roomSlots[slotIndex].card = nil
    -- optionally move it to discardedCards, animate it off-screen, etc.
end

function Game:update(dt)
    local mx, my = love.mouse.getPosition()
    local nextRoomBtn = self.buttons.nextRoom
    nextRoomBtn.hovered = mx > nextRoomBtn.x and mx < nextRoomBtn.x + nextRoomBtn.w
        and my > nextRoomBtn.y and my < nextRoomBtn.y + nextRoomBtn.h

    local skipRoomBtn = self.buttons.skipRoom
    skipRoomBtn.hovered = mx > skipRoomBtn.x and mx < skipRoomBtn.x + skipRoomBtn.w
        and my > skipRoomBtn.y and my < skipRoomBtn.y + skipRoomBtn.h

    for _, c in ipairs(self.deck.cards) do
        c:update(dt)
    end

    for _, slot in ipairs(self.roomSlots) do
        if slot.card then slot.card:update(dt) end
    end

    -- lerp weapon card to weapon slot
    if (self.player.weapon) then self.player.weapon:update(dt) end
end

function Game:draw()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local sx = screenW / self.background:getWidth()
    local sy = screenH / self.background:getHeight()
    love.graphics.draw(self.background, 0, 0, 0, sx, sy)

    -- draw slots
    Slots.drawSlots(self.roomSlots)
    Slots.drawCardClassOnSlot(self.roomSlots)

    -- draw deck of cards
    self.deck:draw()

    -- draw room cards
    for _, slot in ipairs(self.roomSlots) do
        if slot.card then slot.card:draw() end
    end

    -- draw weapon slot
    Slots.drawWeaponSlot(self.weaponSlot, self.player.isWeaponEquipped)

    -- draw common UI
    commonUi.drawHP(self.player.hp)

    -- draw weapon
    if (self.player.weapon) then self.player.weapon:draw() end


    -- TODO: refactor this
    local nextRoomBtn = self.buttons.nextRoom
    local skipRoomBtn = self.buttons.skipRoom

    local bg = nextRoomBtn.hovered and nextRoomBtn.hoverColor or nextRoomBtn.color
    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", nextRoomBtn.x, nextRoomBtn.y, nextRoomBtn.w, nextRoomBtn.h, 8, 8)
    love.graphics.setColor(nextRoomBtn.textColor)
    love.graphics.print(nextRoomBtn.text, nextRoomBtn.textX, nextRoomBtn.textY)

    bg = skipRoomBtn.hovered and skipRoomBtn.hoverColor or skipRoomBtn.color
    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", skipRoomBtn.x, skipRoomBtn.y, skipRoomBtn.w, skipRoomBtn.h, 8, 8)
    love.graphics.setColor(skipRoomBtn.textColor)
    love.graphics.print(skipRoomBtn.text, skipRoomBtn.textX, skipRoomBtn.textY)

    love.graphics.setColor(1, 1, 1, 1)
end

function Game:mousepressed(x, y, btn)
    if btn ~= 1 then return end

    local nextRoomBtn = self.buttons.nextRoom

    -- next room button handler
    if x > nextRoomBtn.x and x < nextRoomBtn.x + nextRoomBtn.w
        and y > nextRoomBtn.y and y < nextRoomBtn.y + nextRoomBtn.h
    then
        nextRoomBtn.onClick()
        return
    end

    for i = #self.deck.cards, 1, -1 do
        local c = self.deck.cards[i]
        if x > c.x and x < c.x + c.width
            and y > c.y and y < c.y + c.height
        then
            self.draggedCard = c
            c.dragging.active = true
            c.dragging.diffX = x - c.x
            c.dragging.diffY = y - c.y
            table.remove(self.deck.cards, i)
            self.deck.cards[#self.deck.cards + 1] = c
            break
        end
    end

    -- room actions
    for i, slot in ipairs(self.roomSlots) do
        if slot.card and x > slot.x and x < slot.x + slot.w
            and y > slot.y and y < slot.y + slot.h then
            self:onSlotCardClicked(i, slot.card)
            return
        end
    end
end

function Game:mousereleased(x, y, btn)
    if btn == 1 and self.draggedCard then
        self.draggedCard:snapToSlot(self.roomSlots)
        self.draggedCard.dragging.active = false
        self.draggedCard = nil
    end
end

return Game
