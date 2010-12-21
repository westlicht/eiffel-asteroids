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

	help_text: STRING
			-- Help text.

feature -- State

	make (a_game: GAME)
		do
			Precursor (a_game)

			create help_text.make_empty

			help_text.append ("Mission:%N%N")
			help_text.append ("Destroy all the asteroids before they destroy you!%N%N")
			help_text.append ("Controls:%N%N")
			help_text.append ("LEFT - Rotate ship left%N")
			help_text.append ("RIGHT - Rotate ship right%N")
			help_text.append ("UP - Thrust%N")
			help_text.append ("SPACE - Shoot%N")
			help_text.append ("SHIFT - Shield%N")
			help_text.append ("ESC - Back/Pause/Exit%N")
			help_text.append ("%N%NPress ENTER to exit help screen.")
		end

	enter
			-- Called to enter the state.
		do
			Precursor
			game.player.active := False
			set_title ("HELP")
			set_message (help_text)
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

end
