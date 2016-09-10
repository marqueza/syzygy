local class = require "lib/middleclass"
ROT= require "/lib/rotLove"
require "zone"
require "player"
--
--this is the manager for the main display port
--

MLayer = class('MLayer')

function MLayer:initialize(player, zone)
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
  self.mapImage = love.graphics.newImage("img/tiles.png")
  
   -- grey floor
  self.mapQuads[0] = love.graphics.newQuad(0 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  -- stone wall
  self.mapQuads[1] = love.graphics.newQuad(1 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  -- door
  self.mapQuads[2] = love.graphics.newQuad(2 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  
end

--unlike items and mobs the map tiles are a unique case
--this preps mapBatch, and mapQuads (used determine which map tile to display for mapBatch)
function MLayer:drawMap()

  for x=1, self.zone.width do
    for y=1, self.zone.height do
      love.graphics.draw(self.mapImage, self.mapQuads[self.zone.map[x][y]], x*self.gridPixels, y*self.gridPixels)
    end
  end
  
end

function MLayer:update(dt)
  --update player sprite
  self.player.sprite:update(dt)
  --update all actors
  --update all items
  for i, item in ipairs(self.zone.items) do
    item.sprite:update(dt)
  end
end

function MLayer:draw()
  self:drawMap()
  --love.graphics.draw(self.mapImage)
  self.player:draw()
  
  --draw all item in the zone
  for i, item in ipairs(self.zone.items) do
    item:draw()
  end
end

