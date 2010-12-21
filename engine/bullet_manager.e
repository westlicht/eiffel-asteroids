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

	Max_bullets: INTEGER = 100
			-- Maximum number of bullets.

feature -- Access

	bullets: like pool.used_objects
			-- List of active bullets.


feature {NONE} -- Local attributes

	pool: OBJECT_POOL [BULLET]
			-- Pool of bullets.


feature -- Initialization

	make (a_engine: ENGINE)
		local
			objects: LINKED_LIST [BULLET]
			i: INTEGER
		do
			make_with_engine (a_engine)

			-- Create bullet pool
			create objects.make
			from i := 1 until i > Max_bullets loop
				objects.extend (create {BULLET}.make)
				i := i + 1
			end
			create pool.make (objects)
			bullets := pool.used_objects
		end


feature -- Fireing

	fire_bullet (position, velocity, direction: VECTOR2; speed: REAL)
		local
			bullet: BULLET
		do
			bullet := pool.use
			if bullet /= Void then
				bullet.fire (position, velocity + direction * speed)
			end
		end

	kill_all_bullets
		do
			from bullets.start until bullets.after loop
				bullets.item.kill
				bullets.forth
			end
		end


feature -- Drawing

	draw
			-- Draws the bullets.
		local
			color: COLOR
		do
			color.set_rgb (0.0, 1.0, 0.0)
			engine.renderer.set_foreground_color (color)
			bullets.do_all (agent draw_bullet)
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the bullets by t seconds.
		do
			bullets.do_all (agent update_bullet (?, t))
		end


feature -- Implementation

	draw_bullet (bullet: BULLET)
			-- Draws a single bullet.
		do
			bullet.draw (engine)
		end

	update_bullet (bullet: BULLET; t: REAL)
			-- Updates a single bullet.
		do
			bullet.update (engine, t)
			if bullet.is_killed then
				pool.unuse (bullet)
			end
		end

invariant
	bullets_valid: bullets = pool.used_objects

end
