Timer = require "packages.hump.timer"

local Card = require("card")
local spritesheet = require("spritesheet")
local constants = require("constants")
local gameDetails = require("game-details")
local Deck = require("deck")
local Slots = require("slots")

local sheet
local deckOfCards = {}
local draggedCard = nil
local slots = {}
local buttons = {}
local tableCards = {}
local discardedCards = {}

local function drawCardsOnTable()
	for _, cardToDiscard in ipairs(tableCards) do
		table.insert(discardedCards, cardToDiscard)
	end
	tableCards = {}

	for i = 1, 4 do
		if #deckOfCards == 0 then
			slots[i].card = nil
		else
			local card = table.remove(deckOfCards, 1)
			card:moveCardToPosition(slots[i].x, slots[i].y)
			slots[i].card = card
			card:flipCardUp()
			tableCards[#tableCards + 1] = card
		end
	end
end

function love.load()
	gameDetails.loadGameDetails()
	sheet = spritesheet.load("assets/cards sprite.png")

	-- card dimensions
	local cardWidth = Card:getCardWidth(sheet)
	local cardHeight = Card:getCardHeight(sheet)

	-- screen dimensions
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	-- slot dimensions
	local slotSpacing = constants.SLOT_SPACING
	local totalSlotsWidth = (4 * cardWidth) + (3 * slotSpacing)
	local slotStartX = (screenWidth - totalSlotsWidth) / 2
	local slotStartY = screenHeight - cardHeight - 600

	-- create slots
	slots = Slots.createSlots(slotStartX, slotStartY, cardWidth, cardHeight, slotSpacing)

	-- generate a shuffled deck
	deckOfCards = Deck.new(sheet)
	deckOfCards = Deck.shuffleDeck(deckOfCards)

	-- button
	buttons.nextRoom = {
		text = "Next room!",
		w = 120,
		h = 40,
		x = love.graphics.getWidth() - 120 - 20,
		y = 20,
		color = constants.GREEN_COLOR,
		hoverColor = constants.GREEN_HOVER_COLOR,
		textColor = constants.WHITE_COLOR,
		hovered = false,
		onClick = function()
			drawCardsOnTable()
		end
	}
end

function love.draw()
	-- draw slots
	Slots.drawSlots(slots)

	-- draw deck of cards
	Deck.drawDeck(deckOfCards)

	-- draw table cards
	for _, c in ipairs(tableCards) do
		c:draw()
	end

	-- draw card class on slots
	Slots.drawCardClassOnSlot(slots)

	-- draw next room button
	local nextRoomBtn = buttons.nextRoom
	local bg = nextRoomBtn.hovered and nextRoomBtn.hoverColor or nextRoomBtn.color
	love.graphics.setColor(bg)
	love.graphics.rectangle("fill", nextRoomBtn.x, nextRoomBtn.y, nextRoomBtn.w, nextRoomBtn.h, 8, 8)
	love.graphics.setColor(nextRoomBtn.textColor)
	local font = love.graphics.getFont()
	local tw = font:getWidth(nextRoomBtn.text)
	local th = font:getHeight()
	love.graphics.print(nextRoomBtn.text, nextRoomBtn.x + (nextRoomBtn.w - tw) / 2,
		nextRoomBtn.y + (nextRoomBtn.h - th) / 2)
	love.graphics.setColor(1, 1, 1, 1)
end

function love.mousepressed(x, y, btn)
	if btn ~= 1 then return end

	if x > buttons.nextRoom.x and x < buttons.nextRoom.x + buttons.nextRoom.w
		and y > buttons.nextRoom.y and y < buttons.nextRoom.y + buttons.nextRoom.h
	then
		buttons.nextRoom.onClick()
		return
	end

	-- drag cards on mouse click
	for i = #deckOfCards, 1, -1 do
		local c = deckOfCards[i]
		if x > c.x and x < c.x + c.width
			and y > c.y and y < c.y + c.height
		then
			draggedCard = c
			c.dragging.active = true
			c.dragging.diffX = x - c.x
			c.dragging.diffY = y - c.y
			table.remove(deckOfCards, i)
			deckOfCards[#deckOfCards + 1] = c
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
	Timer.update(dt)

	local mx, my = love.mouse.getPosition()
	buttons.nextRoom.hovered = mx > buttons.nextRoom.x and mx < buttons.nextRoom.x + buttons.nextRoom.w
		and my > buttons.nextRoom.y and my < buttons.nextRoom.y + buttons.nextRoom.h

	for _, c in ipairs(deckOfCards) do
		c:update(dt)
	end

	for _, c in ipairs(tableCards) do
		c:update(dt)
	end
end
