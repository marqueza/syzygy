local function Sword(x, y)
	entity = Entity()
	entity:add(Physics(x, y))
	entity:add(Sprite("img/sprites/sword.png"))
	return entity
end
return Sword
