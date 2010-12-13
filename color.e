note
	description: "Summary description for {COLOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	COLOR

inherit
	ANY
		redefine
			default_create
		end

create
	default_create


feature -- Access

	r, g, b: REAL
			-- Color components (red, green, blue).

feature -- Initialization

	default_create
			-- Create black by default.
		do
			r := 0.0
			g := 0.0
			b := 0.0
		end

	make_with_rgb (a_r: like r; a_g: like g; a_b: like b)
			-- Create color with rgb values [0..1].
		require
			valid_r: is_valid_component (a_r)
			valid_g: is_valid_component (a_g)
			valid_b: is_valid_component (a_b)
		do
			r := a_r
			g := a_g
			b := a_b
		end

	make_gray (a_gray: REAL)
			-- Create gray color.
		require
			valid_gray: is_valid_component (a_gray)
		do
			make_with_rgb (a_gray, a_gray, a_gray)
		end

	make_from_other (a_other: like Current)
			-- Create a color by copying another.
		do
			make_with_rgb (a_other.r, a_other.g, a_other.b)
		end


feature -- Calculations

	blend (a_other: like Current; a_blend: REAL): like Current
			-- Blends a color with another color.
		local
			one_minus_blend: like a_blend
		do
			one_minus_blend := 1 - a_blend
			Result.make_with_rgb (
				r * one_minus_blend + a_other.r * a_blend,
				g * one_minus_blend + a_other.g * a_blend,
				b * one_minus_blend + a_other.b * a_blend
			)
		end

feature -- Validity

	is_valid_component (a_component: like r): BOOLEAN
			-- Check if a component is in valid range.
		do
			Result := 0.0 <= a_component and a_component <= 1.0
		end


invariant
	valid_r: is_valid_component (r)
	valid_g: is_valid_component (g)
	valid_b: is_valid_component (b)

end
