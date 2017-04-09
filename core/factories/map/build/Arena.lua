local Factory = require("core/factories/entity/EntityFactory")
local function Arena(entityCallback, length, width)
    length = length or 10
    width = width or 7
    for i=1,length do
        for j=1,width do
            if i == 1 or i == length or j == 1 or j == width then
                entityCallback(Factory.Wall(i, j))
            else
                entityCallback(Factory.Floor(i, j))
            end
        end
    end
	entityCallback(Factory.Orc(4,2))
	entityCallback(Factory.Golem(2,4))
    --set player
    game.player = Factory.Player(3,3)
    entityCallback(game.player)
end

return Arena
