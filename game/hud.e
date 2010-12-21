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

	Health_bar_color: COLOR
			-- Color of health bar.
		once
			Result.set_rgb (1.0, 0.2, 0.2)
		end

	Energy_bar_color: COLOR
			-- Color of energy bar.
		once
			Result.set_rgb (0.2, 0.2, 1.0)
		end


feature -- Access

	game: GAME
			-- Game.

	hud_manager: HUD_MANAGER
			-- Alias to the HUD manager.

	stats_visible: BOOLEAN assign set_stats_visible
			-- Sets visibility of player stats widgets.


feature -- Widgets

	health_bar: HUD_BAR
	health_text: HUD_TEXT
	energy_bar: HUD_BAR
	energy_text: HUD_TEXT
	score_text: HUD_TEXT
	highscore_text: HUD_TEXT
	title_text: HUD_TEXT
	message_text: HUD_TEXT


feature -- Initialization

	make (a_game: GAME)
		require
			game: a_game /= Void
		do
			game := a_game
			hud_manager := a_game.engine.hud_manager
			stats_visible := True

			-- Create health bar
			create health_bar.make (hud_manager)
			health_bar.position.set (10.0, 10.0)
			health_bar.size.set (150, 15.0)
			health_bar.bar_color := Health_bar_color
			hud_manager.put_widget (health_bar)

			-- Create health text
			create health_text.make (hud_manager)
			health_text.position := health_bar.position
			health_text.position.x := health_bar.position.x + health_bar.size.x + 10.0
			hud_manager.put_widget (health_text)

			-- Create energy
			create energy_bar.make (hud_manager)
			energy_bar.position.set (10.0, 30.0)
			energy_bar.size.set (150, 15.0)
			energy_bar.bar_color := Energy_bar_color
			hud_manager.put_widget (energy_bar)

			-- Create energy text
			create energy_text.make (hud_manager)
			energy_text.position := energy_bar.position
			energy_text.position.x := energy_bar.position.x + energy_bar.size.x + 10.0
			hud_manager.put_widget (energy_text)

			-- Create score text
			create score_text.make (hud_manager)
			score_text.position.set (10.0, 10.0)
			score_text.size.set (game.engine.renderer.screen_width.to_real - 20.0, 10.0)
			score_text.horizontal_align := score_text.Horizontal_align_right
			hud_manager.put_widget (score_text)

			-- Create highscore text
			create highscore_text.make (hud_manager)
			highscore_text.position.set (10.0, game.engine.renderer.screen_height.to_real - 20.0)
			hud_manager.put_widget (highscore_text)

			-- Create title text (in center of screen)
			create title_text.make (hud_manager)
			title_text.position.set (0.0, 200.0)
			title_text.size.x := game.engine.renderer.screen_width
			title_text.font_id := game.engine.renderer.Font_id_large
			title_text.horizontal_align := title_text.Horizontal_align_center
			hud_manager.put_widget (title_text)

			-- Create message text
			create message_text.make (hud_manager)
			message_text.position.set (0.0, 250.0)
			message_text.size.x := game.engine.renderer.screen_width
			message_text.font_id := game.engine.renderer.Font_id_small
			message_text.horizontal_align := message_text.Horizontal_align_center
			hud_manager.put_widget (message_text)

			-- Add observers for health, energy, score and highscore
			game.player.health.register_observer (agent health_changed)
			game.player.energy.register_observer (agent energy_changed)
			game.player.score.register_observer (agent score_changed)
			game.highscore.max_score.register_observer (agent highscore_changed)

		end

	health_changed (a_sender: NUMERIC_VALUE [REAL])
		do
			health_bar.min := a_sender.min
			health_bar.max := a_sender.max
			health_bar.value := a_sender.value
			health_text.text := "Health: " + a_sender.value.rounded.out + "/" + a_sender.max.rounded.out
		end

	energy_changed (a_sender: NUMERIC_VALUE [REAL])
		do
			energy_bar.min := a_sender.min
			energy_bar.max := a_sender.max
			energy_bar.value := a_sender.value
			energy_text.text := "Energy: " + a_sender.value.rounded.out + "/" + a_sender.max.rounded.out
		end

	score_changed (a_sender: NUMERIC_VALUE [INTEGER])
		do
			score_text.text := "Score: " + a_sender.value.out
		end

	highscore_changed (a_sender: NUMERIC_VALUE [INTEGER])
		do
			highscore_text.text := "Highscore: " + a_sender.value.out
		end

feature -- Access

	set_stats_visible (a_stats_visible: like stats_visible)
		do
			stats_visible := a_stats_visible
			health_bar.visible := stats_visible
			health_text.visible := stats_visible
			energy_bar.visible := stats_visible
			energy_text.visible := stats_visible
			score_text.visible := stats_visible
		end


invariant
	game_exists: game /= Void
	hud_manager_assigned: hud_manager /= Void

end
