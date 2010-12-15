note
	description: "Implements the HUD (heads-up-displayer)."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HUD

inherit
	ENGINE_OBJECT
		redefine
			draw
		end

create
	make


feature -- Constants

	Health_bar_position: VECTOR2
			-- Position of health bar.
		once
			create Result.make (10.0, 10.0)
		end

	Health_bar_color: COLOR
			-- Color of health bar.
		once
			Result.make_with_rgb (1.0, 0.2, 0.2)
		end

	Energy_bar_position: VECTOR2
			-- Position of energy bar.
		once
			create Result.make (10.0, 30.0)
		end

	Energy_bar_color: COLOR
			-- Color of energy bar.
		once
			Result.make_with_rgb (0.2, 0.2, 1.0)
		end

	Text_color: COLOR
			-- Color of HUD text.
		once
			Result.make_with_rgb (0.8, 0.8, 0.8)
		end

	Default_bar_size: VECTOR2
			-- Bar size.
		once
			create Result.make (150.0, 12.0)
		end

	Default_border_color: COLOR
		once
			Result.make_with_rgb (1.0, 1.0, 1.0)
		end

	Default_bar_border: REAL = 3.0

feature -- Access

	player: PLAYER
			-- Player to get info from.


feature -- Initialization

	make (a_engine: ENGINE; a_player: PLAYER)
		do
			make_with_engine (a_engine)
			player := a_player
			set_layer_z (10)
		end


feature -- Drawing

	draw
			-- Draws the object.
		local
			text_offset: VECTOR2
		do
			draw_bar (Health_bar_position, Default_bar_size, Default_bar_border, player.health.value, 100, Default_border_color, Health_bar_color)
			draw_bar (Energy_bar_position, Default_bar_size, Default_bar_border, player.energy.value, 100, Default_border_color, Energy_bar_color)

			create text_offset.make (default_bar_size.x + 10, 0.0)
			engine.renderer.set_foreground_color (Text_color)
			engine.renderer.draw_text (Health_bar_position + text_offset, "Health: " + player.health.out)
			engine.renderer.draw_text (Energy_bar_position + text_offset, "Energy: " + player.energy.out)
		end


feature {NONE} -- Implementation

	draw_bar (a_position: VECTOR2; a_size: VECTOR2; a_border, a_value, a_max: REAL; a_border_color, a_bar_color: COLOR)
		local
			bar_size: VECTOR2
			border: VECTOR2
		do
			engine.renderer.set_foreground_color (a_border_color)
			engine.renderer.draw_rectangle (a_position, a_size, False)

			create border.make (a_border, a_border)
			create bar_size.make_from_other (a_size - border * 2)
			bar_size.set_x (bar_size.x * (a_value / a_max))
			engine.renderer.set_foreground_color (a_bar_color)
			engine.renderer.draw_rectangle (a_position + border, bar_size, True)
		end

end
