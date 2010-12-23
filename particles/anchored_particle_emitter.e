note
	description: "Implements particle emitters attached to a rigid body anchor point."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	ANCHORED_PARTICLE_EMITTER

inherit
	PARTICLE_EMITTER
		redefine
			update
		end

create
	make


feature -- Access

	anchor: RIGID_BODY_ANCHOR
			-- Anchor of a rigid body.


feature -- Initialization

	make (a_manager: PARTICLE_MANAGER; a_settings: PARTICLE_SETTINGS; a_anchor: RIGID_BODY_ANCHOR)
			-- Creates a new anchored particle emitter.
		require
			anchor_exists: a_anchor /= Void
		do
			make_with_settings (a_manager, a_settings)
			anchor := a_anchor
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Updates the emitter by t seconds.
		do
			position := anchor.global_position
			velocity := anchor.rigid_body.velocity
			direction := anchor.global_direction

			Precursor (engine, t)
		end


invariant
	anchor_exists: anchor /= Void

end
