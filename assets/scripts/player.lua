local players = {}

player = {}

player.load = function()
  idleAnimation = newAnimation( 
    "assets/images/playerIdle.png",
    { 
      cellWidth = 16,
      cellSwapTime = 0.15
    }
  )
end

player.handleJoystickPressed = function( joystick )
  for i, playerInstance in pairs(players) do
    if playerInstance.joystick == joystick then
      if joystick:isGamepadDown('a') then
        local vx, vy = playerInstance.body:getLinearVelocity()
        if math.abs(vy) > 0.01 and playerInstance.hasDoubleJump then
          playerInstance.hasDoubleJump = false
        elseif math.abs(vy) > 0.01 then
          return
        end
        playerInstance.body:setLinearVelocity( vx, playerInstance.speed.y )
      elseif joystick:isGamepadDown('b') then
        if playerInstance.attachedBody ~= nil then
          playerInstance.attachedBody:setPosition( playerInstance.body:getX() + playerInstance.forward * 10, playerInstance.body:getY() )
          playerInstance.attachedBody:setActive( true )
          local vx, vy = playerInstance.body:getLinearVelocity()
          playerInstance.body:setLinearVelocity( playerInstance.forward * vx * 2, 0 )
          playerInstance.attachedBody = nil
        else
          for i, contact in pairs(playerInstance.body:getContactList()) do
            local a, b = contact:getFixtures()
            if b:getUserData().colliderType == "collectable" then
              local other = b:getUserData().instance
              other.body:setActive( false )
              playerInstance.attachedBody = other.body
              break
            end
          end
        end
      end
    end
  end
end

player.handleJoystickInput = function(playerInstance, dt)
	local axisX = playerInstance.joystick:getAxis( 1 )
	
  if math.abs( axisX ) > 0.1 then
    local x, y = playerInstance.body:getLinearVelocity()
    playerInstance.body:setLinearVelocity( axisX * playerInstance.speed.x, y )
  else
    local x, y = playerInstance.body:getLinearVelocity()
    playerInstance.body:setLinearVelocity( 0, y )
  end
end

player.newPlayer = function( position, speed, playerIndex )
	local instance = { 
		speed = speed,
		joystick = love.joystick.getJoysticks()[ playerIndex ],
    body = love.physics.newBody( world.physicsWorld, position.x, position.y, "dynamic" ),
    forward = 0,
    playerIndex = playerIndex,
    currentAnimation = idleAnimation
	}
  
  local playerPhysics = {}
  playerPhysics.body = instance.body
  playerPhysics.body:setFixedRotation( true )
  playerPhysics.shape = love.physics.newRectangleShape( instance.currentAnimation:getCellDimensions() )
  playerPhysics.fixture = love.physics.newFixture( playerPhysics.body, playerPhysics.shape, 1 )
  playerPhysics.fixture:setUserData( { colliderType = "player", instance = instance } )
  world.objects.player = playerPhysics
  
	table.insert( players, instance )
end

player.update = function(dt)
	local joysticks = love.joystick.getJoysticks()
	for i, playerInstance in pairs(players) do
    
		player.handleJoystickInput( playerInstance, dt )
    local vx, vy = playerInstance.body:getLinearVelocity()
    
    if vx > 0.01 then
      playerInstance.forward = 1 
    elseif vx < -0.01 then
      playerInstance.forward = -1 
    else
      playerInstance.forward = 0
    end

    if vy == 0 then
      playerInstance.hasDoubleJump = true
    end
    
    if playerInstance.attachedBody ~= nil then
      playerInstance.attachedBody:setPosition( playerInstance.body:getX() + playerInstance.forward * 10, playerInstance.body:getY(), 0 )
    end
    
    playerInstance.currentAnimation:update( dt )
    
	end
end

player.draw = function()
	for i, playerInstance in pairs(players) do
    local playerWidth, playerHeight = playerInstance.currentAnimation:getCellDimensions()
		playerInstance.currentAnimation:draw( { x = playerInstance.body:getX() - playerWidth / 2, y = playerInstance.body:getY() - playerHeight / 2 } )
	end
end