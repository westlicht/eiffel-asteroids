note
	description: "Summary description for {GAME_STATE_GET_READY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_GET_READY

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
			game.player.reset
			game.player.active := False
			game.world.prepare_level (game.level)
			game.hud.stats_visible := True
			set_title ("ENTERING LEVEL " + game.level.out)
			set_message ("Press ENTER to start the level.")
		end

	leave
			-- Called to leave the state.
		do
			Precursor
			game.player.reset
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_state(game.state_run)
				elseif key = game.engine.input_manager.key_escape then
					game.state_manager.switch_state (game.state_pause)
				end
			end
		end

end
