note
	description: "Summary description for {GAME_STATE_PAUSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_PAUSE

inherit
	GAME_STATE
		redefine
			enter,
			leave,
			handle_key
		end

create
	make


feature -- State

	enter
			-- Called to enter the state.
		do
			Precursor
			set_title ("PAUSED")
			set_message ("Press ENTER to exit the game, ESC to go back.")
			game.player.active := False
			game.engine.paused := True
		end

	leave
			-- Called to leave the state.
		do
			Precursor
			game.engine.paused := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_state (game.state_exit)
				elseif key = game.engine.input_manager.key_escape then
					game.state_manager.switch_last_state
				end
			end
		end

end
