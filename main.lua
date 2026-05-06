Timer = require "packages.hump.timer"

local Card = require("card")
local spritesheet = require("spritesheet")
local constants = require("constants")
local gameDetails = require("game-details")
local Deck = require("deck")
local Slots = require("slots")
local GameState = require("gamestate")
local actions = require("actions")
local roomModule = require("room")
local ui = require("ui")
local scoring = require("scoring")

local sheet
local deckOfCards = {}
local slots = {}
local buttons = {}
local tableCards = {}
local discardedCards = {}
local state
local hoveredCard = nil
local feedbackMessage = nil
local feedbackTimer = 0
local finalScore = 0
local highScores = {}

local function startNewGame()
    state = GameState.new()

    deckOfCards = Deck.new(sheet)
    deckOfCards = Deck.shuffleDeck(deckOfCards)
    tableCards = {}
    discardedCards = {}
    hoveredCard = nil
    feedbackMessage = nil
    feedbackTimer = 0
    finalScore = 0

    tableCards = roomModule.dealCards(deckOfCards, slots, state)
end

local function endGame()
    finalScore = scoring.calculate(state)
    highScores = scoring.saveHighScore(finalScore)
end

local function advanceRoom()
    if not roomModule.canAdvance(state) then return end

    state.stats.roomsSurvived = state.stats.roomsSurvived + 1

    for _, card in ipairs(tableCards) do
        table.insert(discardedCards, card)
    end
    tableCards = {}

    if roomModule.isDeckEmpty(deckOfCards) then
        state:setVictory()
        endGame()
        return
    end

    tableCards = roomModule.dealCards(deckOfCards, slots, state)
end

local function showFeedback(msg)
    feedbackMessage = msg
    feedbackTimer = 2
end

local function handleCardClick(card)
    if state.phase ~= "choosing" then return end
    if roomModule.isCardResolved(card, state) then return end

    local result = actions.resolveCard(state, card)
    if result then
        card.resolved = true
        card:fadeOut(2)

        if result.action == "fight" then
            if result.damage > 0 then
                card:shake(8, 0.3)
                showFeedback("-" .. result.damage .. " HP!")
            else
                showFeedback("Blocked! No damage.")
            end
        elseif result.action == "heal" then
            showFeedback("+" .. result.healed .. " HP")
        elseif result.action == "equip" then
            showFeedback("Weapon equipped! (Power: " .. result.weaponValue .. ")")
        end

        if state.phase == "game_over" then
            endGame()
            return
        end
    end

    if state.phase == "choosing" and roomModule.canAdvance(state) then
        local unresolved = roomModule.getUnresolvedCards(state)
        if #unresolved == 0 then
            Timer.after(0.5, function() advanceRoom() end)
        end
    end
end

local function handleSkipClick(card)
    if state.phase ~= "choosing" then return end
    if roomModule.isCardResolved(card, state) then return end

    local result = actions.skipCard(state, card)
    if result.success then
        card.resolved = true
        card:fadeOut(3)
        showFeedback("Card skipped")

        if roomModule.canAdvance(state) then
            local unresolved = roomModule.getUnresolvedCards(state)
            if #unresolved == 0 then
                Timer.after(0.5, function() advanceRoom() end)
            end
        end
    else
        showFeedback(result.reason)
    end
end

