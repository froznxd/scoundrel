Timer = require "lib.hump.timer"

local conf = require("conf")
local Game = require("src.systems.game")

local game

function love.load()
    conf.loadGameDetails()
    game = Game.new()
end

function love.update(dt)
    Timer.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.mousepressed(x, y, btn)
    game:mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
    game:mousereleased(x, y, btn)
end
