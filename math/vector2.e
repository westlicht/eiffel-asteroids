note
	description: "2d vector class."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	VECTOR2

inherit
	ANY
		redefine
			default_create,
			out
		end

	SINGLE_MATH_UTILS
		undefine
			default_create,
			out
		end

create
	default_create


feature -- Access

	x: REAL assign set_x
			-- X coordinate.

	y: REAL assign set_y
			-- Y coordinate.


feature -- Initialization

	default_create
		do
		end


feature -- Access

	set (a_x: like x; a_y: like y)
			-- Sets the vector's coordinates.
		do
			x := a_x
			y := a_y
		ensure
			x_set: x = a_x
			y_set: y = a_y
		end

	set_zero
			-- Sets the vector's coordinates to zero.
		do
			set (0.0, 0.0)
		end

	set_unit (a_angle: REAL)
			-- Sets the vector to a unit length vector with given angle.
		do
			set (-cos(a_angle), sin(a_angle))
		end

	set_random(a_min_x, a_max_x: like x; a_min_y, a_max_y: like y)
			-- Sets the vector's coordinates to random values (a_min_x..a_max_x,a_min_y..a_max_x).
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

	length: REAL
			-- Length of vector.
		do
			Result := sqrt (length_squared)
		ensure
			check_result: Result = sqrt (length_squared)
		end

	length_squared: REAL
			-- Squared length of vector.
		do
			Result := x * x + y * y
		ensure
			check_result: Result = (x * x + y * y)
		end

	normalized: VECTOR2
			-- Returns a normalized version of the vector.
		do
			Result := Current / length
		end


feature -- Vector operations

	plus alias "+" (other: like Current): like Current
			-- Adds two vectors.
		do
			Result.set (x + other.x, y + other.y)
		end

	minus alias "-" (other: like Current): like Current
			-- Subtracts two vectors.
		do
			Result.set (x - other.x, y - other.y)
		end

	product alias "*" (a_factor: REAL): like Current
			-- Scalar multiplication.
		do
			Result.set (x * a_factor, y * a_factor)
		end

	quotient alias "/" (a_divisor: REAL): like Current
			-- Scalar division.
		require
			divisor_not_zero: a_divisor /= 0.0
		do
			Result.set (x / a_divisor, y / a_divisor)
		end

	identity alias "+": like Current
			-- Unary plus.
		do
			Result.set (x, y)
		ensure
			result_is_same: is_equal(Result)
		end

	opposite alias "-": like Current
			-- Unary minus.
		do
			Result.set (-x, -y)
		ensure
			result_is_negation: Result.x = -x and Result.y = -y
		end

	dot_product (other: like Current): REAL
			-- Dot product.
		do
			Result := x * other.x + y * other.y
		ensure
			result_calculated: Result = x * other.x + y * other.y
		end

	distance (other: like Current): REAL
			-- Distance to another vector.
		do
			Result := (other - Current).length
		end

	distance_squared (other: like Current): REAL
			-- Squared distance to another vector.
		do
			Result := (other - Current).length_squared
		end


feature -- Output

	out: STRING
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
