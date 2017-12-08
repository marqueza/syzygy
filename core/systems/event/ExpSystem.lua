local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"

local ExpSystem = class("ExpSystem", lovetoys.System)

function ExpSystem:initialize()
    self.name = "ExpSystem"
end

function ExpSystem:gainExp(entity, amount)
  assert(entity.Stats, "Entity" .. entity.name .. "" .. entity.id .."is missing the Stats component")
  local prevLevel = self:getLevel(entity)
  entity.Stats.exp = entity.Stats.exp+amount
  if self:getLevel(entity)>prevLevel then
    --gain health
    entity.Stats.maxHp = entity.Stats.maxHp + entity.Stats.con * 5
    entity.Stats.hp = entity.Stats.maxHp
  end
end

function ExpSystem:getLevel(entity) 
  return math.round(math.sqrt(entity.Stats.exp)/4)
end
return ExpSystem
