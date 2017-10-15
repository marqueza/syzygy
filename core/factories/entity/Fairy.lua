local lovetoys = require "lib.lovetoys.lovetoys"
local systems = require "core.systems.systems"
local Dust= require "core.factories.entity.Dust"
local function Fairy(args)
	local entity = lovetoys.Entity()
	entity.name = "fairy"
	entity:add(Physics{x=args.x, y=args.y, blocks=true, layer="creature", plane=args.plane})
  entity:add(Stats{hp=2, str=1, dex=2, con=1})
	entity:add(Sprite{filename="img/sprites/fairy.png"})
	entity:add(Faction{name="hostile"})
  entity:add(Ai{combatPreference="melee", idle="still", objective="kill"})
  entity:add(Recruit{desire="Bell", amount=1})
  
  --chance of holding dust
  if math.random(1, 4) == 1 then 
    local dust = Dust{x=-1, y=-1, plane=args.plane}
    systems.addEntity(dust)
    entity:add(Inventory{itemIds={dust.id}})
  end
	return entity
end
return Fairy
