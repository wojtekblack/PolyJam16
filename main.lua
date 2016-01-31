require "assets/scripts/world"
require "assets/scripts/player"
require "assets/scripts/collectable"
require "assets/scripts/ui"
require "assets/scripts/animation"
require "assets/scripts/monsters"

function love.load()
  love.window.setMode( 1024, 800 )
  
  world:load()
	player.load()
  collectable.load()
  monsters.load()
  
	player.newPlayer( { x = 100, y = 100 }, { x = 300, y = -500 }, 1 )
	player.newPlayer( { x = 800, y = 100 }, { x = 300, y = -500 }, 2 )
end

function love.update( dt )
	player.update(dt)
  collectable.update(dt)
  world:update(dt)
  monsters:update(dt)
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
  monsters.draw()
end