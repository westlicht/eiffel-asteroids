note
	description: "Base class for hud widgets."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HUD_WIDGET


feature -- Constants

	Default_position: VECTOR2
			-- Default position.
		once
			create Result.make_zero
		end

	Default_size: VECTOR2
			-- Default size.
		once
			create Result.make (100.0, 10.0)
		end

	Default_color: COLOR
			-- Default color.
		once
			Result.make_with_rgb (1.0, 1.0, 1.0)
		end


feature -- Access

	hud: HUD_MANAGER
			-- HUD manager.

	position: VECTOR2 assign set_position
			-- Widget position.

	size: VECTOR2 assign set_size
			-- Widget size.	

	color: COLOR assign set_color
			-- Widget color.


feature -- Initialization

	make_with_hud (a_hud: HUD_MANAGER)
			-- Creates a widget.
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
			-- Sets the position.
		do
			position.make_from_other (a_position)
		end

	set_size (a_size: like size)
			-- Sets the size.
		require
			size_positive: a_size.x > 0.0 and a_size.y > 0.0
		do
			size.make_from_other (a_size)
		end

	set_color (a_color: like color)
			-- Sets the color.
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
	valid_size: size.x > 0.0 and size.y > 0.0

end
