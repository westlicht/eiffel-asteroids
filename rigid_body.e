note
	description: "Implements physically simulated rigid bodies."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	RIGID_BODY

inherit
	ENGINE_OBJECT
		redefine
			draw, update
		end

create
	make_default, make_with_shape

feature -- Constants

	Restitution: REAL = 1.0

feature -- Access

	shape: POLYGON
			-- Polygon representing the shape of the rigid body.

	position: VECTOR2 assign set_position
			-- Current position.

	velocity: VECTOR2 assign set_velocity
			-- Current velocity.

	acceleration: VECTOR2
			-- Current acceleration.

	angle: REAL assign set_angle
			-- Current angle.

	angular_velocity: REAL assign set_angular_velocity
			-- Current angular velocity.

	mass: REAL
			-- Mass of the body in kg.

	radius: REAL
			-- Radius of the bounding sphere.

	radius_squared: REAL
			-- Squared radius of the bounding sphere.

	anchors: LINKED_LIST [RIGID_BODY_ANCHOR]
			-- List of anchors.


feature {NONE} -- Local attributes

	transform: MATRIX3
			-- Transformation matrix to transform to object's position/rotation.


feature -- Initialization

	make_default (a_engine: ENGINE)
			-- Creates default rigid body.
		do
			make_with_shape (a_engine, create {POLYGON}.make_box (25))
		end

	make_with_shape (a_engine: ENGINE a_shape: POLYGON)
			-- Creates a rigid body with a custom shape.
		require
			shape_valid: a_shape /= Void
		do
			make_with_engine (a_engine)
			shape := a_shape -- TODO maybe copy
			create position.make_zero
			create velocity.make_zero
			create acceleration.make_zero
			angle := 0.0
			angular_velocity := 2.0
			mass := 10.0
			radius := shape.radius
			radius_squared := radius * radius
			create anchors.make
			create transform.make_identity
		end


feature -- Access

	set_position (a_position: like position)
		require
			position_exists: a_position /= Void
		do
			position.make_from_other (a_position)
		end

	set_velocity (a_velocity: like velocity)
		require
			velocity_exists: a_velocity /= Void
		do
			velocity.make_from_other (a_velocity)
		end

	set_angle (a_angle: like angle)
		do
			angle := a_angle
		end

	set_angular_velocity (a_angular_velocity: like angular_velocity)
		do
			angular_velocity := a_angular_velocity
		end


feature -- Anchors

	put_anchor (a_anchor: RIGID_BODY_ANCHOR)
			-- Adds an anchor point to the rigid body.
		require
			anchor_exists: a_anchor /= Void
		do
			anchors.extend (a_anchor)
		end


feature {NONE} -- Anchors implementation

	update_anchor (a_anchor: RIGID_BODY_ANCHOR)
			-- Updates an anchor point.
		require
			anchor_exists: a_anchor /= Void
		do
			a_anchor.transform (transform)
		end


feature -- Drawing

	draw
			-- Draws the rigid body.
		local
			color: COLOR
		do
			-- Draw bounding sphere
			--engine.renderer.set_foreground_color (create {EV_COLOR}.make_with_rgb (0.0, 0.0, 1.0))
			--engine.renderer.draw_circle (position, radius)

			-- Draw shape
			color.make_with_rgb (1.0, 1.0, 1.0)
			engine.renderer.set_foreground_color (color)
			engine.renderer.draw_transformed_polygon (shape, transform)
		end


feature -- Updateing

	update (t: REAL)
			-- Updates the rigid body by t seconds.
		do
			-- Primitive integration for basic dynamic motion
			velocity := velocity + acceleration * t
			position := position + velocity * t
			angle := angle + angular_velocity * t

			-- Wrap position
			if position.x < -radius then
				position.set_x (position.x + engine.renderer.screen_width + 2 * radius)
			end
			if position.x > engine.renderer.screen_width + radius then
				position.set_x (position.x - engine.renderer.screen_width - 2 * radius)
			end
			if position.y < -radius then
				position.set_y (position.y + engine.renderer.screen_height + 2 * radius)
			end
			if position.y > engine.renderer.screen_height + radius then
				position.set_y (position.y - engine.renderer.screen_height - 2 * radius)
			end

			-- Update transformation matrix
			transform := create {MATRIX3}.make_translation (position) * create {MATRIX3}.make_rotation (angle)

			-- Update anchors
			anchors.do_all (agent update_anchor)
		end


feature -- Collision handling

	is_colliding (other: like Current): BOOLEAN
			-- Checks if this rigid body is colliding with another rigid body.
		require
			other_valid: other /= Void and other /= Current
		do
			Result := position.distance (other.position) < radius + other.radius
		end

	solve_collision (other: like Current)
		require
			other_valid: other /= Void and other /= Current
		local
			delta: VECTOR2
			d: REAL
			mtd: VECTOR2
			im1, im2: REAL
			v: VECTOR2
			vn: REAL
			i: REAL
			impulse: VECTOR2
		do
			delta := position - other.position
			d := delta.length

			-- Compute minimum distance to push objects apart after collision
			if d < 1.0 then
				d := 1.0
				create mtd.make (1.0, 0.0)
			else
				mtd := delta * ((radius + other.radius - d) / d)
			end

			-- Resolve intersection
			-- Compute inverse masses
			im1 := {REAL} 1.0 / mass
			im2 := {REAL} 1.0 / other.mass

			-- Push-pull rigid bodies based on their mass
			set_position(position + mtd * (im1 / (im1 + im2)))
			other.set_position (other.position - mtd * (im2 / (im1 + im2)))

			-- Impact speed
			v := velocity - other.velocity
			mtd := mtd.normalized
			vn := v.dot_product (mtd)

			-- Check if bodies are moving towards another
			if vn <= 0.0 then
				-- Compute impulse
				i := (-({REAL} 1.0 + Restitution) * vn) / (im1 + im2)
				impulse := mtd * i

				-- Change momentum
				set_velocity(velocity + impulse * im1)
				other.set_velocity (other.velocity - impulse * im2)
			end
		end

	hit (bullet: BULLET)
			-- Called when rigid body is hit by a bullet.
		do
		end


invariant
	transform_exists: transform /= Void
	mass_positive: mass > 0
	anchors_exists: anchors /= Void

end
