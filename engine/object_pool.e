note
	description: "Implements pre-allocated pools of objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OBJECT_POOL [G -> ANY]

create
	make


feature -- Access

	capacity: INTEGER
			-- Capacity of the object pool.

	used_objects: LINKED_LIST [G]
			-- List of used objects.

feature {NONE} -- Local attributes

	free_objects: LINKED_LIST [G]
			-- List of free objects.



feature -- Initialization

	make (a_capacity: INTEGER; a_allocator: FUNCTION [ANY, TUPLE, G])
			-- Creates the object pool with the given capacity of objects.
		require
			capacity_positive: a_capacity > 0
		local
			i: INTEGER
		do
			capacity := a_capacity

			create free_objects.make
			create used_objects.make

			-- Allocate objects
			from i := 1 until i > a_capacity loop
				free_objects.extend (a_allocator.item ([]))
				i := i + 1
			end
		end

	use: G
			-- Request an unused object from the object pool.
			-- Returns Void if no free object is available.
		do
			if not free_objects.is_empty then
				-- Remove first object from free list
				Result := free_objects.first
				free_objects.start
				free_objects.remove
				-- Add object to used list
				used_objects.extend (Result)
			end
		ensure
			object_used: Result /= Void implies used_objects.has (Result)
		end

	unuse (object: G)
			-- Give back an object to the object pool.
		require
			object_used: used_objects.has (object)
		do
			used_objects.search (object)
			used_objects.remove
			free_objects.extend (object)
		end


invariant
	free_objects_exists: free_objects /= Void
	used_objects_exists: used_objects /= Void
	consistent_capacity: free_objects.count + used_objects.count = capacity

end
