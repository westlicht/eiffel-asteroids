note
	description: "Summary description for {GAME_STATE_NEW_HIGHSCORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE_NEW_HIGHSCORE

inherit
	GAME_STATE
		redefine
			enter,
			leave,
			handle_key
		end

create
	make


feature -- State

	enter
			-- Called to enter the state.
		do
			Precursor
			set_title ("NEW HIGHSCORE")
			set_message ("Your score is " + game.player.score.value.out + ".%N%NEnter your name and press ENTER to accept or ESC to abort:")
			game.player.active := False

			game.engine.input_manager.prompt := game.player.name
			game.engine.input_manager.prompt_handler := agent handle_prompt
			game.hud.name_entry_text.text := game.player.name
		end

	leave
			-- Called to leave the state.
		do
			Precursor
			game.engine.input_manager.prompt_handler := Void
			game.hud.name_entry_text.text.make_empty
		end


feature -- Key handling

	handle_key (key: INPUT_KEY; pressed: BOOLEAN)
		do
			if pressed then
				if key = game.engine.input_manager.key_enter and game.engine.input_manager.prompt.count >= 3 then
					game.player.name := game.engine.input_manager.prompt
					game.highscore.insert (create {HIGHSCORE}.make (game.player.name, game.player.score.value, create {DATE_TIME}.make_now_utc))
					game.highscore.save_to_file (game.Highscore_filename)
					game.state_manager.switch_state(game.state_highscore)
				elseif key = game.engine.input_manager.key_escape then
					game.state_manager.switch_state(game.state_intro)
				end
			end
		end

	handle_prompt (a_prompt: STRING)
		do
			game.hud.name_entry_text.text := a_prompt
		end


end
