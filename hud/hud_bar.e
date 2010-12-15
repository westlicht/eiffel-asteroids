note
	description: "Implements simple status bars, showing infos like health."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HUD_BAR

inherit
	HUD_WIDGET
		redefine
			update,
			draw
		end

create
	make


feature -- Constants

	Default_bar_color: COLOR
			-- Default color of bar.
		once
			Result.make_with_rgb (1.0, 1.0, 1.0)
		end

	Default_border_size: REAL = 3.0
			-- Default border size.


feature -- Access

	value: REAL assign set_value
			-- Current value displayed by the bar.

	min: REAL assign set_min
			-- Minimum value.

	max: REAL assign set_max
			-- Maximum value.

	border_size: REAL assign set_border_size
			-- Border size

	bar_color: COLOR assign set_bar_color
			-- Bar color.


feature -- Initialization

	make (a_hud: HUD_MANAGER)
		do
			make_with_hud (a_hud)
			size := Default_size
			value := 1.0
			min := 0.0
			max := 1.0
			border_size := Default_border_size
			bar_color := Default_bar_color
		end


feature -- Access

	set_value (a_value: like value)
		do
			value := a_value
		end

	set_min (a_min: like min)
		do
			min := a_min
		end

	set_max (a_max: like max)
		do
			max := a_max
		end

	set_border_size (a_border_size: like border_size)
		do
			border_size := a_border_size
		end

	set_bar_color (a_bar_color: like bar_color)
		do
			bar_color := a_bar_color
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Update the widget by t seconds.
		do

		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draw the widget.
		local
			border: VECTOR2
			bar_size: VECTOR2
		do
			-- Draw border
			engine.renderer.set_foreground_color (color)
			engine.renderer.draw_rectangle (position, size, False)

			-- Draw bar
			create border.make (border_size, border_size)
			create bar_size.make_from_other (size - border * 2)
			bar_size.x := bar_size.x * ((value - min) / (max - min))
			engine.renderer.set_foreground_color (bar_color)
			engine.renderer.draw_rectangle (position + border, bar_size, True)
		end


end
