local GameState = require("gamestate")
local roomModule = require("room")

local ui = {}

function ui.drawHUD(state, deckOfCards)
    local font = love.graphics.getFont()
    local x, y = 20, 20

    -- HP display
    local hpRatio = state.hp / state.maxHp
    local hpBarWidth = 200
    local hpBarHeight = 24

    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", x, y, hpBarWidth, hpBarHeight, 4, 4)

    local hpColor
    if hpRatio > 0.6 then
        hpColor = { 0.2, 0.8, 0.2 }
    elseif hpRatio > 0.3 then
        hpColor = { 0.9, 0.7, 0.1 }
    else
        hpColor = { 0.9, 0.2, 0.2 }
    end
    love.graphics.setColor(hpColor)
    love.graphics.rectangle("fill", x, y, hpBarWidth * hpRatio, hpBarHeight, 4, 4)

    love.graphics.setColor(1, 1, 1, 1)
    local hpText = "HP: " .. state.hp .. " / " .. state.maxHp
    local tw = font:getWidth(hpText)
    love.graphics.print(hpText, x + (hpBarWidth - tw) / 2, y + 4)

    -- Weapon display
    y = y + hpBarHeight + 16
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    if state.weapon then
        local wCard = state.weapon.card
        local wValue = GameState.getCardValue(wCard)
        love.graphics.print("Weapon: " .. wCard.rank .. " of " .. wCard.suit ..
            " (Power: " .. wValue .. ", Ceiling: " .. state.weapon.ceiling .. ")", x, y)
    else
        love.graphics.print("Weapon: None", x, y)
    end

    -- Deck counter
    y = y + 24
    love.graphics.setColor(0.7, 0.7, 0.9, 1)
    love.graphics.print("Deck: " .. #deckOfCards .. " cards remaining", x, y)

    -- Room progress
    y = y + 24
    local totalInRoom = #state.roomCards
    love.graphics.setColor(0.7, 0.9, 0.7, 1)
    love.graphics.print("Room: " .. state.resolvedCount .. "/" .. totalInRoom .. " resolved", x, y)

    if state:canSkip() then
        love.graphics.setColor(0.9, 0.9, 0.5, 1)
        love.graphics.print("  (can skip 1)", x + font:getWidth("Room: " .. state.resolvedCount .. "/" .. totalInRoom .. " resolved"), y)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function ui.drawCardHighlight(card, state)
    local value = GameState.getCardValue(card)
    local color

    if card.class == "monster" then
        local damage = value
        if state.weapon and value <= state.weapon.ceiling then
            local weaponValue = GameState.getCardValue(state.weapon.card)
            damage = math.max(0, value - weaponValue)
        end
        if damage == 0 then
            color = { 0.2, 0.8, 0.2, 0.3 }
        else
            color = { 0.9, 0.2, 0.2, 0.3 }
        end
    elseif card.class == "heal" then
        color = { 0.2, 0.8, 0.2, 0.3 }
    elseif card.class == "weapon" then
        color = { 0.3, 0.5, 0.9, 0.3 }
    end

    if color then
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", card.x - 4, card.y - 4, card.width + 8, card.height + 8, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Tooltip showing what will happen
    local font = love.graphics.getFont()
    local tooltip = ""
    if card.class == "monster" then
        local damage = value
        if state.weapon and value <= state.weapon.ceiling then
            local weaponValue = GameState.getCardValue(state.weapon.card)
            damage = math.max(0, value - weaponValue)
        end
        if damage > 0 then
            tooltip = "Fight: -" .. damage .. " HP"
        else
            tooltip = "Fight: Blocked!"
        end
    elseif card.class == "heal" then
        local healAmount = math.min(value, state.maxHp - state.hp)
        tooltip = "Heal: +" .. healAmount .. " HP"
    elseif card.class == "weapon" then
        tooltip = "Equip: Power " .. value
    end

    if tooltip ~= "" then
        love.graphics.setColor(1, 1, 1, 0.9)
        love.graphics.print(tooltip, card.x, card.y - 20)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function ui.drawButtons(buttons, state)
    -- Next Room button (only when can advance)
    if roomModule.canAdvance(state) and state.phase == "choosing" then
        ui.drawButton(buttons.nextRoom)
    end

    -- Skip button (only when can skip and there's a hovered card)
    if state:canSkip() and state.phase == "choosing" then
        ui.drawButton(buttons.skip)
    end
end

function ui.drawButton(btn)
    local bg = btn.hovered and btn.hoverColor or btn.color
    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
    love.graphics.setColor(btn.textColor)
    local font = love.graphics.getFont()
    local tw = font:getWidth(btn.text)
    local th = font:getHeight()
    love.graphics.print(btn.text, btn.x + (btn.w - tw) / 2, btn.y + (btn.h - th) / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

function ui.drawFeedback(message, timer)
    local alpha = math.min(1, timer)
    local screenWidth = love.graphics.getWidth()
    local font = love.graphics.getFont()
    local tw = font:getWidth(message)

    local color = { 1, 1, 1, alpha }
    if message:find("^%-") then
        color = { 1, 0.3, 0.3, alpha }
    elseif message:find("^%+") then
        color = { 0.3, 1, 0.3, alpha }
    elseif message:find("Blocked") then
        color = { 0.3, 0.8, 1, alpha }
    elseif message:find("Weapon") then
        color = { 0.5, 0.7, 1, alpha }
    end

    local yOffset = (2 - timer) * 20

    love.graphics.setColor(color)
    love.graphics.print(message, (screenWidth - tw) / 2, 100 - yOffset)
    love.graphics.setColor(1, 1, 1, 1)
end

function ui.drawEndScreen(state, restartBtn, score, highScores)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local font = love.graphics.getFont()

    -- Overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)

    -- Title
    local title
    local titleColor
    if state.phase == "victory" then
        title = "VICTORY!"
        titleColor = { 0.2, 0.9, 0.3, 1 }
    else
        title = "GAME OVER"
        titleColor = { 0.9, 0.2, 0.2, 1 }
    end

    love.graphics.setColor(titleColor)
    local tw = font:getWidth(title)
    love.graphics.print(title, (screenWidth - tw) / 2, screenHeight / 2 - 120)

    -- Score
    love.graphics.setColor(1, 0.9, 0.3, 1)
    local scoreText = "Score: " .. (score or 0)
    local sw = font:getWidth(scoreText)
    love.graphics.print(scoreText, (screenWidth - sw) / 2, screenHeight / 2 - 90)

    -- Stats
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    local stats = {
        "Rooms survived: " .. state.stats.roomsSurvived,
        "Monsters slain: " .. state.stats.monstersSlain,
        "Total damage taken: " .. state.stats.totalDamage,
        "Final HP: " .. state.hp .. "/" .. state.maxHp,
    }

    local sy = screenHeight / 2 - 50
    for _, line in ipairs(stats) do
        local lw = font:getWidth(line)
        love.graphics.print(line, (screenWidth - lw) / 2, sy)
        sy = sy + 22
    end

    -- High scores
    if highScores and #highScores > 0 then
        sy = sy + 16
        love.graphics.setColor(0.7, 0.7, 0.9, 1)
        local hsTitle = "-- High Scores --"
        local hw = font:getWidth(hsTitle)
        love.graphics.print(hsTitle, (screenWidth - hw) / 2, sy)
        sy = sy + 22

        love.graphics.setColor(0.6, 0.6, 0.8, 1)
        for i = 1, math.min(5, #highScores) do
            local entry = i .. ". " .. highScores[i]
            local ew = font:getWidth(entry)
            love.graphics.print(entry, (screenWidth - ew) / 2, sy)
            sy = sy + 20
        end
    end

    love.graphics.setColor(1, 1, 1, 1)

    -- Restart button
    restartBtn.y = sy + 20
    ui.drawButton(restartBtn)
end

return ui
