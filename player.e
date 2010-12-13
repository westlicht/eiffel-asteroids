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
			update
		end

create
	make


feature -- Constants

	Rotation_velocity: REAL_64 = 3.0
			-- Angular velocity used for rotating the ship.

	Thrust_acceleration: REAL_64 = 100.0
			-- Thrust acceleration.

	Fire_interval: REAL_64 = 0.1
			-- Minimum interval for fireing.

	Bullet_speed: REAL_64 = 300.0
			-- Speed of bullets.

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


feature {NONE} -- Local attributes

	key_left: INPUT_KEY
			-- Left key.

	key_right: INPUT_KEY
			-- Right key.

	key_thrust: INPUT_KEY
			-- Thrust key.

	key_fire: INPUT_KEY
			-- Fire key.

	last_fire_time: REAL_64
			-- Last time of fireing.

	anchor_gun: RIGID_BODY_ANCHOR
			-- Anchor point for gun.

	anchor_engine: RIGID_BODY_ANCHOR
			-- Anchor point of engine.

	emitter_engine: ANCHORED_PARTICLE_EMITTER
			-- Particle emitter of engine.


feature -- Initialization

	make (a_engine: ENGINE)
			-- Creates the player.
		do
			make_with_shape (a_engine, create_ship_shape)
			position.set_x (200)
			position.set_y (200)
			angular_velocity := 0.0

			key_left := engine.input_manager.keys_by_name.item ("left")
			key_right := engine.input_manager.keys_by_name.item ("right")
			key_thrust := engine.input_manager.keys_by_name.item ("up")
			key_fire := engine.input_manager.keys_by_name.item ("space")

			-- Create anchor points
			create anchor_gun.make (Current, Gun_position, Gun_direction)
			put_anchor (anchor_gun)
			create anchor_engine.make (Current, Engine_position, Engine_direction)
			put_anchor (anchor_engine)

			-- Create particle emitters
			create emitter_engine.make (engine.particle_manager, engine.particle_manager.get_settings ("engine"), anchor_engine)
			engine.particle_manager.put_emitter (emitter_engine)
		end

feature -- Updateing

	update (t: REAL_64)
			-- Updates the rigid body by t seconds.
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
				acceleration.make (0, -Thrust_acceleration)
				acceleration := transform.transform_no_translation (acceleration)
			else
				acceleration.make_zero
			end

			-- Handle fireing
			if key_fire.is_pressed and engine.time >= last_fire_time + Fire_interval then
				engine.bullet_manager.fire_bullet (anchor_gun.global_position, velocity, anchor_gun.global_direction, Bullet_speed)
				last_fire_time := engine.time
			end

			-- Handle particle emitters
			emitter_engine.enabled := key_thrust.is_pressed

			Precursor (t)
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

end
