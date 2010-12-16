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
			set_message ("GAME OVER! PRESS ENTER TO RESTART")
			game.player.active := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key.name.is_equal ("enter") then
					game.state_manager.switch_state(game.state_start)
				end
			end
		end

end
