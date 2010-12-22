note
	description: "Summary description for {GAME_STATE_HELP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_HELP

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
			-- Text.

feature -- State

	make (a_game: GAME)
		do
			Precursor (a_game)

			create text.make_empty

			text.append ("Mission:%N%N")
			text.append ("Destroy all the asteroids before they destroy you!%N%N")
			text.append ("Controls:%N%N")
			text.append ("LEFT - Rotate ship left%N")
			text.append ("RIGHT - Rotate ship right%N")
			text.append ("UP - Thrust%N")
			text.append ("SPACE - Shoot%N")
			text.append ("SHIFT - Shield%N")
			text.append ("ESC - Back/Pause/Exit%N")
			text.append ("%N%NPress ENTER to exit help screen.")
		end

	enter
			-- Called to enter the state.
		do
			Precursor
			game.player.active := False
			set_title ("HELP")
			set_message (text)
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_last_state
				elseif key = game.engine.input_manager.key_escape then
					game.state_manager.switch_last_state
				end
			end
		end

end
