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
  self.mapQuads['floor'] = love.graphics.newQuad(0 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  -- stone wall
  self.mapQuads['wall'] = love.graphics.newQuad(1 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  -- door
  self.mapQuads['door'] = love.graphics.newQuad(2 * self.gridPixels, 0 * self.gridPixels, self.gridPixels, self.gridPixels,
    self.mapImage:getWidth(), self.mapImage:getHeight())
  
  
  self.mapBatch = love.graphics.newSpriteBatch(self.mapImage, self.zone.width * self.zone.height)
  
  for x=1, self.zone.width do
    for y=1, self.zone.height do
      if self.zone.seen[x][y] == 1 then
        self.mapBatch:add(self.mapQuads[self.zone.map[x][y].tile], x*self.gridPixels, y*self.gridPixels)
      end
    end
  end
  
  self.mapBatch:flush()
end

function MLayer:updateMapBatch()
  self.mapBatch:clear()
  for x=1, self.zone.width do
    for y=1, self.zone.height do
      if self.zone.seen[x][y] == 1 then
        if self.zone.field[x][y] == 1 then
          self.mapBatch:setColor(255,255,255) --default
        else
          self.mapBatch:setColor(100,100,100) --greyed
        end
         
         self.mapBatch:add(self.mapQuads[self.zone.map[x][y].tile], x*self.gridPixels, y*self.gridPixels)

      end
    end
  end
  self.mapBatch:flush()
end

function MLayer:update(dt)
  --update mapBatch
  self:updateMapBatch()
  
  --update all items
  for i, item in ipairs(self.zone.items) do
    item:update(dt)
  end
  
  --update all features
  for i, feat in ipairs(self.zone.feats) do
    feat:update(dt)
  end
  
  --update all mobs
  for i, mob in ipairs(self.zone.mobs) do
    mob:update(dt)
  end
  
  --update player
  self.player.sprite:update(dt)
end


function MLayer:draw()
  
  love.graphics.draw(self.mapBatch)
  
  ----draw all seen dungeon features
  for i, feat in ipairs(self.zone.feats) do
    if self.zone.seen[feat.x][feat.y] == 1 then
      if self.zone.field[feat.x][feat.y] == 1 then
        feat.sprite:setColor(255,255,255) --default
      else
        feat.sprite:setColor(100,100,100) --greyed
      end
    feat:draw()
    end
  end
  
  --draw all seen items
  for i, item in ipairs(self.zone.items) do
    if self.zone.seen[item.x][item.y] == 1 then
      if self.zone.field[item.x][item.y] == 1 then
        item.sprite:setColor(255,255,255) --default
      else
        item.sprite:setColor(100,100,100) --greyed
      end
      item:draw()
    end
  end
  
  --draw all mobs in fov
  for i, mob in ipairs(self.zone.mobs) do
    if self.zone.field[mob.x] and self.zone.field[mob.x][mob.y] then
      if self.zone.field[mob.x][mob.y] == 1 then
        mob:draw()
      end
    end
  end

end

