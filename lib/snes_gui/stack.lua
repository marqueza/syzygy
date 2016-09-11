gui_stack={}

gui_stack.stack={}
gui_stack.total=0
gui_stack.gui_color={r=255, g=255, b=255, alpha=255}
gui_stack.gui_outline_color={r=255, g=255, b=255, alpha=255}
gui_stack.font=nil
gui_stack.groups={}
gui_stack.focus_stack={}
gui_stack.focus_num=0
gui_stack.font_height=0

function gui_stack.current_focus()
	return gui_stack.focus_stack[gui_stack.focus_num]
end

function gui_stack.set_focus(id)
		gui_stack.focus_num=gui_stack.focus_num+1
		table.insert(gui_stack.focus_stack, id)
end

function gui_stack.lose_focus()
		if(gui_stack.focus_num>0) then
			gui_stack.focus_num=gui_stack.focus_num-1
			table.remove(gui_stack.focus_stack)
		end
end

function gui_stack.has_focus()
		if(gui_stack.focus_num>0) then 
			return true 
		end
		return false
end

function gui_stack.set_font(font, height)
	gui_stack.font=love.graphics.newFont(font, height)
	love.graphics.setFont(gui_stack.font)
	gui_stack.font_height=gui_stack.font:getHeight()
end

function gui_stack.set_colors(gui_color, outline_color)
	gui_stack.gui_color=gui_color
	gui_stack.gui_outline_color=outline_color
end

function gui_stack.set_group_defaults(group, font, height, gui_color, outline_color)
	gui_stack.set_group_font(group, font, height)
	gui_stack.set_group_colors(gui_color, outline_color)
end

function gui_stack.set_group_colors(group, gui_color, outline_color)
	for k,v in pairs(gui_stack.groups["" .. group]) do
		v.set_colors(gui_color, outline_color)
	end
end

function gui_stack.set_group_font(group, font, height)
	for k,v in pairs(gui_stack.groups["" .. group]) do
		v.set_font(font, height)
	end
end


function gui_stack.set_defaults(font, height, gui_color, outline_color)
	set_controls()
	gui_stack.set_colors(gui_color, outline_color)
	gui_stack.set_font(font, height)
end

function gui_stack.add_to_group(group, id, gui)
	local msg=gui_stack.add(id, gui)
	gui_stack.groups[group][id]=msg
	return msg
end

function gui_stack.remove_from_group(group, id)
	gui_stack.groups[group][id]=nil
end

function gui_stack.draw_group(group)
	for k,v in pairs(gui_stack.groups["" .. group]) do
		if(gui_stack.stack[k].enabled) then gui_stack.stack[k].draw() end
	end
end

function gui_stack.update_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		if(gui_stack.stack[k].enabled) then 
			gui_stack.stack[k].update() 
		end
	end
end

function gui_stack.open_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		--gui_stack.stack[k]=gui_stack.stack[k].reopen()
		gui_stack.open(k)
	end
end

function gui_stack.close_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		gui_stack.close(k)
	end
end

function gui_stack.group_closed(group)
	local closed=false
	for k,v in pairs(gui_stack.groups[group]) do
		if(gui_stack.stack[k].closed) then closed=true end
	end
	return closed
end

function gui_stack.force_shut_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		gui_stack.force_shut(k)
	end
end


function gui_stack.group_disabled(group)
	local closed=false
	for k,v in pairs(gui_stack.groups[group]) do
		if(gui_stack.stack[k].enabled==false) then closed=true end
	end
	return closed
end

function gui_stack.group_enabled(group)
	local closed=false
	for k,v in pairs(gui_stack.groups[group]) do
		if(gui_stack.stack[k].enabled) then closed=true end
	end
	return closed
end


function gui_stack.enable_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		--gui_stack.stack[k].enabled=true
		gui_stack.enable(k)
	end
end

function gui_stack.disable_group(group)
	for k,v in pairs(gui_stack.groups[group]) do
		--gui_stack.stack[k].enabled=false
		gui_stack.disable(k)
	end
end

function gui_stack.create_group(group)
	gui_stack.groups[group]={}
end

function gui_stack.open(id)
	gui_stack.stack[id]=gui_stack.stack[id].reopen()
	if(gui_stack.stack[id].can_focus) then
		gui_stack.set_focus(id)
	end	
end

function gui_stack.close(id)
	gui_stack.stack[id].close()
end

function gui_stack.force_shut(id)
	gui_stack.stack[id].closed=true
end


function gui_stack.set_text(id, text)
	gui_stack.stack[id].set_text(text)
end

function gui_stack.set_items(id, items)
	gui_stack.stack[id].set_items(items)
end

function gui_stack.add(id, gui)
	gui.set_colors(gui_stack.gui_color, gui_stack.gui_outline_color)
	gui.set_font(gui_stack.font, gui_stack.font_height)
	gui_stack.stack[id]=gui
	if(gui.can_focus) then
		gui_stack.set_focus(id)
	end
	return gui
end

function gui_stack.disable(id)
	gui_stack.stack[id].enabled=false
	if(gui_stack.current_focus()==id) then
		gui_stack.lose_focus()
	end
end

function gui_stack.enable(id)
	gui_stack.stack[id].enabled=true
	if(gui_stack.stack[id].can_focus) then
		gui_stack.set_focus(id)
	end
end

function gui_stack.remove(id)
	gui_stack.stack.id=nil
end

function gui_stack.update()
	TLbind:update()
	for k,v in pairs(gui_stack.stack) do		
		if(v.enabled) then 
			if(gui_stack.current_focus()==k) then
				v.update() 
			end
		end
		if ((v.closed) or(v.enabled==false)) and (gui_stack.current_focus()==k) then
				gui_stack.lose_focus()
		end
		
	end
end

function gui_stack.draw()
	for k,v in pairs(gui_stack.stack) do
		if(v.enabled) then v.draw() end
	end
end

function gui_stack.list_groups()
	local x=50
	local y=50
	
	for k, v in pairs(gui_stack.groups) do
		love.graphics.print("name: " .. k, x, y)
		y=y+10
	end
end

function gui_stack.closed(id)
	return gui_stack.stack[id].closed
end

function gui_stack.list_stack()
	local x=50
	local y=20
	local old_x=x	
	for k, v in pairs(gui_stack.groups) do
		local closed="false"
		if(gui_stack.group_closed(k)) then closed="true" else closed="false" end
		love.graphics.print("group name: " .. k .. " is closed " .. closed, x, y)
		for f, z in pairs(v) do
			y=y+20
			x=x+40
			love.graphics.print("- " .. f, x, y)
		end
		x=old_x
		y=y+20
	end
end