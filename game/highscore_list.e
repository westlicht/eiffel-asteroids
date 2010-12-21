note
	description: "List of high scores."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HIGHSCORE_LIST

inherit
	SORTED_TWO_WAY_LIST [HIGHSCORE]
		redefine
			make,
			extend,
			wipe_out
		end

create
	make


feature -- Access

	max_score: NUMERIC_VALUE [INTEGER]
			-- Maximum highscore.


feature -- Initialization

	make
		do
			Precursor
			create max_score.make (0, 1000000, 0)
		end


feature -- List overrides

	extend (a_highscore: HIGHSCORE)
		do
			Precursor (a_highscore)
			max_score.set_value (first.score)
		end

	wipe_out
		do
			Precursor
			max_score.set_value (0)
		end


feature -- Serialization

	load_from_file (a_filename: STRING)
			-- Loads the highscores from a file. TODO ugly ugly code!!!
		require
			valid_filename: a_filename /= Void and then not a_filename.is_empty
		local
			file: RAW_FILE
			name: STRING
			score: INTEGER
			date: DATE_TIME
		do
			wipe_out
			create file.make_open_read (a_filename)
			if file.is_open_read then
				from
					file.start
				until
					file.after
				loop
					-- Read highscore record
					if file.file_readable then
						file.read_line
						create name.make_from_string (file.last_string)
						if file.file_readable then
							file.read_integer
							score := file.last_integer
							if file.file_readable then
								file.read_integer
								create date.make_from_epoch (file.last_integer)

								-- Create record
								extend (create {HIGHSCORE}.make(name, score, date))
							end
						end
					end
				end
				file.close
			end
		end

	save_to_file (a_filename: STRING)
			-- Saves the highscores to a file.
		require
			valid_filename: a_filename /= Void and then not a_filename.is_empty
		local
			file: RAW_FILE
			cur: LINKED_LIST_ITERATION_CURSOR [HIGHSCORE]
		do
			create file.make_open_write (a_filename)
			if file.is_open_write then
				cur := new_cursor
				from
					cur.start
				until
					cur.after
				loop
					file.put_string (cur.item.name)
					file.put_new_line
					file.put_integer (cur.item.score)
					file.put_integer (cur.item.date.duration.second)
					cur.forth
				end
				file.close
			end
		end


invariant
	max_score_exists: max_score /= Void
	max_score_correct: not is_empty implies max_score.value = first.score

end
