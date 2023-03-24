	Warp 3, 7, 1
	Warp 4, 7, 1

	NPC SPRITE_MART_GUY, 0, 5, STAY, RIGHT
		asm
			CheckEvent EVENT_OAK_GOT_PARCEL
			jr nz, .OakGotParcel

				text "Okay! Say hi to"
				next "PROF.OAK for me!"
				done
			jr .finish
			
		.OakGotParcel
			; todo - will need to call up new mart screen
			ld hl, ViridianCashierText
		finish

	NPC SPRITE_BUG_CATCHER, 5, 5, WALK, 1
		text "This shop sells"
		next "many ANTIDOTEs."
		
	NPC SPRITE_BLACK_HAIR_BOY_1, 3, 3, STAY, NONE
		text "No! POTIONs are"
		next "all sold out."

	WarpTo 3, 7
	WarpTo 4, 7
