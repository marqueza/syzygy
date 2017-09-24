local options = {
  debug = false,
  headless = false,
  player = true,
  auto = false}

--graphic settings
options.spriteSize = 48
options.screenWidth = 1280
options.screenHeight = 720
options.topBarWidth = options.screenWidth - options.spriteSize*11
options.topBarHeight = options.spriteSize*1
options.viewportWidth = options.spriteSize*20
options.viewportHeight = options.spriteSize*11

options.sideBarWidth = options.screenWidth - options.spriteSize*20
options.sideBarHeight = options.screenHeight - options.spriteSize*11
options.sideBarMarginWidth = 35
options.fontSize = 16

return options
