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

	prepare_level (level: INTEGER)
		local
			asteroid: ASTEROID
			i: INTEGER
		do
			from i := 1 until i > 2 loop
				create asteroid.make_with_category (engine, 5)
				engine.put_object (asteroid)
				i := i + 1
			end
		end

	cleanup_level
		do

		end

feature {NONE} -- Particle settings

	load_particle_settings
		local
			settings: PARTICLE_SETTINGS
			color: COLOR
		do
			create settings.make
			settings.spread := 0.2
			settings.velocity := 100.0
			settings.velocity_random := 0.5
			settings.rate := 50.0
			settings.life_time := 1.0
			settings.drag := 0.5
			color.make_with_rgb (1.0, 1.0, 1.0)
			settings.color_gradient.put_marker (color, 0.0)
			color.make_with_rgb (0.0, 0.0, 0.0)
			settings.color_gradient.put_marker (color, 1.0)
			engine.particle_manager.put_settings (settings, "engine")

			create settings.make
			settings.spread := 6.283
			settings.velocity := 100.0
			settings.velocity_random := 0.7
			settings.rate := 100.0
			settings.life_time := 1.5
			settings.drag := 0.6
			color.make_with_rgb (1.0, 1.0, 1.0)
			settings.color_gradient.put_marker (color, 0.0)
			color.make_with_rgb (0.0, 0.0, 0.0)
			settings.color_gradient.put_marker (color, 1.0)
			engine.particle_manager.put_settings (settings, "explosion")
		end


invariant
	game_exists: game /= Void
	engine_assigned: engine /= Void

end
