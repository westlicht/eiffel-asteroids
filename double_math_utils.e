note
	description: "A few math utilities."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	DOUBLE_MATH_UTILS

inherit
	DOUBLE_MATH


feature -- Operations

	cos (angle: REAL_64): REAL_64
			-- Cosine function that handles all input (radian).
		do
			Result := sin (Pi/2 - angle)
		end

	sin (angle: REAL_64): REAL_64
			-- Sine function that handles all input (in radian).
		local
			rad: REAL_64
		do
			from
				rad := angle
			until
				rad >= 0 and rad <= 2*Pi
			loop
				if rad < 0 then
					rad := rad + 2 * Pi
				else
					rad := rad - 2 * Pi
				end
			end
			if rad <= Pi / 4 then
				Result := sine (rad)
			elseif rad <= Pi / 2 then
				Result := cosine (Pi/2 - rad)
			elseif rad <= Pi then
				Result := sin (Pi-rad)
			elseif rad <= 3/2*Pi then
				Result := - sin (rad - Pi)
			else
				Result := - sin (2*Pi - rad)
			end
		end

end
