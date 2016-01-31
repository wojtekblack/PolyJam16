musicManager = {
  musicSources = {},
  requestQueue = {},
  lastTime = 0
}

function musicManager:load()
  local musicFiles = {
    { "loopStart", "assets/sounds/LoopStart.wav" },
    { "cross", "assets/sounds/Cross.wav" },
    { "loopEnd", "assets/sounds/LoopEnd.wav" },
    { "choir", "assets/sounds/Choir.wav" }
  }
  
  for _, nameFilePair in pairs(musicFiles) do
    local newSoundSource = love.audio.newSource( nameFilePair[2], "stream" )
    table.insert( self.musicSources, { nameFilePair[1], newSoundSource } )
  end
  
  --self:requestPlay( "loopStart", true )
  self:requestPlay( "loopEnd", true )

end

function musicManager:requestPlay( clipName, isLooped )
  local clipSource
  for _, nameSourcePair in pairs( self.musicSources ) do
    if nameSourcePair[1] == clipName then
      clipSource = nameSourcePair[2]
      break
    end
  end
  
  if clipSource ~= nil then
    table.insert( self.requestQueue, { clipSource, isLooped } )
  end
end

function musicManager:playNext()
  if #self.requestQueue > 0 then
    self.currentClip = self.requestQueue[1]
    table.remove( self.requestQueue, 1 )
    love.audio.play( self.currentClip[1] )
  end
end

function musicManager:update( dt )
  if self.currentClip == nil then
    self:playNext()
  end
  
  local currentTime = love.timer.getTime()
  if currentTime - self.lastTime >= self.currentClip[1]:getDuration( "seconds" ) then
    if #self.requestQueue == 0 and self.currentClip[2] then --isLooped
      self.currentClip[1]:rewind()
    else
      self:playNext()
    end
    self.lastTime = currentTime
  end

end