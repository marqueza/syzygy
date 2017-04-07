local function Spear(x, y)
	entity = Entity()
	entity:add(physics(x, y, 1, false))
	entity:add(sprite("img/sprites/spear.png"))
	return entity
end
return Spear
