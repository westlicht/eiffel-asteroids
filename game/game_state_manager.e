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

	states: LINKED_LIST [GAME_STATE]
			-- List of game states.

	idle_state: GAME_STATE
			-- Placeholder for empty state.

	active_state: GAME_STATE
			-- Currently active game state.


feature {NONE} -- Local attributes

	next_state: GAME_STATE
			-- Next state.


feature -- Initialization

	make (a_game: GAME)
		do
			make_with_engine (a_game.engine)
			game := a_game
			create states.make
			create idle_state.make (game)
			engine.input_manager.put_key_handler (agent key_handler)

			active_state := idle_state
		end


feature -- States

	put_state (a_state: GAME_STATE)
			-- Adds a game state to the manager.
		require
			state_exists: a_state /= Void
			state_not_put: not states.has (a_state)
		do
			states.extend (a_state)
		end

	switch_state (a_state: GAME_STATE)
			-- Switch the game state.
		require
			state_exists: a_state /= Void
			state_put: states.has (a_state)
		do
			next_state := a_state
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the scene.
		do
			active_state.update (t)
			if next_state /= Void then
				active_state.deactivate
				next_state.activate
				active_state := next_state
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
	states_exists: states /= Void
	idle_state_exists: idle_state /= Void
	active_state_assigned: active_state /= Void

end
