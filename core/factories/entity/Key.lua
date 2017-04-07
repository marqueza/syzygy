local function Key(x, y)
	entity = Entity()
	entity:add(physics(x, y, 1, false))
	entity:add(sprite("img/sprites/key.png"))
	return entity
end
return Key
