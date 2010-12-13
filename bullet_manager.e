note
	description: "Manages a list of bullets."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	BULLET_MANAGER

inherit
	ENGINE_OBJECT
		redefine
			draw,
			update
		end

create
	make


feature -- Constants

	Max_bullets: INTEGER = 10
			-- Maximum number of bullets.

feature -- Access

	bullets: like pool.used_objects
			-- List of active bullets.


feature {NONE} -- Local attributes

	pool: OBJECT_POOL [BULLET]
			-- Pool of bullets.


feature -- Initialization

	make (a_engine: ENGINE)
		do
			make_with_engine (a_engine)

			-- TODO create pool as last because of invariant
			create pool.make (Max_bullets, agent bullet_allocator)
			bullets := pool.used_objects
		end


feature -- Fireing

	fire_bullet (position, velocity, direction: VECTOR2; speed: REAL_64)
		local
			bullet: BULLET
		do
			bullet := pool.use
			if bullet /= Void then
				bullet.fire (position, velocity + direction * speed)
			end
		end


feature -- Drawing

	draw
			-- Draws the bullets.
		local
			color: COLOR
		do
			color.make_with_rgb (0.0, 1.0, 0.0)
			engine.renderer.set_foreground_color (color)
			bullets.do_all (agent draw_bullet)
		end


feature -- Updateing

	update (t: REAL_64)
			-- Updates the bullets by t seconds.
		do
			bullets.do_all (agent update_bullet (?, t))
		end


feature -- Implementation

	bullet_allocator: BULLET
		do
			create Result.make
		end

	draw_bullet (bullet: BULLET)
			-- Draws a single bullet.
		do
			bullet.draw (engine)
		end

	update_bullet (bullet: BULLET; t: REAL_64)
			-- Updates a single bullet.
		do
			bullet.update (engine, t)
			if bullet.is_killed then
				pool.unuse (bullet)
			end
		end

invariant
	-- TODO bullets may be Void as the allocated is called before the bullets list alias can be set
	bullets_valid: bullets /= Void implies bullets = pool.used_objects

end
