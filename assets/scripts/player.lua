local players = {}

player = {}

player.load = function()
  -- sfx initialization
  jumpSounds = {}
  for i = 1, 3, 1 do
    local jumpSound = love.audio.newSource( "assets/sounds/FX/Jump" .. i .. ".wav", "static" )
    table.insert( jumpSounds, jumpSound )
  end
  
  landingSounds = {}
  for i = 1, 2, 1 do
    local landingSound = love.audio.newSource( "assets/sounds/FX/Landing" .. i .. ".wav", "static" )
    table.insert( landingSounds, landingSound )
  end
  
  pickupSounds = {}
  for i = 1, 5, 1 do
    local pickupSound = love.audio.newSource( "assets/sounds/FX/Pickup" .. i .. ".wav", "static" )
    table.insert( pickupSounds, pickupSound )
  end
  
  tauntSounds = {}
  for i = 1, 3, 1 do
    local tauntSound = love.audio.newSource( "assets/sounds/FX/Taunt" .. i .. ".wav", "static" )
    table.insert( tauntSounds, tauntSound )
  end

  stepSounds = {}
  for i = 1, 6, 1 do
    local stepSound = love.audio.newSource( "assets/sounds/FX/Step" .. i .. ".wav", "static" )
    table.insert( stepSounds, stepSound )
  end

  -- animation initialization
  local cellScale = { 1.5, 1.5 }
  local cellLeftScale = { -1.5, 1.5 }
  local cellSwapTime = 0.15
  local cellWidth = 16
  hangAnimation = newAnimation(
    "assets/images/playerIdle.png",
    {
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 0,
      to = 0
    }
  )
  
  idleAnimation = newAnimation( 
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 1,
      to = 4
    }
  )

  idleFallAnimation = newAnimation( 
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 5,
      to = 5
    }
  )
  
  idleJumpAnimation = newAnimation(
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 6,
      to = 6
    }
  )
  
  moveJumpRightAnimation = newAnimation(
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 8,
      to = 8
    }
  )
  
  moveFallRightAnimation = newAnimation(
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 7,
      to = 7
    }
  )
  
  moveJumpLeftAnimation = newAnimation(
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellLeftScale,
      from = 8,
      to = 8
    }
  )
  
  moveFallLeftAnimation = newAnimation(
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellLeftScale,
      from = 7,
      to = 7
    }
  )
  
  moveRightAnimation = newAnimation(
    "assets/images/playerIdle.png",
    {
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellScale,
      from = 9,
      to = 14
    }
  )
  
  moveLeftAnimation = newAnimation( 
    "assets/images/playerIdle.png",
    { 
      cellWidth = cellWidth,
      cellSwapTime = cellSwapTime,
      cellScale = cellLeftScale,
      from = 9,
      to = 15
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
  love.audio.play( jumpSounds[ love.math.random( 1, #jumpSounds ) ] )
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
        love.audio.play( pickupSounds[ love.math.random( 1, #pickupSounds ) ] )
        love.audio.play( tauntSounds[ love.math.random( 1, #tauntSounds ) ] )
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
    currentAnimation = idleAnimation,
    lastVY = 0
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

    if math.abs( vy ) < 0.01 and math.abs( playerInstance.lastVY ) >= 0.01 then
      playerInstance.hasDoubleJump = true
      love.audio.play( landingSounds[ love.math.random( 1, #landingSounds ) ] )
    end
    playerInstance.lastVY = vy
    
    if playerInstance.attachedBody ~= nil then
      playerInstance.attachedBody:setPosition( playerInstance.body:getX() + playerInstance.forward * 10, playerInstance.body:getY(), 0 )
    end
    
    if playerInstance.forward == 1 and vy > 0.01 then
      playerInstance.currentAnimation = moveJumpRightAnimation
    elseif playerInstance.forward == -1 and vy > 0.01 then
      playerInstance.currentAnimation = moveJumpLeftAnimation
    elseif playerInstance.forward == 1 and vy < -0.01 then
      playerInstance.currentAnimation = moveFallRightAnimation
    elseif playerInstance.forward == -1 and vy < -0.01 then
      playerInstance.currentAnimation = moveFallLeftAnimation
    elseif playerInstance.forward == 1 and math.abs( vy) < 0.01 then
      playerInstance.currentAnimation = moveRightAnimation
    elseif playerInstance.forward == -1 and math.abs( vy ) < 0.01 then
      playerInstance.currentAnimation = moveLeftAnimation
    elseif playerInstance.forward == 0 and math.abs( vy ) < 0.01 then
      playerInstance.currentAnimation = idleAnimation
    elseif playerInstance.forward == 0 and vy < -0.01 then
      playerInstance.currentAnimation = idleFallAnimation
    elseif playerInstance.forward == 0 and vy > 0.01 then
      playerInstance.currentAnimation = idleJumpAnimation
    end
    
    playerInstance.currentAnimation:update( dt )
    if playerInstance.currentAnimation == moveLeftAnimation or playerInstance.currentAnimation == moveRightAnimation then
      love.audio.play( stepSounds[ love.math.random( 1, #stepSounds ) ] )
    end
    
	end
end

player.draw = function()
	for i, playerInstance in pairs(players) do
    local playerWidth, playerHeight = playerInstance.currentAnimation:getCellDimensions()
		playerInstance.currentAnimation:draw( { x = playerInstance.body:getX() - playerWidth / 2, y = playerInstance.body:getY() - playerHeight / 2 } )
	end
end