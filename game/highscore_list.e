note
	description: "List of high scores."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HIGHSCORE_LIST

inherit
	SORTED_TWO_WAY_LIST [HIGHSCORE]
		rename
			extend as list_extend
		redefine
			make,
			wipe_out
		end

create
	make


feature -- Constants

	Max_count: INTEGER = 8
			-- Maximum number of highscore entries.


feature -- Access

	max_score: NUMERIC_VALUE [INTEGER]
			-- Maximum highscore.


feature -- Initialization

	make
			-- Initializes the highscore list.
		do
			Precursor
			create max_score.make (0, 1000000, 0)
		end


feature -- Highscore management

	insert (a_highscore: HIGHSCORE)
			-- Inserts a new highscore into the highscore list.
		do
			list_extend (a_highscore)
			max_score.set_value (first.score)
			if count > Max_count then
				start
				prune (last)
			end
		end

	wipe_out
			-- Wipes out the highscore list.
		do
			Precursor
			max_score.set_value (0)
		end

	is_highscore (score: INTEGER): BOOLEAN
			-- Checks if a given score is a valid new highscore.
		do
			if count < Max_count then
				Result := True
			else
				Result := score < last.score
			end
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
			create file.make (a_filename)
			if file.exists and then file.is_readable then
				file.open_read
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
								insert (create {HIGHSCORE}.make(name, score, date))
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
	check_max_count: count <= Max_count

end
