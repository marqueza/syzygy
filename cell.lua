local class = require "lib.middleclass"
require "actor"
require "feature"
require "item"--


Cell = class("Cell")

function Cell:initialize(tile, isPassable, isOpaque, inv, actor, feat )
  self.tile = tile or 'wall'
  self.isPassable = isPassable or false
  self.isOpaque = isOpaque or true
  self.inv = inv or {}
  self.actor = actor or nil
  self.feat = feat or nil
end

function Cell:createFloor()
  self.tile = 'floor'
  self.isPassable = true
  self.isOpaque = false
end

function Cell:createWall()
  self.tile = 'wall'
  self.isPassable = false
  self.isOpaque = true
end

function Cell:getData()
  local data = {}
  for k,v in pairs(self) do
      if k ~= "inv" and k ~= "actor" and k ~= "feat" and k~="class" then
        data[k] = v
      end
  end
  return data
end