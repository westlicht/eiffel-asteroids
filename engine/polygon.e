note
	description: "Represents simple 2d polygons."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	POLYGON

inherit
	SINGLE_MATH

create
	make_from_points, make_box


feature -- Access

	points: ARRAY[VECTOR2]
			-- List of polygon points


feature -- Creation

	make_from_points (a_points: ARRAY[VECTOR2])
			-- Creates a polygon using the given points.
		require
			points_exists: a_points /= Void
			min_points: a_points.count >= 3
		do
			create points.make_from_array (a_points)
		ensure
			points_copied: points.count = a_points.count
		end

	make_box (size: REAL)
			-- Creates a polygon in the shape of a box with given side length.
		require
			size_positive: size > 0.0
		local
			half: REAL
			v: VECTOR2
		do
			half := size / 2.0
			create points.make (1, 4)
			v.set (-half, -half)
			points [1] := v
			v.set (half, -half)
			points [2] := v
			v.set (half, half)
			points [3] := v
			v.set (-half, half)
			points [4] := v
		ensure
			points_count: points.count = 4
		end


feature -- Calculations

	radius: REAL
			-- Computes the radius of the bounding sphere of the polygon.
			-- Origin of the bounding sphere is assumed to be (0,0).
		local
			i: INTEGER
			t: REAL
		do
			Result := 0.0
			from i := 1 until i > points.count loop
				t := points[i].length_squared
				if t > Result then
					Result := t
				end
				i := i + 1
			end
			Result := sqrt(Result)
		end

feature -- Operations

	transform_to_screen (m: MATRIX3): ARRAY[EV_COORDINATE]
			-- Transforms the polygon to screen coordinates.
		require
			m_exists: m /= Void
		local
			i: INTEGER
			v: VECTOR2
			coord: EV_COORDINATE
		do
			create Result.make (1, points.count)
			from i := 1 until i > points.count loop
				v := m.transform (points[i])
				create coord.make (v.x.rounded, v.y.rounded)
				Result[i] := coord
				i := i + 1
			end
		end


invariant
	points_exist: points /= Void
	points_count: points.count >= 3

end
