gui_trans={open=1, fade=2, slide_right=3, slide_left=4, slide_right=5, slide_down=6, slide_up=7, none=0}


function notice_box(x, y, width, height, trans, text)
   local box={}
   box.can_focus=false
   box.finished_anim=false
   box.cords={}
   box.cords.x=x
   box.cords.y=y
   box.cords.animheight=0   
   box.cords.animx=x
   box.cords.animy=y
   box.cords.alpha=255
   box.cords.anim_alpha=255
   box.close_anim=false
   box.closed=false
   box.enabled=true
   box.flicker_more=1
   box.flicker_col=true
   
   box.show_more=false
   
   box.background={r=255, g=255, b=255, 255}
   box.outline={r=255, g=255, b=255, 255}
   
   
   box.cords.width=width
   box.cords.height=height
   box.text=text
   box.font=""
   box.font_height=0

   function box.close()
		box.close_anim=true
   end
   
   function box.set_font(font, height)
		box.font=font
		box.font_height=height
   end
   
   
   function box.set_transition(trans)
		box.trans=trans
			if(trans==gui_trans.open) then
				box.cords.animx=box.cords.x
				box.cords.animy=box.cords.y
				box.cords.anim_alpha=255
			end
			if(trans==gui_trans.fade) then
				box.cords.animx=box.cords.x
				box.cords.animy=box.cords.y
				box.cords.anim_alpha=0
				box.cords.animheight=height
			end
			if(trans==gui_trans.slide_right) then
				box.cords.animx=(0-box.cords.width)
				box.cords.animy=box.cords.y
				box.cords.anim_alpha=255
				box.cords.animheight=height				
			end
			if(trans==gui_trans.slide_left) then
				box.cords.animx=220+box.cords.width
				box.cords.animy=box.cords.y
				box.cords.anim_alpha=255
				box.cords.animheight=height				
			end
			if(trans==gui_trans.slide_up) then
				box.cords.animx=box.cords.x
				box.cords.animy=240+box.cords.height
				box.cords.anim_alpha=255
				box.cords.animheight=height				
			end
			if(trans==gui_trans.slide_down) then
				box.cords.animx=box.cords.x
				box.cords.animy=(0-box.cords.height)
				box.cords.anim_alpha=255
				box.cords.animheight=height				
			end
	end
	
	box.set_transition(trans)
	
   function box.set_colors(background, outline)
		box.background=background
		box.outline=outline
		box.alpha=box.background.alpha
   end
	
   function box.update()
		--do nothing.
   end
   
   function box.reopen()
	   local nbox=notice_box(box.cords.x, box.cords.y, box.cords.width, box.cords.height, box.trans, box.text)
	   nbox.set_colors(box.background, box.outline)
	   nbox.set_font(box.font, box.font_height)
	   return nbox
   end
   
   function box.set_text(text)
		box.text=text
   end
   
   function box.draw()  
		if(box.finished_anim==false) then
			if(box.trans==gui_trans.open) then			
				   if(box.cords.animheight<=box.cords.height) then
						box.cords.animheight=box.cords.animheight+5
				   else
						box.finished_anim=true
				   end
			end
			if(box.trans==gui_trans.fade) then			
				   if(box.cords.anim_alpha<245) then
						box.cords.anim_alpha=box.cords.anim_alpha+15
				   else
						box.cords.anim_alpha=255
						box.finished_anim=true
				   end
			end
			if(box.trans==gui_trans.slide_up) then			
				   if(box.cords.animy>box.cords.y) then
						box.cords.animy=box.cords.animy-8
				   else
						box.cords.animy=box.cords.y
						box.finished_anim=true
				   end
			end
			if(box.trans==gui_trans.slide_down) then			
				   if(box.cords.animy<box.cords.y) then
						box.cords.animy=box.cords.animy+8
				   else
						box.cords.animy=box.cords.y
						box.finished_anim=true
				   end
			end			
			if(box.trans==gui_trans.slide_right) then			
				   if(box.cords.animx<box.cords.x) then
						box.cords.animx=box.cords.animx+8
				   else
						box.cords.animx=box.cords.x
						box.finished_anim=true
				   end
			end			
			if(box.trans==gui_trans.slide_left) then			
				   if(box.cords.animx>box.cords.x) then
						box.cords.animx=box.cords.animx-8
				   else
						box.cords.animx=box.cords.x
						box.finished_anim=true
				   end
			end					
		end
		
		if(box.close_anim==true) then
			if(box.trans==gui_trans.open) then					
					if(box.cords.animheight>5) then
						box.cords.animheight=box.cords.animheight-5
					else
						box.anim_height=0
						box.closed=true
						return false
					end
			end
			
			if(box.trans==gui_trans.fade) then					
					if(box.cords.anim_alpha>=10) then
						box.cords.anim_alpha=box.cords.anim_alpha-15
					else
						box.anim_alpha=0
						box.closed=true
						return false
					end
			end	
			if(box.trans==gui_trans.slide_up) then					
					if(box.cords.animy<box.cords.height+240) then
						box.cords.animy=box.cords.animy+8
					else
						box.animy=box.cords.height+240
						box.closed=true
						return false
					end
			end
			if(box.trans==gui_trans.slide_down) then					
					if(box.cords.animy>(0-box.cords.height)) then
						box.cords.animy=box.cords.animy-8
					else
						box.animy=(0-box.cords.height)
						box.closed=true
						return false
					end
			end
			if(box.trans==gui_trans.slide_right) then					
					if(box.cords.animx>(0-box.cords.width)) then
						box.cords.animx=box.cords.animx-8
					else
						box.animx=(0-box.cords.width)
						box.closed=true
						return false
					end
			end
			if(box.trans==gui_trans.slide_left) then					
					if(box.cords.animx<(box.cords.width+320)) then
						box.cords.animx=box.cords.animx+8
					else
						box.animx=(box.cords.width+320)
						box.closed=true
						return false
					end
			end

		end
		
		   if(box.cords.anim_alpha>box.background.alpha) then
				love.graphics.setColor(box.background.r, box.background.g, box.background.b, box.background.alpha)
		   else
				love.graphics.setColor(box.background.r, box.background.g, box.background.b, box.cords.anim_alpha)		   
		   end
		   
		   love.graphics.rectangle("fill", box.cords.animx+1, box.cords.animy+1, box.cords.width-2, box.cords.animheight-1)
		   
		   love.graphics.setLineStyle(box.outline.style)
		   if(box.cords.anim_alpha>box.background.alpha) then
		   		   love.graphics.setColor(box.outline.r, box.outline.g, box.outline.b, box.outline.alpha)
			else
		   		   love.graphics.setColor(box.outline.r, box.outline.g, box.outline.b, box.cords.anim_alpha)
			end
		   -- RIGHT HAND SIDE
		   love.graphics.line(box.cords.animx+box.cords.width-1, box.cords.animy+2, box.cords.animx+box.cords.width-1, box.cords.animy+box.cords.animheight)
		   -- TOP
		   love.graphics.line(box.cords.animx+1, box.cords.animy+1, box.cords.animx+box.cords.width-2, box.cords.animy+1)
		   --BOTTOM
		   love.graphics.line(box.cords.animx+1, box.cords.animy+box.cords.animheight, box.cords.animx+box.cords.width-2, box.cords.animy+box.cords.animheight)
		   -- LEFT HAND SIDE
		   love.graphics.line(box.cords.animx+1, box.cords.animy+2, box.cords.animx+1, box.cords.animy+box.cords.animheight)
		   
		   --pixel top right hand side
		   love.graphics.point(box.cords.animx+1.5, box.cords.animy+2.5)
		   --pixel top left hand side
		   love.graphics.point(box.cords.animx+((box.cords.width-1)-1.5), box.cords.animy+2.5)
		   --pixel bottom right hand side
		   love.graphics.point(box.cords.animx+1.5, box.cords.animy+(box.cords.animheight)-0.5)
		   --pixel top bottom hand left side
		   love.graphics.point(box.cords.animx+((box.cords.width-1)-1.5), box.cords.animy+(box.cords.animheight)-0.5)		   
		   
		   love.graphics.setLineStyle("smooth")
		   love.graphics.setColor(255, 255, 255, 255)
		   
		if((box.finished_anim==true)  and 
		(box.close_anim==false)) or 
		(box.trans>2)  then
		   box.write_text(box.text)
		end
		
		return true
	end
	
	function box.write_text(text)
			love.graphics.setColor(255, 255, 255, 255)		   
			love.graphics.printf(text, box.cords.animx+9, box.cords.animy+9, box.cords.width-5, "left")			
	if(box.show_more) then
			if(box.flicker_more>10) then
				box.flicker_more=0
				if(box.flicker_col) then box.flicker_col=false else box.flicker_col=true end
			else
				box.flicker_more=box.flicker_more+1
			end
			if(box.flicker_col) then love.graphics.setColor(218, 236, 94, 255)	 else 	love.graphics.setColor(255, 255, 255, 255)	end
			love.graphics.printf("[more]", box.cords.x, box.cords.y+(box.cords.height-(box.font_height-2)), box.cords.width-5, "right")		
		end
		
	end
	
	return box
