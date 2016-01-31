--require('mobdebug').start()

require "assets/scripts/world"
require "assets/scripts/player"
require "assets/scripts/collectable"
require "assets/scripts/ui"
require "assets/scripts/animation"
require "assets/scripts/monsters"
require "assets/scripts/musicManager"

function love.load()
  love.window.setMode( 1024, 800 )
  
  world:load()
	player.load()
  collectable.load()
  monsters.load()
  musicManager:load()
  ui:load()
  
	player.newPlayer( { x = 100, y = 100 }, { x = 300, y = -500 }, 2 )
	player.newPlayer( { x = 800, y = 100 }, { x = 300, y = -500 }, 1 )
end

function love.update( dt )
	player.update(dt)
  collectable.update(dt)
  world:update(dt)
  monsters:update(dt)
  musicManager:update(dt)
end

function love.joystickpressed(joystick,button)
  player.handleJoystickPressed( joystick )
end

function love.keypressed(key, scancode, isRepeat)
  player.handleKeyboardPressed( key, scancode, isRepeat )
end

function love.draw()
  world:draw()
	player.draw()
  collectable.draw()
  ui.draw()
end