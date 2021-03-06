note
	description: "Summary description for {SCENE_GAME_OVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_GAME_OVER

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
			set_title ("GAME OVER")
			set_message ("Press ENTER to restart the game.")
			game.player.active := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					if game.highscore.is_highscore (game.player.score.value) then
						game.state_manager.switch_state (game.state_new_highscore)
					else
						game.state_manager.switch_state(game.state_select_level)
					end
				end
			end
		end

end
