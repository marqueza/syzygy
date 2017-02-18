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
local files = love.filesystem.getDirectoryItems( "factories" ) 
for k, file in ipairs(files) do
    tokens = split(file, ".")
    file = tokens[1]
    if (file ~= "Factory") then
        Factory[file] = require("factories/" .. file)
    end
end



return Factory