note
	description: "Single marker on a color gradient."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	COLOR_GRADIENT_MARKER

create
	make


feature -- Access

	color: COLOR
			-- Color associated with marker.

	position: REAL
			-- Position on gradient.

feature -- Initialization

	make (a_color: like color; a_position: like position)
		require
			position_in_range: 0 <= a_position and a_position <= 1.0
		do
			color := a_color
			position := a_position
		end

end
