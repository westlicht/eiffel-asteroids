note
	description: "Implements game scenes. Scenes can be menus, the game etc."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE

create
	make


feature -- Access

	game: GAME
			-- Game


feature -- Initialization

	make (a_game: GAME)
		require
			game_exists: a_game /= Void
		do
			game := a_game
		end


feature -- Activation

	activate
			-- Called to activate the scene.
		do
		end

	deactivate
			-- Called to deactivate the scene.
		do
		end

	update (t: REAL)
			-- Called to update the scene.
		do
		end


feature -- Key handling

	handle_key (a_key: INPUT_KEY; pressed: BOOLEAN)
		do

		end


feature -- Utilities

	set_message (a_text: STRING)
		do
			game.hud.message_text.text.make_from_string (a_text)
		end

end
