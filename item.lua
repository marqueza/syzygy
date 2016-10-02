local class = require "lib/middleclass"
require "itemsprite"
local itemInfo = require "item_info"
Item = class("Item", Enitity)

local id = 0
function Item:initialize(args)
   if type(args) == 'string' then
    local itemName = args
    args = itemInfo[itemName]
    assert(itemInfo[itemName], itemName .. " not found in item_info.lua.")
  end
  
  --Enitity.initialize(self, args.name, args.x, args.y)
  self.name = args.name or "VOID"
  self.x = args.x or 1
  self.y = args.y or 1
  self.sheetX = args.sheetX
  self.sheetY = args.sheetY
  self.sprite = ItemSprite("img/item.png", 64*self.x, 64*self.y, self.sheetX or 1, self.sheetY or 1)

  
  id = id + 1
  self.id = id
  
  self.sprite.actual_x = self.x*64
  self.sprite.actual_y = self.y*64
  self.sprite.grid_x = self.x*64
  self.sprite.grid_y = self.y*64
  
  self.onFloor = args.onFloor or true
end

function Item:place(x,y, zone)
  zone = zone or e.dungeon:getZone()
  self.x = x
  self.y = y
  self.sprite.actual_x = x*64
  self.sprite.actual_y = y*64
  self.sprite.grid_x = x*64
  self.sprite.grid_y = y*64
  zone:regItem(self)
end
function Item:draw()
  if self.onFloor then 
    self.sprite:draw()
  end
end

function Item:update(dt)
  self.sprite:update(dt)
end