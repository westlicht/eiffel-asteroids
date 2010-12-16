note
	description: "Handles the HUD."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	HUD

create
	make


feature -- Constants

	Health_bar_position: VECTOR2
			-- Position of health bar.
		once
			create Result.make (10.0, 10.0)
		end

	Health_bar_color: COLOR
			-- Color of health bar.
		once
			Result.make_with_rgb (1.0, 0.2, 0.2)
		end

	Energy_bar_position: VECTOR2
			-- Position of energy bar.
		once
			create Result.make (10.0, 30.0)
		end

	Energy_bar_color: COLOR
			-- Color of energy bar.
		once
			Result.make_with_rgb (0.2, 0.2, 1.0)
		end

	Bar_size: VECTOR2
			-- Bar size.
		once
			create Result.make (150.0, 12.0)
		end

	Score_text_position: VECTOR2
			-- Position of score text.
		once
			create Result.make (10.0, 20.0)
		end

	Title_text_position: VECTOR2
			-- Position of title text.
		once
			create Result.make (0.0, 200.0)
		end

	Message_text_position: VECTOR2
			-- Position of message text.
		once
			create Result.make (0.0, 250.0)
		end


feature -- Access

	game: GAME
		-- Game.

	hud_manager: HUD_MANAGER
		-- Alias to the HUD manager.


feature -- Widgets

	health_bar: HUD_BAR
	health_text: HUD_TEXT
	energy_bar: HUD_BAR
	energy_text: HUD_TEXT
	score_text: HUD_TEXT
	title_text: HUD_TEXT
	message_text: HUD_TEXT


feature -- Initialization

	make (a_game: GAME)
		require
			game: a_game /= Void
		do
			game := a_game
			hud_manager := a_game.engine.hud_manager

			-- Create health bar
			create health_bar.make (hud_manager)
			health_bar.position := Health_bar_position
			health_bar.size := Bar_size
			health_bar.bar_color := Health_bar_color
			hud_manager.put_widget (health_bar)

			-- Create health text
			create health_text.make (hud_manager)
			health_text.position := health_bar.position
			health_text.position.x := health_bar.position.x + health_bar.size.x + 10.0
			hud_manager.put_widget (health_text)

			-- Create energy
			create energy_bar.make (hud_manager)
			energy_bar.position := Energy_bar_position
			energy_bar.size := Bar_size
			energy_bar.bar_color := Energy_bar_color
			hud_manager.put_widget (energy_bar)

			-- Create energy text
			create energy_text.make (hud_manager)
			energy_text.position := energy_bar.position
			energy_text.position.x := energy_bar.position.x + energy_bar.size.x + 10.0
			hud_manager.put_widget (energy_text)

			-- Create score text
			create score_text.make (hud_manager)
			score_text.position := Score_text_position
			score_text.position.y := game.engine.renderer.screen_height - score_text.position.y
			hud_manager.put_widget (score_text)

			-- Create title text (in center of screen)
			create title_text.make (hud_manager)
			title_text.position := Title_text_position
			title_text.size.x := game.engine.renderer.screen_width
			title_text.font_id := game.engine.renderer.Font_id_large
			title_text.horizontal_align := title_text.Horizontal_align_center
			hud_manager.put_widget (title_text)

			-- Create message text
			create message_text.make (hud_manager)
			message_text.position := Message_text_position
			message_text.size.x := game.engine.renderer.screen_width
			message_text.font_id := game.engine.renderer.Font_id_small
			message_text.horizontal_align := message_text.Horizontal_align_center
			hud_manager.put_widget (message_text)

			-- Add observers for health and energy
			game.player.health.register_observer (agent health_changed)
			game.player.energy.register_observer (agent energy_changed)
			game.player.score.register_observer (agent score_changed)
		end

	health_changed (a_sender: NUMERIC_VALUE)
		do
			health_bar.min := a_sender.min
			health_bar.max := a_sender.max
			health_bar.value := a_sender.value
			health_text.text := "Health: " + a_sender.value.out + "/" + a_sender.max.out
		end

	energy_changed (a_sender: NUMERIC_VALUE)
		do
			energy_bar.min := a_sender.min
			energy_bar.max := a_sender.max
			energy_bar.value := a_sender.value
			energy_text.text := "Energy: " + a_sender.value.out + "/" + a_sender.max.out
		end

	score_changed (a_sender: NUMERIC_VALUE)
		do
			score_text.text := "Score: " + a_sender.value.out
		end


invariant
	game_exists: game /= Void
	hud_manager_assigned: hud_manager /= Void

end
