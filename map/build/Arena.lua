
local function Arena(length, width) 
    length = length or 10
    width = width or 7
    for i=1,length do
        for j=1,width do
            if i == 1 or i == length or j == 1 or j == width then
                engine:addEntity(Factory.Wall(i, j))
            else
                engine:addEntity(Factory.Floor(i, j))
            end
        end
    end
	engine:addEntity(Factory.Goo(2,2))
	engine:addEntity(Factory.Fairy(3,2))
	engine:addEntity(Factory.Ghost(4,2))
	engine:addEntity(Factory.Kobold(5,2))
	engine:addEntity(Factory.Orc(6,2))
	engine:addEntity(Factory.Angel(7,2))
	engine:addEntity(Factory.Skeleton(8,2))
	engine:addEntity(Factory.Zombie(9,2))
	engine:addEntity(Factory.Goblin(2,3))
	engine:addEntity(Factory.Golem(2,4))

	engine:addEntity(Factory.Dust(2,6))
	engine:addEntity(Factory.Key(3,6))
	engine:addEntity(Factory.Heart(4,6))
	engine:addEntity(Factory.Goop(5,6))
	engine:addEntity(Factory.Sword(6,6))
	engine:addEntity(Factory.Mail(7,6))
	engine:addEntity(Factory.Boots(8,6))
	engine:addEntity(Factory.Spear(9,6))
end

return Arena
