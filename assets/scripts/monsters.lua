
monsters = {}

monster1Img = {}
monster2Img = {}
handsBackImg = {}
handsFrontImg = {}

offset1 = { x = 0, y = 0, r = 0, sx = 0, sy = 0}
offset2 = { x = 0, y = 0, r = 0, sx = 0, sy = 0}

handsPtA = { x = 0, y = 0 }
handsPtB = { x = 400, y = 400 }

function monsters:load()
  monster1Img = love.graphics.newImage( "assets/images/qqq_mo1.png" )
  monster2Img = love.graphics.newImage( "assets/images/qqq_mo2.png" )
  handsBackImg = love.graphics.newImage( "assets/images/qqq_ml1.png" )
  handsFrontImg = love.graphics.newImage( "assets/images/qqq_ml2.png" )
end

function monsters:draw()
  
  --love.graphics.draw( handsBackImg, ( handsPtA.x + handsPtb.x )/2, 500, 0, 0.9, 0.9 )
  --love.graphics.draw( monster1Img, offset1.x + 300, offset1.y + 500, offset1.r + 0, offset1.sx + 0.9, offset1.sy + 0.9 )
  --love.graphics.draw( monster2Img, offset2.x + 500, offset2.y + 500, offset2.r + 0, offset2.sx + 0.9, offset2.sy + 0.9 )
  --love.graphics.draw( handsFrontImg, 400, 500, 0, 0.9, 0.9 )
end

function monsters:update(dt)
  
  
end

