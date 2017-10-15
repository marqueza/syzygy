local lovetoys = require "lib.lovetoys.lovetoys"
local Key = require "core.factories.entity.Key"
local systems = require "core.systems.systems"
local function Golem(args)
	local entity = lovetoys.Entity()
	entity.name = "Golem"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=10, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/golem.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  
  
  local key = Key{x=-1, y=-1, plane=args.plane}
  systems.addEntity(key)
  entity:add(Inventory{itemIds={key.id}})
	return entity
end
return Golem
