require 'engine'
local Camera = require 'lib.hump.camera'

local e
local camera
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  e = Engine()
  camera = Camera(e.player.sprite.grid_x, e.player.sprite.grid_y)
  camera.smoother = Camera.smooth.linear(10000)
end

function love.update(dt)
  local sX, sY = e.player.sprite.grid_x, e.player.sprite.grid_y
  local cX, cY = camera:cameraCoords(sX, sY)
  
  if cX >= screenWidth-32 or cX <= 32 then
    camera.x = sX
  end
  if cY >= screenHeight-48 or cY <=48 then
    camera.y = sY
  end
  e.viewport:update(dt)
  
end

function love.draw()
  camera:attach() 
  e.viewport:draw()
  camera:detach()
  love.graphics.print("playerX "..e.player.x, 10, 40)
  love.graphics.print("playerY "..e.player.y, 10, 50)
  love.graphics.print("playerSpriteX "..e.player.sprite.grid_x, 10, 60)
  love.graphics.print("playerSpriteY "..e.player.sprite.grid_y, 10, 70)
  local pscX, pscY = camera:cameraCoords(e.player.sprite.grid_x, e.player.sprite.grid_y)
  love.graphics.print("playerSpriteXCam"..pscX, 10, 80)
  love.graphics.print("playerSpriteYCam"..pscY, 10, 90)
  --draw player sprite
end

  
function love.keypressed(key)
  
    if key == '-' then
      camera:zoom(.5)
    elseif key == '=' then
      camera:zoom(2)
    end
    
    
    local dx,dy = 0,0
    
    if     key=='kp1' then dx,dy=-1, 1
    elseif key=='kp2' then dx,dy= 0, 1
    elseif key=='kp3' then dx,dy= 1, 1
    elseif key=='kp4' then dx,dy=-1, 0
    elseif key=='kp5' then dx,dy= 0, 0
    elseif key=='kp6' then dx,dy= 1, 0
    elseif key=='kp7' then dx,dy=-1,-1
    elseif key=='kp8' then dx,dy= 0,-1
    elseif key=='kp9' then dx,dy= 1,-1
    end

    e:movePlayer(dx,dy)
    
end
