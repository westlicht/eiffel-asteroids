 note
	description: "Base class for all objects handled by the engine. Engine objects can be updated an drawn."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENGINE_OBJECT


feature -- Access

	engine: ENGINE
			-- Associated engine.

	layer_z: INTEGER assign set_layer_z
			-- Z-depth of the layer, lower Z are drawn before higher Z.

	is_killed: BOOLEAN
			-- True if the object is killed and should be removed.


feature -- Initialization

	make_with_engine (a_engine: ENGINE)
			-- Initializes the engine object.
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

	set_layer_z (a_layer_z: like layer_z)
			-- Sets the Z-depth of the layer.
		do
			layer_z := a_layer_z
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
