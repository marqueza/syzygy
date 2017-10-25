local lovetoys = require "lib.lovetoys.lovetoys"
local function Scroll(args)
	entity = lovetoys.Entity()
	entity.name = "Scroll of " .. args.spellName
	entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
	entity:add(Sprite{filename="img/sprites/scroll.png"})
	entity:add(Stack{amount=args.amount})
	entity:add(
	Use{
		eventName="SpellCastEvent",
		eventArgs={
			spellName = args.spellName
		},
		userIdArg="casterId",
		consumeable=true
	}
)
return entity
end
return Scroll
