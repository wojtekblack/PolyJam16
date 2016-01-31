
monsters = {}

monster1Img = {}
monster2Img = {}
handsBackImg = {}
handsFrontImg = {}

offset1 = { x = 0, y = 0, r = 0, sx = 0, sy = 0}
offset2 = { x = 0, y = 0, r = 0, sx = 0, sy = 0}

mLoc1 = { x = 400, y = 650 }
mLoc2 = { x = 600, y = 650 }

handsPtA = { x = 0, y = 1 }
handsPtB = { x = 0, y = 1 }

offsHA = { x = 15, y = 20 }
offsHB = { x = -25, y = 20 }

function monsters:load()
  monster1Img = love.graphics.newImage( "assets/images/qqq_mo1.png" )
  monster2Img = love.graphics.newImage( "assets/images/qqq_mo2.png" )
  handsFrontImg = love.graphics.newImage( "assets/images/qqq_ml1.png" )
  handsBackImg = love.graphics.newImage( "assets/images/qqq_ml2.png" )
  
  monsterSounds = {}
  for i = 1, 2, 1 do
    local monsterSound = love.audio.newSource( "assets/sounds/FX/Growl" .. i .. ".wav", "static" )
    table.insert( monsterSounds, monsterSound )
  end
  
  deathSound = love.audio.newSource( "assets/sounds/FX/Death.wav", "static" )
  
end

function monsters:draw()
  w, h = handsBackImg:getDimensions()
  local dist = math.sqrt( (handsPtA.x-handsPtB.x)*(handsPtA.x-handsPtB.x) + (handsPtA.y-handsPtB.y)*(handsPtA.y-handsPtB.y) ) / w
  love.graphics.draw( handsBackImg, ( handsPtA.x + handsPtB.x )/2 - w/2*dist, ( handsPtB.y + handsPtA.y )/2 -h/2*dist, math.atan2( handsPtA.y-handsPtB.y, handsPtA.x-handsPtB.x ), dist , 0.9 )
  w, h = monster1Img:getDimensions()
  love.graphics.draw( monster1Img, offset1.x + mLoc1.x - w/2, offset1.y + mLoc1.y - h/2, offset1.r, offset1.sx + 0.9, offset1.sy + 0.9 )
  w, h = monster2Img:getDimensions()
  love.graphics.draw( monster2Img, offset2.x + mLoc2.x - w/2, offset2.y + mLoc2.y - h/2, offset2.r, offset2.sx + 0.9, offset2.sy + 0.9 )
  w, h = handsFrontImg:getDimensions()
  love.graphics.draw( handsFrontImg, ( handsPtA.x + handsPtB.x )/2 - w/2*dist , ( handsPtB.y + handsPtA.y )/2 -h/2*dist , math.atan2( handsPtA.y-handsPtB.y, handsPtA.x-handsPtB.x ), dist , 0.9 )
end

shockT1 = -1
shockT2 = -1

monsterBalance = 0
cahcedBalance = 0

function monsters.hit1()
  shockT2 = 0.6
  cahcedBalance = cahcedBalance + 50
  love.audio.play( monsterSounds[ love.math.random( 1, #monsterSounds ) ] )
end

function monsters.hit2()
  shockT1 = 0.6
  cahcedBalance = cahcedBalance - 50
  love.audio.play( monsterSounds[ love.math.random( 1, #monsterSounds ) ] )
end

timer = 0
shockScale = 25
shockAmpX = 5
shockAmpY = 5

function monsters:endgame( winerIndex )
  monsterBalance = 0;
  love.audio.play( deathSound )
end

function monsters:update(dt)
  timer = timer + dt;  
  
  monsterBalance = monsterBalance + cahcedBalance*dt*5
  cahcedBalance = cahcedBalance * ( 1 - dt*5 )
  
  if monsterBalance > 310 then
    monsters:endgame( 0 )
  elseif monsterBalance < -310 then
    monsters:endgame( 1 )
  end
  
  if monsterBalance > 250 or monsterBalance < -250 then
    musicManager:requestPlay( "cross", false )
    musicManager:requestPlay( "loopEnd", true )
  end
    
  
  offset1.x = math.sin( timer ) * 20 + monsterBalance
  offset2.x = math.sin( timer*0.76 ) * 20 + monsterBalance
  offset1.y = math.sin( timer*0.58 ) * 10
  offset2.y = math.sin( timer*0.8 ) * 10
  
  if shockT1 > 0 then
    shockT1 = shockT1 - dt
    offset1.x = offset1.x + math.sin( timer * shockScale )*shockAmpX
    offset1.y = offset1.y + math.cos( timer * shockScale )*shockAmpY
  end
  
  if shockT2 > 0 then
    shockT2 = shockT2 - dt
    offset2.x = offset2.x + math.sin( timer * shockScale )*shockAmpX
    offset2.y = offset2.y + math.cos( timer * shockScale )*shockAmpY
  end
  
  handsPtA.x = offset2.x + mLoc2.x + offsHA.x
  handsPtA.y = offset2.y + mLoc2.y + offsHA.y
  handsPtB.x = offset1.x + mLoc1.x + offsHB.x
  handsPtB.y = offset1.y + mLoc1.y + offsHB.y
end

