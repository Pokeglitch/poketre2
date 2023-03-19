	Warp 4, 11, 2
	Warp 5, 11, 2

	NPC SPRITE_BLUE, 4, 3, STAY, NONE
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

	NPC SPRITE_BALL, 6, 3, STAY, NONE
		textbox NO_TEXTBOX
		asmtext
		ld a, STARTER2
		ld [wRivalStarterTemp], a
		ld a, $3
		ld [wRivalStarterBallSpriteIndex], a
		ld a, STARTER1
		ld b, $2
		goto OaksLabPokeballText

	NPC SPRITE_BALL, 7, 3, STAY, NONE
		textbox NO_TEXTBOX
		asmtext
		ld a, STARTER3
		ld [wRivalStarterTemp], a
		ld a, $4
		ld [wRivalStarterBallSpriteIndex], a
		ld a, STARTER2
		ld b, $3
		goto OaksLabPokeballText

	NPC SPRITE_BALL, 8, 3, STAY, NONE
		textbox NO_TEXTBOX
		asmtext
		ld a, STARTER1
		ld [wRivalStarterTemp], a
		ld a, $2
		ld [wRivalStarterBallSpriteIndex], a
		ld a, STARTER3
		ld b, $4
		
	OaksLabPokeballText:
		ld [wcf91], a
		ld [wd11e], a
		ld a, b
		ld [wSpriteIndex], a
		CheckEvent EVENT_GOT_STARTER
		jr nz, .OaksLabLastMon
		CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
		jr nz, .OaksLabOfferStarter
		
		textbox DEFAULT_SPEECH_TEXTBOX
		text "Those are #"
		next "BALLs. They"
		cont "contain POKéMON!"
		done

		ret

	.OaksLabLastMon
		ld a, $5
		ld [H_SPRITEINDEX], a
		ld a, $9
		ld [H_SPRITEDATAOFFSET], a
		call GetPointerWithinSpriteStateData1
		ld [hl], $0

		textbox DEFAULT_SPEECH_TEXTBOX
		text "That's PROF.OAK's"
		next "last POKéMON!"
		done
		ret

	.OaksLabOfferStarter
		ld a, $5
		ld [H_SPRITEINDEX], a
		ld a, $9
		ld [H_SPRITEDATAOFFSET], a
		call GetPointerWithinSpriteStateData1
		ld [hl], SPRITE_FACING_DOWN
		ld a, $1
		ld [H_SPRITEINDEX], a
		ld a, $9
		ld [H_SPRITEDATAOFFSET], a
		call GetPointerWithinSpriteStateData1
		ld [hl], SPRITE_FACING_RIGHT
		ld hl, wd730
		set 6, [hl]
		predef StarterDex
		ld hl, wd730
		res 6, [hl]
		
		Delay 10

		ld a, [wSpriteIndex]
		cp 2
		jr z, .LookAtCharmander
		cp 3
		jr z, .LookAtSquirtle
		
	.LookAtBulbasaur
		textbox DEFAULT_SPEECH_TEXTBOX
		text "So! You want the"
		next "plant POKéMON,"
		cont "BULBASAUR?"
		gototext OaksLabYesNoText
		ret
		
	.LookAtCharmander
		textbox DEFAULT_SPEECH_TEXTBOX
		text "So! You want the"
		next "fire POKéMON,"
		cont "CHARMANDER?"
		gototext OaksLabYesNoText
		ret

	.LookAtSquirtle
		textbox DEFAULT_SPEECH_TEXTBOX
		text "So! You want the"
		next "water POKéMON,"
		cont "SQUIRTLE?"
	OaksLabYesNoText:
		two_opt YesText, NoText, .yes, .no
	.no
		close
	.yes
		asmtext
		ld a, [wcf91]
		ld [wPlayerStarter], a
		ld [wd11e], a
		call GetMonName
		ld a, [wSpriteIndex]
		cp $2
		jr nz, .asm_1d1db
		ld a, HS_STARTER_BALL_1
		jr .asm_1d1e5

	.asm_1d1db
		cp $3
		jr nz, .asm_1d1e3
		ld a, HS_STARTER_BALL_2
		jr .asm_1d1e5

	.asm_1d1e3
		ld a, HS_STARTER_BALL_3

	.asm_1d1e5
		ld [wMissableObjectIndex], a
		predef HideObject
		ld a, $1
		ld [wDoNotWaitForButtonPressAfterDisplayingText], a

		text "This POKéMON is"
		next "really energetic!"
		prompt
		printtext
		
		text "<PLAYER> received"
		next "a "
		ramtext wcd6d
		text "!"
		sfxtext SFX_GET_KEY_ITEM
		done
		printtext

		xor a ; PLAYER_PARTY_DATA
		ld [wMonDataLocation], a
		ld a, 5
		ld [wCurEnemyLVL], a
		ld a, [wcf91]
		ld [wd11e], a
		call AddPartyMon
		ld hl, wd72e
		set 3, [hl]
		ld a, $fc
		ld [wJoyIgnore], a
		ld a, 2
		ld [wOaksLabCurScript], a
		asmdone
	asmexit

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
