local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local components = require "core.components.components"
local events = require "core.events.events"

local SpellSystem = class("SpellSystem", lovetoys.System)

function SpellSystem:initialize()
  lovetoys.System.initialize(self)
  self.name = "SpellSystem"
end

function SpellSystem:onSpellLearn(spellLearnEvent)
  local learner = systems.getEntityById(spellLearnEvent.learnerId)
  if not learner.Spells then
    learner:add(components.Spells())
  end
  table.insert(learner.Spells.names, spellLearnEvent.spellName)
  events.fireEvent(events.LogEvent{text="You learn "..spellLearnEvent.spellName})
  events.fireEvent(events.TurnEvent{})
end

function SpellSystem:onSpellCast(spellCastEvent)
  events.fireEvent(events.LogEvent{text="You cast "..spellCastEvent.spellName})
  local caster = systems.getEntityById(spellCastEvent.casterId)
  --take party to overworld
  if string.lower(spellCastEvent.spellName) == "return" then

    local travelerIds
    if caster.Party then 
      travelerIds=systems.partySystem.getMemberIds(caster)
    else
      travelerIds = {caster.id}
    end
    events.fireEvent(events.LevelEvent{
        levelName="overWorld", 
        levelSeed=0,
        levelDepth=0,
        options={},
        travelerIds=travelerIds})
  end
end

function SpellSystem:onSpellDisplay(spellDisplayEvent)
    local caster = systems.getEntityById(spellDisplayEvent.casterId)
    if caster == nil then 
      return
    end
    if caster.Spells == nil then
        caster:add(components.Spells({}))
    end
    events.fireEvent(events.MenuDisplayEvent{
        type="string",
        choices=caster.Spells.names,
        title="Cast spell",
        resultKey="spellName",
        resultEvent=events.SpellCastEvent,
        resultEventArgs={casterId=caster.id},
    })
end
return SpellSystem
