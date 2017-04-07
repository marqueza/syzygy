local PromptSystem = class("PromptSystem", System)
function PromptSystem:initialize()
    System.initialize(self)
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
    for i = 1, math.min(#(engine.log), lines) do
        self.text = self.text .. engine.log[i]
    end
end
function PromptSystem:flushPrompt()
    self:getLatestLines(20)
end
function PromptSystem:requires()
    return {}
end

return PromptSystem
