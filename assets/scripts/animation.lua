
function newAnimation( spriteSheetPath, animationData )
  
  local spriteSheet = love.graphics.newImage( spriteSheetPath )
  
  local animation = {
    spriteSheet = spriteSheet,
    currentCell = 0,
    cellQuads = {},
    cellWidth = animationData.cellWidth,
    cellScale = animationData.cellScale,
    cellFrom = animationData.from, 
    cellTo = animationData.to,
    cellSwapTime = animationData.cellSwapTime,
    lastTime = 0
  }
  
  for i = 0, animationData.to - animationData.from, 1 do
    table.insert( animation.cellQuads, i, 
      love.graphics.newQuad( ( i + animation.cellFrom ) * animation.cellWidth, 0, animation.cellWidth, animation.spriteSheet:getHeight(), animation.spriteSheet:getDimensions() )
    )
  end
  
  function animation:getCellDimensions()
    return self.cellWidth * self.cellScale[1], self.spriteSheet:getHeight() * self.cellScale[2]
  end
  
  function animation:getNextCell()
    if self.cellTo - self.cellFrom == 0 then
      return
    end
    
    if self.currentCell == self.cellTo - self.cellFrom - 1 then
      self.currentCell = 0
    else
      self.currentCell = self.currentCell + 1
    end
  end
  
  function animation:draw( position )
    love.graphics.draw( self.spriteSheet, self.cellQuads[ self.currentCell ], position.x, position.y, 0, self.cellScale[1], self.cellScale[2] )
  end
  
  function animation:update( dt )
    local currentTime = love.timer.getTime()
    if currentTime - self.lastTime >= self.cellSwapTime then
      self:getNextCell()
      self.lastTime = currentTime
    end
  end
  
  return animation
end