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


feature -- State

	enter
			-- Called to enter the state.
		do
		end

	leave
			-- Called to leave the state.
		do
			-- Clear texts as default action
			set_title ("")
			set_message ("")
		end


feature -- Updateing

	update (t: REAL)
			-- Called to update the state.
		do
		end


feature -- Key handling

	handle_key (a_key: INPUT_KEY; pressed: BOOLEAN)
		do

		end


feature -- Utilities

	set_title (a_text: STRING)
		do
			game.hud.title_text.text := a_text
		end

	set_message (a_text: STRING)
		do
			game.hud.message_text.text := a_text
		end

end
