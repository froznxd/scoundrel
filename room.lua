local room = {}

function room.dealCards(deckOfCards, slots, state)
    local dealt = {}
    local count = math.min(4, #deckOfCards)

    for i = 1, count do
        if #deckOfCards == 0 then break end
        local card = table.remove(deckOfCards, 1)
        card:moveCardToPosition(slots[i].x, slots[i].y)
        card:flipCardUp()
        card.resolved = false
        card.slotIndex = i
        slots[i].card = card
        dealt[#dealt + 1] = card
    end

    for i = count + 1, 4 do
        slots[i].card = nil
    end

    state:startRoom(dealt)
    return dealt
end

function room.isCardResolved(card, state)
    for _, rc in ipairs(state.resolvedCards) do
        if rc == card then return true end
    end
    if state.skippedCard == card then return true end
    return false
end

function room.getUnresolvedCards(state)
    local unresolved = {}
    for _, card in ipairs(state.roomCards) do
        if not room.isCardResolved(card, state) then
            unresolved[#unresolved + 1] = card
        end
    end
    return unresolved
end

function room.canAdvance(state)
    return state.resolvedCount >= 3 or
        (#state.roomCards - (state.skippedCard and 1 or 0)) <= state.resolvedCount
end

function room.isDeckEmpty(deckOfCards)
    return #deckOfCards == 0
end

return room
