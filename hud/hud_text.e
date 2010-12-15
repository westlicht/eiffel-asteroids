note
	description: "Displays simple text."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HUD_TEXT

inherit
	HUD_WIDGET
		redefine
			draw
		end

create
	make


feature -- Access

	text: STRING assign set_text
			-- Text to display.


feature -- Initialization

	make (a_hud: HUD_MANAGER)
		do
			make_with_hud (a_hud)
			create text.make_from_string ("TEXT")
		end


feature -- Access

	set_text (a_text: like text)
		require
			text_exists: a_text /= Void
		do
			text.make_from_string (a_text)
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draw the widget.
		do
			engine.renderer.set_foreground_color (color)
			engine.renderer.draw_text (position, text)
		end


invariant
	text_exists: text /= Void

end
