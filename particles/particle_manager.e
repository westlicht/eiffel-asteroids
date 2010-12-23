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

	systems: LINKED_LIST [PARTICLE_SYSTEM]
			-- List of particle systems.

	systems_by_name: HASH_TABLE [PARTICLE_SYSTEM, STRING]
			-- Hash table of particle systems indexed by a descriptive name.

	random: RANDOM
			-- Global random generator
		once
			create Result.make
			Result.start
		end

	particle_pool: OBJECT_POOL [PARTICLE]
			-- Pool of particles.

feature {NONE} -- Local attributes


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
			create particle_pool.make (objects)

			create systems.make
			create systems_by_name.make (16)
		end


feature -- Particle systems

	put_system (a_system: PARTICLE_SYSTEM; a_name: STRING)
			-- Adds particle system to the particle manager.
		require
			system_exists: a_system /= Void
			name_valid: a_name /= Void and then not a_name.is_empty and then not systems_by_name.has_key (a_name)
		do
			systems.extend (a_system)
			systems_by_name.extend (a_system, a_name)
		end

	get_system (a_name: STRING): PARTICLE_SYSTEM
			-- Gets settings from the particle manager.
		require
			name_exists: a_name /= Void
			system_exists: systems_by_name.has_key (a_name)
		do
			Result := systems_by_name [a_name]
		end


feature -- Drawing

	draw
			-- Draws the particles.
		local
			color: COLOR
		do
			systems.do_all (agent draw_system)
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the particles by t seconds.
		do
			systems.do_all (agent update_system (?, t))
		end


feature -- Random numbers

	random_range (a_min, a_max: REAL): REAL
			-- Returns the current random value scaled to be in a given range.
		do
			Result := a_min + random.real_item * (a_max - a_min)
		end


feature -- Implementation

	draw_system (a_system: PARTICLE_SYSTEM)
			-- Draws a single particle system.
		do
			a_system.draw
		end

	update_system (a_system: PARTICLE_SYSTEM; t: REAL)
			-- Updates a single particle system.
		do
			a_system.update (t)
		end


invariant
	systems_exists: systems /= Void
	systems_by_name_exists: systems_by_name /= Void
	systems_count_correct: systems.count = systems_by_name.count
	random_exists: random /= Void
	pool_exists: particle_pool /= Void

end
