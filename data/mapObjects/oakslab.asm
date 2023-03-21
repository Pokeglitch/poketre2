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
		; fall through
		
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
		; todo - these should be constants (what sprite is it referring to?)
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

		; todo - Use constant (Can assign names to Map Objects...)
		; - or, store to ram before calling OaksLabPokeballText
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
			two_opt YesText, NoText

				; Yes action
				asmtext
					ld a, [wcf91]
					ld [wPlayerStarter], a
					ld [wd11e], a
					call GetMonName
					ld a, [wSpriteIndex]
					cp $2 ; todo - Use constant (Can assign names to Map Objects...) | or, store to ram before calling OaksLabPokeballText
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
		
				; No action
				close
		ret

	NPC SPRITE_OAK, 5, 2, STAY, DOWN
		asmtext
			CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
			jr nz, .DisplayDexRating

			ld hl, wPokedexOwned
			ld b, wPokedexOwnedEnd - wPokedexOwned
			call CountSetBits
			ld a, [wNumSetBits]
			cp 2
			jr c, .NoPokemonCaughtYet

			CheckEvent EVENT_GOT_POKEDEX
			jr z, .NoPokemonCaughtYet

		.DisplayDexRating
				text "OAK: Good to see "
				next "you! How is your "
				cont "POKéDEX coming? "
				cont "Here, let me take"
				cont "a look!"
				prompt
			printtext
			ld a, $1
			ld [wDoNotWaitForButtonPressAfterDisplayingText], a
			predef DisplayDexRating
			jp .end

		.NoPokemonCaughtYet
			ld b, POKE_BALL
			call IsItemInBag
			jr nz, .ComeSeeMe

			CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
			jr nz, .GivePokeballs

			CheckEvent EVENT_GOT_POKEDEX
			jr nz, .GotPokedex

			CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
			jr nz, .AfterRivalBattle
			ld a, [wd72e]
			bit 3, a
			jr nz, .StarterSelected
			
				text "OAK: Now, <PLAYER>,"
				next "which POKéMON do"
				cont "you want?"
			printtext
			jr .end

		.StarterSelected
				text "OAK: If a wild"
				next "POKéMON appears,"
				cont "your POKéMON can"
				cont "fight against it!"
			printtext
			jr .end

		.AfterRivalBattle
			ld b, OAKS_PARCEL
			call IsItemInBag
			jr nz, .GiveParcel
			
				text "OAK: <PLAYER>,"
				next "raise your young"
				cont "POKéMON by making"
				cont "it fight!"
			printtext
			jr .end

		.GiveParcel
				text "OAK: Oh, <PLAYER>!"

				para "How is my old"
				next "POKéMON?"
			
				para "Well, it seems to"
				next "like you a lot."
			
				para "You must be"
				next "talented as a"
				cont "POKéMON trainer!"
			
				para "What? You have"
				next "something for me?"
			
				para "<PLAYER> delivered"
				next "OAK's PARCEL."
			
				sfxtext SFX_GET_KEY_ITEM
			
				para "Ah! This is the"
				next "custom POKé BALL"
				cont "I ordered!"
				cont "Thank you!"
			printtext
			call OaksLabScript_RemoveParcel
			ld a, 5
			ld [wOaksLabCurScript], a
			jr .end

		.GotPokedex
				text "POKéMON around the"
				next "world wait for"
				cont "you, <PLAYER>!"
			printtext
			jr .end

		.GivePokeballs
			CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
			jr nz, .ComeSeeMe
			lb bc, POKE_BALL, 5
			call GiveItem
			
				text "OAK: You can't get"
				next "detailed data on"
				cont "POKéMON by just"
				cont "seeing them."

				para "You must catch"
				next "them! Use these"
				cont "to capture wild"
				cont "POKéMON."

				para "<PLAYER> got 5"
				next "POKé BALLs!"

				sfxtext SFX_GET_KEY_ITEM

				para "When a wild"
				next "POKéMON appears,"
				cont "it's fair game."

				para "Just throw a #"
				next "BALL at it and try"
				next "to catch it!"

				para "This won't always"
				next "work, though."

				para "A healthy POKéMON"
				next "could escape. You"
				cont "have to be lucky!"
			printtext
			jr .end

		.ComeSeeMe
				text "OAK: Come see me"
				next "sometimes."
			
				para "I want to know how"
				next "your POKéDEX is"
				cont "coming along."
			printtext

		.end
			end


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
