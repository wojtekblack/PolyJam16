require "assets/scripts/player"

function love.load() 
	player.load()
	player.newPlayer( { x = 100, y = 100 }, { x = 100, y = 100 }, { 255, 0, 0, 100 }, love.joystick.getJoysticks()[1] )
	player.newPlayer( { x = 200, y = 100 }, { x = 100, y = 100 }, { 0, 255, 0, 100 }, love.joystick.getJoysticks()[2] )
end

function love.update( dt )
	player.update(dt)
end

function love.draw()
	player.draw()
end