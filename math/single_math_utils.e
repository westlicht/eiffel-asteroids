note
	description: "A few math utilities."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	SINGLE_MATH_UTILS

inherit
	SINGLE_MATH


feature -- Constants

	Pi_32: REAL_32
			-- PI as 32-bit single precision floating point.
		once
			Result := Pi.truncated_to_real
		end


feature -- Operations

	cos (angle: REAL_32): REAL_32
			-- Cosine function that handles all input (radian).
		do
			Result := sin (Pi_32 / 2 - angle)
		end

	sin (angle: REAL_32): REAL_32
			-- Sine function that handles all input (in radian).
		local
			rad: REAL_32
		do
			from
				rad := angle
			until
				rad >= 0 and rad <= 2 * Pi_32
			loop
				if rad < 0 then
					rad := rad + 2 * Pi_32
				else
					rad := rad - 2 * Pi_32
				end
			end
			if rad <= Pi_32 / 4 then
				Result := sine (rad)
			elseif rad <= Pi_32 / 2 then
				Result := cosine (Pi_32 / 2 - rad)
			elseif rad <= Pi_32 then
				Result := sin (Pi_32 - rad)
			elseif rad <= 3/2 * Pi_32 then
				Result := - sin (rad - Pi_32)
			else
				Result := - sin (2 * Pi_32 - rad)
			end
		end

end
