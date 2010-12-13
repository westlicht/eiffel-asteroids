note
	description: "Root class for the ASTEROIDS game."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	EV_APPLICATION

create
	make

feature -- Constants

	size_x: INTEGER = 600
			-- Main window width.

	size_y: INTEGER = 600
			-- Main window height.


feature {NONE} -- Local attributes

	main_window: EV_TITLED_WINDOW
			-- Main window.

	container: EV_FIXED
			-- Container on main window.

	drawing_area: EV_PIXMAP
			-- Drawing area on main window.

	engine: ENGINE
			-- Game engine.


feature -- Initialization

	make
		do
			default_create

			-- Create main window
			create main_window.make_with_title ("ASTEROIDS")

			-- Set screen size
			main_window.set_size (size_x, size_y)

			-- Destroy window on closing
			main_window.close_request_actions.extend (agent destroy)

			-- Create widgets on main window
			create container
			main_window.extend (container)
			create drawing_area.default_create
			drawing_area.set_size (size_x, size_y)
			container.extend (drawing_area)

			-- Create engine
			create engine.make (main_window, drawing_area)

			-- Load the world
			load_particle_settings
			load_world

			-- Add idle action to be called regularly
			add_idle_action (agent update)

			-- Show main window
			main_window.show

			-- Start message loop
			launch
		end

	load_particle_settings
		local
			settings: PARTICLE_SETTINGS
		do
			create settings.make
			settings.spread := 0.2
			settings.velocity := 100.0
			settings.velocity_random := 0.5
			settings.rate := 100.0
			settings.life_time := 1.5
			settings.drag := 0.5
			engine.particle_manager.put_settings (settings, "engine")

			create settings.make
			settings.spread := 6.283
			settings.velocity := 150.0
			settings.velocity_random := 0.5
			settings.rate := 100.0
			settings.life_time := 1.5
			settings.drag := 0.3
			engine.particle_manager.put_settings (settings, "explosion")
		end

	load_world
			-- Prepares the game world.
		local
			background: BACKGROUND
			asteroid: ASTEROID
			i: INTEGER
			player: PLAYER
			hud: HUD
		do
			create background.make (engine)
			engine.put_object (background)

			from i := 1 until i > 3 loop
				create asteroid.make_with_category (engine, 3)
				engine.put_object (asteroid)
				i := i + 1
			end

			create player.make (engine)
			engine.put_object (player)

			create hud.make (engine, player)
			engine.put_object (hud)
		end

	update
			-- Called repeatatly to update the game.
		do
			engine.update
			engine.draw
		end

end
