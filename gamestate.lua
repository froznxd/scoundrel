local GameState = {}
GameState.__index = GameState

local RANK_VALUES = {
    A = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5,
    ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10,
    J = 11, Q = 12, K = 13
}

local MAX_HP = 20
local STARTING_HP = 20

function GameState.new()
    local self = setmetatable({}, GameState)
    self.hp = STARTING_HP
    self.maxHp = MAX_HP
    self.weapon = nil          -- { card = Card, ceiling = number }
    self.phase = "dealing"     -- dealing, choosing, game_over, victory
    self.resolvedCount = 0
    self.roomCards = {}        -- cards currently in the room (up to 4)
    self.resolvedCards = {}    -- cards resolved this room
    self.skippedCard = nil     -- the one card skipped this room
    self.stats = {
        roomsSurvived = 0,
        totalDamage = 0,
        monstersSlain = 0,
    }
    return self
end

function GameState.getCardValue(card)
    return RANK_VALUES[card.rank] or 0
end

function GameState:isAlive()
    return self.hp > 0
end

function GameState:canAdvanceRoom()
    return self.resolvedCount >= 3
end

function GameState:canSkip()
    return self.skippedCard == nil
end

function GameState:getRemainingRoomCards()
    local remaining = {}
    for _, card in ipairs(self.roomCards) do
        local resolved = false
        for _, rc in ipairs(self.resolvedCards) do
            if rc == card then resolved = true; break end
        end
        if card ~= self.skippedCard and not resolved then
            remaining[#remaining + 1] = card
        end
    end
    return remaining
end

function GameState:resetRoom()
    self.resolvedCount = 0
    self.roomCards = {}
    self.resolvedCards = {}
    self.skippedCard = nil
end

function GameState:startRoom(cards)
    self:resetRoom()
    self.roomCards = cards
    self.phase = "choosing"
end

function GameState:setVictory()
    self.phase = "victory"
end

function GameState:setGameOver()
    self.phase = "game_over"
end

function GameState:reset()
    self.hp = STARTING_HP
    self.weapon = nil
    self.phase = "dealing"
    self.resolvedCount = 0
    self.roomCards = {}
    self.resolvedCards = {}
    self.skippedCard = nil
    self.stats = {
        roomsSurvived = 0,
        totalDamage = 0,
        monstersSlain = 0,
    }
end

return GameState
