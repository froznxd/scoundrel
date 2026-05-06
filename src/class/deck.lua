local Deck = {}
Deck.__index = Deck

local Card = require("src.class.card")
local constants = require("src.constants")

local deckTable = constants.DECK_CARDS

function Deck.new(cardSheet)
    local self = setmetatable({}, Deck)
    local cards = {}
    for i, tc in ipairs(deckTable) do
        local c = Card.new(cardSheet, tc.suit, tc.rank, tc.class, 40 + i * 0.1, 40 + i * 0.1)
        cards[#cards + 1] = c
    end

    self.cards = cards
    return self
end

function Deck:draw()
    for _, c in ipairs(self.cards) do
        c:draw()
    end
end

function Deck:shuffleDeck()
    local deck = self.cards
    for i = #deck, 2, -1 do
        local j = math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

return Deck
