local filer = require "data.filer"
local components = {}
filer.requireDirectoryItems(components, "components", "core/components/")
return components
