note
	description: "Represents a single particle."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTICLE

create
	make


feature -- Access

	settings: PARTICLE_SETTINGS
			-- Particle settings.

	age: REAL
			-- Age of particle in seconds.

	position: VECTOR2
			-- Current position.

	velocity: VECTOR2
			-- Current velocity.

	is_killed: BOOLEAN
			-- Kill the particle on next frame.

feature -- Initialization

	make
			-- Initializes a particle.
		do
			position.set_zero
			velocity.set_zero
			is_killed := True
		end

	emit (a_settings: PARTICLE_SETTINGS; a_position: VECTOR2; a_velocity: VECTOR2)
			-- Sets up the particle when emitting.
		do
			settings := a_settings
			age := 0.0
			position := a_position
			velocity := a_velocity
			is_killed := False
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draws the particle.
		do
			engine.renderer.set_foreground_color (settings.color_start.blend (settings.color_end, age / settings.life_time))
			engine.renderer.draw_point (position)
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Updates the particle by t seconds.
		do
			-- Primitive integration for basic dynamic motion
			position := position + velocity * t
			velocity := velocity - velocity * settings.drag * t

			age := age + t
			if age > settings.life_time then
				kill
			end

			-- Kill particle if it is out of the screen
			if position.x < 0 or position.x > engine.renderer.screen_width or
			   position.y < 0 or position.y > engine.renderer.screen_height then
			   	kill
			end
		end


feature -- Killing

	kill
			-- Kills the particle.
		do
			is_killed := True
		end


invariant
	settings_exists: not is_killed implies settings /= Void
	age_positive: age >= 0.0

end
