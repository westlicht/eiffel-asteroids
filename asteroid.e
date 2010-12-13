note
	description: "Represents a single asteroid."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit
	RIGID_BODY
		redefine
			hit
		end


create
	make_with_category


feature -- Constants

	Num_points: INTEGER = 16
			-- Number of points.

	Max_velocity: REAL = 100.0
			-- Maximum velocity.


feature -- Access

	category: INTEGER
		-- Asteroid category (higher is larger).

feature -- Creation

	make_with_size (a_engine: ENGINE; a_size: REAL)
		do
			make_with_shape (a_engine, random_shape (a_size))

			-- Random position, velocity and angular velocity
			position.make_random (0, engine.renderer.screen_width, 0, engine.renderer.screen_height)
			velocity.make_random (-Max_velocity, Max_velocity, -Max_velocity, Max_velocity)
			angular_velocity := (random.real_item - 0.5) * 2
			random.forth
		end

	make_with_category (a_engine: ENGINE; a_category: INTEGER)
		do
			category := a_category
			make_with_size (a_engine, a_category * 20 + random.real_item * 10 - 5)
			random.forth
		end


feature {NONE} -- Implementation

	hit (bullet: BULLET)
			-- Called when rigid body is hit by a bullet.
		local
			emitter: PARTICLE_EMITTER
		do
			create emitter.make_with_settings (engine.particle_manager, engine.particle_manager.get_settings ("explosion"))
			emitter.position := position
			emitter.velocity := velocity
			emitter.burst (50, 0.1)

			if category > 1 then
				explode
			end
			kill
		end

	explode
		require
			category_valid: category > 1
		local
			i: INTEGER
			child: ASTEROID
			count: INTEGER
			direction: VECTOR2
		do
			count := 3

			from i := 1 until i > count loop
				create child.make_with_category (engine, category - 1)
				create direction.make_unit (({REAL} 6.283 / count.to_real) * i.to_real)
				child.position := position + direction * radius
				child.velocity := velocity + direction * 50.0
				child.angular_velocity:= angular_velocity + random.real_item * 10 - 5
				engine.put_object (child)
				i := i + 1
			end

		end

	random: RANDOM
		once
			create Result.make
			Result.start
		end

	random_shape (size: REAL): POLYGON
		require
			size_positive: size > 0.0
		local
			points: ARRAY[VECTOR2]
			i: INTEGER
			v: VECTOR2
		do
			create points.make (1, Num_points)
			from i := 1 until i > Num_points loop
				create v.make_unit (i / Num_points.to_real * 2 * 3.1415)
				v := v * ((1 - random.real_item * 0.5) * size)
				points[i] := v
				i := i + 1
				random.forth
			end
			create Result.make_from_points (points)
		ensure
			result_exists: Result /= Void
		end



end
