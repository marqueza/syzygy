local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"

local KeyPressSystem = class("KeyPressSystem", System)

function KeyPressSystem:initialize()
  self.name = "KeyPressSystem"
end

function KeyPressSystem:onNotify(KeyPressEvent)
  local state = systems.stateSystem:getState()
  if state == "command" then
    self:doCommandKey(KeyPressEvent)
  elseif state == "focus" then
    self:doFocusKey(KeyPressEvent)
  elseif state == "menu" then
    events.fireEvent(events.MenuCommandEvent{key=KeyPressEvent.key})
  end
end

function KeyPressSystem:doFocusKey(KeyPressEvent)
  if KeyPressEvent.key == "up" then
    events.fireEvent(events.FocusEvent{dx=0, dy=-1})
  elseif KeyPressEvent.key == "down" then
    events.fireEvent(events.FocusEvent{dx=0, dy=1})
  elseif KeyPressEvent.key == "left" then
    events.fireEvent(events.FocusEvent{dx=-1, dy=0})
  elseif KeyPressEvent.key == "right" then
    events.fireEvent(events.FocusEvent{dx=1, dy=0})
  elseif KeyPressEvent.key == '.' or
  KeyPressEvent.key == "return" or
  KeyPressEvent.key == "l" then
    events.fireEvent(events.FocusEvent{unfocus=true})
    events.fireEvent(events.StateEvent{state="command"})
  end
end
function KeyPressSystem:doCommandKey(KeyPressEvent)
  if KeyPressEvent.key == "up" or KeyPressEvent.key == "kp8" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x,
            y=Physics.y-1
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "down" or KeyPressEvent.key == "kp2" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x,
            y=Physics.y+1
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "right" or KeyPressEvent.key == "kp6" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x+1,
            y=Physics.y
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "left" or KeyPressEvent.key == "kp4" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x-1,
            y=Physics.y
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "kp9" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x+1,
            y=Physics.y-1
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "kp7" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x-1,
            y=Physics.y-1
          }))
      events.fireEvent(events.TurnEvent())
    end
  elseif KeyPressEvent.key == "kp3" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x+1,
            y=Physics.y+1
          }))
      events.fireEvent(events.TurnEvent())
    end 
  elseif KeyPressEvent.key == "kp1" then
    for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
      local Physics = entity:get("Physics")
      events.fireEvent(events.MoveEvent( {
            moverId=entity.id,
            x=Physics.x-1,
            y=Physics.y+1
          }))
      events.fireEvent(events.TurnEvent())
    end 
  elseif KeyPressEvent.key == "s" then
    events.fireEvent(events.SaveEvent())
  elseif KeyPressEvent.key == "l" and (
    love.keyboard.isDown("lshift") or
    love.keyboard.isDown("rshift")) then
    events.fireEvent(events.LoadEvent())
  elseif KeyPressEvent.key == "r" then
    events.fireEvent(events.ReplayEvent())
  elseif KeyPressEvent.key == "q" then
    events.fireEvent(events.ToggleRecordingEvent())
  elseif KeyPressEvent.key == "l" then
    events.fireEvent(events.StateEvent{state="focus"})
    events.fireEvent(events.FocusEvent{dx=0, dy=0})
  elseif KeyPressEvent.key == "," then
    --go upstairs
    if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
      for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
        game.player = entity
      end
      for index, entrance in pairs(systems.getEntitiesWithComponent("Entrance")) do
        if entrance.Physics.x == game.player.Physics.x and
        entrance.Physics.y == game.player.Physics.y and
        entrance.Entrance.commandKey == "<" then
          events.fireEvent(events.LevelEvent{
              levelName=entrance.Entrance.levelName, 
              entranceId=entrance.id,
              options={depthDelta=-1},
              travelerIds={game.player.id}})
          break
        end
      end
    end
  elseif KeyPressEvent.key == "." then
    --go downstairs
    if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
      for index, entity in pairs(systems.getEntitiesWithComponent("Control")) do
        game.player = entity
      end
      for index, entrance in pairs(systems.getEntitiesWithComponent("Entrance")) do
        if entrance.Physics.x == game.player.Physics.x and
        entrance.Physics.y == game.player.Physics.y and
        entrance.Entrance.commandKey == ">" then
          events.fireEvent(events.LevelEvent{
              levelName=entrance.Entrance.levelName, 
              entranceId=entrance.id,
              options={depthDelta=1},
              travelerIds={game.player.id}})
          break
        end
      end
    else
      events.fireEvent(events.TurnEvent())
      if game.player then
        if game.player.Physics.hp < game.player.Physics.maxHp then
          game.player.Physics.hp = game.player.Physics.hp+5
          if game.player.Physics.hp > game.player.Physics.maxHp then
            game.player.Physics.hp = game.player.Physics.maxHp
          end
        end
      end
    end
  elseif KeyPressEvent.key == "t" then
    events.fireEvent(events.SpawnEvent{name="Ghost", x=1,y=1, game.player.Physics.plane})
    local unit = systems.getLastEntity()
    events.fireEvent(events.ReservesEnterEvent{entityId=unit.id})
    assert(unit:has("Reserve"))
  elseif KeyPressEvent.key == "m" then
    events.fireEvent(events.MissionUnitEvent{})
  elseif KeyPressEvent.key == "p" then
    events.fireEvent(events.StockDisplayEvent{})
  elseif KeyPressEvent.key == "h" then
    events.fireEvent(events.HireBrowseEvent{})
  elseif KeyPressEvent.key == "g" then
    local item = systems.planeSystem:getTopEntity(game.player.Physics.x, game.player.Physics.y, "item", game.player.Physics.plane)
    if item then
      events.fireEvent(events.InventoryEnterEvent{
          itemId=item.id,
          holderId=game.player.id
      })
    end
  elseif KeyPressEvent.key == "d" then
    events.fireEvent(events.InventoryDisplayEvent{
        holderId=game.player.id
      })
  elseif KeyPressEvent.key == "v" then
    for index, resourceEntity in pairs(systems.getEntitiesWithComponent("Harvest")) do
        if resourceEntity.Physics.x == game.player.Physics.x and
        resourceEntity.Physics.y == game.player.Physics.y then
        events.fireEvent(events.HarvestEvent{
            entityId=resourceEntity.id
          })
          break
        end
      end
  end

end

return KeyPressSystem
