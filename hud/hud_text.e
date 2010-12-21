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


feature -- Constants

	Horizontal_align_left: INTEGER = 0
	Horizontal_align_center: INTEGER = 1
	Horizontal_align_right: INTEGER = 2


feature -- Access

	text: STRING assign set_text
			-- Text to display.

	horizontal_align: INTEGER assign set_horizontal_align
			-- Horizontal alignment

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

	set_horizontal_align (a_horizontal_align: like horizontal_align)
			-- Sets the horizontal alignment.
		require
			horizontal_align_valid: Horizontal_align_left <= a_horizontal_align and a_horizontal_align <= Horizontal_align_right
		do
			horizontal_align := a_horizontal_align
		end

	set_font_id (a_font_id: like font_id)
			-- Sets the font id.
		do
			font_id := a_font_id
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draw the widget.
		local
			lines: LIST [STRING]
		do
			if not text.is_empty then
				engine.renderer.set_foreground_color (color)
				engine.renderer.set_font (font_id)
				-- Draw multiple lines
				lines := text.split ('%N')
				from lines.start until lines.after loop
					draw_line (lines.item, lines.index)
					lines.forth
				end
			end
		end


feature {NONE} -- Implementation

	draw_line (a_line: STRING; a_index: INTEGER)
		local
			origin: VECTOR2
			text_size: VECTOR2
		do
			if not a_line.is_empty then
				text_size := hud.engine.renderer.text_size (a_line)
				origin := position
				origin.y := origin.y + (a_index - 1) * text_size.y
				inspect horizontal_align
				when  Horizontal_align_center then
					origin.x := origin.x + (size.x - text_size.x) / 2.0
				when  Horizontal_align_right then
					origin.x := origin.x + size.x - text_size.x
				else
					-- Do nothing
				end
				hud.engine.renderer.draw_text (origin, a_line)
			end
		end

invariant
	text_exists: text /= Void

end
