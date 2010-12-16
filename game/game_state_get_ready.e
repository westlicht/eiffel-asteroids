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
			set_title ("ENTERING LEVEL " + game.level.out)
			set_message ("Press ENTER to start the level")
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key.name.is_equal ("enter") then
					game.state_manager.switch_state(game.state_run)
				end
			end
		end

end
