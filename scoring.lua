local scoring = {}

function scoring.calculate(state)
    local score = 0

    score = score + state.hp * 10
    score = score + state.stats.roomsSurvived * 5
    score = score + state.stats.monstersSlain * 3

    if state.phase == "victory" then
        score = score + 100
    end

    return score
end

function scoring.loadHighScores()
    local scores = {}
    if love.filesystem.getInfo("highscores.txt") then
        local content = love.filesystem.read("highscores.txt")
        for line in content:gmatch("[^\n]+") do
            local s = tonumber(line)
            if s then scores[#scores + 1] = s end
        end
    end
    table.sort(scores, function(a, b) return a > b end)
    return scores
end

function scoring.saveHighScore(score)
    local scores = scoring.loadHighScores()
    scores[#scores + 1] = score
    table.sort(scores, function(a, b) return a > b end)

    -- Keep top 10
    local lines = {}
    for i = 1, math.min(10, #scores) do
        lines[#lines + 1] = tostring(scores[i])
    end

    love.filesystem.write("highscores.txt", table.concat(lines, "\n"))
    return scores
end

return scoring
