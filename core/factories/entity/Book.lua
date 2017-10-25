local lovetoys = require "lib.lovetoys.lovetoys"
local function Book(args)
	entity = lovetoys.Entity()
	entity.name = "Book Of " .. args.spellName
  entity:add(Physics{x=args.x, y=args.y, blocks=false, layer="item", plane=args.plane})
  entity:add(Sprite{filename="img/sprites/book.png"})
	entity:add(Stack{amount=args.amount})
  entity:add(
    Use{
      eventName="SpellLearnEvent",
      eventArgs={
        spellName = args.spellName
      },
      userIdArg="learnerId",
      consumeable=false
	  }
    )
	return entity
end
return Book
