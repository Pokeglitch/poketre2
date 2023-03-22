RedsHouse1FObject:
	Warp 2, 7, 0
	Warp 3, 7, 0
	Warp 7, 1, 0, REDS_HOUSE_2F

	Sign 3, 1
		asm
				text "Oops, wrong side."
				done
			ld a, [wSpriteStateData1 + 9]
			cp SPRITE_FACING_UP
			jr nz, .finish

				text "There's a movie"
				next "on TV. Four boys"
				cont "are walking on"
				cont "railroad tracks."

				para "I better go too."
		finish

	NPC SPRITE_MOM, 5, 4, STAY, LEFT
		asm
			; todo - this can be a CheckEvent
			ld a, [wd72e]
			bit 3, a
			jr nz, .heal ; if player has received a Pokémon from Oak, heal team
				text "MOM: Right."
				next "All boys leave"
				cont "home some day."
				cont "It said so on TV."
			
				para "PROF.OAK, next"
				next "door, is looking"
				cont "for you."
				done
			jr .finish
		.heal
				text "MOM: <PLAYER>!"
				next "You should take a"
				cont "quick rest."

				wait
				textbox NO_TEXTBOX
			printtext
			call GBFadeOutToWhite
			call ReloadMapData
			predef HealParty
			play_sound MUSIC_PKMN_HEALED
		.next
			ld a, [wChannelSoundIDs]
			cp MUSIC_PKMN_HEALED
			jr z, .next
			call PlayDefaultMusic
			call GBFadeInFromWhite
				textbox DEFAULT_SPEECH_TEXTBOX
				text "MOM: Oh good!"
				next "You and your"
				cont "POKéMON are"
				cont "looking great!"
				cont "Take care now!"
				done
		finish

	WarpTo 2, 7
	WarpTo 3, 7
	WarpTo 7, 1
