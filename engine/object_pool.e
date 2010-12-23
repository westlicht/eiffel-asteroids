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

	free_objects: LINKED_LIST [G]
			-- List of free objects.


feature -- Initialization

	make (a_objects: SEQUENCE [G])
			-- Initializes an object pool with the given set of objects.
		require
			objects_exists: a_objects /= Void
			objects_not_empty: not a_objects.is_empty
		do
			capacity := a_objects.count

			create free_objects.make
			create used_objects.make

			free_objects.append (a_objects)
		end

feature -- Objects

	has_next: BOOLEAN
			-- Returns true if there is a free object.
		do
			Result := not free_objects.is_empty
		end

	next: G
			-- Next free object.
		do
			Result := free_objects.first
		end

	use_next
			-- Mark the next free object as used.
		require
			next_available: has_next
		do
			if not free_objects.is_empty then
				-- Add object to used list
				used_objects.extend (free_objects.first)
				-- Remove first object from free list
				free_objects.start
				free_objects.remove
			end
		ensure
			one_free_less: free_objects.count = old free_objects.count - 1
			one_used_more: used_objects.count = old used_objects.count + 1
		end

	unuse (object: G)
			-- Give back an object to the object pool.
		require
			object_used: used_objects.has (object)
		do
			used_objects.start
			used_objects.search (object)
			used_objects.remove
			free_objects.extend (object)
		ensure
			one_free_more: free_objects.count = old free_objects.count + 1
			one_used_less: used_objects.count = old used_objects.count - 1
		end


invariant
	free_objects_exists: free_objects /= Void
	used_objects_exists: used_objects /= Void
	consistent_capacity: free_objects.count + used_objects.count = capacity

end
