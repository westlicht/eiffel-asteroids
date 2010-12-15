note
	description: "Summary description for {SCENE_START}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_START

inherit
	GAME_STATE
		redefine
			activate,
			deactivate,
			handle_key
		end

create
	make


feature -- Activation

	activate
			-- Called to activate the scene.
		do
			game.world.prepare_idle
			game.level := game.Level_min
			game.player.active := False
			update_screen
		end

	deactivate
			-- Called to deactivate the scene.
		do

		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key.name.is_equal ("enter") then
					game.state_manager.switch_state(game.state_get_ready)
				elseif key.name.is_equal ("up") then
					if game.level < game.Level_max then
						game.level := game.level + 1
						update_screen
					end
				elseif key.name.is_equal ("down") then
					if game.level > game.Level_min then
						game.level := game.level - 1
						update_screen
					end
				end
			end
		end


feature -- Implementation

	update_screen
		do
			set_message ("STARTING AT LEVEL: " + game.level.out)
		end

end
