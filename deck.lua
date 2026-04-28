local Deck = {}
Deck.__index = Deck

local Card = require("card")
local constants = require("constants")

local deckTable = constants.DECK_CARDS

function Deck.new(cardSheet)
    local self = setmetatable({}, Deck)
    local cards = {}
    for i, tc in ipairs(deckTable) do
        local c = Card.new(cardSheet, tc.suit, tc.rank, 40 + i * 0.1, 40 + i * 0.1)
        cards[#cards + 1] = c
    end

    self.deck = cards
    return self.deck
end

function Deck.drawDeck(cards)
    for _, c in ipairs(cards) do
        c:draw()
    end
end

function Deck.shuffleDeck(cards)
    for i = #cards, 2, -1 do
        local j = math.random(i)
        cards[i], cards[j] = cards[j], cards[i]
    end

    return cards
end

return Deck
