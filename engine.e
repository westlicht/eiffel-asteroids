note
	description: "Core of the game engine. Gives access to sub-systems and manages game objects."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE

create
	make

feature -- Access

	input_manager: INPUT_MANAGER
			-- Input manager.

	renderer: RENDERER
			-- Renderer.

	bullet_manager: BULLET_MANAGER
			-- Bullet manager.

	collision_manager: COLLISION_MANAGER
			-- Collision manager.

	particle_manager: PARTICLE_MANAGER
			-- Particle manager.

	time: REAL
			-- Relative time in seconds.


feature {NONE} -- Implementation

	objects: LINKED_LIST [ENGINE_OBJECT]
			-- List of engine objects.

	objects_by_z: LINKED_LIST [ENGINE_OBJECT]
			-- List of engine objects sorted by Z-depth.

	last_time: TIME
			-- Time of last update.


feature -- Creation

	make (a_window: EV_WINDOW; a_drawing_area: EV_PIXMAP)
			-- Create the engine.
		require
			window_exists: a_window /= Void
			drawing_area_valid: a_drawing_area /= Void and then a_drawing_area.width > 0 and a_drawing_area.height > 0
		do
			create input_manager.make (a_window)
			create renderer.make (a_drawing_area)
			create objects.make
			create objects_by_z.make
			create bullet_manager.make (Current)
			create collision_manager.make (Current)
			create particle_manager.make (Current)

			-- Get current time
			create last_time.make_now

			put_object (bullet_manager)
			put_object (collision_manager)
			put_object (particle_manager)
		end

feature -- Drawing

	draw
			-- Draws all objects registered in the engine.
		do
			objects_by_z.do_all (agent draw_object)
			renderer.flip
		end

	sort_layers
			-- Sorts the layer by Z-depth.
		local
			inserted: BOOLEAN
		do
			objects_by_z.wipe_out
			from objects.start until objects.after loop
				inserted := False
				from objects_by_z.start until objects_by_z.after or inserted loop
					if objects.item.layer_z < objects_by_z.item.layer_z then
						objects_by_z.put_left (objects.item)
						inserted := True
					end
					objects_by_z.forth
				end
				if not inserted then
					objects_by_z.extend (objects.item)
				end
				objects.forth
			end
		end

feature -- Updateing

	update
			-- Updates all objects registered in the engine.
		local
			current_time: TIME
			duration: TIME_DURATION
			t: REAL
			cur: LINKED_LIST_ITERATION_CURSOR [ENGINE_OBJECT]
			prev : ENGINE_OBJECT
		do
			-- Compute time passed since last call
			create current_time.make_now
			duration := current_time.relative_duration (last_time)
			last_time := current_time
			t := duration.fine_second.truncated_to_real

			time := time + t
			objects.do_all (agent update_object (?, t) )

			cur := objects.new_cursor
			from cur.start until cur.after loop
				if cur.item.is_killed then
					prev := cur.item
					cur.forth
					prune_object (prev)
				else
					cur.forth
				end
			end
		end


feature -- Objects

	put_object (object: ENGINE_OBJECT)
			-- Adds an object to the engine.
		require
			object_exists: object /= Void
		local
			rigid_body: RIGID_BODY
		do
			objects.extend (object)
			objects_by_z.extend (object)
			sort_layers

			rigid_body ?= object
			if rigid_body /= Void then
				collision_manager.put_rigid_body (rigid_body)
			end
		end

	prune_object (object: ENGINE_OBJECT)
			-- Removes an object from the engine.
		require
			object_exists: object /= Void
		local
			rigid_body: RIGID_BODY
		do
			objects.prune_all (object)
			objects_by_z.prune_all (object)

			rigid_body ?= object
			if rigid_body /= Void then
				collision_manager.prune_rigid_body (rigid_body)
			end
		end


feature {NONE} -- Implementation

	draw_object (object: ENGINE_OBJECT)
		do
			object.draw
		end

	update_object (object: ENGINE_OBJECT; t: REAL)
		do
			object.update (t)
		end

invariant
	input_manager_exists: input_manager /= Void
	renderer_exists: renderer /= Void
	bullet_manager_exists: bullet_manager /= Void
	collision_manager_exists: collision_manager /= Void
	particle_manager_exists: particle_manager /= Void
	objects_exists: objects /= Void
	objects_by_z_exists: objects_by_z /= Void
	object_count: objects.count = objects_by_z.count
	time_positive: time >= 0.0
	last_time_exists: last_time /= Void

end
