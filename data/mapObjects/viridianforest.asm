	Warp 1, 0, 2, VIRIDIAN_FOREST_EXIT
	Warp 2, 0, 3, VIRIDIAN_FOREST_EXIT
	Warp 15, 47, 1, VIRIDIAN_FOREST_ENTRANCE
	Warp 16, 47, 1, VIRIDIAN_FOREST_ENTRANCE
	Warp 17, 47, 1, VIRIDIAN_FOREST_ENTRANCE
	Warp 18, 47, 1, VIRIDIAN_FOREST_ENTRANCE

	Sign 24, 40
		text "TRAINER TIPS"

		para "If you want to"
		next "avoid battles,"
		cont "stay away from"
		cont "grassy areas!"

	Sign 16, 32
		text "For poison, use"
		next "ANTIDOTE! Get it"
		cont "at POKéMON MARTs!"

	Sign 26, 17
		text "TRAINER TIPS"

		para "Contact PROF.OAK"
		next "via PC to get"
		cont "your POKéDEX"
		cont "evaluated!"

	Sign 4, 24
		text "TRAINER TIPS"

		para "No stealing of"
		next "POKéMON from"
		cont "other trainers!"
		cont "Catch only wild"
		cont "POKéMON!"

	Sign 18, 45
		text "TRAINER TIPS"

		para "Weaken POKéMON"
		next "before attempting"
		cont "capture!"

		para "When healthy,"
		next "they may escape!"

	Sign 2, 1
		text "LEAVING"
		next "VIRIDIAN FOREST"
		cont "PEWTER CITY AHEAD"

	NPC SPRITE_BUG_CATCHER, 16, 43, STAY, NONE
	 	text "I came here with"
		next "some friends!"

		para "They're out for"
		next "POKéMON fights!"

	Battle SPRITE_BUG_CATCHER, 30, 33, STAY, LEFT, 4, BugCatcher, 1
		text "Hey! You have"
		next "POKéMON! Come on!"
		cont "Let's battle'em!"

		text "Ssh! You'll scare"
		next "the bugs away!"

		text "No!"
		next "CATERPIE can't"
		cont "cut it!"
		
	Battle SPRITE_BUG_CATCHER, 30, 19, STAY, LEFT, 4, BugCatcher, 2
		text "Yo! You can't jam"
		next "out if you're a"
		cont "POKéMON trainer!"

		text "Darn! I'm going"
		next "to catch some"
		cont "stronger ones!"
		
		text "Huh?"
		next "I ran out of"
		cont "POKéMON!"

	Battle SPRITE_BUG_CATCHER, 2, 18, STAY, LEFT, 1, BugCatcher, 3
		text "Hey, wait up!"
		next "What's the hurry?"

		text "Sometimes, you"
		next "can find stuff on"
		cont "the ground!"

		para "I'm looking for"
		next "the stuff I"
		cont "dropped!"

		text "I"
		next "give! You're good"
		cont "at this!"
	
	Pickup 25, 11, ANTIDOTE
	Pickup 12, 29, POTION
	Pickup 1, 31, POKE_BALL
	
	NPC SPRITE_BUG_CATCHER, 27, 40, STAY, NONE
	 	text "I ran out of #"
		next "BALLs to catch"
		cont "POKéMON with!"

		para "You should carry"
		next "extras!"

	; warp-to
	WarpTo 1, 0
	WarpTo 2, 0
	WarpTo 15, 47
	WarpTo 16, 47
	WarpTo 17, 47
	WarpTo 18, 47