function love.load()
    gameDetails.loadGameDetails()
    sheet = spritesheet.load("assets/cards sprite.png")

    local cardWidth = Card:getCardWidth(sheet)
    local cardHeight = Card:getCardHeight(sheet)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local slotSpacing = constants.SLOT_SPACING
    local totalSlotsWidth = (4 * cardWidth) + (3 * slotSpacing)
    local slotStartX = (screenWidth - totalSlotsWidth) / 2
    local slotStartY = (screenHeight - cardHeight) / 2

    slots = Slots.createSlots(slotStartX, slotStartY, cardWidth, cardHeight, slotSpacing)

    buttons.nextRoom = {
        text = "Next Room",
        w = 140,
        h = 44,
        x = screenWidth - 160,
        y = screenHeight - 64,
        color = constants.GREEN_COLOR,
        hoverColor = constants.GREEN_HOVER_COLOR,
        textColor = constants.WHITE_COLOR,
        hovered = false,
        onClick = function()
            advanceRoom()
        end
    }

    buttons.skip = {
        text = "Skip Card",
        w = 140,
        h = 44,
        x = screenWidth - 160,
        y = screenHeight - 120,
        color = constants.YELLOW_COLOR,
        hoverColor = constants.YELLOW_HOVER_COLOR,
        textColor = { 0, 0, 0 },
        hovered = false,
        onClick = function()
            if hoveredCard and not roomModule.isCardResolved(hoveredCard, state) then
                handleSkipClick(hoveredCard)
            end
        end
    }

    buttons.restart = {
        text = "Play Again",
        w = 160,
        h = 50,
        x = screenWidth / 2 - 80,
        y = screenHeight / 2 + 60,
        color = constants.GREEN_COLOR,
        hoverColor = constants.GREEN_HOVER_COLOR,
        textColor = constants.WHITE_COLOR,
        hovered = false,
        onClick = function()
            startNewGame()
        end
    }

    startNewGame()
end

function love.draw()
    if state.phase == "game_over" or state.phase == "victory" then
        ui.drawEndScreen(state, buttons.restart, finalScore, highScores)
        return
    end

    Slots.drawSlots(slots)

    for _, c in ipairs(tableCards) do
        if c.alpha > 0 then
            c:draw()
        end
    end

    Slots.drawCardClassOnSlot(slots)

    if hoveredCard and not roomModule.isCardResolved(hoveredCard, state) and state.phase == "choosing" then
        ui.drawCardHighlight(hoveredCard, state)
    end

    ui.drawHUD(state, deckOfCards)
    ui.drawButtons(buttons, state)

    if feedbackMessage and feedbackTimer > 0 then
        ui.drawFeedback(feedbackMessage, feedbackTimer)
    end
end

function love.mousepressed(x, y, btn)
    if btn ~= 1 then return end

    if state.phase == "game_over" or state.phase == "victory" then
        local r = buttons.restart
        if x > r.x and x < r.x + r.w and y > r.y and y < r.y + r.h then
            r.onClick()
        end
        return
    end

    -- Check Next Room button
    if roomModule.canAdvance(state) then
        local nr = buttons.nextRoom
        if x > nr.x and x < nr.x + nr.w and y > nr.y and y < nr.y + nr.h then
            nr.onClick()
            return
        end
    end

    -- Check Skip button
    if state:canSkip() and hoveredCard then
        local sk = buttons.skip
        if x > sk.x and x < sk.x + sk.w and y > sk.y and y < sk.y + sk.h then
            sk.onClick()
            return
        end
    end

    -- Click on room cards to resolve
    for i = #tableCards, 1, -1 do
        local c = tableCards[i]
        if not c.resolved and x > c.x and x < c.x + c.width and y > c.y and y < c.y + c.height then
            handleCardClick(c)
            return
        end
    end
end

function love.update(dt)
    Timer.update(dt)

    if feedbackTimer > 0 then
        feedbackTimer = feedbackTimer - dt
    end

    local mx, my = love.mouse.getPosition()

    -- Update button hover states
    for _, btn in pairs(buttons) do
        if btn.x and btn.w then
            btn.hovered = mx > btn.x and mx < btn.x + btn.w
                and my > btn.y and my < btn.y + btn.h
        end
    end

    -- Track hovered card
    hoveredCard = nil
    if state.phase == "choosing" then
        for i = #tableCards, 1, -1 do
            local c = tableCards[i]
            if not c.resolved and mx > c.x and mx < c.x + c.width
                and my > c.y and my < c.y + c.height then
                hoveredCard = c
                break
            end
        end
    end

    for _, c in ipairs(tableCards) do
        c:update(dt)
    end
end
