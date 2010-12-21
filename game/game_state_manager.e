note
	description: "Manages game states."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_MANAGER

inherit
	ENGINE_OBJECT
		redefine
			update
		end

create
	make


feature -- Access

	game: GAME
			-- Game.

	idle_state: GAME_STATE
			-- Placeholder for empty state.

	active_state: GAME_STATE
			-- Currently active game state.

	state_stack: LINKED_STACK [GAME_STATE]
			-- Stack of game states.


feature {NONE} -- Local attributes

	next_state: GAME_STATE
			-- Next state.


feature -- Initialization

	make (a_game: GAME)
		do
			make_with_engine (a_game.engine)
			game := a_game
			create idle_state.make (game)
			engine.input_manager.put_key_handler (agent key_handler)

			active_state := idle_state
			create state_stack.make
		end


feature -- States

	switch_state (a_state: GAME_STATE)
			-- Switch the game state.
		require
			state_exists: a_state /= Void
		do
			next_state := a_state
			-- Switch mode even if engine is paused
			if engine.paused then
				update (0.0)
			end
		end

	switch_last_state
			-- Switches to the last game state.
		require
			has_last_state: not state_stack.is_empty
		local
			last_state: GAME_STATE
		do
			state_stack.remove
			last_state := state_stack.item
			state_stack.remove
			switch_state (last_state)
		end



feature -- Updateing

	update (t: REAL)
			-- Updates the scene.
		do
			active_state.update (t)
			if next_state /= Void then
				active_state.leave
				next_state.enter
				active_state := next_state
				state_stack.put (active_state)
				next_state := Void
			end
		end


feature {NONE} -- Implementation

	key_handler (a_key: INPUT_KEY; pressed: BOOLEAN)
		do
			if active_state /= Void then
				active_state.handle_key (a_key, pressed)
			end
		end


invariant
	game_exists: game /= Void
	idle_state_exists: idle_state /= Void
	active_state_assigned: active_state /= Void
	state_stack_exists: state_stack /= Void

end
