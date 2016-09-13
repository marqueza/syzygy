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
  
  
  self.mapBatch = love.graphics.newSpriteBatch(self.mapImage, self.zone.width * self.zone.height)
  
  for x=1, self.zone.width do
    for y=1, self.zone.height do
      self.mapBatch:add(self.mapQuads[self.zone.map[x][y]], x*self.gridPixels, y*self.gridPixels)
    end
  end
  
  self.mapBatch:flush()
end

function MLayer:update(dt)
  --update player sprite
 
  --update all actors
  --update all items
  for i, item in ipairs(self.zone.items) do
    item.sprite:update(dt)
  end
  
  --update all features
  for i, feat in ipairs(self.zone.feats) do
    feat:update(dt)
  end
  
   self.player.sprite:update(dt)
end


function MLayer:draw()
  
  love.graphics.draw(self.mapBatch)
  
  ----draw dungeon features the zone
  for i, feat in ipairs(self.zone.feats) do
    feat:draw()
  end
  --draw all item in the zone
  for i, item in ipairs(self.zone.items) do
    item:draw()
  end
  
end

