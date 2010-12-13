note
	description: "Manages collisions among rigid bodies and bullets."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	COLLISION_MANAGER

inherit
	ENGINE_OBJECT
		redefine
			update
		end

create
	make

feature -- Access

	rigid_bodies: ARRAYED_LIST [RIGID_BODY]
			-- List of rigid bodies.

feature -- Initialization

	make (a_engine: ENGINE)
		do
			make_with_engine (a_engine)
			create rigid_bodies.make (0)
		end


feature -- Objects

	put_rigid_body (a_rigid_body: RIGID_BODY)
		do
			rigid_bodies.extend (a_rigid_body)
		end

	prune_rigid_body (a_rigid_body: RIGID_BODY)
		do
			rigid_bodies.prune_all (a_rigid_body)
		end


feature -- Updating

	update (t: REAL)
			-- Updates the object by t seconds.
		do
			check_rigid_bodies
			check_bullets
		end

	check_rigid_bodies
			-- Check all pairs of rigid bodies for collision (brute-force).
		local
			i, j: INTEGER
		do
			-- TODO May be improved with some sweep-and-prune algorithm
			from i := 1 until i > rigid_bodies.count loop
				from j := i + 1 until j > rigid_bodies.count loop
					check_rigid_body_collision (rigid_bodies [i], rigid_bodies [j])
					j := j + 1
				end
				i := i + 1
			end

		end

	check_bullets
			-- Check all bullets for collision (brute-force).
		local
			bullets: LINKED_LIST [BULLET]
		do
			bullets := engine.bullet_manager.bullets
			from bullets.start until bullets.after loop
				check_bullet_collision (bullets.item)
				bullets.forth
			end
		end

	check_rigid_body_collision (a, b: RIGID_BODY)
			-- Check for collision between two rigid bodies and solve if colliding.
		require
			valid_rigid_bodies: a /= Void and b /= Void and a /= b
		do
			if a.is_colliding (b) then
				a.solve_collision (b)
			end
		end

	check_bullet_collision (bullet: BULLET)
			-- Check for collision between a bullet and rigid bodies.
		require
			valid_bullet: bullet /= Void
		local
			rigid_body: RIGID_BODY
		do
			from rigid_bodies.start until rigid_bodies.after loop
				rigid_body := rigid_bodies.item
				if rigid_body.position.distance_squared (bullet.position) < rigid_body.radius_squared then
					rigid_body.hit (bullet)
					bullet.kill
				end
				rigid_bodies.forth
			end
		end


invariant
	rigid_bodies_exists: rigid_bodies /= Void

end
