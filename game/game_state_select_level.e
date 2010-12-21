note
	description: "Summary description for {SCENE_START}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_SELECT_LEVEL

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
			game.world.prepare_idle
			game.level := game.Level_min
			game.player.active := False
			game.player.score.value := game.player.score.min
			update_screen
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.state_manager.switch_state(game.state_get_ready)
				elseif key = game.engine.input_manager.key_up then
					if game.level < game.Level_max then
						game.level := game.level + 1
						update_screen
					end
				elseif key = game.engine.input_manager.key_down then
					if game.level > game.Level_min then
						game.level := game.level - 1
						update_screen
					end
				end
			end
		end


feature -- Implementation

	update_screen
		do
			set_title ("START LEVEL: " + game.level.out)
			set_message ("Press UP/DOWN to select start level, press ENTER to continue")
		end

end
