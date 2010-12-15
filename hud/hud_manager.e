note
	description: "Implements the HUD (heads-up-displayer)."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HUD_MANAGER

inherit
	ENGINE_OBJECT
		redefine
			draw,
			update
		end

create
	make


feature -- Constants

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

feature -- Access

	player: PLAYER
			-- Player to get info from.

	widgets: LINKED_LIST [HUD_WIDGET]
			-- List of widgets.


feature -- Initialization

	make (a_engine: ENGINE)
		do
			make_with_engine (a_engine)
			create widgets.make
			set_layer_z (10)

			create_hud
		end


	create_hud
		local
			bar: HUD_BAR
		do
			-- Create health bar
			create bar.make (Current)
			bar.position := Health_bar_position
			bar.size := Bar_size
			bar.bar_color := Health_bar_color
			put_widget (bar)

			-- Create energy
			create bar.make (Current)
			bar.position := Energy_bar_position
			bar.size := Bar_size
			bar.bar_color := Energy_bar_color
			put_widget (bar)
		end



feature -- Widgets

	put_widget (a_widget: HUD_WIDGET)
		require
			widget_exists: a_widget /= Void
			widget_not_added: not widgets.has (a_widget)
		do
			widgets.extend (a_widget)
		end


feature -- Drawing

	draw
			-- Draws the object.
		do
			widgets.do_all (agent draw_widget)
		end


feature -- Updating

	update (t: REAL)
			-- Updates the object by t seconds.
		do
			widgets.do_all (agent update_widget (?, t))
		end


feature {NONE} -- Implementation

	draw_widget (a_widget: HUD_WIDGET)
		do
			a_widget.draw (engine)
		end

	update_widget (a_widget: HUD_WIDGET; t: REAL)
		do
			a_widget.update (engine, t)
		end

end
