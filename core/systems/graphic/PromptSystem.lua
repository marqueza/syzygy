local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local PromptSystem = class("PromptSystem", lovetoys.System)

function PromptSystem:initialize()
    lovetoys.System.initialize(self)
    self.margin = 10
    self.text = nil
    self.textTable = {}
    self.visibleRowMarker = 21
    self.newRowMarker = 0
    self.oldMessageLogLength = 1
    self.oldTextTable = {}
    self.pixelX = 0
    self.pixelY = game.options.viewportHeight
end
local _getFormattedLine 

function PromptSystem:draw()
  local color
  for i = 1, math.min(#(systems.logSystem.messageLog), self.visibleRowMarker) do
    if i > self.newRowMarker then
          color = {100,100,100}
        else
          color = {255,255,255}
        end
    love.graphics.print(
        {color, _getFormattedLine(self, i)},
        self.margin+self.pixelX,
        self.margin+self.pixelY+(i-1)*(game.options.fontSize+1))
  end
  --[[
    for index, text in ipairs(self.textTable) do
      love.graphics.print(text,
        self.margin+self.pixelX,
        self.margin+self.pixelY+(index-1)*(game.options.fontSize+4))
    end
  --]]
end
function PromptSystem:getLatestLines(lines)
    self.textTable = {}
    if systems.logSystem.messageLog == nil then
      systems.logSystem.messageLog = {}
    end
    for i = 1, math.min(#(systems.logSystem.messageLog), lines) do

        local formattedMessage = systems.logSystem.messageLog[i] .. "\n"
        --formattedMessage = string.upper(formattedMessage)
        formattedMessage = string.gsub(formattedMessage, '{', '[')
        formattedMessage = string.gsub(formattedMessage, '}', ']')
        formattedMessage = string.gsub(formattedMessage, '\"', '')
        formattedMessage = string.upper(formattedMessage)

        table.insert(self.textTable, formattedMessage)
    end
end

_getFormattedLine = function(self, i)
  local formattedMessage = systems.logSystem.messageLog[i]  .. "\n"
  --formattedMessage = string.upper(formattedMessage)
  formattedMessage = string.gsub(formattedMessage, '{', '[')
  formattedMessage = string.gsub(formattedMessage, '}', ']')
  formattedMessage = string.gsub(formattedMessage, '\"', '')
  formattedMessage = string.upper(formattedMessage)
  return formattedMessage
end
function PromptSystem:flushPrompt()--flush on a new turn!
    self.newRowMarker = #(systems.logSystem.messageLog) - self.oldMessageLogLength
    self.oldMessageLogLength = #(systems.logSystem.messageLog)
end
function PromptSystem:requires()
    return {}
end

return PromptSystem
