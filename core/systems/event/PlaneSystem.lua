local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local serializer = require "data.serializer"

local PlaneSystem = class("PlaneSystem", lovetoys.System)

function PlaneSystem:initialize()
    lovetoys.System.initialize(self)
    self.layers = {}
end

function PlaneSystem:addToLayer(entity)
  assert(entity.Physics.layer, "This entity needs a layer variable in Physics ->"..entity.id)
  if not self.layers[entity.Physics.layer] then
    self.layers[entity.Physics.layer] = {}
  end
  if not self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] then
    self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] = {}
  end
  assert(entity.id)
  if entity.name == "overlord" then
   print ("woah") 
  end
  self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y][entity.id] = entity
end

function PlaneSystem:removeFromLayer(entity)
  assert (self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] ~= nil,
    "An entity moved without using the plane system knowing: "..serializer.entityToString(entity))
  self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y][entity.id] = nil
  if next(self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y]) == nil then
    self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] = nil
  end
end

function PlaneSystem:reposition(entity, newX, newY)
  if self.layers[entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] then
    self:removeFromLayer(entity)
  end
  entity.Physics.x = newX
  entity.Physics.y = newY
  self:addToLayer(entity)
end

function PlaneSystem:getTopEntity(x,y,layerName)
  if layerName ~= nil then
    if self.layers[layerName] == nil then
      return nil
    else
      if self.layers[layerName][x..','..y] then
        for i, v in pairs(self.layers[layerName][x..','..y]) do
          return v
        end
      end
    end
  else
    if self.layers["creature"] and self.layers["creature"][x..','..y] then
      for i, v in pairs(self.layers["creature"][x..','..y]) do
        return v
      end
    elseif self.layers["item"] and self.layers["item"][x..','..y] then
      for i, v in pairs(self.layers["item"][x..','..y]) do
        return v
      end
    elseif self.layers["backdrop"] and self.layers["backdrop"][x..','..y] then
      for i, v in pairs(self.layers["backdrop"][x..','..y]) do
        return v
      end
    elseif self.layers["floor"] and self.layers["floor"][x..','..y] then
      for i, v in pairs(self.layers["floor"][x..','..y]) do
        return v
      end
    end
  end
end

return PlaneSystem