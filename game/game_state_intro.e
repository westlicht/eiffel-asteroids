note
	description: "Summary description for {GAME_STATE_INTRO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_INTRO

inherit
	GAME_STATE
		redefine
			enter,
			handle_key
		end

create
	make


feature -- State

	enter
			-- Called to enter the state.
		do
			game.player.active := False
			game.world.prepare_level (game.level)
			set_title ("WELCOME TO ASTEROIDS")
			set_message ("Press SHIFT for help, press ENTER to continue")
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_state(game.state_select_level)
				elseif key = game.engine.input_manager.key_shift then
					game.state_manager.switch_state (game.state_help)
				end
			end
		end

end
