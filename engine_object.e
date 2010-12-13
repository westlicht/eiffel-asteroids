note
	description: "Base class for all objects handled by the engine."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_OBJECT

create
	make_with_engine


feature -- Access

	engine: ENGINE
			-- Associated engine.

	layer_z: INTEGER
			-- Z-depth of the layer, lower Z are drawn before higher Z.

	is_killed: BOOLEAN
			-- True if the object is killed and should be removed.


feature -- Initialization

	make_with_engine (a_engine: ENGINE)
		require
			engine_exists: a_engine /= Void
		do
			engine := a_engine
		end


feature -- Drawing

	draw
			-- Draws the object.
		do
			-- Provide zero implementation.
		end

	set_layer_z (a_z: INTEGER)
			-- Sets the Z-depth of the layer.
		do
			layer_z := a_z
			engine.sort_layers
		end


feature -- Updating

	update (t: REAL)
			-- Updates the object by t seconds.
		require
			t_positive: t >= 0.0
		do
			-- Provide zero implementation.
		end


feature -- Killing

	kill
			-- Mark object as killed, will be removed as soon as possible.
	do
		is_killed := True
	end


invariant
	engine_exists: engine /= Void

end
