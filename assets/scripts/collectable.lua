collectables = {}
collectablesSprites = {}

collectable = {}
collectable.spawnInterval = 3.5
quads = {}
width = 25
height = width
spriteSize = {}

collectable.load = function()
  path = "assets/images/symbols.png"
  collectablesSprites = love.graphics.newImage( path )
  collectable.lastTime = love.timer.getTime()
  spriteSize = collectablesSprites:getHeight() / 2
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
    local type = 4;
    randomType = love.math.random( 4 )
    local instance = {
      body = love.physics.newBody( world.physicsWorld, position.x, position.y, "dynamic" ),
      type = randomType
    }
    
    collectablePhysics.body = instance.body
    collectablePhysics.body:setFixedRotation( true )
    collectablePhysics.shape = love.physics.newRectangleShape( width, height )
    collectablePhysics.fixture = love.physics.newFixture( collectablePhysics.body, collectablePhysics.shape, 1 )
    collectablePhysics.fixture:setUserData( { colliderType = "collectable", instance = instance } )
    table.insert( collectables, instance )
    collectable.lastTime = currentTime
  end
end

dispSize = 45
pt1 = { x = 50, y = 490}
pt2 = { x = 976, y = 490}

collectable.draw = function()
  for i, collectableInstance in pairs(collectables) do
    if not collectableInstance.body:isDestroyed() then
    love.graphics.draw( collectablesSprites, quads[ collectableInstance.type ], 
      collectableInstance.body:getX() - width/2, collectableInstance.body:getY()-height/2, 0, width/spriteSize, height/spriteSize )
    end
  end
end

collectable.drawUI = function( colDispType1, colDispType2 )
  love.graphics.draw( collectablesSprites, quads[ colDispType1 ], pt1.x - dispSize/2, pt1.y - dispSize/2, 0, dispSize/spriteSize, dispSize/spriteSize )
  love.graphics.draw( collectablesSprites, quads[ colDispType2 ], pt2.x - dispSize/2, pt2.y - dispSize/2, 0, dispSize/spriteSize, dispSize/spriteSize )
end

