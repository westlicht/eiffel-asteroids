note
	description: "Summary description for {GAME_STATE_HIGHSCORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_HIGHSCORE

inherit
	GAME_STATE
		redefine
			make,
			enter,
			handle_key
		end

create
	make

feature -- Access

	text: STRING
			-- Help text.

feature -- State

	make (a_game: GAME)
		do
			Precursor (a_game)

			create text.make_empty
		end

	enter
			-- Called to enter the state.
		do
			Precursor
			game.player.active := False
			set_title ("HIGHSCORE")
			update_text
			set_message (text)
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_state(game.state_intro)
				end
			end
		end


feature {NONE} -- Implementation

	update_text
		do
			create text.make_empty

			game.highscore.do_all (agent (highscore: HIGHSCORE)
				do
					text.append_string (highscore.name)
					text.append_string ("%N")
					text.append_integer (highscore.score)
					text.append_string ("%N%N")
				end
			)
		end

end
