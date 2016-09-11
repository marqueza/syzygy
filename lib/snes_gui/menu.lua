function list_menu(x, y, width, height, items)
   local menu={}
   menu.enabled=true
   menu.x=x
   menu.y=y
   menu.width=width
   menu.height=height
   menu.select=0
   menu.items=items
   menu.can_focus=true
   menu.font_height=0
   menu.flicker_col=true
   menu.flicker_more=0
   
   function menu.set_font(font, height)
	menu.font=font
	menu.font_height=height
   end
   
    function menu.update()
		   if control.tap.up then
			  menu.move_down()
		   end   
		   if control.tap.down then
			  menu.move_up()
		   end
		   if control.tap.accept then
				local i=0
				for k,v in pairs(menu.items) do
						if(i==menu.select) then
							menu.items["" .. k]()
						end
						i=i+1
				end
		   end
	end
	
    function menu.set_items(items)
		menu.items=items
	end
   
	function menu.draw()
		local x=menu.x
		local y=menu.y+5
		local i=0
			if(menu.flicker_more>10) then
				menu.flicker_more=0
				if(menu.flicker_col) then menu.flicker_col=false else menu.flicker_col=true end
			else
				menu.flicker_more=menu.flicker_more+1
			end
		
		for k,v in pairs(menu.items) do
--			if((y+8)<menu.height+menu.y) then
				if(i==menu.select) then
					if(menu.flicker_col) then love.graphics.setColor(218, 236, 94, 255)	else love.graphics.setColor(255, 255, 255, 255)	end	
				else
					love.graphics.setColor(255, 255, 255, 255)		   
				end
				love.graphics.printf(k, x, y, menu.width, "center") -- change this to K when we add the functions.
			
				i=i+1
				y=y+menu.font_height+2
--			end
		end
		love.graphics.setColor(255, 255, 255, 255)		   
	end
	
	function menu.count_items()
		local i=0
		for k,v in pairs(menu.items) do
				i=i+1
		end
		if(i>0) then i=i-1 end
		return i
	end
	
	function menu.move_up()
		local i=menu.count_items()
		menu.select=menu.select+1
		if(menu.select>i) then
			menu.select=0
		end
	end

	function menu.move_down()
		local i=menu.count_items()
		menu.select=menu.select-1
		if(menu.select<0) then
			menu.select=i
		end
	end
	
	return menu
end

function menu_box(x, y, width, height, trans, items)
	local msg_menu={}
	msg_menu.menu=list_menu(x, y, width, height, items)
	msg_menu.box=message_box(x, y, width, height, trans, "")
	msg_menu.alpha=255
	msg_menu.trans=trans
	msg_menu.enabled=true
	msg_menu.closed=false
	msg_menu.can_focus=true
	msg_menu.font_height=0
	
   function msg_menu.set_colors(background, outline)
		msg_menu.box.set_colors(background, outline)
   end
   
   function msg_menu.close()
	msg_menu.box.close_anim=true
   end
   
   function msg_menu.set_font(font, height)
		msg_menu.font_height=height
		msg_menu.menu.set_font(font, height)
		msg_menu.box.set_font(font, height)
   end

	
	function msg_menu.update()
		if(msg_menu.box.enabled) and (msg_menu.box.closed==false) and msg_menu.box.finished_anim and msg_menu.box.close_anim==false then
			msg_menu.menu.update()
			if control.tap.cancel then
			   msg_menu.box.update()
			end
		end
	end
	
	function msg_menu.reopen()
		local nbox=menu_box(msg_menu.box.cords.x, msg_menu.box.cords.y, msg_menu.box.cords.width, msg_menu.box.cords.height,  msg_menu.box.trans)
		nbox.set_items(msg_menu.menu.items)
		nbox.set_colors(msg_menu.box.background, msg_menu.box.outline)
		nbox.set_font(msg_menu.menu.font, msg_menu.menu.font_height)
		msg_menu={}
		return nbox
	end
	
	function msg_menu.draw()
		love.graphics.push()
		msg_menu.box.draw()
		if((msg_menu.box.finished_anim==true)  and (msg_menu.box.close_anim==false)) or (msg_menu.box.trans>2)  then
			if msg_menu.closed==false then
				   msg_menu.menu.x=msg_menu.box.cords.animx
				   msg_menu.menu.y=msg_menu.box.cords.animy
				   msg_menu.menu.draw()
			end
		end
		if(msg_menu.box.closed) then
			msg_menu.closed=true
		end
		love.graphics.pop()
	end
	
	function msg_menu.move_down()
		msg_menu.menu.move_down()
	end

	function msg_menu.move_up()
		msg_menu.menu.move_up()
	end	

	function msg_menu.set_text(text)
		msg_menu.box.set_text(text)
	end
	
    function msg_menu.set_items(items)
		msg_menu.menu.set_items(items)
	end	
	
	return msg_menu
end