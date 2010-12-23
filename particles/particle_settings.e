note
	description: "Stores the settings of a particle system."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	PARTICLE_SETTINGS

create
	make


feature -- Access

	spread: REAL assign set_spread
			-- Spreading angle.

	velocity: REAL assign set_velocity
			-- Initial velocity.

	velocity_random: REAL assign set_velocity_random
			-- Initial velocity random deviation.

	rate: REAL assign set_rate
			-- Emitting rate in hz.

	life_time: REAL assign set_life_time
			-- Particle life time in seconds.

	drag: REAL assign set_drag
			-- Particle drag factor (slow down based on current velocity).

	color_start: COLOR assign set_color_start
			-- Particle start color.

	color_end: COLOR assign set_color_end
			-- Particle end color.


feature -- Initialization

	make
			-- Initializes the particle settings with defaults.
		do
			spread := 1.0
			velocity := 100.0
			velocity_random := 0.0
			rate := 100.0
			life_time := 1.0
			drag := 0.0
			color_start.set_rgb (1.0, 1.0, 1.0)
		end


feature -- Settings

	set_spread (a_spread: like spread)
		do
			spread := a_spread
		end

	set_velocity (a_velocity: like velocity)
		do
			velocity := a_velocity
		end

	set_velocity_random (a_velocity_random: like velocity_random)
		do
			velocity_random := a_velocity_random
		end

	set_rate (a_rate: like rate)
		do
			rate := a_rate
		end

	set_life_time (a_life_time: like life_time)
		do
			life_time := a_life_time
		end

	set_drag (a_drag: like drag)
		do
			drag := a_drag
		end

	set_color_start (a_color_start: like color_start)
		do
			color_start := a_color_start
		end

	set_color_end (a_color_end: like color_end)
		do
			color_end := a_color_end
		end


end
