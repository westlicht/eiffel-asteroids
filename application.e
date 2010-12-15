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

	game: GAME
			-- Game.


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

			-- Create game
			create game.make (engine)
			engine.put_object (game)

			-- Add idle action to be called regularly
			add_idle_action (agent update)

			-- Show main window
			main_window.show

			-- Start message loop
			launch
		end


	update
			-- Called repeatatly to update the game.
		do
			engine.update
			engine.draw
		end

end
