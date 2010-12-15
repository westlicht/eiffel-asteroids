note
	description: "Implements input handling (keyboard)."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	INPUT_MANAGER

create
	make


feature -- Keys

	keys_by_name: HASH_TABLE[INPUT_KEY, STRING]
			-- Hash table of keys indexed by key name

	keys_by_code: HASH_TABLE[INPUT_KEY, INTEGER]
			-- Hash table of keys indexed by key code

feature -- Initialization

	make (a_window: EV_WINDOW)
		do
			create keys_by_name.make (16)
			create keys_by_code.make (16)
			register_default_keys

			-- Register key press/release handlers
			a_window.key_press_actions.extend (agent key_press)
			a_window.key_release_actions.extend (agent key_release)
		end

feature

	register_default_keys
		local
			key_constants: EV_KEY_CONSTANTS
		do
			create key_constants
			register_key ("left", key_constants.key_left)
			register_key ("right", key_constants.key_right)
			register_key ("up", key_constants.key_up)
			register_key ("down", key_constants.key_down)
			register_key ("space", key_constants.key_space)
			register_key ("ctrl", key_constants.key_ctrl)
			register_key ("shift", key_constants.key_shift)
		end


	register_key (name: STRING; key_code: INTEGER)
		local
			key: INPUT_KEY
		do
			create key.make (name, key_code)
			keys_by_name.put (key, name)
			keys_by_code.put (key, key_code)
		end

feature {NONE} -- Implementation

	key_press (key: EV_KEY)
		do
			if keys_by_code.has (key.code) then
				keys_by_code.at (key.code).set_is_pressed (True)
			end
		end

	key_release (key: EV_KEY)
		do
			if keys_by_code.has (key.code) then
				keys_by_code.at (key.code).set_is_pressed (False)
			end
		end

invariant
	keys_by_name_exists: keys_by_name /= Void
	keys_by_code_exists: keys_by_code /= Void
	keys_by_name_by_code_corresponds: keys_by_name.count = keys_by_code.count

end
