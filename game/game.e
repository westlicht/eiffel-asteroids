note
	description: "Implements main logic of the game."
	author: "Simon Kallweit"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

create
	make_with_engine


feature -- Access

	engine: ENGINE
			-- Game engine.

	world: WORLD
			-- World.	

	player: PLAYER
			-- Player.

	hud: HUD
			-- HUD.


feature -- Initialization

	make_with_engine (a_engine: ENGINE)
			-- Creates the game.
		require
			engine_exists: a_engine /= Void
		do
			engine := a_engine

			-- Create the world
			create world.make (Current)

			-- Create player
			create player.make (engine)
			engine.put_object (player)

			-- Create HUD
			create hud.make (Current)

			-- Load the world
			world.prepare_level (1)
		end

end
