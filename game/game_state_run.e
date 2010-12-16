note
	description: "Summary description for {GAME_STATE_RUN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_RUN

inherit
	GAME_STATE
		redefine
			enter,
			update
		end

create
	make


feature -- State

	enter
			-- Called to enter the state.
		do
			game.player.reset
			game.player.active := True
		end


feature -- Updateing

	update (t: REAL)
			-- Called to update the state.
		do
			if game.player.health.value = 0.0 then
				game.state_manager.switch_state (game.state_game_over)
			end
			if game.engine.object_count_by_type ("ASTEROID") = 0 then
				game.level := game.level + 1
				game.state_manager.switch_state (game.state_get_ready)
			end
		end

end
