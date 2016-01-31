require "assets/scripts/monsters"
require "assets/scripts/collectable"

ui = {}

type1 = 0
type2 = 0

function randTypes()
  type1 = love.math.random( 4 )
  type2 = love.math.random( 4 )
end

ui.addNeutralCollectible = function( collectibleType )
  randTypes();
end

ui.addCollectible = function( collectibleType, playerIndex )
  if playerIndex == 2 and collectibleType == type1 then
    monsters:hit1()
  elseif playerIndex == 1 and collectibleType == type2 then
    monsters:hit2()
  end
  
  randTypes();
end
    
function ui:load()
  randTypes()
end
    
function ui:draw()
  collectable.drawUI( type1, type2 )
end
    