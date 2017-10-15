local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local Goop = require "core.factories.entity.Goop"

local function Goo(args)
	local entity = lovetoys.Entity()
	entity.name = "Goo"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=5, str=1, dex=1, con=1})
	entity:add(Sprite{filename="img/sprites/goo.png"})
	entity:add(Faction{name="hostile"})
  
  --items
  local goop = Goop{x=-1, y=-1, plane=args.plane}
    systems.addEntity(goop)
    entity:add(Inventory{itemIds={goop.id}})
	return entity
end
return Goo
