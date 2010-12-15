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

	size_x: INTEGER = 800
			-- Main window width.

	size_y: INTEGER = 800
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
			load_hud

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

	load_world
			-- Prepares the game world.
		local
			background: BACKGROUND
			asteroid: ASTEROID
			i: INTEGER
			player: PLAYER
			hud: HUD_MANAGER
		do
			create background.make (engine)
			engine.put_object (background)

			from i := 1 until i > 4 loop
				create asteroid.make_with_category (engine, 3)
				engine.put_object (asteroid)
				i := i + 1
			end

			create player.make (engine)
			engine.put_object (player)
		end


feature -- HUD

	Health_bar_position: VECTOR2
			-- Position of health bar.
		once
			create Result.make (10.0, 10.0)
		end

	Health_bar_color: COLOR
			-- Color of health bar.
		once
			Result.make_with_rgb (1.0, 0.2, 0.2)
		end

	Energy_bar_position: VECTOR2
			-- Position of energy bar.
		once
			create Result.make (10.0, 30.0)
		end

	Energy_bar_color: COLOR
			-- Color of energy bar.
		once
			Result.make_with_rgb (0.2, 0.2, 1.0)
		end

	Bar_size: VECTOR2
			-- Bar size.
		once
			create Result.make (150.0, 12.0)
		end

	Text_color: COLOR
			-- Color of HUD text.
		once
			Result.make_with_rgb (0.8, 0.8, 0.8)
		end


	load_hud
		local
			bar: HUD_BAR
		do
			-- Create health bar
			create bar.make (engine.hud_manager)
			bar.position := Health_bar_position
			bar.size := Bar_size
			bar.bar_color := Health_bar_color
			engine.hud_manager.put_widget (bar)

			-- Create energy
			create bar.make (engine.hud_manager)
			bar.position := Energy_bar_position
			bar.size := Bar_size
			bar.bar_color := Energy_bar_color
			engine.hud_manager.put_widget (bar)
		end


	update
			-- Called repeatatly to update the game.
		do
			engine.update
			engine.draw
		end

end
