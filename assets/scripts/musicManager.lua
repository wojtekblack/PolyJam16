musicManager = {
  musicSources = {},
  requestQueue = {},
  lastTime = love.timer.getTime()
}

function musicManager:load()
  local musicFiles = {
    { "loopStart", "assets/sounds/LoopStart.wav" },
    { "cross", "assets/sounds/Cross.wav" },
    { "loopEnd", "assets/sounds/LoopEnd.wav" },
    { "choir", "assets/sounds/Choir.wav" }
  }
  
  for _, nameFilePair in pairs(musicFiles) do
    local newSoundSource = love.audio.newSource( nameFilePair[2], "static" )
    table.insert( self.musicSources, { nameFilePair[1], newSoundSource } )
  end
  
  self:requestPlay( "loopStart", true )

end

function musicManager:requestPlay( clipName, isLooped )
  local clipSource
  for _, nameSourcePair in pairs( self.musicSources ) do
    if nameSourcePair[1] == clipName then
      clipSource = nameSourcePair[2]
      clipSource:setLooping( isLooped )
      break
    end
  end
  
  if clipSource ~= nil then
    table.insert( self.requestQueue, clipSource )
  end
end

function musicManager:playNext()
  if #self.requestQueue > 0 then
    if self.currentClip ~= nil then
      self.currentClip:stop()
    end
    self.currentClip = self.requestQueue[1]
    table.remove( self.requestQueue, 1 )
    love.audio.play( self.currentClip )
  end
end

function musicManager:update( dt )
  if self.currentClip == nil then
    self:playNext()
  end
  
  local currentTime = love.timer.getTime()
  local duration = self.currentClip:getDuration( "seconds" )
  if currentTime - self.lastTime >= duration then
    if #self.requestQueue ~= 0 then
      self:playNext()
    end
    self.lastTime = currentTime
  end

end