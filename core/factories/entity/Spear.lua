local function Spear(x, y)
	entity = Entity()
	entity:add(Physics(x, y, 1, false))
	entity:add(Sprite("img/sprites/spear.png"))
	return entity
end
return Spear
