local function Player(x, y)
	entity = Entity()
	entity:add(physics(x,y))
	entity.name = "player"
	entity:add(faction("ally"))
	entity:add(sprite("img/sprites/human.png"))
	entity:add(control())
	return entity
end
return Player
