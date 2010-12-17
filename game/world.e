note
	description: "Support class to create/cleanup the world."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	WORLD

create
	make


feature -- Access

	game: GAME
			-- Game.

	engine: ENGINE
			-- Alias to game engine.

	background: BACKGROUND
			-- Background.

feature -- Initialization

	make (a_game: GAME)
			-- Creates the game world.
		require
			game_exists: a_game /= Void
		do
			game := a_game
			engine := game.engine

			-- Load particle settings
			load_particle_settings

			-- Create background
			create background.make (engine)
			engine.put_object (background)
		end


feature -- Level generation

	clear
		do
			engine.kill_objects_by_type ("ASTEROID")
		end

	prepare_idle
		local
			asteroid: ASTEROID
			i: INTEGER
		do
			clear
			from i := 1 until i > 20 loop
				random.forth
				create asteroid.make_with_category (engine, random.item \\ 3 + 1)
				engine.put_object (asteroid)
				i := i + 1
			end

		end

	prepare_level (a_level: INTEGER)
		local
			asteroid: ASTEROID
			i: INTEGER
		do
			clear
			from i := 1 until i > 3 loop
				create asteroid.make_with_category (engine, a_level)
				engine.put_object (asteroid)
				i := i + 1
			end
		end


feature {NONE} -- Particle settings

	load_particle_settings
		local
			settings: PARTICLE_SETTINGS
		do
			create settings.make
			settings.spread := 0.2
			settings.velocity := 100.0
			settings.velocity_random := 0.5
			settings.rate := 50.0
			settings.life_time := 1.0
			settings.drag := 0.5
			engine.particle_manager.put_settings (settings, "engine")

			create settings.make
			settings.spread := 6.283
			settings.velocity := 100.0
			settings.velocity_random := 0.7
			settings.rate := 100.0
			settings.life_time := 1.5
			settings.drag := 0.6
			engine.particle_manager.put_settings (settings, "explosion")
		end


feature {NONE} -- Random

	random: RANDOM
		once
			create Result.make
			Result.start
		end


invariant
	game_exists: game /= Void
	engine_assigned: engine /= Void

end
