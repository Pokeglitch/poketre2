	Warp 4, 11, 2
	Warp 5, 11, 2

	NPC SPRITE_BLUE, 4, 3, STAY, NONE
		; todo - just asm, not asmtext
		asmtext
			text "<RIVAL>: Yo"
			next "<PLAYER>! Gramps"
			cont "isn't around!"
			; todo - finish if xxx | finish if not xxx
			CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
			jr z, .finish

			text "<RIVAL>: Heh, I"
			next "don't need to be"
			cont "greedy like you!"
		
			para "Go ahead and"
			next "choose, <PLAYER>!"
			CheckEvent EVENT_GOT_STARTER
			jr z, .finish

			text "<RIVAL>: My"
			next "POKéMON looks a"
			cont "lot stronger."
		finish

	NPC SPRITE_BALL, 6, 3, STAY, NONE, OaksLabText2
	NPC SPRITE_BALL, 7, 3, STAY, NONE, OaksLabText3
	NPC SPRITE_BALL, 8, 3, STAY, NONE, OaksLabText4
	NPC SPRITE_OAK, 5, 2, STAY, DOWN, OaksLabText5

	NPC SPRITE_BOOK_MAP_DEX, 2, 1, STAY, NONE
		OaksLabPokedexText:
			text "It's encyclopedia-"
			next "like, but the"
			cont "pages are blank!"

	NPC SPRITE_BOOK_MAP_DEX, 3, 1, STAY, NONE, OaksLabPokedexText

	NPC SPRITE_OAK, 5, 10, STAY, UP
		text "?"

	NPC SPRITE_GIRL, 1, 9, WALK, 1
		text "PROF.OAK is the"
		next "authority on"
		cont "POKéMON!"

		para "Many POKéMON"
		next "trainers hold him"
		cont "in high regard!"

	NPC SPRITE_OAK_AIDE, 2, 10, STAY, NONE
		OaksLabAideText:	
			text "I study POKéMON as"
			next "PROF.OAK's AIDE."

	NPC SPRITE_OAK_AIDE, 8, 10, STAY, NONE, OaksLabAideText

	WarpTo 4, 11
	WarpTo 5, 11
