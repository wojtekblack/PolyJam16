collectables = {}
collectablesSprites = {}

collectable = {}

collectable.spawnInterval = 2.0

collectable.load = function()
  spritesPaths = {
    sprite1 = "assets/images/collectable1.png"
  }
  
  for i, path in pairs(spritesPaths) do
    table.insert( collectablesSprites, love.graphics.newImage( path ) )
  end
  
  collectable.lastTime = love.timer.getTime()
end

collectable.update = function(dt)
  local currentTime = love.timer.getTime()
  if currentTime - collectable.lastTime >= collectable.spawnInterval then
    local position = {
      x = love.math.random( love.graphics.getWidth() / 10, love.graphics.getWidth() / 10 * 9 ),
      y = love.math.random( love.graphics.getHeight() / 10, love.graphics.getHeight() / 10 * 5 )
    }
    
    local collectableSprite = collectablesSprites[ math.floor( love.math.random( 1, #collectablesSprites ) ) ]
    
    local collectablePhysics = {}
    
    local instance = {
      body = love.physics.newBody( world.physicsWorld, position.x, position.y, "dynamic" ),
      sprite = collectableSprite,
      object = collectablePhysics
    }
    
    collectablePhysics.body = instance.body
    collectablePhysics.body:setFixedRotation( true )
    collectablePhysics.shape = love.physics.newRectangleShape( collectableSprite:getWidth(), collectableSprite:getHeight() )
    collectablePhysics.fixture = love.physics.newFixture( collectablePhysics.body, collectablePhysics.shape, 1 )
    collectablePhysics.fixture:setUserData( { colliderType = "collectable", instance = instance, type = 1 } )
    table.insert( world.objects, collectablePhysics )
    collectable.lastTime = currentTime
  end
end

collectable.draw = function()
  for i, collectableInstance in pairs(collectables) do
    love.graphics.draw( collectableInstance.sprite, 
      collectableInstance.body:getX() - collectableInstance.sprite.getWidth() / 2,
      collectableInstance.body:getY() - collectableInstance.sprite.getHeight() / 2 )
  end
end