local class = require 'middleclass'
local serpent = require 'serpent'
Serializable = {}

function Serializable:toString()
    return serpent.line(self:reflect(), {comment=false, valtypeignore = {'table', 'userdata', 'function'}})
end
function Serializable:reflect()
    local t = {}
    for k, v in pairs(self) do
        if k == 'class' then
            t[k] = string.gsub(v.name, "class", "")
        end
        if type(v) ~= 'table' and type(v) ~= 'userdata' then
            t[k] = v
        end
    end
    return t
end

return Serializable
