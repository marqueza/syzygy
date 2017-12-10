local class = require 'lib.middleclass'
local serpent = require 'lib.serpent'
local Serializable = {}

function Serializable:toString()
    return serpent.line(self:toTable(), 
      {comment=false, 
        sparse=true,
        compact=true, 
        valtypeignore = {'userdata', 'function'},
        nohuge=true})
end

--[[
function Serializable:__tostring()
  return "HIIII"
end
--]]

function Serializable:toTable()
    local t = {}
    for k, v in pairs(self) do
        if k == "class" then
            t[k] = string.gsub(v.name, "class ", "")
            
        end
        if type(v) ~= 'userdata' and k~="class" then
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
