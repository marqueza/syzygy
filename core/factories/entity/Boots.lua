local function Boots(x, y)
	entity = Entity()
	entity:add(physics(x, y, 1, false))
	entity:add(sprite("img/sprites/boots.png"))
	return entity
end
return Boots
