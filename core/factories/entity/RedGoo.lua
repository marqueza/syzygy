local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local Heart = require "core.factories.entity.Heart"

local function RedGoo(args)
	local entity = lovetoys.Entity()
	entity.name = "Red Goo"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=40, str=3, dex=1, con=3})
	entity:add(Sprite{filename="img/sprites/red_goo.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  
  local heart = Heart{x=-1, y=-1, plane=args.plane}
  systems.addEntity(heart)
  entity:add(Inventory{itemIds={heart.id}})
  
	return entity
end

return RedGoo

