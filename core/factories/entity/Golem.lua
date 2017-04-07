local function Golem(x, y)
	entity = Entity()
	entity.name = "golem"
	entity:add(physics{x=x, y=y, hp=10, blocks=true})
	entity:add(sprite("img/sprites/golem.png"))
	entity:add(faction("hostile"))
	return entity
end
return Golem
