note
	description: "Summary description for {GAME_STATE_EXIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_EXIT

inherit
	GAME_STATE
		redefine
			enter,
			handle_key
		end

create
	make


feature -- State

	enter
			-- Called to enter the state.
		do
			set_title ("EXIT?")
			set_message ("Press ENTER to exit the game, ESC to abort.")
			game.player.active := False
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter then
					game.engine.exit
				elseif key = game.engine.input_manager.key_escape then
					
				end
			end
		end

end
