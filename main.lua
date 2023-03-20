io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end


Game = require("game2")
function love.load()
 	love.window.setMode(1024,768)
 	Game.load()

end
function love.update(dt)
	Game.update(dt)
end

function love.draw()
	Game.draw()
end
function love.keypressed(key)
	Game.keypressed(key)
end