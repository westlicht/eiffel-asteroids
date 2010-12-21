note
	description: "Represents a high score entry in the high score table."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HIGHSCORE

inherit
	COMPARABLE


create
	make


feature -- Access

	name: STRING
			-- Player's name.

	score: INTEGER
			-- Player's score.

	date: DATE_TIME
			-- Date of highscore.


feature -- Initialization

	make (a_name: STRING; a_score: INTEGER; a_date: DATE_TIME)
			-- Creates a high score entry.
		require
			valid_name: a_name /= Void and then not a_name.is_empty
			date_exists: a_date /= Void
		do
			create name.make_from_string (a_name)
			score := a_score
			create date.make_by_date_time (a_date.date, a_date.time)
		end


feature -- Comparing

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := score > other.score
		end


invariant
	valid_name: name /= Void and then not name.is_empty
	valid_score: score >= 0
	date_exists: date /= Void

end
