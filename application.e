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

	player: PLAYER
			-- Player.

	health_bar: HUD_BAR
	health_text: HUD_TEXT
	energy_bar: HUD_BAR
	energy_text: HUD_TEXT


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
		do
			-- Create health bar
			create health_bar.make (engine.hud_manager)
			health_bar.position := Health_bar_position
			health_bar.size := Bar_size
			health_bar.bar_color := Health_bar_color
			engine.hud_manager.put_widget (health_bar)

			-- Create health text
			create health_text.make (engine.hud_manager)
			health_text.position := health_bar.position
			health_text.position.x := health_bar.position.x + health_bar.size.x + 10.0
			engine.hud_manager.put_widget (health_text)

			-- Create energy
			create energy_bar.make (engine.hud_manager)
			energy_bar.position := Energy_bar_position
			energy_bar.size := Bar_size
			energy_bar.bar_color := Energy_bar_color
			engine.hud_manager.put_widget (energy_bar)

			-- Create energy text
			create energy_text.make (engine.hud_manager)
			energy_text.position := energy_bar.position
			energy_text.position.x := energy_bar.position.x + energy_bar.size.x + 10.0
			engine.hud_manager.put_widget (energy_text)


			-- Add observers for health and energy
			player.health.register_observer (agent health_changed)
			player.energy.register_observer (agent energy_changed)
		end

	health_changed (a_sender: NUMERIC_VALUE)
		do
			health_bar.min := a_sender.min
			health_bar.max := a_sender.max
			health_bar.value := a_sender.value
			health_text.text := "Health: " + a_sender.value.out + "/" + a_sender.max.out
		end

	energy_changed (a_sender: NUMERIC_VALUE)
		do
			energy_bar.min := a_sender.min
			energy_bar.max := a_sender.max
			energy_bar.value := a_sender.value
			energy_text.text := "Energy: " + a_sender.value.out + "/" + a_sender.max.out
		end


	update
			-- Called repeatatly to update the game.
		do
			engine.update
			engine.draw
		end

end
