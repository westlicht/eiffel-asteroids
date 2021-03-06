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


feature -- Access

	widgets: LINKED_LIST [HUD_WIDGET]
			-- List of widgets.


feature -- Initialization

	make (a_engine: ENGINE)
			-- Creates the widget manager.
		do
			make_with_engine (a_engine)
			create widgets.make
			layer_z := 1
		end


feature -- Widgets

	put_widget (a_widget: HUD_WIDGET)
			-- Adds a widget to the manager.
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
			-- Draws a single widget.
		do
			if a_widget.visible then
				a_widget.draw (engine)
			end
		end

	update_widget (a_widget: HUD_WIDGET; t: REAL)
			-- Updates a single widget.
		do
			a_widget.update (engine, t)
		end


invariant
	widgets_exists: widgets /= Void

end
