local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"

local PlaneSystem = class("PlaneSystem", lovetoys.System)

function PlaneSystem:initialize()
  lovetoys.System.initialize(self)
  self.planes = {}
end

function PlaneSystem:addToLayer(entity)
  assert(entity.Physics.layer, "This entity needs a layer variable in Physics ->"..entity.id)
  assert(entity.Physics.plane, "This entity needs a plane variable in Physics ->"..entity.id)
  if not self.planes[entity.Physics.plane] then 
    self.planes[entity.Physics.plane] = {}
  end
  if not self.planes[entity.Physics.plane][entity.Physics.layer] then
    self.planes[entity.Physics.plane][entity.Physics.layer]  = {}
  end
  if not self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] then
    self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] = {}
  end
  assert(entity.id)
  self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y][entity.id] = entity
end

function PlaneSystem:setFloorSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["structure"] then
    self.planes[planeName]["structure"]  = {}
  end
  self.planes[planeName]["structure"][x .. ',' .. y] = true
end

function PlaneSystem:isFloorSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["structure"] then
    self.planes[planeName]["structure"]  = {}
  end
  return self.planes[planeName]["structure"][x .. ',' .. y]
end

function PlaneSystem:setVisibleSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["visible"] then
    self.planes[planeName]["visible"]  = {}
  end
  self.planes[planeName]["visible"][x .. ',' .. y] = true
end

function PlaneSystem:isVisibleSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["visible"] then
    self.planes[planeName]["visible"]  = {}
  end
  return self.planes[planeName]["visible"][x .. ',' .. y]
end

function PlaneSystem:clearVisible(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
    self.planes[planeName]["visible"]  = {}
end

function PlaneSystem:setKnownSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["known"] then
    self.planes[planeName]["known"]  = {}
  end
  self.planes[planeName]["known"][x .. ',' .. y] = true
end

function PlaneSystem:isKnownSpace(x, y, planeName)
  if not self.planes[planeName] then 
    self.planes[planeName] = {}
  end
  if not self.planes[planeName]["known"] then
    self.planes[planeName]["known"]  = {}
  end
  return self.planes[planeName]["known"][x .. ',' .. y]
end

function PlaneSystem:removeFromLayer(entity)
  assert (self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] ~= nil,
    "An entity moved without using the plane system knowing: "..entity:toString())
  self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y][entity.id] = nil
  if next(self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y]) == nil then
    self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] = nil
  end
  if next(self.planes[entity.Physics.plane][entity.Physics.layer]) == nil then
    self.planes[entity.Physics.plane][entity.Physics.layer] = nil
  end
  if next(self.planes[entity.Physics.plane]) == nil then
    self.planes[entity.Physics.plane] = nil
  end
end

function PlaneSystem:reposition(entity, newX, newY, newPlane)
  if self.planes[entity.Physics.plane] and  self.planes[entity.Physics.plane][entity.Physics.layer] and self.planes[entity.Physics.plane][entity.Physics.layer][entity.Physics.x..','..entity.Physics.y] then
    self:removeFromLayer(entity)
  end
  entity.Physics.x = newX
  entity.Physics.y = newY
  if newPlane then
    entity.Physics.plane = newPlane
  end
  self:addToLayer(entity)
end

function PlaneSystem:getTopEntity(x,y,layerName, planeName)
  assert(planeName, "PlaneName is required for getTopEntity")
  if layerName ~= nil then
    if self.planes[planeName][layerName] == nil then
      return nil
    else
      if self.planes[planeName][layerName][x..','..y] then
        for i, v in pairs(self.planes[planeName][layerName][x..','..y]) do
          return v
        end
      end
    end
  else
    if self.planes[planeName]["creature"] and self.planes[planeName]["creature"][x..','..y] then
      for i, v in pairs(self.planes[planeName]["creature"][x..','..y]) do
        return v
      end
    elseif self.planes[planeName]["item"] and self.planes[planeName]["item"][x..','..y] then
      for i, v in pairs(self.planes[planeName]["item"][x..','..y]) do
        return v
      end
    elseif self.planes[planeName]["backdrop"] and self.planes[planeName]["backdrop"][x..','..y] then
      for i, v in pairs(self.planes[planeName]["backdrop"][x..','..y]) do
        return v
      end
    end
      --[[
    elseif self.planes[planeName]["floor"] and self.planes[planeName]["floor"][x..','..y] then
      for i, v in pairs(self.planes[planeName]["floor"][x..','..y]) do
        return v
      end
    end
    --]]
    end
  end

--providing the layerName gives a list of all entities in that layer
--leaving layerName nil will give a list of all entities
  function PlaneSystem:getEntityList(x,y,layerName,planeName)
    assert(planeName, "PlaneName is required for getEntityList")
    if layerName ~= nil then
      if self.planes[planeName][layerName] == nil then
        return nil
      else
        if self.planes[planeName][layerName][x..','..y] then
          return self.planes[planeName][layerName][x..','..y]
        end
        return {}
      end
    else
      local entityList = {}
      if self.planes[planeName]["creature"] and self.planes[planeName]["creature"][x..','..y] then
        for k, v in pairs(self.planes[planeName]["creature"][x..','..y]) do
          entityList[k] = v
        end
      end
      if self.planes[planeName]["item"] and self.planes[planeName]["item"][x..','..y] then
        for k, v in pairs(self.planes[planeName]["item"][x..','..y]) do
          entityList[k] = v
        end
      end
      if self.planes[planeName]["backdrop"] and self.planes[planeName]["backdrop"][x..','..y] then
        for k, v in pairs(self.planes[planeName]["backdrop"][x..','..y]) do
          entityList[k] = v
        end
      end
      --[[
    if self.planes[planeName]["floor"] and self.planes[planeName]["floor"][x..','..y] then
      for k, v in pairs(self.planes[planeName]["floor"][x..','..y]) do
        entityList[k] = v
      end
    end
    --]]
      return entityList
    end
  end

  return PlaneSystem