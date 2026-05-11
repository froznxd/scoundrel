local constants = require "src.constants"

local conf = require("conf")
local Game = require("src.systems.game")

local game

function love.load()
	conf.loadGameDetails()
	love.graphics.setFont(love.graphics.newFont(constants.FONT_PATH, constants.FONT_SIZE_1))
	game = Game.new()
end

function love.update(dt)
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
