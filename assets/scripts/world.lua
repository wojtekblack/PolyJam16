require "assets/scripts/monsters"

world = {}

function world:load()
  self.background = love.graphics.newImage( "assets/images/qqq.png" )
  self.bgWidth = self.background:getWidth()
  self.bgHeight = self.background:getHeight()
  
  self.bgFilter = love.graphics.newImage( "assets/images/qqq_mask.png" )
  
  love.physics.setMeter(64)
  local physicsWorld = love.physics.newWorld( 0, 9.81*128 )
  self.physicsWorld = physicsWorld
  
  local objects = {}
  
  for i = 0,1 do
    local ground = {}
    ground.body = love.physics.newBody( physicsWorld, love.graphics.getWidth() / 2, i * 420, "static" )
    ground.shape = love.physics.newRectangleShape( love.graphics.getWidth(), 10 )
    ground.fixture = love.physics.newFixture( ground.body, ground.shape, 1 )
    table.insert( objects, ground )
  end
  
  for i = 0,1 do
    local wall = {}
    wall.body = love.physics.newBody( physicsWorld, i * love.graphics.getWidth(), love.graphics.getHeight() / 2, "static" )
    wall.shape = love.physics.newRectangleShape( 10 , love.graphics.getHeight() )
    wall.fixture = love.physics.newFixture( wall.body, wall.shape, 1 )
    wall.fixture:setFriction( 100 )
    table.insert( objects, wall )
  end
  
  local platforms = {
    platform1 = { x = love.graphics.getWidth() / 6, y = love.graphics.getHeight() / 16 * 3 },
    platform2 = { x = love.graphics.getWidth() / 6, y = love.graphics.getHeight() / 16 * 7 },
    platform3 = { x = love.graphics.getWidth() / 6 * 3, y = love.graphics.getHeight() / 16 * 5 },
    platform4 = { x = love.graphics.getWidth() / 6 * 5, y = love.graphics.getHeight() / 16 * 3 },
    platform5 = { x = love.graphics.getWidth() / 6 * 5, y = love.graphics.getHeight() / 16 * 7 }
  }
  
  for i, platform in pairs(platforms) do
    local plaformCollider = {}
    plaformCollider.body = love.physics.newBody( physicsWorld, platform.x, platform.y, "static" )
    plaformCollider.shape = love.physics.newRectangleShape( love.graphics.getWidth() / 5, love.graphics.getHeight() / 40 )
    plaformCollider.fixture = love.physics.newFixture( plaformCollider.body, plaformCollider.shape, 1 )
    table.insert( objects, plaformCollider )
  end
  
  local cauldron = {}
  cauldron.body = love.physics.newBody( physicsWorld, love.graphics.getWidth() / 2, 380, "static" )
  cauldron.shape = love.physics.newRectangleShape( 60, 60 )
  cauldron.fixture = love.physics.newFixture( cauldron.body, cauldron.shape, 1 )
  cauldron.fixture:setSensor( true )
  cauldron.fixture:setUserData( { colliderType = "cauldron", instance = nil } )
  table.insert( objects, cauldron )
  
  world.objects = objects

  function checkCollisions ( cauldron, other, contact )
    if other:getUserData().colliderType == "collectable" then
      remObj( other:getUserData().instance.object, world.objects )
      ui.addNeutralCollectible( other:getUserData().instance.type )
      other:getBody():destroy()
    elseif other:getUserData().colliderType == "player" then
      local playerInstance = other:getUserData().instance
      if playerInstance.attachedBody ~= nil then
        local boxInstance = playerInstance.attachedBody:getFixtureList()[1]:getUserData()
        local type = boxInstance.type
        ui.addCollectible( boxInstance.instance.type, playerInstance.playerIndex )
        remObj( playerInstance.attachedBody, world.objects )       
        playerInstance.attachedBody:destroy()
        playerInstance.attachedBody = nil
      end
    end
  end

  beginContact = function ( a, b, contact )
    if a:getUserData() ~= nil and a:getUserData().colliderType == "cauldron" then
      checkCollisions( a, b, contact )
    elseif b:getUserData() ~= nil and b:getUserData().colliderType == "cauldron" then
      checkCollisions( b, a, contact )
    end
  end
  world.physicsWorld:setCallbacks( beginContact, nil, nil, nil )
end

function remObj( object, container )
  for i, value in pairs(container) do
      if object == value then
          table.remove(container, i)
      end
  end
end

function world:draw()
  love.graphics.draw( self.background, 0, 0, 0, love.graphics.getWidth() / self.bgWidth, love.graphics.getHeight() / self.bgHeight )
  monsters.draw()
  love.graphics.draw( self.bgFilter, 0, 0, 0, love.graphics.getWidth() / self.bgWidth, love.graphics.getHeight() / self.bgHeight )
  
  local r, g, b, a = love.graphics.getColor()
  for i, object in pairs(self.objects) do
    love.graphics.setColor( 255, 255, 0, 100 )
    if not object.body:isDestroyed() then
      love.graphics.polygon( "fill", object.body:getWorldPoints( object.shape:getPoints() ) )
    end
  end
  love.graphics.setColor( r, g, b, a )
end

function world:update(dt)
  self.physicsWorld:update(dt)
end