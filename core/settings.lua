local options = {
  debug = false,
  headless = false,
  player = true,
  auto = false,
  scouter = true}

--graphic settings
--[[
options.screenWidth = 1280
options.screenHeight = 720
--the view port should be 75% of height and width
options.spriteSize = 48
options.verticalTileMax = 11
options.horizontalTileMax = 20
--]]

--options.screenWidth = 1920
--options.screenHeight = 1080
options.screenWidth = 1280
options.screenHeight = 720
--the view port should be 75% of height and width
options.spriteSize = 48
options.verticalTileMax = math.floor(options.screenHeight*.75/options.spriteSize)
options.horizontalTileMax = math.floor(options.screenWidth*.75/options.spriteSize)

options.topBarWidth = options.screenWidth - options.spriteSize*options.verticalTileMax
options.topBarHeight = options.spriteSize*1
options.viewportWidth = options.spriteSize*options.horizontalTileMax
options.viewportHeight = options.spriteSize*options.verticalTileMax

options.sideBarWidth = options.screenWidth - options.spriteSize*options.horizontalTileMax
options.sideBarHeight = options.screenHeight - options.spriteSize*options.verticalTileMax
options.sideBarMarginWidth = 35
options.fontSize = 16

return options
