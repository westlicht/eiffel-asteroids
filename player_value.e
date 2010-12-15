note
	description: "Represents a single player attribute value like health, energy etc."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER_VALUE

create
	make


feature -- Access

	value: REAL
			-- Current value.

	min: like value
			-- Minimum value.

	max: like value
			-- Maximum value.

	range: like value
			-- Range of value.
		do
			Result := max - min
		end

	low: BOOLEAN
			-- True if current value is at minimum.
		do
			Result := value <= min
		end

	high: BOOLEAN
			-- True if current value is at maximum.
		do
			Result := value >= max
		end


feature -- Initialization

	make (a_min, a_max, a_value: like value)
		require
			valid_min_max: a_min <= a_max
			valid_value: a_min <= a_value and a_value <= a_max
		do
			min := a_min
			max := a_max
			value := a_value
		end


feature -- Manipulation

	increment (a_value: like value)
			-- Increments the value.
		require
			value_positive: a_value >= 0.0
		do
			value := value + a_value
			if value > max then
				value := max
			end
		end

	decrement (a_value: like value)
			-- Decrements the value.
		require
			value_positive: a_value >= 0.0
		do
			value := value - a_value
			if value < min then
				value := min
			end
		end


invariant
	valid_min_max: min <= max
	valid_value: min <= value and value <= max

end
