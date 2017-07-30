local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local PromptSystem = class("PromptSystem", lovetoys.System)

function PromptSystem:initialize()
    lovetoys.System.initialize(self)
    self.margin = 10
    self.text = nil
    self.pixelX = 0
    self.pixelY = game.options.viewportHeight
end
function PromptSystem:draw()
    love.graphics.print(self.text or "BLANK",
    self.margin+self.pixelX,
    self.margin+self.pixelY)
end
function PromptSystem:getLatestLines(lines)
    self.text = ""
    if systems.logSystem.messageLog == nil then
      systems.logSystem.messageLog = {}
    end
    for i = 1, math.min(#(systems.logSystem.messageLog), lines) do

        local formattedMessage = systems.logSystem.messageLog[i] .. "\n"
        --formattedMessage = string.upper(formattedMessage)
        formattedMessage = string.gsub(formattedMessage, '{', '[')
        formattedMessage = string.gsub(formattedMessage, '}', ']')
        formattedMessage = string.gsub(formattedMessage, '\"', '')

        self.text = self.text .. formattedMessage
    end
end
function PromptSystem:flushPrompt()--flush on a new turn!
    self:getLatestLines(21)
end
function PromptSystem:requires()
    return {}
end

return PromptSystem
