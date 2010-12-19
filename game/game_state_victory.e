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
			set_title ("VICTORY")
			set_message ("Your current score is " + game.player.score.value.out + ". Press ENTER to continue with the next level.")
			game.player.active := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key.name.is_equal ("enter") then
					game.engine.bullet_manager.kill_all_bullets
					game.state_manager.switch_state(game.state_get_ready)
				end
			end
		end

end
