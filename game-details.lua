local function loadGameDetails()
    love.window.setMode(1600, 900, { resizable = true })
    love.window.setTitle("Poker Game")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)
end

return {
    loadGameDetails = loadGameDetails
}
