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

	font_id: INTEGER assign set_font_id
			-- Font id.


feature -- Initialization

	make (a_hud: HUD_MANAGER)
			-- Creates a text widget.
		do
			make_with_hud (a_hud)
			create text.make_from_string ("TEXT")
		end


feature -- Access

	set_text (a_text: like text)
			-- Sets the text.
		require
			text_exists: a_text /= Void
		do
			text.make_from_string (a_text)
		end

	set_font_id (a_font_id: like font_id)
			-- Sets the font id.
		do
			font_id := a_font_id
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draw the widget.
		do
			engine.renderer.set_foreground_color (color)
			engine.renderer.set_font (font_id)
			if not text.is_empty then
				engine.renderer.draw_text (position, text)
			end
		end


invariant
	text_exists: text /= Void

end
