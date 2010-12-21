note
	description: "Implements the players ship."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	RIGID_BODY
		redefine
			update,
			draw,
			hit_by_rigid_body
		end

create
	make


feature -- Constants

	Default_health_capacity: REAL = 100.0
			-- Default health capacity.

	Default_energy_capacity: REAL = 100.0
			-- Default energy capacity.

	Energy_charge_rate: REAL = 30.0
			-- Charge rate in Hz.

	Shield_discharge_rate: REAL = 80.0
			-- Shield discharge rate in Hz.

	Shield_min_energy: REAL = 25.0
			-- Minimum energy necessary for shield.

	Rotation_velocity: REAL = 3.0
			-- Angular velocity used for rotating the ship.

	Thrust_force: REAL = 1000.0
			-- Thrust force.

	Fire_interval: REAL = 0.1
			-- Minimum interval for fireing.

	Bullet_speed: REAL = 300.0
			-- Speed of bullets.

	Bullet_energy: REAL = 10.0
			-- Energy hit for a single bullet.

	Gun_position: VECTOR2
			-- Local position of the gun.
		once
			Result.set (0.0, -11.0)
		end

	Gun_direction: VECTOR2
			-- Local direction of the gun.
		once
			Result.set (0.0, -1.0)
		end

	Engine_position: VECTOR2
			-- Local position of engine.
		once
			Result.set (0.0, 5.0)
		end

	Engine_direction: VECTOR2
			-- Local direction of engine.
		once
			Result.set (0.0, 1.0)
		end

	Shield_radius: REAL = 20.0
			-- Radius of the shield.

	Shield_color: COLOR
			-- Color of the shield.
		once
			Result.set_rgb (0.2, 0.2, 1.0)
		end

	Default_name: STRING = "player"
			-- Default player name.


feature -- Access

	game: GAME
			-- Game.

	health: NUMERIC_VALUE [REAL]
			-- Health.

	energy: NUMERIC_VALUE [REAL]
			-- Energy.

	score: NUMERIC_VALUE [INTEGER]
			-- Player's score.

	active: BOOLEAN assign set_active
			-- Player is active.

	name: STRING assign set_name
			-- Player's name.


feature {NONE} -- Local attributes

	key_left: INPUT_KEY
			-- Left key.

	key_right: INPUT_KEY
			-- Right key.

	key_thrust: INPUT_KEY
			-- Thrust key.

	key_fire: INPUT_KEY
			-- Fire key.

	key_shield: INPUT_KEY
			-- Shield key.

	key_anti_gravity: INPUT_KEY
			-- Anti-gravity key.

	last_fire_time: REAL
			-- Last time of fireing.

	anchor_gun: RIGID_BODY_ANCHOR
			-- Anchor point for gun.

	anchor_engine: RIGID_BODY_ANCHOR
			-- Anchor point of engine.

	emitter_engine: ANCHORED_PARTICLE_EMITTER
			-- Particle emitter of engine.

	shield_active: BOOLEAN
			-- True if shield is active.


feature -- Initialization

	make (a_game: GAME)
			-- Creates the player.
		require
			game_exists: a_game /= Void
		do
			make_with_shape (a_game.engine, create_ship_shape)
			game := a_game

			position.set (engine.renderer.screen_width.to_real / 2, engine.renderer.screen_height.to_real / 2)
			angular_velocity := 0.0

			create health.make (0.0, 100.0, 100.0)
			create energy.make (0.0, 100.0, 100.0)
			create score.make (0, 1000000, 0)
			active := True
			create name.make_from_string (Default_name)

			key_left := engine.input_manager.key_left
			key_right := engine.input_manager.key_right
			key_thrust := engine.input_manager.key_up
			key_fire := engine.input_manager.key_space
			key_shield := engine.input_manager.key_shift
			key_anti_gravity := engine.input_manager.key_alt

			-- Create anchor points
			create anchor_gun.make (Current, Gun_position, Gun_direction)
			put_anchor (anchor_gun)
			create anchor_engine.make (Current, Engine_position, Engine_direction)
			put_anchor (anchor_engine)

			-- Create particle emitters
			create emitter_engine.make (engine.particle_manager, engine.particle_manager.get_settings ("engine"), anchor_engine)
			engine.particle_manager.put_emitter (emitter_engine)
		end


feature -- Resetting

	reset
		do
			position.x := engine.renderer.screen_width.to_real / 2.0
			position.y := engine.renderer.screen_height.to_real / 2.0
			velocity.set_zero
			angular_velocity := 0.0
			angle := 0.0
			health.value := health.max
			energy.value := energy.max
		end


