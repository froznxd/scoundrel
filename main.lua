local Card = require("card")
local spritesheet = require("spritesheet")
local constants = require("constants")
local gameDetails = require("game-details")
local Deck = require("deck")

local sheet
local cards = {}
local draggedCard = nil
local slots = {}
local button = {}
local tableCards = {}
local discardedCards = {}

local function drawCardsOnTable()
	for i = 1, 4 do
		if #cards == 0 then break end
		local card = table.remove(cards, 1)
		card:moveCardToPosition(slots[i].x, slots[i].y)
		tableCards[#tableCards + 1] = card
	end
end

function love.load()
	gameDetails.loadGameDetails()
	sheet = spritesheet.load("assets/cards sprite.png")

	-- cards
	local cardW = Card:getCardWidth(sheet)
	local cardH = Card:getCardHeight(sheet)

	-- screen
	local screenW = love.graphics.getWidth()
	local screenH = love.graphics.getHeight()

	-- slots
	local slotSpacing = constants.SLOT_SPACING
	local totalSlotsWidth = 4 * cardW + 3 * slotSpacing
	local slotStartX = (screenW - totalSlotsWidth) / 2
	local slotStartY = screenH - cardH - 600

	-- create slots
	for i = 0, 3 do
		slots[i + 1] = {
			x = slotStartX + i * (cardW + slotSpacing),
			y = slotStartY,
			w = cardW,
			h = cardH
		}
	end

	-- generate a shuffled deck
	cards = Deck.new(sheet)
	cards = Deck.shuffleDeck(cards)

	-- button
	button = {
		text = "draw cards",
		w = 120,
		h = 40,
		x = love.graphics.getWidth() - 120 - 20,
		y = 20,
		color = { 0.25, 0.25, 0.25 },
		hoverColor = { 0.35, 0.35, 0.35 },
		textColor = { 1, 1, 1 },
		hovered = false,
		onClick = function()
			drawCardsOnTable()
		end
	}
end

function love.draw()
	for _, slot in ipairs(slots) do
		love.graphics.setColor(1, 1, 1, 0.3)
		love.graphics.rectangle("line", slot.x, slot.y, slot.w, slot.h, 6, 6)
	end
	love.graphics.setColor(1, 1, 1, 1)

	Deck.drawDeck(cards)

	for _, c in ipairs(tableCards) do
		c:draw()
	end

	-- draw button
	local bg = button.hovered and button.hoverColor or button.color
	love.graphics.setColor(bg)
	love.graphics.rectangle("fill", button.x, button.y, button.w, button.h, 8, 8)
	love.graphics.setColor(button.textColor)
	local font = love.graphics.getFont()
	local tw = font:getWidth(button.text)
	local th = font:getHeight()
	love.graphics.print(button.text, button.x + (button.w - tw) / 2, button.y + (button.h - th) / 2)
	love.graphics.setColor(1, 1, 1, 1)
end

function love.mousepressed(x, y, btn)
	if btn ~= 1 then return end

	if x > button.x and x < button.x + button.w
		and y > button.y and y < button.y + button.h
	then
		button.onClick()
		return
	end

	for i = #cards, 1, -1 do
		local c = cards[i]
		if x > c.x and x < c.x + c.width
			and y > c.y and y < c.y + c.height
		then
			draggedCard = c
			c.dragging.active = true
			c.dragging.diffX = x - c.x
			c.dragging.diffY = y - c.y
			table.remove(cards, i)
			cards[#cards + 1] = c
			break
		end
	end
end

function love.mousereleased(x, y, btn)
	if btn == 1 and draggedCard then
		draggedCard:snapToSlot(slots)
		draggedCard.dragging.active = false
		draggedCard = nil
	end
end

function love.update(dt)
	local mx, my = love.mouse.getPosition()
	button.hovered = mx > button.x and mx < button.x + button.w
		and my > button.y and my < button.y + button.h

	for _, c in ipairs(cards) do
		c:update(dt)
	end

	for _, c in ipairs(tableCards) do
		c:update(dt)
	end
end
