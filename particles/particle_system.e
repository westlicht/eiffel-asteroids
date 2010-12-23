note
	description: "Implements particle systems. They are defined by some particle settings and a list of emitters."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTICLE_SYSTEM

create
	make


feature -- Access

	manager: PARTICLE_MANAGER
			-- Particle manager.

	settings: PARTICLE_SETTINGS
			-- Particle settings.

	emitters: LINKED_LIST [PARTICLE_EMITTER]
			-- List of particle emitters.

	particles: LINKED_LIST [PARTICLE]
			-- List of particles currently belonging to this system.


feature -- Initialization

	make (a_manager: PARTICLE_MANAGER; a_settings: PARTICLE_SETTINGS)
			-- Initializes a particle system.
		require
			manager_exists: a_manager /= Void
			settings_exists: a_settings /= Void
		do
			manager := a_manager
			settings := a_settings
			create emitters.make
			create particles.make
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


feature -- Emitting

	emit_particle (a_settings: PARTICLE_SETTINGS; a_position, a_velocity: VECTOR2; t: REAL)
			-- Emits a new particle.
		local
			particle: PARTICLE
		do
			particle := manager.particle_pool.use
			if particle /= Void then
				particles.extend (particle)
				particle.emit (a_settings, a_position, a_velocity)
				manager.random.forth
				particle.update (manager.engine, manager.random.real_item * t)
			end
		end


feature -- Drawing

	draw
			-- Draws the particles.
		do
			manager.engine.renderer.set_foreground_color (settings.color_start)
			particles.do_all (agent draw_particle)
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the particles by t seconds.
		do
			emitters.do_all (agent update_emitter (?, t))
			particles.do_all (agent update_particle (?, t))
			from particles.start until particles.after loop
				if particles.item.is_killed then
					manager.particle_pool.unuse (particles.item)
					particles.remove
				else
					particles.forth
				end
			end
		end


feature -- Implementation

	draw_particle (particle: PARTICLE)
			-- Draws a single particle.
		do
			particle.draw (manager.engine)
		end

	update_emitter (emitter: PARTICLE_EMITTER; t: REAL)
			-- Updates a single emitter.
		do
			emitter.update (manager.engine, t)
		end

	update_particle (particle: PARTICLE; t: REAL)
			-- Updates a single particle.
		do
			particle.update (manager.engine, t)
		end


invariant
	manager_exists: manager /= Void
	settings_exists: settings /= Void
	emitters_exists: emitters /= Void
	particles_exists: particles /= Void

end

