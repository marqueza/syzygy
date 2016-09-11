function set_controls()
	TLbind.keys = {
		[" "]="accept", lctrl="cancel", escape="exit", ["return"]="menu",
		up="up", left="left", down="down", right="right",
	}
	
	TLbind.joyAxes = { {"horiz", "vert"} }	
	TLbind.maps = { horiz={"left","right"}, vert={"up","down"} }	
	TLbind.joyHats = { {{"left","right","up","down"}} }	
	TLbind.joyBtns = { {"accept", "cancel", "menu"} }
end