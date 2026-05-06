local GameState = require("gamestate")

local actions = {}

function actions.fightMonster(state, card)
    local monsterValue = GameState.getCardValue(card)
    local damage = monsterValue

    if state.weapon then
        if monsterValue <= state.weapon.ceiling then
            local weaponValue = GameState.getCardValue(state.weapon.card)
            damage = math.max(0, monsterValue - weaponValue)
            state.weapon.ceiling = monsterValue
        end
    end

    state.hp = state.hp - damage
    state.resolvedCount = state.resolvedCount + 1
    state.resolvedCards[#state.resolvedCards + 1] = card
    state.stats.totalDamage = state.stats.totalDamage + damage
    state.stats.monstersSlain = state.stats.monstersSlain + 1

    if state.hp <= 0 then
        state.hp = 0
        state:setGameOver()
    end

    return { action = "fight", damage = damage, killed = state.hp <= 0 }
end

function actions.heal(state, card)
    local healValue = GameState.getCardValue(card)
    local oldHp = state.hp
    state.hp = math.min(state.maxHp, state.hp + healValue)
    local healed = state.hp - oldHp

    state.resolvedCount = state.resolvedCount + 1
    state.resolvedCards[#state.resolvedCards + 1] = card

    return { action = "heal", healed = healed }
end

function actions.equipWeapon(state, card)
    local weaponValue = GameState.getCardValue(card)
    state.weapon = {
        card = card,
        ceiling = weaponValue
    }

    state.resolvedCount = state.resolvedCount + 1
    state.resolvedCards[#state.resolvedCards + 1] = card

    return { action = "equip", weaponValue = weaponValue }
end

function actions.skipCard(state, card)
    if not state:canSkip() then
        return { action = "skip", success = false, reason = "Already skipped a card this room" }
    end

    state.skippedCard = card

    return { action = "skip", success = true }
end

function actions.resolveCard(state, card)
    if state.phase ~= "choosing" then
        return nil
    end

    local class = card.class
    if class == "monster" then
        return actions.fightMonster(state, card)
    elseif class == "heal" then
        return actions.heal(state, card)
    elseif class == "weapon" then
        return actions.equipWeapon(state, card)
    end

    return nil
end

return actions
