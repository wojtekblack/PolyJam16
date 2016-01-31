
function newAnimation( spriteSheetPath, animationData )
  
  local spriteSheet = love.graphics.newImage( spriteSheetPath )
  
  local animation = {
    spriteSheet = spriteSheet,
    currentCell = 0,
    cellQuads = {},
    cellWidth = animationData.cellWidth,
    nCells = math.floor( spriteSheet:getWidth() / animationData.cellWidth ),
    cellSwapTime = animationData.cellSwapTime,
    lastTime = 0
  }
  
  for i = 0, animation.nCells - 1, 1 do
    table.insert( animation.cellQuads, i, 
      love.graphics.newQuad( i * animation.cellWidth, 0, animation.cellWidth, animation.spriteSheet:getHeight(), animation.spriteSheet:getDimensions() )
    )
  end
  
  function animation:getCellDimensions()
    return self.cellWidth, self.spriteSheet:getHeight()
  end
  
  function animation:getNextCell()
    if self.currentCell == self.nCells - 1 then
      self.currentCell = 0
    else
      self.currentCell = self.currentCell + 1
    end
  end
  
  function animation:draw( position )
    love.graphics.draw( self.spriteSheet, self.cellQuads[ self.currentCell ], position.x, position.y )
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