local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local PromptSystem = class("PromptSystem", lovetoys.System)

function PromptSystem:initialize()
    lovetoys.System.initialize(self)
    self.margin = 10
    self.text = nil -- I dont know why I cant set this to a default
end
function PromptSystem:draw()
    love.graphics.print(self.text or "BLANK",
    self.margin+0,
    self.margin+444)
end
function PromptSystem:getLatestLines(lines)
    self.text = ""
    for i = 1, math.min(#(systems.messageSystem.log), lines) do
        self.text = self.text .. systems.messageSystem.log[i]
    end
end
function PromptSystem:flushPrompt()--flush on a new turn!
    self:getLatestLines(20)
end
function PromptSystem:requires()
    return {}
end

return PromptSystem
