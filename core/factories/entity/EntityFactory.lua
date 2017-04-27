local lovetoys = require "lib.lovetoys.lovetoys"
require("core.components.components")

Sprite, Faction, Physics, Control, Entrance = lovetoys.Component.load({'Sprite', 'Faction', 'Physics', 'Control', 'Entrance'})
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
function getDirectoryItems(dir)
    local i, t = 0, {}
    local pfile = io.popen('ls "'..dir..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename:match( '^(.+)%..+$' )
    end
    pfile:close()
    return t
end
local files = getDirectoryItems( "core/factories/entity" )
for k, file in ipairs(files) do
    tokens = split(file, ".")
    file = tokens[1]
    if (file ~= "EntityFactory") then
        Factory[file] = require("core/factories/entity/" .. file)
    end
end
return Factory
