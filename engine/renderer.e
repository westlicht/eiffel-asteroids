note
	description: "Implements the renderer, handling of the canvas and some utilities for rendering."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	RENDERER


create
	make


feature -- Constants

	Font_id_small: INTEGER = 0

	Font_id_large: INTEGER = 1


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

	active_font: EV_FONT
			-- Currently active font.

	font_small: EV_FONT
			-- Small font.

	font_large: EV_FONT
			-- Large font.


feature -- Initialization

	make (a_drawing_area: EV_PIXMAP)
		require
			valid_drawing_area: a_drawing_area /= Void and then a_drawing_area.width > 0 and a_drawing_area.height > 0
		local
			font_constants: EV_FONT_CONSTANTS
		do
			drawing_area := a_drawing_area
			create canvas.make_with_size (drawing_area.width, drawing_area.height)
			screen_width := drawing_area.width
			screen_height := drawing_area.height

			create background_color.default_create
			create foreground_color.default_create

			create font_constants
			create font_small.make_with_values (font_constants.family_screen, font_constants.weight_regular, font_constants.shape_regular, 10)
			create font_large.make_with_values (font_constants.family_screen, font_constants.weight_regular, font_constants.shape_regular, 30)

			active_font := font_small
			canvas.set_font (active_font)
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

	set_foreground_color (a_color: COLOR)
			-- Sets the foreground color.
		do
			foreground_color.set_rgb (a_color.r, a_color.g, a_color.b)
			canvas.set_foreground_color (foreground_color)
		end

	set_background_color (a_color: COLOR)
			-- Sets the background color.
		do
			background_color.set_rgb (a_color.r, a_color.g, a_color.b)
			canvas.set_background_color (background_color)
		end

	draw_point (a_position: VECTOR2)
			-- Draws a single point.
		do
			canvas.draw_point (a_position.x.rounded, a_position.y.rounded)
		end

	draw_circle (a_center: VECTOR2; a_radius: REAL; a_filled: BOOLEAN)
			-- Draws a circle.
		require
			radius_positive: a_radius >= 0.0
		local
			r: INTEGER
		do
			r := a_radius.rounded
			if a_filled then
				canvas.fill_ellipse (a_center.x.rounded - r, a_center.y.rounded - r, r * 2, r * 2)
			else
				canvas.draw_ellipse (a_center.x.rounded - r, a_center.y.rounded - r, r * 2, r * 2)
			end
		end

	draw_rectangle (a_position: VECTOR2; a_size: VECTOR2; a_filled: BOOLEAN)
			-- Draws a rectangle.
		require
			size_valid: a_size.x >= 0.0 and a_size.y >= 0.0
		do
			if a_filled then
				canvas.fill_rectangle (a_position.x.rounded, a_position.y.rounded, a_size.x.rounded, a_size.y.rounded)
			else
				canvas.draw_rectangle (a_position.x.rounded, a_position.y.rounded, a_size.x.rounded, a_size.y.rounded)
			end
		end

	draw_transformed_polygon (a_polygon: POLYGON; a_transform: MATRIX3; a_filled: BOOLEAN)
			-- Draws a polygon first transformed by a matrix.
		require
			transform_exists: a_transform /= Void
		local
			points: ARRAY[EV_COORDINATE]
		do
			points := a_polygon.transform_to_screen (a_transform)
			if a_filled then
				canvas.fill_polygon (points)
			else
				canvas.draw_polyline (points, True)
			end
		end

	draw_text (a_position: VECTOR2; a_text: STRING)
			-- Draws text.
		require
			text_valid: a_text /= Void and then not a_text.is_empty
		do
			canvas.draw_text_top_left (a_position.x.rounded, a_position.y.rounded, a_text)
		end

	set_font (a_font_id: INTEGER)
		local
			new_font: EV_FONT
		do
			inspect a_font_id
			when Font_id_small  then
				new_font := font_small
			when Font_id_large then
				new_font := font_large
			else
				new_font := font_small
			end
			if new_font /= active_font then
				active_font := new_font
				canvas.set_font (active_font)
			end
		end

	text_size (a_text: STRING): VECTOR2
		require
			text_valid: a_text /= Void and then not a_text.is_empty
		local
			size: TUPLE [width: INTEGER; height: INTEGER]
		do
			size := active_font.string_size (a_text)
			Result.set (size.width, size.height)
		end


invariant
	canvas_exists: canvas /= Void
	screen_size_valid: screen_width > 0 and screen_height > 0
	drawing_area_exists: drawing_area /= Void

end
