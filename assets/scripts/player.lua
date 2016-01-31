local players = {}

player = {}

player.load = function()
  idleAnimation = newAnimation( 
    "assets/images/playerIdle.png",
    { 
      cellWidth = 16,
      cellSwapTime = 0.15,
      cellScale = { 1.5, 1.5 }
    }
  )
  
  keyboardInputMapping = {
    {
      left = "left",
      right = "right",
      jump = "j",
      action1 = "k"
    },
    {
      left = "a",
      right = "d",
      jump = "f",
      action1 = "g"
    }
  }
  
end

player.handleJump = function( playerInstance )
  local vx, vy = playerInstance.body:getLinearVelocity()
  if math.abs(vy) > 0.01 and playerInstance.hasDoubleJump then
    playerInstance.hasDoubleJump = false
  elseif math.abs(vy) > 0.01 then
    return
  end
  playerInstance.body:setLinearVelocity( vx, playerInstance.speed.y )
end

player.handleGrabThrow = function( playerInstance )
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

player.handleJoystickPressed = function( joystick )
  for i, playerInstance in pairs(players) do
    if playerInstance.joystick == joystick then
      if joystick:isGamepadDown('a') then
        player.handleJump( playerInstance )
      elseif joystick:isGamepadDown('b') then
        player.handleGrabThrow( playerInstance )
      end
    end
  end
end

player.handleKeyboardPressed = function( key, scancode, isRepeat )
  for i, playerInstance in pairs(players) do
    if scancode == keyboardInputMapping[ playerInstance.playerIndex ].jump then
      player.handleJump( playerInstance )
    end
    if scancode == keyboardInputMapping[ playerInstance.playerIndex ].action1 then
      player.handleGrabThrow( playerInstance )
    end
  end
end

player.handleMovement = function( playerInstance, axisX )
  if math.abs( axisX ) > 0.1 then
    local x, y = playerInstance.body:getLinearVelocity()
    playerInstance.body:setLinearVelocity( axisX * playerInstance.speed.x, y )
  else
    local x, y = playerInstance.body:getLinearVelocity()
    playerInstance.body:setLinearVelocity( 0, y )
  end
end

player.handleInput = function(playerInstance, dt)
  local axisX = 0
  if playerInstance.joystick ~= nil then
    axisX = playerInstance.joystick:getAxis( 1 )
  else
    if love.keyboard.isDown( keyboardInputMapping[ playerInstance.playerIndex ].left ) then
      axisX = -1
    end
    if love.keyboard.isDown( keyboardInputMapping[ playerInstance.playerIndex ].right ) then
      axisX = 1
    end
  end
  player.handleMovement( playerInstance, axisX )
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
	for i, playerInstance in pairs(players) do
    
		player.handleInput( playerInstance, dt )
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