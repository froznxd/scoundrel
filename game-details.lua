local function loadGameDetails()
    love.window.setMode(1600, 900, { resizable = true })
    love.window.setTitle("Scoundrel")
    love.graphics.setBackgroundColor(0.08, 0.1, 0.12, 1)
end

return {
    loadGameDetails = loadGameDetails
}
