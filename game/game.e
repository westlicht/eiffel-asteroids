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

	Absolute_path: STRING
			-- Absolute path of executable. TODO is there really no usable pathname abstraction in Eiffel?
		local
			ee: EXECUTION_ENVIRONMENT
			index, t: INTEGER
		once
			create ee
			create Result.make_from_string (ee.command_line.command_name)
			index := Result.last_index_of ('/', Result.count)
			t := Result.last_index_of ('\', Result.count)
			if t > index then
				index := t
			end
			Result.remove_tail (Result.count - index)
		end

	Highscore_filename: STRING
			-- Filename for highscore file.
		once
			create Result.make_from_string (Absolute_path + "highscore.dat")
		end


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

	highscore: HIGHSCORE_LIST
			-- List of high scores.


feature -- Game states

	state_intro: GAME_STATE_INTRO
	state_help: GAME_STATE_HELP
	state_select_level: GAME_STATE_SELECT_LEVEL
	state_get_ready: GAME_STATE_GET_READY
	state_run: GAME_STATE_RUN
	state_victory: GAME_STATE_VICTORY
	state_game_over: GAME_STATE_GAME_OVER
	state_new_highscore: GAME_STATE_NEW_HIGHSCORE
	state_highscore: GAME_STATE_HIGHSCORE
	state_pause: GAME_STATE_PAUSE
	state_exit: GAME_STATE_EXIT


feature -- Initialization

	make (a_engine: ENGINE)
			-- Creates the game.
		do
			make_with_engine (a_engine)

			level := Level_min

			-- Create highscores
			create highscore.make
			highscore.load_from_file (Highscore_filename)

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
			create state_new_highscore.make (Current)
			create state_highscore.make (Current)
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
