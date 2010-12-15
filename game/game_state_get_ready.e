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
			activate,
			deactivate,
			handle_key
		end

create
	make


feature -- Activation

	activate
			-- Called to activate the scene.
		do
			game.player.active := False
			game.world.prepare_level (game.level)
			set_message ("ENTERING LEVEL " + game.level.out + " - PRESS ENTER TO START!")
		end

	deactivate
			-- Called to deactivate the scene.
		do
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
