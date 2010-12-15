note
	description: "Summary description for {HUD_WIDGET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HUD_WIDGET

create
	make_with_hud


feature -- Constants

	Default_position: VECTOR2
		once
			create Result.make_zero
		end

	Default_size: VECTOR2
		once
			create Result.make (100.0, 10.0)
		end

	Default_color: COLOR
		once
			Result.make_with_rgb (1.0, 1.0, 1.0)
		end


feature -- Access

	hud: HUD_MANAGER
			-- HUD.

	position: VECTOR2 assign set_position
			-- Widget position.

	size: VECTOR2 assign set_size
			-- Widget size.	

	color: COLOR assign set_color
			-- Widget color.


feature -- Initialization

	make_with_hud (a_hud: HUD_MANAGER)
		require
			hud_exists: a_hud /= Void
		do
			hud := a_hud
			create position.make_from_other (Default_position)
			create size.make_from_other (Default_size)
			color := Default_color
		end


feature -- Access

	set_position (a_position: like position)
		do
			position.make_from_other (a_position)
		end

	set_size (a_size: like size)
		do
			size.make_from_other (a_size)
		end

	set_color (a_color: like color)
		do
			color := a_color
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Update the widget by t seconds.
		do
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draw the widget.
		do
		end


invariant
	hud_exists: hud /= Void

end
