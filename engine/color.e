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

	r: REAL assign set_r
			-- Red component [0..1].

	g: REAL assign set_g
			-- Green component [0..1].

	b: REAL assign set_b
			-- Blue component [0..1].


feature -- Initialization

	default_create
			-- Create black by default.
		do
			r := 0.0
			g := 0.0
			b := 0.0
		end


feature -- Access

	set_r (a_r: like r)
			-- Sets the red component [0..1].
		require
			valid_r: is_valid_component (a_r)
		do
			r := a_r
		end

	set_g (a_g: like g)
			-- Sets the green component [0..1].
		require
			valid_g: is_valid_component (a_g)
		do
			g := a_g
		end

	set_b (a_b: like b)
			-- Sets the blue component [0..1].
		require
			valid_b: is_valid_component (a_b)
		do
			b := a_b
		end

	set_rgb (a_r: like r; a_g: like g; a_b: like b)
			-- Sets RGB components [0..1].
		require
			valid_r: is_valid_component (a_r)
			valid_g: is_valid_component (a_g)
			valid_b: is_valid_component (a_b)
		do
			r := a_r
			g := a_g
			b := a_b
		end

	set_gray (a_gray: REAL)
			-- Sets all RGB components to the same intensity to make gray colors.
		require
			valid_gray: is_valid_component (a_gray)
		do
			set_rgb (a_gray, a_gray, a_gray)
		end


feature -- Calculations

	blend (a_other: like Current; a_blend: REAL): like Current
			-- Blends a color with another color.
		local
			one_minus_blend: like a_blend
		do
			one_minus_blend := 1 - a_blend
			Result.set_rgb (
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
