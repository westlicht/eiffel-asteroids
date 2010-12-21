note
	description: "Implements input handling (keyboard)."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_MANAGER

create
	make


feature -- Access

	keys_by_name: HASH_TABLE[INPUT_KEY, STRING]
			-- Hash table of keys indexed by key name.

	keys_by_code: HASH_TABLE[INPUT_KEY, INTEGER]
			-- Hash table of keys indexed by key code.

	key_handlers: LINKED_LIST [PROCEDURE [ANY, TUPLE [key: INPUT_KEY; pressed: BOOLEAN]]]
			-- List of key handlers.


feature -- Keys

	key_left: INPUT_KEY
	key_right: INPUT_KEY
	key_up: INPUT_KEY
	key_down: INPUT_KEY
	key_space: INPUT_KEY
	key_ctrl: INPUT_KEY
	key_shift: INPUT_KEY
	key_enter: INPUT_KEY
	key_escape: INPUT_KEY
	key_alt: INPUT_KEY


feature -- Initialization

	make (a_window: EV_WINDOW)
			-- Initializes the input manager.
		do
			create keys_by_name.make (16)
			create keys_by_code.make (16)
			create key_handlers.make
			register_default_keys

			-- Register key press/release handlers
			a_window.key_press_actions.extend (agent key_press)
			a_window.key_release_actions.extend (agent key_release)
		end


feature -- Key management

	register_default_keys
			-- Registers a set of default keys.
		local
			key_constants: EV_KEY_CONSTANTS
		do
			create key_constants

			create key_left.make ("left", key_constants.key_left)
			register_key (key_left)
			create key_right.make ("right", key_constants.key_right)
			register_key (key_right)
			create key_up.make ("up", key_constants.key_up)
			register_key (key_up)
			create key_down.make ("down", key_constants.key_down)
			register_key (key_down)
			create key_space.make ("space", key_constants.key_space)
			register_key (key_space)
			create key_ctrl.make ("ctrl", key_constants.key_ctrl)
			register_key (key_ctrl)
			create key_shift.make ("shift", key_constants.key_shift)
			register_key (key_shift)
			create key_enter.make ("enter", key_constants.key_enter)
			register_key (key_enter)
			create key_escape.make ("escape", key_constants.key_escape)
			register_key (key_escape)
			create key_alt.make ("alt", key_constants.key_alt)
			register_key (key_alt)
		end

	register_key (a_key: INPUT_KEY)
			-- Registers a key.
		do
			keys_by_name.put (a_key, a_key.name)
			keys_by_code.put (a_key, a_key.key_code)
		end

	put_key_handler (a_handler: PROCEDURE[ANY, TUPLE[key: INPUT_KEY; pressed: BOOLEAN]])
			-- Adds a key handler to the input manager.
		do
			key_handlers.extend (a_handler)
		end


feature {NONE} -- Implementation

	key_press (a_key: EV_KEY)
			-- Called when a key is pressed.
		do
			if keys_by_code.has (a_key.code) then
				keys_by_code.at (a_key.code).set_is_pressed (True)
				key_handlers.do_all (agent notify_key_handler (?, keys_by_code.at (a_key.code), True))
			end
		end

	key_release (a_key: EV_KEY)
			-- Called when a key is depressed.
		do
			if keys_by_code.has (a_key.code) then
				keys_by_code.at (a_key.code).set_is_pressed (False)
				key_handlers.do_all (agent notify_key_handler (?, keys_by_code.at (a_key.code), False))
			end
		end

	notify_key_handler (a_handler: PROCEDURE[ANY, TUPLE[key: INPUT_KEY; pressed: BOOLEAN]]; a_key: INPUT_KEY; a_pressed: BOOLEAN)
			-- Notifies a single key handled.
		do
			a_handler.call ([a_key, a_pressed])
		end


invariant
	keys_by_name_exists: keys_by_name /= Void
	keys_by_code_exists: keys_by_code /= Void
	keys_by_name_by_code_corresponds: keys_by_name.count = keys_by_code.count
	key_handlers_exists: key_handlers /= Void

end
