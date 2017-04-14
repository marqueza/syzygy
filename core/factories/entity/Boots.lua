local function Boots(x, y)
	entity = Entity()
	entity:add(Physics(x, y, 1, false))
	entity:add(Sprite("img/sprites/boots.png"))
	return entity
end
return Boots
