note
	description: "Manages particle systems."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTICLE_MANAGER

inherit
	ENGINE_OBJECT
		redefine
			draw,
			update
		end

create
	make


feature -- Constants

	Max_particles: INTEGER = 1000
			-- Maximum number of particles.

feature -- Access

	particles: like pool.used_objects
			-- List of active particles.

	settings_by_name: HASH_TABLE [PARTICLE_SETTINGS, STRING]
			-- Hash table of particle settings.

	emitters: LINKED_LIST [PARTICLE_EMITTER]
			-- List of emitters.

	random: RANDOM
			-- Global random generator
		once
			create Result.make
			Result.start
		end


feature {NONE} -- Local attributes

	pool: OBJECT_POOL [PARTICLE]
			-- Pool of particles.

feature -- Initialization

	make (a_engine: ENGINE)
			-- Initializes the particle manager.
		local
			objects: LINKED_LIST [PARTICLE]
			i: INTEGER
		do
			make_with_engine (a_engine)

			-- Create particle pool
			create objects.make
			from i := 1 until i > Max_particles loop
				objects.extend (create {PARTICLE}.make)
				i := i + 1
			end
			create pool.make (objects)
			particles := pool.used_objects

			create settings_by_name.make (16)
			create emitters.make
		end


feature -- Particle settings

	put_settings (a_settings: PARTICLE_SETTINGS; a_name: STRING)
			-- Adds settings to the particle manager.
		require
			settings_exists: a_settings /= Void
			name_valid: a_name /= Void and then not a_name.is_empty
		do
			settings_by_name.extend (a_settings, a_name)
		end

	get_settings (a_name: STRING): PARTICLE_SETTINGS
			-- Gets settings from the particle manager.
		require
			name_exists: a_name /= Void
			settings_exists: settings_by_name.has (a_name)
		do
			Result := settings_by_name [a_name]
		end


feature -- Particle emitters

	put_emitter (a_emitter: PARTICLE_EMITTER)
			-- Adds an emitter to the particle manager.
		require
			emitter_exists: a_emitter /= Void
			emitter_not_put: not emitters.has (a_emitter)
		do
			emitters.extend (a_emitter)
		end

	prune_emitter (a_emitter: PARTICLE_EMITTER)
			-- Removes an emitter from the particle manager.
		require
			emitter_exists: a_emitter /= Void
			emitter_registered: emitters.has (a_emitter)
		do
			emitters.prune (a_emitter)
		end

feature -- Fireing

	emit_particle (a_settings: PARTICLE_SETTINGS; a_position, a_velocity: VECTOR2; t: REAL)
			-- Emits a new particle.
		local
			particle: PARTICLE
		do
			particle := pool.use
			if particle /= Void then
				particle.emit (a_settings, a_position, a_velocity)
				random.forth
				particle.update (engine, random.real_item * t)
			end
		end


feature -- Drawing

	draw
			-- Draws the particles.
		local
			color: COLOR
		do
			color.make_gray (0.5)
			engine.renderer.set_foreground_color (color)
			particles.do_all (agent draw_particle)
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the particles by t seconds.
		do
			emitters.do_all (agent update_emitter (?, t))
			particles.do_all (agent update_particle (?, t))
		end


feature -- Random numbers

	random_range (min, max: REAL): REAL
		do
			Result := min + random.real_item * (max - min)
		end


feature -- Implementation

	draw_particle (particle: PARTICLE)
			-- Draws a single particle.
		do
			particle.draw (engine)
		end

	update_emitter (emitter: PARTICLE_EMITTER; t: REAL)
			-- Updates a single emitter.
		do
			emitter.update (engine, t)
		end

	update_particle (particle: PARTICLE; t: REAL)
			-- Updates a single particle.
		do
			particle.update (engine, t)
			if particle.is_killed then
				pool.unuse (particle)
			end
		end

invariant
	particles_valid: particles = pool.used_objects
	emitters_exists: emitters /= Void

end
