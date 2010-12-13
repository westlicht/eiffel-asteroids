note
	description: "2d vector class."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	VECTOR2

inherit
	ANY
		redefine
			out
		end

	DOUBLE_MATH_UTILS
		undefine
			out
		end

create
	make, make_zero, make_unit, make_from_other, make_random


feature -- Access

	x: REAL_64
			-- X coordinate.

	y: REAL_64
			-- Y coordinate.


feature -- Creation

	make (a_x: REAL_64; a_y: REAL_64)
			-- Creates a vector with (a_x,a_y) coordinates.
		do
			x := a_x
			y := a_y
		ensure
			x_set: x = a_x
			y_set: y = a_y
		end

	make_zero
			-- Creates a vector with (0,0) coordinates.
		do
			make (0.0, 0.0)
		ensure
			x_zero: x = 0.0
			y_zero: y = 0.0
		end

	make_unit(a_angle: REAL_64)
			-- Creates a unit length vector with given angle.
		do
			make (-cos(a_angle), sin(a_angle))
		end

	make_from_other(other: like Current)
			-- Creates a vector with same coordinates as another vector.
		require
			other_exists: other /= Void
		do
			make (other.x, other.y)
		ensure
			equal_to_other: is_equal(other)
		end

	make_random(a_min_x, a_max_x: like x; a_min_y, a_max_y: like y)
			-- Creates a vector with random coordinates (a_min_x..a_max_x,a_min_y..a_max_x).
		do
			random.forth
			x := a_min_x + random.real_item * (a_max_x - a_min_x)
			random.forth
			y := a_min_y + random.real_item * (a_max_y - a_min_y)
		end


feature -- Coordinate access

	set_x (a_x: like x)
			-- Sets the X coordinate.
		do
			x := a_x
		ensure
			x_set: x = a_x
		end

	set_y (a_y: like y)
			-- Sets the Y coordinate.
		do
			y := a_y
		ensure
			y_set: y = a_y
		end


feature -- Calculations

	length: REAL_64
			-- Length of vector.
		do
			Result := sqrt (length_squared)
		ensure
			check_result: Result = sqrt (length_squared)
		end

	length_squared: REAL_64
			-- Squared length of vector.
		do
			Result := x^2 + y^2
		ensure
			check_result: Result = (x^2 + y^2)
		end

	normalized: VECTOR2
			-- Returns a normalized version of the vector.
		do
			create Result.make_from_other (Current)
			Result := Result / Result.length
		end


feature -- Vector operations

	infix "+" (other: like Current): like Current
			-- Adds two vectors.
		require
			other_exists: other /= Void
		do
			create Result.make (x + other.x, y + other.y)
		end

	infix "-" (other: like Current): like Current
			-- Subtracts two vectors.
		require
			other_exists: other /= Void
		do
			create Result.make (x - other.x, y - other.y)
		end

	infix "*" (a_factor: REAL_64): like Current
			-- Scalar multiplication.
		do
			create Result.make (x * a_factor, y * a_factor)
		end

	infix "/" (a_divisor: REAL_64): like Current
			-- Scalar division.
		require
			divisor_not_zero: a_divisor /= 0.0
		do
			create Result.make (x / a_divisor, y / a_divisor)
		end

	prefix "+": like Current
			-- Unary plus.
		do
			create Result.make (x, y)
		ensure
			result_is_same: is_equal(Result)
		end

	prefix "-": like Current is
			-- Unary minus.
		do
			create Result.make (-x, -y)
		ensure
			result_is_negation: Result.x = -x and Result.y = -y
		end

	dot_product (other: like Current): REAL_64
			-- Dot product.
		require
			other_exists: other /= Void
		do
			Result := x * other.x + y * other.y
		ensure
			result_calculated: Result = x * other.x + y * other.y
		end

	distance (other: like Current): REAL_64
			-- Distance to another vector.
		require
			other_exists: other /= Void
		do
			Result := (other - Current).length
		end

	distance_squared (other: like Current): REAL_64
			-- Squared distance to another vector.
		require
			other_exists: other /= Void
		do
			Result := (other - Current).length_squared
		end


feature -- Output

	out: STRING is
			-- String representation of the vector.
		do
			Result := "(x = " + x.out + ", y = " + y.out + ")"
		end


feature {NONE} -- Implementation

	random: RANDOM
			-- Static random generator.
		local
			time: TIME
		once
			create time.make_now
			create Result.make
			Result.set_seed (time.milli_second)
			Result.start
		end


end
