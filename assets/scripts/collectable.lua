collectables = {}
collectablesSprites = {}

collectable = {}
collectable.spawnInterval = 2.0
quads = {}
width = 20
height = 20


collectable.load = function()
  path = "assets/images/symbols.png"
  collectablesSprites = love.graphics.newImage( path )
  collectable.lastTime = love.timer.getTime()
  local spriteSize = collectablesSprites:getHeight() / 2
  for i = 0, 4, 1 do
    table.insert( quads, i, love.graphics.newQuad( math.floor( i / 2 - 0.1 ) * spriteSize, math.fmod(i, 2) * spriteSize , spriteSize, spriteSize, collectablesSprites:getDimensions() ) )
  end
end

collectable.update = function(dt)
  local currentTime = love.timer.getTime()
  if currentTime - collectable.lastTime >= collectable.spawnInterval then
    local position = {
      x = love.math.random( love.graphics.getWidth() / 10, love.graphics.getWidth() / 10 * 9 ),
      y = love.math.random( love.graphics.getHeight() / 10, love.graphics.getHeight() / 10 * 5 )
    }
    
    local collectablePhysics = {}
    
    local instance = {
      body = love.physics.newBody( world.physicsWorld, position.x, position.y, "dynamic" ),
      type = love.math.random( 4 )
    }
    
    collectablePhysics.body = instance.body
    collectablePhysics.body:setFixedRotation( true )
    collectablePhysics.shape = love.physics.newRectangleShape( width, height )
    collectablePhysics.fixture = love.physics.newFixture( collectablePhysics.body, collectablePhysics.shape, 1 )
    collectablePhysics.fixture:setUserData( { colliderType = "collectable", instance = instance } )
    table.insert( world.objects, collectablePhysics )
    table.insert( collectables, instance )
    collectable.lastTime = currentTime
  end
end

collectable.draw = function()
  for i, collectableInstance in pairs(collectables) do
    love.graphics.draw( collectablesSprites, quads[ collectableInstance.type ], collectableInstance.body:getX(), collectableInstance.body:getY() )
  end
end