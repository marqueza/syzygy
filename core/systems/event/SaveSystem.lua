local class = require "lib.middleclass"
local events = require "core.events.events"

local SaveSystem = class("SaveSystem", System)

function SaveSystem:initialize()
    self.name = "SaveSystem"
end

function SaveSystem:onNotify(SaveEvent)
    f = love.filesystem.newFile("save.txt")
    f:open("w")
    for index, entity in pairs(systems.getEntitiesWithComponent("physics")) do
        --write to file
        for k, v in pairs(entity.components) do
            f:write(entity.id .. " " .. v:toString() .. "\n")
        end
        f:write("\n")
    end
    f:close()
end

return SaveSystem
