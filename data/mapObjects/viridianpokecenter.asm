	Warp 3, 7, 0
	Warp 4, 7, 0

	NPC SPRITE_NURSE, 3, 1, STAY, DOWN
		text 
		TX_POKECENTER_NURSE

	NPC SPRITE_GENTLEMAN, 10, 5, WALK, 1
		text "You can use that"
		next "PC in the corner."

		para "The receptionist"
		next "told me. So kind!"
		
	NPC SPRITE_BLACK_HAIR_BOY_1, 4, 3, STAY, NONE
		text "There's a POKéMON"
		next "CENTER in every"
		cont "town ahead."

		para "They don't charge"
		next "any money either!"

	NPC SPRITE_CABLE_CLUB_WOMAN, 11, 2, STAY, DOWN
		text
		TX_CABLE_CLUB_RECEPTIONIST

	WarpTo 3, 7
	WarpTo 4, 7
