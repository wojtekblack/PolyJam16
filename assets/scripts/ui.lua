require "assets/scripts/monsters"

ui = {}

ui.addCollectible = function( collectibleType, playerIndex )
  if collectibleType == 0 or collectibleType == 1 then
    monsters:hit1()
  elseif collectibleType == 2 or collectibleType == 3 then
    monsters:hit2()
  end
end