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

	Health_position: VECTOR2
			-- Position of health info.
		once
			create Result.make (10.0, 10.0)
		end

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
		do
			engine.renderer.set_foreground_color (create {EV_COLOR}.make_with_rgb (1.0, 1.0, 1.0))
			engine.renderer.draw_text (Health_position, "Health: 123")
		end

end
