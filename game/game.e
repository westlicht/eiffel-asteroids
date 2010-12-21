note
	description: "Implements main logic of the game."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ENGINE_OBJECT

create
	make


feature -- Constants

	Level_min: INTEGER = 1

	Level_max: INTEGER = 10

feature -- Access

	world: WORLD
			-- World.

	player: PLAYER
			-- Player.

	hud: HUD
			-- HUD.

	state_manager: GAME_STATE_MANAGER
			-- Game state manager.

	level: INTEGER assign set_level
			-- Current level.


feature -- Game states

	state_intro: GAME_STATE_INTRO
	state_help: GAME_STATE_HELP
	state_select_level: GAME_STATE_SELECT_LEVEL
	state_get_ready: GAME_STATE_GET_READY
	state_run: GAME_STATE_RUN
	state_victory: GAME_STATE_VICTORY
	state_game_over: GAME_STATE_GAME_OVER
	state_pause: GAME_STATE_PAUSE
	state_exit: GAME_STATE_EXIT


feature -- Initialization

	make (a_engine: ENGINE)
			-- Creates the game.
		do
			make_with_engine (a_engine)

			level := Level_min

			-- Create the world
			create world.make (Current)

			-- Create player
			create player.make (Current)
			engine.put_object (player)

			-- Create HUD
			create hud.make (Current)

			-- Create game state manager and game states
			create state_manager.make (Current)
			engine.put_object (state_manager)

			create state_intro.make (Current)
			create state_help.make (Current)
			create state_select_level.make (Current)
			create state_get_ready.make (Current)
			create state_run.make (Current)
			create state_victory.make (Current)
			create state_game_over.make (Current)
			create state_pause.make (Current)
			create state_exit.make (Current)

			state_manager.switch_state (state_intro)
		end


feature -- Access

	set_level (a_level: like level)
		require
			valid_level: Level_min <= a_level and a_level <= Level_max
		do
			level := a_level
		end

end
