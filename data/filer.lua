local filer = {}

local _split = function (inputstr, sep)
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
local _firstToLower = function (str)
    return (str:gsub("^%u", string.lower))
end
function filer.getDirectoryItems(dir)
    local i, t = 0, {}
    local pfile = io.popen('ls "'..dir..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename:match( '^(.+)%..+$' )
    end
    pfile:close()
    return t
end

function filer.requireDirectoryItems(table, tableName, path)
    --local files = filer.getDirectoryItems( path )
    local files = love.filesystem.getDirectoryItems( path)
    for k, file in ipairs(files) do
        tokens = _split(file, ".")
        file = tokens[1]
        if (file ~= tableName) then
            table[file] = require(path .. file)
        end
    end
end

function filer.instantiateDirectoryItems(table, tableName, path)
    --local files = filer.getDirectoryItems( path )
    local files = love.filesystem.getDirectoryItems( path )
    for k, file in ipairs(files) do
        tokens = _split(file, ".")
        file = tokens[1]
        if (file ~= tableName) then
          if type(table)=="boolean" then
              print("WAT")
          end
          print(file)
          print(path)
            table[_firstToLower(file)] = require(path .. file)()
        end
    end
end

return filer
