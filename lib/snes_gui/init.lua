--[[
-------------------------------------------------------------
This is just a list of includes. Just include this file
and the gui system will be ready to roll.
-------------------------------------------------------------
]]--

local GUI_LIBPATH=({...})[1]:gsub("[%.\\/]init$", "") .. '.'
local GUI_TBINDPATH=string.gsub(GUI_LIBPATH, "snes_gui.", "snes_gui/")

TLbind,control = love.filesystem.load(GUI_TBINDPATH .. "TLbind.lua")()

require(GUI_LIBPATH .. "stack")
require(GUI_LIBPATH .. "control_map")
require(GUI_LIBPATH .. "stack")
require(GUI_LIBPATH .. "menu")
require(GUI_LIBPATH .. "message_box")
