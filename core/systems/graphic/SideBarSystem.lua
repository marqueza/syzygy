local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local SideBarSystem = class("SideBarSystem", lovetoys.System)

function SideBarSystem:initialize()
  lovetoys.System.initialize(self)
  self.pixelX = game.options.viewportWidth
  self.pixelY = 0
  self.marginWidth = 10
  self.marginHeight = 40
  self.text = ""
  self.font = love.graphics.setNewFont("res/font/PressStart/PressStart2p.ttf", 16)

end
local _refreshText

_refreshText = function(self)
  self.text = ""
  if game.player and game.player.Party then
    --get follower entity and then filter by id == game.player
    local followers = systems.getEntitiesWithComponent("Follower")
    for id, follower in pairs(followers) do
      if follower.Follower.leaderId == game.player.id then
        self.text = self.text .. string.upper(follower.name.." ")
        if follower.Ai then
          self.text = self.text .. string.upper(follower.Ai.lastAction)
        end
        self.text = self.text .. "\n"
      end
    end
  end
end

function SideBarSystem:draw()
  love.graphics.setFont(self.font)

  love.graphics.print(self.text or "",
    self.pixelX+self.marginWidth,
    self.pixelY+self.marginHeight)
  love.graphics.setFont(game.options.font)

end

function SideBarSystem:requires()
  return {}
end

function SideBarSystem:refreshSideBar()
  _refreshText(self)
end

return SideBarSystem
