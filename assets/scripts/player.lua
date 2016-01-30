local players = {}

player = {}

player.handleJoystickInput = function(playerInstance, dt)
	local axisX = playerInstance.joystick:getAxis( 1 )
	local axisY = playerInstance.joystick:getAxis( 2 )
	
	playerInstance.position.x = playerInstance.position.x + axisX * dt * playerInstance.speed.x
	playerInstance.position.y = playerInstance.position.y + axisY * dt * playerInstance.speed.y
end

player.newPlayer = function( position, speed, color, joystick )
	local instance = { 
		position = position,
		speed = speed,
		color = color,
		joystick = joystick
	}
	table.insert( players, instance )
end

player.load = function()
	playerSprite = love.graphics.newImage("assets/images/player.png")
end

player.update = function(dt)
	local joysticks = love.joystick.getJoysticks()
	for k, playerInstance in pairs(players) do
		player.handleJoystickInput( playerInstance, dt )
	end
end

player.draw = function()
	for k, playerInstance in pairs(players) do
		love.graphics.setColor( playerInstance.color )
		love.graphics.draw( playerSprite, playerInstance.position.x, playerInstance.position.y )--, 1, 1, playerSprite:getWidth() / 2, playerSprite:getHeight() / 2 )
	end
end