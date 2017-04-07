require("core/components/sprite")
require("core/components/faction")
require("core/components/physics")
require("core/components/control")
sprite, faction, physics, control = Component.load({'sprite', 'faction', 'physics', 'control'})
local Factory = {}
function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
local dir = love.filesystem.getSourceBaseDirectory()
local files = love.filesystem.getDirectoryItems( "core/factories/entity" )
for k, file in ipairs(files) do
    tokens = split(file, ".")
    file = tokens[1]
    if (file ~= "EntityFactory") then
        Factory[file] = require("core/factories/entity/" .. file)
    end
end
return Factory
