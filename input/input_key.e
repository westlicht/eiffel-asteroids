note
	description: "Class representing a single key on the keyboard."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_KEY

create
	make


feature -- Access

	name: STRING
			-- Key's name

	key_code: INTEGER
			-- Key's code

	is_pressed: BOOLEAN
			-- Key is currently pressed down


feature {NONE} -- Implementation

	handlers: LINKED_LIST[PROCEDURE[ANY, TUPLE[INPUT_KEY]]]
			-- Linked list of key handlers


feature -- Initialization

	make (a_name: STRING; a_key_code: INTEGER)
			-- Initializes the key.
		require
			name_valid: a_name /= Void and then not a_name.is_empty
		do
			create name.make_from_string(a_name)
			key_code := a_key_code
			create handlers.make
		end


feature -- Key handlers

	add_handler (a_handler: PROCEDURE[ANY, TUPLE[INPUT_KEY]])
			-- Adds a new key handler.
		require
			handler_exists: a_handler /= Void
		do
			handlers.extend (a_handler)
		end


feature {INPUT_MANAGER} -- Input manager functions

	set_is_pressed (a_is_pressed: BOOLEAN)
			-- Called from the input manager when the key state changed.
		do
			if a_is_pressed /= is_pressed then
				is_pressed := a_is_pressed
			 	handlers.do_all (agent call_handler (?, Current))
			end
		end

feature {NONE} -- Implementation

	call_handler (handler: PROCEDURE[ANY, TUPLE[INPUT_KEY]]; key: like Current)
		do
			handler.call ([key])
		end


invariant
	name_valid: name /= Void and then not name.is_empty
	handlers_exists: handlers /= Void

end