feature -- Access

	set_active (a_active: BOOLEAN)
			-- Makes the player active/inactive.
			-- If active, player reacts to user input etc.
		do
			active := a_active
		end

	set_name (a_name: like name)
			-- Sets the player's name.
		require
			name_valid: a_name /= Void and then not a_name.is_empty
		do
			name.make_from_string (a_name)
		end

feature -- Updateing

	update (t: REAL)
			-- Updates the rigid body by t seconds.
		do
			if active then
				handle_user_input (t)
			end

			Precursor (t)
		end

	handle_user_input (t: REAL)
		local
			thrust: VECTOR2
		do
			-- Handle steering
			angular_velocity := 0
			if key_left.is_pressed then
				angular_velocity := angular_velocity - Rotation_velocity
			end
			if key_right.is_pressed then
				angular_velocity := angular_velocity + Rotation_velocity
			end

			-- Handle thrust
			if key_thrust.is_pressed then
				thrust.set (0, -Thrust_force)
				thrust := transform.transform_no_translation (thrust)
				add_force (thrust)
			else
				acceleration.set_zero
			end

			-- Handle fireing
			if key_fire.is_pressed and engine.time >= last_fire_time + Fire_interval and energy.value >= Bullet_energy then
				engine.bullet_manager.fire_bullet (anchor_gun.global_position, velocity, anchor_gun.global_direction, Bullet_speed)
				energy.decrement (Bullet_energy)
				last_fire_time := engine.time
			end

			-- Handle shield
			if key_shield.is_pressed and energy.value > Shield_min_energy then
				energy.decrement (Shield_discharge_rate * t)
				shield_active := True
			else
				shield_active := False
			end

			-- Handle anti-gravity
			if key_shield.is_pressed then
				engine.physics_manager.rigid_bodies.do_all (agent handle_anti_gravity)
			end

			-- Handle energy
			energy.increment (Energy_charge_rate * t)

			-- Handle particle emitters
			emitter_engine.enabled := key_thrust.is_pressed
		end

	handle_anti_gravity (a_rigid_body: RIGID_BODY)
		local
			r: REAL
		do
			r := 250.0
			if a_rigid_body.position.distance (position) < r then
				a_rigid_body.add_force (-a_rigid_body.velocity * 5.0)
			end
		end


feature -- Drawing

	draw
		do
			Precursor
			if shield_active then
				engine.renderer.set_foreground_color (Shield_color)
				engine.renderer.draw_circle (position, Shield_radius, False)
			end
		end

feature {NONE} -- Collision

	hit_by_rigid_body (a_other: RIGID_BODY)
			-- Called when this rigid body was hit by another rigid body.
		local
			relative_velocity: REAL
		do
			if attached {ASTEROID} a_other as asteroid then
				-- Compute relative velocity
				relative_velocity := (asteroid.velocity - velocity).length
				damage (relative_velocity * asteroid.mass * 0.004)
			end
		end

	damage (a_amount: REAL)
			-- Damage the player.
		do
			if shield_active then
				if energy.value < a_amount then
					health.decrement (a_amount - energy.value)
					energy.decrement (energy.value)
				else
					energy.decrement (a_amount)
				end
			else
				health.decrement (a_amount)
			end

			if health.value <= 0.0 then
				explode
			end
		end


	explode
		local
			emitter: PARTICLE_EMITTER
		do
			create emitter.make_with_settings (engine.particle_manager, engine.particle_manager.get_settings ("explosion"))
			emitter.position := position
			emitter.velocity := velocity
			emitter.burst (100, 0.1)
		end


feature {NONE} -- Implementation

	create_ship_shape: POLYGON
			-- Creates a simple ship shaped polygon.
		local
			points: ARRAY[VECTOR2]
			v: VECTOR2
		do
			create points.make (1, 4)
			v.set (0.0, -10.0)
			points [1] := v
			v.set (10.0, 10.0)
			points [2] := v
			v.set (0.0, 7.0)
			points [3] := v
			v.set (-10.0, 10.0)
			points [4] := v
			create Result.make_from_points (points)
		end


invariant
	game_exists: game /= Void
	name_valid: name /= Void and then not name.is_empty
	key_left_exists: key_left /= Void
	key_right_exists: key_right /= Void
	key_thrust_exists: key_thrust /= Void
	key_fire_exists: key_fire /= Void
	key_shield_exists: key_shield /= Void
	key_anti_gravity_exists: key_anti_gravity /= Void

end
