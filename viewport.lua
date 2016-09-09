local class = require "lib/middleclass"
ROT= require "/lib/rotLove"
require "zone"

--
--this is the manager for the main display port
--

Viewport = class('Viewport')

function Viewport:initialize(player, zone)
  self.player = player
  self.zone = zone
  
  --position in top left corner
  self.x = 1
  self.y = 1
  
  --a grids are 64x64 px
  self.gridPixels = 64
  
  --size in term of the grid
  --also number of tiles to show
  self.width = 13 
  self.height = 10
  
  self.mapQuads = {}
  self.mapImage = love.graphics.newImage("img/" .. self.zone.name .. ".png")
  
   -- grey floor
  self.mapQuads[0] = love.graphics.newQuad(3 * self.gridPixels, 9 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  -- stone wall
  self.mapQuads[1] = love.graphics.newQuad(8 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  
end

--unlike items and mobs the map tiles are a unique case
--this preps mapBatch, and mapQuads (used determine which map tile to display for mapBatch)
function Viewport:drawMap()

  for x=1, self.zone.width do
    for y=1, self.zone.height do
      love.graphics.draw(self.mapImage, self.mapQuads[self.zone.map[x][y]], x*self.gridPixels, y*self.gridPixels)
    end
  end
  
end

function Viewport:update(dt)
  --update player sprite
  self.player.sprite:update(dt)
  --update all actors
  --update any item movement
end

function Viewport:draw()
  self:drawMap()
  --love.graphics.draw(self.mapImage)
  self.player.sprite:draw()
end

