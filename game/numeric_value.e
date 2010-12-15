note
	description: "Represents a numeric values (attributes) like health, energy etc."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	NUMERIC_VALUE

create
	make


feature -- Access

	value: REAL assign set_value
			-- Current value.

	min: like value assign set_min
			-- Minimum value.

	max: like value assign set_max
			-- Maximum value.

	range: like value
			-- Range of value.
		do
			Result := max - min
		end

	observers: LINKED_LIST [PROCEDURE [ANY, TUPLE [value: like Current]]]
			-- List of observers.

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
			value := a_value
			min := a_min
			max := a_max
			create observers.make
		end


feature -- Manipulation

	set_value (a_value: like value)
		require
			value_in_range: is_in_range (a_value)
		do
			if a_value /= value then
				value := a_value
				notify_observers
			end
		end

	set_min (a_min: like min)
		require
			valid_min: a_min <= max
		do
			if a_min /= min then
				min := a_min
				notify_observers
			end
		end

	set_max (a_max: like max)
		require
			valid_max: a_max >= min
		do
			if a_max /= max then
				max := a_max
				notify_observers
			end
		end

	increment (a_increment: like value)
			-- Increments the value.
		require
			increment_positive: a_increment >= 0.0
		do
			if value + a_increment > max then
				set_value (max)
			else
				set_value (value + a_increment)
			end
		end

	decrement (a_decrement: like value)
			-- Decrements the value.
		require
			decrement_positive: a_decrement >= 0.0
		do
			if value - a_decrement < min then
				set_value (min)
			else
				set_value (value - a_decrement)
			end
		end


feature -- Consistency

	is_in_range (a_value: like value): BOOLEAN
		do
			Result := min <= a_value and a_value <= max
		end

feature -- Observers

	register_observer (a_observer: PROCEDURE [ANY, TUPLE [value: like Current]])
			-- Registers an observer to be called when the value, min or max change.
		require
			observer_exists: a_observer /= Void
			observer_not_added: not observers.has (a_observer)
		do
			observers.extend (a_observer)
			notify_observer (a_observer)
		end


feature {NONE} -- Implementation

	notify_observers
			-- Notify all registered observers.
		do
			observers.do_all (agent notify_observer (?))
		end

	notify_observer (a_observer: PROCEDURE [ANY, TUPLE [value: like Current]])
			-- Notify a single observer.
		do
			a_observer.call ([Current])
		end


invariant
	valid_min_max: min <= max
	value_in_range: is_in_range (value)
	observers_exists: observers /= Void

end
