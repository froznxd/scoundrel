local function loadGameDetails()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(0, 0, { fullscreen = true, resizable = false })
    love.window.setTitle("Poker Game")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)
end

return {
    loadGameDetails = loadGameDetails
}
