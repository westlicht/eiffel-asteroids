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
			draw,
			hit_by_bullet
		end


create
	make_with_category


feature -- Constants

	Num_points: INTEGER = 10
			-- Number of points.

	Max_velocity: REAL = 100.0
			-- Maximum velocity.

	Fill_color: COLOR
			-- Asteroid fill color.
		once
			Result.set_rgb (0.2, 0.2, 0.2)
		end

	Border_color: COLOR
			-- Asteroid border color.
		once
			Result.set_rgb (0.8, 0.8, 0.8)
		end


feature -- Access

	game: GAME
		-- Game.

	category: INTEGER
		-- Asteroid category (higher is larger).

feature -- Creation

	make_with_category (a_game: GAME; a_category: INTEGER)
			-- Initializes asteroid with the given ceategory.
		require
			game_exists: a_game /= Void
		do
			category := a_category
			mass := a_category * a_category
			make_with_size (a_game, a_category * 20 + random.real_item * 10 - 5)
			random.forth
		end

	make_with_size (a_game: GAME; a_size: REAL)
			-- Initializes asteroid with given size.
		require
			game_exists: a_game /= Void
		do
			make_with_shape (a_game.engine, random_shape (a_size))
			game := a_game

			-- Random position, velocity and angular velocity
			position.set_random (0, engine.renderer.screen_width, 0, engine.renderer.screen_height)
			velocity.set_random (-Max_velocity, Max_velocity, -Max_velocity, Max_velocity)
			angular_velocity := (random.real_item - 0.5) * 2
			random.forth
		end


feature -- Drawing

	draw
			-- Draws the asteroid.
		do
			engine.renderer.set_foreground_color (Fill_color)
			engine.renderer.draw_transformed_polygon (shape, transform, True)
			engine.renderer.set_foreground_color (Border_color)
			engine.renderer.draw_transformed_polygon (shape, transform, False)
		end



feature {NONE} -- Implementation

	hit_by_bullet (a_bullet: BULLET)
			-- Called when this rigid body was hit by a bullet.
		local
			emitter: PARTICLE_EMITTER
		do
			create emitter.make (engine.particle_manager.get_system ("explosion"))
			emitter.position := position
			emitter.velocity := velocity
			emitter.burst (50, 0.1)

			-- Score points
			game.player.score.increment (category * 10)

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
			offset: REAL
		do
			count := 3

			random.forth
			offset := random.real_item * {REAL} 6.283

			from i := 1 until i > count loop
				create child.make_with_category (game, category - 1)
				direction.set_unit (({REAL} 6.283 / count.to_real + offset) * i.to_real)
				child.position := position + direction * radius * 0.3
				child.velocity := velocity + direction * 70.0
				child.angular_velocity:= angular_velocity + random.real_item * 4 - 2
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
				v.set_unit (i / Num_points.to_real * 2 * 3.1415)
				v := v * ((1 - random.real_item * 0.5) * size)
				points[i] := v
				i := i + 1
				random.forth
			end
			create Result.make_from_points (points)
		ensure
			result_exists: Result /= Void
		end


invariant
	game_exists: game /= Void

end
