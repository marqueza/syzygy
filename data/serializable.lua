local class = require 'lib.middleclass'
local serpent = require 'serpent'
Serializable = {}

function Serializable:toString()
    return serpent.line(self:toTable(), {comment=false, sparse=true,compact=true, valtypeignore = {'table', 'userdata', 'function'}})
end
function Serializable:toTable()
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

function Serializable:restore(t)
    for k, v in pairs(t) do
        if k ~= 'class' then
            self[k] = v
        end
    end
end

return Serializable
