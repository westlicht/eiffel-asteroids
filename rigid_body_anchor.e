note
	description: "Implements anchor points on rigid bodies."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	RIGID_BODY_ANCHOR

create
	make


feature -- Access

	rigid_body: RIGID_BODY
			-- Rigid body this anchor belongs to.

	local_position: VECTOR2
			-- Position of anchor in local space.

	local_direction: VECTOR2
			-- Direction of anchor in local space.

	global_position: VECTOR2
			-- Position of anchor in global space.

	global_direction: VECTOR2
			-- Direction of anchor in global space.


feature -- Initialization

	make (a_rigid_body: RIGID_BODY; a_position, a_direction: VECTOR2)
			-- Creats an anchor with local space position and direction on rigid body.
		require
			rigid_body_exists: a_rigid_body /= Void
			position_exists: a_position /= Void
			direction_exists: a_direction /= Void
		do
			rigid_body := a_rigid_body
			create local_position.make_from_other (a_position)
			create local_direction.make_from_other (a_direction.normalized)
			create global_position.make_from_other (local_position)
			create global_direction.make_from_other (local_direction)
		end


feature -- Transformation

	transform (a_transform: MATRIX3)
			-- Transforms the anchor from local to global space based on transform matrix.
		do
			global_position := a_transform.transform (local_position)
			global_direction := a_transform.transform_no_translation (local_direction)
		end


invariant
	rigid_body_exists: rigid_body /= Void
	local_position_exists: local_position /= Void
	local_direction_exists: local_direction /= Void
	global_position_exists: global_position /= Void
	global_direction_exists: global_direction /= Void

end
