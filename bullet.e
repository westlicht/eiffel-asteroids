note
	description: "Represents a single bullet."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	BULLET

create
	make


feature -- Access

	position: VECTOR2
			-- Current position.

	velocity: VECTOR2
			-- Current velocity.

	is_killed: BOOLEAN
			-- Kill the bullet on next frame.

feature -- Initialization

	make
		do
			create position.make_zero
			create velocity.make_zero
		end

	fire (a_position: VECTOR2; a_velocity: VECTOR2)
		do
			position.make_from_other (a_position)
			velocity.make_from_other (a_velocity)
			is_killed := False
		end


feature -- Drawing

	draw (engine: ENGINE)
			-- Draws the bullet.
		do
			engine.renderer.draw_point (position)
			engine.renderer.draw_circle (position, 2, False)
		end


feature -- Updateing

	update (engine: ENGINE; t: REAL)
			-- Updates the bullet by t seconds.
		do
			-- Primitive integration for basic dynamic motion
			position := position + velocity * t

			-- Kill bullet if it is out of the screen
			if position.x < 0 or position.x > engine.renderer.screen_width or
			   position.y < 0 or position.y > engine.renderer.screen_height then
			   	kill
			end
		end


feature -- Killing

	kill
			-- Kills the bullet.
		do
			is_killed := True
		end

end
