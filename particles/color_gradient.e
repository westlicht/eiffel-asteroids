note
	description: "Implements color gradients used for particle systems."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	COLOR_GRADIENT

create
	make


feature -- Access

	markers: LINKED_LIST [COLOR_GRADIENT_MARKER]
			-- List of gradient markers.

	default_color: COLOR
			-- Default color.


feature -- Initialization

	make
		do
			create markers.make
		end


feature -- Markers

	put_marker (a_color: COLOR; a_position: REAL)
		require
			position_in_range: 0 <= a_position and a_position <= 1.0
		local
			marker: COLOR_GRADIENT_MARKER
		do
			create marker.make (a_color, a_position)
			markers.extend (marker)
		end

	get_sample (position: REAL): COLOR
		do
			if markers.is_empty then
				Result := default_color
			else
				if position < markers.first.position then
					Result := markers.first.color
				elseif position > markers.last.position then
					Result := markers.last.color
				else
					-- Interpolate
					Result := markers.first.color.blend (markers.last.color, position)
				end
			end
		end



invariant
	markers_exists: markers /= Void

end
