note
	description: "Implements the background. Draws some twinkling stars."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	BACKGROUND

inherit
	ENGINE_OBJECT
		redefine
			draw
		end

create
	make


feature -- Constants

	Background: COLOR
			-- Background color.
		once
			Result.make_with_rgb(0.0, 0.0, 0.0)
		end

	Num_stars: INTEGER = 100
			-- Number of stars.

feature -- Initialization

	make (a_engine: ENGINE)
			-- Creates the background. Inits random position for stars.
		local
			i: INTEGER
			v: VECTOR2
		do
			make_with_engine (a_engine)

			create stars.make
			from i := 1 until i > 100 loop
				create v.make_random(0.0, engine.renderer.screen_width, 0.0, engine.renderer.screen_height)
				stars.extend (v)
				i := i + 1
			end

			set_layer_z (-1)
		end


feature {NONE} -- Implementation

	stars: LINKED_LIST[VECTOR2]
			-- List of star positions.

	oscillate (time: REAL_64; scale: REAL_64; offset: REAL_64): REAL_32
			-- Creates a simple triangle oscillation.
		local
			i: INTEGER
		do
			i := ((time * scale + offset) * 1000.0).rounded \\ 1000
			if i < 500 then
				Result := (i / 500.0).truncated_to_real
			else
				Result := (1.0 - (i - 500) / 500.0).truncated_to_real
			end
		end

feature -- Drawing

	draw
			-- Draws the background.
		local
			t: REAL_64
			gray: REAL_32
			color: COLOR
		do
			engine.renderer.set_background_color (Background)
			engine.renderer.clear

			t := 1.0 / (engine.renderer.screen_width * engine.renderer.screen_height)
			from stars.start until stars.after loop
				-- Create pseudo random oscillating color
				gray := oscillate (engine.time, stars.item.x * stars.item.y * t, stars.item.x * stars.item.y * t)
				color.make_gray (gray)
				engine.renderer.set_foreground_color (color)

				-- Draw star
				engine.renderer.draw_point (stars.item)
				stars.forth
			end
		end

end
