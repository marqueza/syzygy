
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
end

return Arena