note
	description: "Particle emitter."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTICLE_EMITTER

create
	make


feature -- Access

	system: PARTICLE_SYSTEM
			-- Particle system.

	position: VECTOR2 assign set_position
			-- Emitter position.

	velocity: VECTOR2 assign set_velocity
			-- Emitter velocity.

	direction: VECTOR2 assign set_direction
			-- Emitter direction (as normalized vector).

	enabled: BOOLEAN assign set_enabled
			-- Enable/disable emitter.


feature -- Local attributes

	time_left: REAL
			-- Time not yet 'processed'.


feature -- Initialization


	make (a_system: PARTICLE_SYSTEM)
			-- Initializes the particle emitter.
		require
			system_exists: a_system /= Void
		do
			system := a_system
			position.set_zero
			velocity.set_zero
			direction.set_unit (0)
		end


feature -- Access

	set_position (a_position: like position)
			-- Sets the position.
		do
			position := a_position
		end

	set_velocity (a_velocity: like velocity)
			-- Sets the velocity.
		do
			velocity := a_velocity
		end

	set_direction (a_direction: like direction)
			-- Sets the direction.
		do
			direction := a_direction
		end

	set_enabled (a_enabled: like enabled)
			-- Enables/disables the particle emitter.
		do
			enabled := a_enabled
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Updates the emitter by t seconds.
		local
			inv_rate: REAL
		do
			if enabled then
				inv_rate := {REAL} 1.0 / system.settings.rate
				from
					time_left := time_left + t
				until
					time_left < inv_rate
				loop
					emit_particle (t)
					time_left := time_left - inv_rate
				end
			else
				time_left := 0.0
			end
		end

feature -- Emitting

	burst (count: INTEGER; t: REAL)
			-- Bursts a number of particles over a short period of time.
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				emit_particle (t)
				i := i + 1
			end
		end

	emit_particle (t: REAL)
			-- Emits a single particle.
		local
			rotation: MATRIX3
			particle_velocity: VECTOR2
		do
			system.manager.random.forth
			create rotation.make_rotation (system.manager.random_range (-system.settings.spread, system.settings.spread))
			system.manager.random.forth
			particle_velocity := rotation.transform_no_translation (direction) * (system.settings.velocity * system.manager.random_range ({REAL} 1.0 - system.settings.velocity_random, {REAL} 1.0 + system.settings.velocity_random)) + velocity
			system.emit_particle (system.settings, position, particle_velocity, t)
		end


invariant
	system_exists: system /= Void
	time_left_positive: time_left >= 0.0

end
