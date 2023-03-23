	Warp 2, 7, 1
	Warp 3, 7, 1

	NPC SPRITE_DAISY, 2, 3, STAY, RIGHT
		asm
			CheckEvent EVENT_GOT_TOWN_MAP
			jr nz, .GotMap
			
			CheckEvent EVENT_GOT_POKEDEX
			jr nz, .GiveMap
			
				text "Hi <PLAYER>!"
				next "<RIVAL> is out at"
				cont "Grandpa's lab."
				done
			jr .finish

		.GiveMap
				text "Grandpa asked you"
				next "to run an errand?"
				cont "Here, this will"
				cont "help you!"
				prompt
			printtext
			give_item TOWN_MAP
			jr nc, .BagFull

			ld a, HS_TOWN_MAP
			ld [wMissableObjectIndex], a
			predef HideObject ; hide table map object
			SetEvent EVENT_GOT_TOWN_MAP
			
				text "<PLAYER> got a"
				next ""
				ramtext wcf4b
				text "!"
				sfxtext SFX_GET_KEY_ITEM
				done
			jr .finish

		.GotMap
				text "Use the TOWN MAP"
				next "to find out where"
				cont "you are."
				done
			jr .finish

		.BagFull
				text "You have too much"
				next "stuff with you."
		finish

	NPC SPRITE_DAISY, 6, 4, WALK, 1
		text "POKéMON are living"
		next "things! If they"
		cont "get tired, give"
		cont "them a rest!"

	NPC SPRITE_BOOK_MAP_DEX, 3, 3, STAY, NONE
		text "It's a big map!"
		next "This is useful!"

	WarpTo 2, 7
	WarpTo 3, 7
