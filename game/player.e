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
			create Result.make (0.0, -11.0)
		end

	Gun_direction: VECTOR2
			-- Local direction of the gun.
		once
			create Result.make (0.0, -1.0)
		end

	Engine_position: VECTOR2
			-- Local position of engine.
		once
			create Result.make (0.0, 5.0)
		end

	Engine_direction: VECTOR2
			-- Local direction of engine.
		once
			create Result.make (0.0, 1.0)
		end

	Shield_radius: REAL = 20.0
			-- Radius of the shield.

	Shield_color: COLOR
			-- Color of the shield.
		once
			Result.make_with_rgb (0.2, 0.2, 1.0)
		end


feature -- Access

	health: NUMERIC_VALUE
			-- Health.

	energy: NUMERIC_VALUE
			-- Energy.

	score: NUMERIC_VALUE
			-- Player's score.

	active: BOOLEAN assign set_active
			-- Player is active.


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

	make (a_engine: ENGINE)
			-- Creates the player.
		do
			make_with_shape (a_engine, create_ship_shape)
			position.set_x (200)
			position.set_y (200)
			angular_velocity := 0.0

			create health.make (0.0, 100.0, 100.0)
			create energy.make (0.0, 100.0, 100.0)
			create score.make (0.0, 100000.0, 0.0)
			active := True

			key_left := engine.input_manager.keys_by_name.item ("left")
			key_right := engine.input_manager.keys_by_name.item ("right")
			key_thrust := engine.input_manager.keys_by_name.item ("up")
			key_fire := engine.input_manager.keys_by_name.item ("space")
			key_shield := engine.input_manager.keys_by_name.item ("shift")

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
			velocity.make_zero
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
				create thrust.make (0, -Thrust_force)
				thrust := transform.transform_no_translation (thrust)
				add_force (thrust)
			else
				acceleration.make_zero
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

			-- Handle energy
			energy.increment (Energy_charge_rate * t)

			-- Handle particle emitters
			emitter_engine.enabled := key_thrust.is_pressed
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
			damage: REAL
		do
			damage := 20.0
			if shield_active then
				if energy.value < damage then
					health.decrement (damage - energy.value)
					energy.decrement (energy.value)
				else
					energy.decrement (damage)
				end
			else
				health.decrement (damage)
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
		do
			create points.make (1, 4)
			points[1] := create {VECTOR2}.make (0.0, -10.0)
			points[2] := create {VECTOR2}.make (10.0, 10.0)
			points[3] := create {VECTOR2}.make (0.0, 7.0)
			points[4] := create {VECTOR2}.make (-10.0, 10.0)
			create Result.make_from_points (points)
		end


invariant
	key_left_exists: key_left /= Void
	key_right_exists: key_right /= Void
	key_thrust_exists: key_thrust /= Void
	key_fire_exists: key_fire /= Void
	key_shield_exists: key_shield /= Void

end
