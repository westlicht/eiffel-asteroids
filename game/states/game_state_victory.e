note
	description: "Summary description for {GAME_STATE_VICTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_VICTORY

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
			Precursor
			set_title ("VICTORY")
			set_message ("Your current score is " + game.player.score.value.out + ".%N%NPress ENTER to continue with the next level or ESC to end the game.")
			game.player.active := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.engine.bullet_manager.kill_all_bullets
					game.state_manager.switch_state(game.state_get_ready)
				elseif key = game.engine.input_manager.key_escape then
					game.state_manager.switch_state (game.state_game_over)
				end
			end
		end

end
