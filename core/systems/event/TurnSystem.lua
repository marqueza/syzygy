local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local systems = require "core.systems.systems"
local TurnSystem = class("TurnSystem", System)
TurnSystem:include(Serializable)

function TurnSystem:initialize()
    self.name = "TurnSystem"
    self.turn = 1
end

function TurnSystem:onNotify(TurnEvent)
    self.turn = self.turn+1

    --regenerate those who can
    if self.turn % 10 == 0 then
        for index, entity in pairs(systems.getEntitiesWithComponent("Stats")) do
            if entity.Stats.hp < entity.Stats.maxHp then
                entity.Stats.hp = entity.Stats.hp+math.floor(entity.Stats.con/4)+1
            end
        end
    end
    
    
end

function TurnSystem:passTurns(turnAmount)
    for i=1,turnAmount do
        events.fireEvent(TurnEvent())
    end

end

return TurnSystem
