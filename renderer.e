note
	description: "Implements the renderer, handling of the canvas and some utilities for rendering."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	RENDERER


create
	make

feature -- Access

	screen_width: INTEGER
			-- Screen width.

	screen_height: INTEGER
			-- Screen height


feature {NONE} -- Local attributes

	canvas: EV_PIXMAP
			-- Drawing canvas.

	drawing_area: EV_PIXMAP
			-- Drawing area.

	background_color: EV_COLOR
			-- Background color.

	foreground_color: EV_COLOR
			-- Foreground color.


feature -- Initialization

	make (a_drawing_area: EV_PIXMAP)
		require
			valid_drawing_area: a_drawing_area /= Void and then a_drawing_area.width > 0 and a_drawing_area.height > 0
		do
			drawing_area := a_drawing_area
			create canvas.make_with_size (drawing_area.width, drawing_area.height)
			screen_width := drawing_area.width
			screen_height := drawing_area.height

			create background_color.default_create
			create foreground_color.default_create
		end


feature -- Drawing operations

	clear
			-- Clears the canvas with the background color.
		do
			canvas.clear
		end

	flip
			-- Flips the back-buffer to the front-buffer.
		do
			drawing_area.draw_pixmap (0, 0, canvas)
		end

	set_foreground_color (color: COLOR)
			-- Sets the foreground color.
		do
			foreground_color.set_rgb (color.r, color.g, color.b)
			canvas.set_foreground_color (foreground_color)
		end

	set_background_color (color: COLOR)
			-- Sets the background color.
		do
			background_color.set_rgb (color.r, color.g, color.b)
			canvas.set_background_color (background_color)
		end

	draw_point (position: VECTOR2)
			-- Draws a single point.
		require
			position_exists: position /= Void
		do
			canvas.draw_point (position.x.rounded, position.y.rounded)
		end

	draw_circle (center: VECTOR2; radius: REAL)
			-- Draws a circle.
		require
			center_exists: center /= Void
			radius_positive: radius >= 0.0
		local
			r: INTEGER
		do
			r := radius.rounded
			canvas.draw_ellipse (center.x.rounded - r, center.y.rounded - r, r * 2, r * 2)
		end

	draw_transformed_polygon (polygon: POLYGON; transform: MATRIX3)
			-- Draws a polygon first transformed by a matrix.
		require
			polygon_exists: polygon /= Void
			transform_exists: transform /= Void
		local
			points: ARRAY[EV_COORDINATE]
--			i: INTEGER
--			p1, p2: VECTOR2
--			x1, y1, x2, y2: INTEGER
		do
			points := polygon.transform_to_screen (transform)
			canvas.draw_polyline (points, True)
--			p1 := transform.transform (polygon.points [polygon.points.count])
--			from i := 1 until i > polygon.points.count loop
--				p2 := transform.transform (polygon.points [i])
--				x1 := p1.x.rounded; y1 := p1.y.rounded
--				x2 := p2.x.rounded; y2 := p2.y.rounded
--				if (x1 /= x2) and (y1 /= y2) then
--					canvas.draw_segment (x1, y1, x2, y2)
--				end
--				p1 := p2
--				i := i + 1
--			end
		end

	draw_text (position: VECTOR2; text: STRING)
		require
			position_exists: position /= Void
			text_valid: text /= Void and then not text.is_empty
		local
			font: EV_FONT
		do
--			create font.default_create
--			canvas.set_font (font)
--			canvas.draw_text_top_left (position.x.rounded, position.y.rounded, text)
		end


invariant
	canvas_exists: canvas /= Void
	screen_size_valid: screen_width > 0 and screen_height > 0
	drawing_area_exists: drawing_area /= Void

end