end

function message_box(x, y, width, height, trans, text)
   local msg_box=notice_box(x, y, width, height, trans, text)
   msg_box.can_focus=true
   function msg_box.update()
		if(msg_box.enabled) and (msg_box.closed==false) then
			if control.tap.accept then
			   msg_box.close_anim=true
		    end   
			if control.tap.cancel then
			  msg_box.close_anim=true
		    end
		end
   end
   function msg_box.reopen()
	   local nbox=message_box(msg_box.cords.x, msg_box.cords.y, msg_box.cords.width, msg_box.cords.height, msg_box.trans, msg_box.text)
	   nbox.set_colors(msg_box.background, msg_box.outline)
	   nbox.set_font(msg_box.font, msg_box.font_height)
	   return nbox
   end
   function msg_box.set_text(text)
		msg_box.text=text
   end
   return msg_box
end

function message_choice_box(x, y, message_width, message_height, menu_width, menu_height, trans, choice_trans, text, items)
	local msg_choice={}
	msg_choice.box=message_box(x, y, message_width, message_height, trans, text)
	msg_choice.menu=menu_box(x+(message_width-15), y+(message_height-15), menu_width, menu_height, choice_trans, items)
	msg_choice.close_anim=false
	msg_choice.closed=false
	msg_choice.alpha=alpha
	msg_choice.trans=trans
	msg_choice.enabled=true
	msg_choice.can_focus=true
	
	function msg_choice.close()
		msg_choice.menu.box.close_anim=true
	end
	
	function msg_choice.set_font(font, height)
		msg_choice.font=font
		msg_choice.font_height=height
		msg_choice.menu.set_font(font, height)
		msg_choice.box.set_font(font, height)
	end
	
	function msg_choice.update()
		msg_choice.menu.update()
	end
	
   function msg_choice.set_colors(background, outline)
   		background1={r=background.r, g=background.g, b=background.b, alpha=background.alpha-10}
		msg_choice.box.set_colors(background1, outline)
		background2={r=background.r, g=background.g, b=background.b, alpha=background.alpha+40}
		msg_choice.menu.set_colors(background2, outline)
   end
	
	
	function msg_choice.reopen()
		local nbox=message_choice_box(
										msg_choice.box.cords.x, 
										msg_choice.box.cords.y, 
										msg_choice.box.cords.width, 
										msg_choice.box.cords.height, 
										msg_choice.menu.box.cords.width, 
										msg_choice.menu.box.cords.height, msg_choice.trans, msg_choice.menu.box.trans
									)
		nbox.set_colors(msg_choice.box.background, msg_choice.box.outline)	
		nbox.set_font(msg_choice.font, msg_choice.font_height)
		nbox.set(msg_choice.box.text, msg_choice.menu.menu.items)
		return nbox
	end
	
	function msg_choice.draw()
			if (msg_choice.menu.box.closed) then
				msg_choice.box.close_anim=true
			end
			if(msg_choice.menu.box.closed) and (msg_choice.box.closed) then
				msg_choice.closed=true
			end
		
		msg_choice.box.draw()
		if(msg_choice.box.finished_anim) then
				msg_choice.menu.draw()		
		end
	end
	
	function msg_choice.move_down()
		msg_choice.menu.move_down()
	end
	
	function msg_choice.move_up()
		msg_choice.menu.move_up()
	end	
	
    function msg_choice.set_items(items)
		msg_choice.menu.set_items(items)
	end
	
	function msg_choice.set_text(text)
		msg_choice.box.set_text(text)
	end
	
	function msg_choice.set(text, items)
		msg_choice.set_text(text)
		msg_choice.set_items(items)
	end
	
	return msg_choice
end

