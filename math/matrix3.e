note
	description: "3x3 matrix class."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	MATRIX3

inherit
	ANY
		redefine
			out
		end

	SINGLE_MATH_UTILS
		undefine
			out
		end


create
	make, make_identity, make_translation, make_rotation, make_scaling


feature -- Constants

	Size: INTEGER = 3
			-- Number of rows/cols


feature {NONE} -- Local attributes

	elements: ARRAY2[REAL]
			-- Elements of the matrix indexed by (row, column).


feature {NONE} -- Initialization

	make
			-- Creates a zero matrix.
		do
			create elements.make (Size, Size)
		end

	make_identity
			-- Creates an identity matrix.
		do
			make
			set_element(1, 1, 1.0)
			set_element(2, 2, 1.0)
			set_element(3, 3, 1.0)
		end

	make_translation (a_position: VECTOR2)
			-- Creates a translation matrix.
		require
			position_exists: a_position /= Void
		do
			make_identity
			set_element(1, 3, a_position.x)
			set_element(2, 3, a_position.y)
		end

	make_rotation (a_angle: REAL)
			-- Creates a rotation matrix.
		do
			make
			set_element(1, 1, cos(a_angle))
			set_element(1, 2, -sin(a_angle))
			set_element(2, 1, sin(a_angle))
			set_element(2, 2, cos(a_angle))
			set_element(3, 3, 1.0)
		end

	make_scaling (a_scale: REAL)
			-- Creates a scaling matrix.
		do
			make
			set_element(1, 1, a_scale)
			set_element(2, 2, a_scale)
			set_element(3, 3, 1.0)
		end


feature -- Operations

	infix "*" (other: like Current): like Current
			-- Matrix multiplication.
		require
			other_exists: other /= Void
		local
			row, col, i: INTEGER
			t: REAL
		do
			create Result.make
			from row := 1 until row > Size loop
				from col := 1 until col > Size loop
					t := 0.0
					from i := 1 until i > Size loop
						t := t + Current.element (row, i) * other.element (i, col)
						i := i + 1
					end
					Result.set_element(row, col, t)
					col := col + 1
				end
				row := row + 1
			end
		end


	transform (v: VECTOR2): VECTOR2
			-- Vector multiplication.
		require
			v_exists: v /= Void
		do
			create Result.make (
				Current.element (1, 1) * v.x + Current.element (1, 2) * v.y + Current.element (1, 3),
				Current.element (2, 1) * v.x + Current.element (2, 2) * v.y + Current.element (2, 3)
			)
		end

	transform_no_translation (v: VECTOR2): VECTOR2
			-- Vector multiplication without taking translation into account.
		require
			v_exists: v /= Void
		do
			create Result.make (
				Current.element (1, 1) * v.x + Current.element (1, 2) * v.y,
				Current.element (2, 1) * v.x + Current.element (2, 2) * v.y
			)
		end


feature -- Element access

	element (row, col: INTEGER): REAL
			-- Gets an element of the matrix.
		require
			valid_row: 1 <= row and row <= Size
			valid_col: 1 <= col and col <= Size
		do
			Result := elements.item (row, col)
		end

	set_element (row, col: INTEGER; value: REAL)
			-- Sets an element of the matrix.
		require
			valid_row: 1 <= row and row <= Size
			valid_col: 1 <= col and col <= Size
		do
			elements.item (row, col) := value
		end


feature -- Output

	out: STRING
		do
			-- TODO implement
		end

invariant
	elements_exists: elements /= Void
	elements_size: elements.width = Size and elements.height = Size

end
