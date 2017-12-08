if arg[#arg] == "-debug" then require("mobdebug").start() end

if arg[#arg] == "--test" then 
  dofile('test/startup_tests.lua')
else
  dofile('core/main.lua')
end
