OaksLabScript:
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OaksLabScriptPointers
	ld a, [wOaksLabCurScript]
	jp RunIndexedMapScript

OaksLabScriptPointers:
	dw OaksLabScript0
	dw OaksLabScript1
	dw OaksLabScript2
	dw OaksLabScript3
	dw OaksLabScript4
	dw OaksLabScript5
	dw OaksLabScript6
	dw OaksLabScript7

OakEntryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

PlayerEntryMovementRLE:
	db D_UP,$8
	db $ff

OaksLabScript0:
	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	ret z
	
	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld hl, wd72e
	res 4, [hl]

	ld a, $8
	ld [H_SPRITEINDEX], a
	ld de, OakEntryMovement
	call MoveSprite

	call WaitForNPCMovement

	ld a, HS_OAKS_LAB_OAK_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OAKS_LAB_OAK_1
	ld [wMissableObjectIndex], a
	predef ShowObject

	Delay 3
	ld hl, wSimulatedJoypadStatesEnd
	ld de, PlayerEntryMovementRLE
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	call WaitForScriptedPlayerMovement
	
	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	ld hl, wFlags_D733
	res 1, [hl]
	call PlayDefaultMusic

	xor a
	ld [wJoyIgnore], a

	text "<RIVAL>: Gramps!"
	next "I'm fed up with"
	cont "waiting!"
	
	Delay 3
	
	text "OAK: <RIVAL>?"
	next "Let me think..."

	para "Oh, that's right,"
	next "I told you to"
	cont "come! Just wait!"

	para "Here, <PLAYER>!"

	para "There are 3"
	next "POKéMON here!"

	para "Haha!"

	para "They are inside"
	next "the POKé BALLs."

	para "When I was young,"
	next "I was a serious"
	cont "POKéMON trainer!"

	para "In my old age, I"
	next "have only 3 left,"
	cont "but you can have"
	cont "one! Choose!"
	
	Delay 3

	text "<RIVAL>: Hey!"
	next "Gramps! What"
	cont "about me?"
	
	Delay 3

	text "OAK: Be patient!"
	next "<RIVAL>, you can"
	cont "have one too!"
	done

	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON

	ld a, 1
	ld [wOaksLabCurScript], a
	ret

OaksLabScript1:
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, 5
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call UpdateSprites
	
	text "OAK: Hey! Don't go"
	next "away yet!"
	done

	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates

	jp WaitForScriptedPlayerMovement

OaksLabScript2:
	ld a, [wPlayerStarter]
	cp STARTER1
	jr z, .Charmander
	cp STARTER2
	jr z, .Squirtle
	jr .Bulbasaur
.Charmander
	ld de, .MiddleBallMovement1
	ld a, [wYCoord]
	cp $4 ; is the player standing below the table?
	jr z, .asm_1ccf3
	ld de, .MiddleBallMovement2
	jr .asm_1ccf3

.MiddleBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db $FF

.MiddleBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db $FF

.Squirtle
	ld de, .RightBallMovement1
	ld a, [wYCoord]
	cp $4 ; is the player standing below the table?
	jr z, .asm_1ccf3
	ld de, .RightBallMovement2
	jr .asm_1ccf3

.RightBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db $FF

.RightBallMovement2
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db $FF

.Bulbasaur
	ld de, .LeftBallMovement1
	ld a, [wXCoord]
	cp $9 ; is the player standing to the right of the table?
	jr nz, .asm_1ccf3
	push hl
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, $4
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	push hl
	ld [hl], $4c
	inc hl
	inc hl
	ld [hl], $0
	pop hl
	inc h
	ld [hl], $8
	inc hl
	ld [hl], $9
	ld de, .LeftBallMovement2 ; the rival is not currently onscreen, so account for that
	pop hl
	jr .asm_1ccf3

.LeftBallMovement1
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT ; not yet terminated!
.LeftBallMovement2
	db NPC_MOVEMENT_RIGHT
	db $FF

.asm_1ccf3
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite

	call WaitForNPCMovement

	ld a, $fc
	ld [wJoyIgnore], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	
	text "<RIVAL>: I'll take"
	next "this one, then!"
	done

	ld a, [wRivalStarterBallSpriteIndex]
	cp $2
	jr nz, .asm_1cd28
	ld a, HS_STARTER_BALL_1
	jr .asm_1cd32
.asm_1cd28
	cp $3
	jr nz, .asm_1cd30
	ld a, HS_STARTER_BALL_2
	jr .asm_1cd32
.asm_1cd30
	ld a, HS_STARTER_BALL_3
.asm_1cd32
	ld [wMissableObjectIndex], a
	predef HideObject

	Delay 3
	
	ld a, [wRivalStarterTemp]
	ld [wRivalStarter], a
	ld [wcf91], a
	ld [wd11e], a
	call GetMonName
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	
	text "<RIVAL> received"
	next "a "
	ramtext wcd6d
	more "!"
	done

	SetEvent EVENT_GOT_STARTER
	xor a
	ld [wJoyIgnore], a

	ld a, 3
	ld [wOaksLabCurScript], a
	ret

OaksLabScript3:
	ld a, [wYCoord]
	cp $6
	ret nz
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	
	text "<RIVAL>: Wait"
	next "<PLAYER>!"
	cont "Let's check out"
	cont "our POKéMON!"

	para "Come on, I'll take"
	next "you on!"
	done

	ld a, $1
	ld [hNPCPlayerRelativePosPerspective], a
	ld a, $1
	swap a
	ld [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld a, [hNPCPlayerYDistance]
	dec a
	ld [hNPCPlayerYDistance], a
	predef FindPathToPlayer
	ld de, wNPCMovementDirections2
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite

	call WaitForNPCMovement

	ld a, 1
	ld [wSpriteIndex], a
	call GetSpritePosition1
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	xor a
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	ld a, 4
	ld [wOaksLabCurScript], a

	Battle Rival1
		text "WHAT?"
		next "Unbelievable!"
		cont "I picked the"
		cont "wrong POKéMON!"

		text "<RIVAL>: Yeah! Am"
		next "I great or what?"

		Team switch, wRivalStarter
			case STARTER1, 5, Charmander
			case STARTER2, 5, Squirtle
			case STARTER3, 5, Bulbasaur
		end

RivalExitMovement:
	db $E0 ; change sprite facing direction
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

OaksLabScript4:
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	call UpdateSprites
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ld a, $1
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	predef HealParty
	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB

	Delay 20
	
	text "<RIVAL>: Okay!"
	next "I'll make my"
	cont "POKéMON fight to"
	cont "toughen it up!"

	para "<PLAYER>! Gramps!"
	next "Smell you later!"
	done
	
	callba Music_RivalAlternateStart
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, RivalExitMovement
	call MoveSprite
	ld a, [wXCoord]
	cp $4
	; move left or right depending on where the player is standing
	jr nz, .moveLeft
	ld a, NPC_MOVEMENT_RIGHT
	jr .next
.moveLeft
	ld a, NPC_MOVEMENT_LEFT
.next
	ld [wNPCMovementDirections], a

	call WaitForNPCMovement
	; TODO - want to have player face rival as he walks away...

	;ld a, [wd730]
	;bit 0, a
	;jr nz, .asm_1ce8c
	
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	call PlayDefaultMusic ; reset to map music
	ld a, -1
	ld [wOaksLabCurScript], a
	jr .done
	
; make the player keep facing the rival as he walks away
.asm_1ce8c
	ld a, [wNPCNumScriptedSteps]
	cp $5
	jr nz, .asm_1cea8
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1cea1
	ld a, SPRITE_FACING_RIGHT
	ld [wSpriteStateData1 + 9], a
	jr .done
.asm_1cea1
	ld a, SPRITE_FACING_LEFT
	ld [wSpriteStateData1 + 9], a
	jr .done
.asm_1cea8
	cp $4
	ret nz
	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 9], a
.done
	ret

OaksLabScript5:
	xor a
	ld [hJoyHeld], a
	call EnableAutoTextBoxDrawing
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStart

	text "<RIVAL>: Gramps!"
	done

	call OaksLabScript_1d02b
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wNPCMovementDirections2Index]
	ld [wSavedNPCMovementDirections2Index], a
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	ld a, NPC_MOVEMENT_UP
	call FillMemory
	ld [hl], $ff
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, 6
	ld [wOaksLabCurScript], a
	ret

OaksLabScript_1cefd:
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $8
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	jp SetSpriteFacingDirectionAndDelay

OaksLabScript6:
	ld a, [wd730]
	bit 0, a
	ret nz
	call EnableAutoTextBoxDrawing
	call PlayDefaultMusic
	ld a, $fc
	ld [wJoyIgnore], a
	call OaksLabScript_1cefd
	
	text "<RIVAL>: What did"
	next "you call me for?"

	Delay

	call OaksLabScript_1cefd

	text "OAK: Oh right! I"
	next "have a request"
	cont "of you two."

	Delay

	call OaksLabScript_1cefd

	text "On the desk there"
	next "is my invention,"
	cont "POKéDEX!"

	para "It automatically"
	next "records data on"
	cont "POKéMON you've"
	cont "seen or caught!"

	para "It's a hi-tech"
	next "encyclopedia!"

	Delay

	text "OAK: <PLAYER> and"
	next "<RIVAL>! Take"
	cont "these with you!"

	para "<PLAYER> got"
	next "POKéDEX from OAK!"
	sfxtext SFX_GET_KEY_ITEM
	
	Delay 3

	ld a, HS_POKEDEX_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_POKEDEX_2
	ld [wMissableObjectIndex], a
	predef HideObject
	call OaksLabScript_1cefd

	text "To make a complete"
	next "guide on all the"
	cont "POKéMON in the"
	cont "world..."

	para "That was my dream!"

	para "But, I'm too old!"
	next "I can't do it!"

	para "So, I want you two"
	next "to fulfill my"
	cont "dream for me!"

	para "Get moving, you"
	next "two!"

	para "This is a great"
	next "undertaking in"
	cont "POKéMON history!"
	done

	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

	Delay 3

	text "<RIVAL>: Alright"
	next "Gramps! Leave it"
	cont "all to me!"

	para "<PLAYER>, I hate to"
	next "say it, but I"
	cont "don't need you!"

	para "I know! I'll"
	next "borrow a TOWN MAP"
	cont "from my sis!"

	para "I'll tell her not"
	next "to lend you one,"
	cont "<PLAYER>! Hahaha!"
	done

	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_OAK_GOT_PARCEL
	ld a, HS_LYING_OLD_MAN
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OLD_MAN
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, [wSavedNPCMovementDirections2Index]
	ld b, 0
	ld c, a
	ld hl, wNPCMovementDirections2
	xor a ; NPC_MOVEMENT_DOWN
	call FillMemory
	ld [hl], $ff
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStart
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld de, wNPCMovementDirections2
	call MoveSprite

	ld a, 7
	ld [wOaksLabCurScript], a
	ret

OaksLabScript7:
	ld a, [wd730]
	bit 0, a
	ret nz
	call PlayDefaultMusic
	ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	xor a
	ld [wJoyIgnore], a
	ld a, -1
	ld [wOaksLabCurScript], a
	ret

OaksLabScript_RemoveParcel:
	ld a, OAKS_PARCEL
	ld [wWhichItem], a
	ld a, 1
	ld [wItemQuantity], a
	jp RemoveItemFromInventory

OaksLabScript_1d02b:
	ld a, $7c
	ld [$ffeb], a
	ld a, $8
	ld [$ffee], a
	ld a, [wYCoord]
	cp $3
	jr nz, .asm_1d045
	ld a, $4
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $b
	jr .asm_1d068
.asm_1d045
	cp $1
	jr nz, .asm_1d054
	ld a, $2
	ld [wNPCMovementDirections2Index], a
	ld a, $30
	ld b, $9
	jr .asm_1d068
.asm_1d054
	ld a, $3
	ld [wNPCMovementDirections2Index], a
	ld b, $a
	ld a, [wXCoord]
	cp $4
	jr nz, .asm_1d066
	ld a, $40
	jr .asm_1d068
.asm_1d066
	ld a, $20
.asm_1d068
	ld [$ffec], a
	ld a, b
	ld [$ffed], a
	ld a, $1
	ld [wSpriteIndex], a
	call SetSpritePosition1
	ret

OaksLabTrainerHeader0:
	db TrainerHeaderTerminator

OaksLabTextPointers:
	dw OaksLabText1
	dw OaksLabText2
	dw OaksLabText3
	dw OaksLabText4
	dw OaksLabText5
	dw OaksLabText6
	dw OaksLabText7
	dw OaksLabText8
	dw OaksLabText9
	dw OaksLabText10
	dw OaksLabText11

OaksLabText1:
	asmtext
	ld hl, RivalBeforeOakText
	CheckEvent EVENT_FOLLOWED_OAK_INTO_LAB
	jr z, .finish

	ld hl, RivalChoosingStarterText
	CheckEvent EVENT_GOT_STARTER
	jr z, .finish

	ld hl, RivalGotStarterText

.finish
	call PrintText
	jp TextScriptEnd

RivalBeforeOakText:
	text "<RIVAL>: Yo"
	next "<PLAYER>! Gramps"
	cont "isn't around!"
	done

RivalChoosingStarterText:
	text "<RIVAL>: Heh, I"
	next "don't need to be"
	cont "greedy like you!"

	para "Go ahead and"
	next "choose, <PLAYER>!"
	done

RivalGotStarterText:
	text "<RIVAL>: My"
	next "POKéMON looks a"
	cont "lot stronger."
	done

OaksLabText2:
	db NO_TEXTBOX
	asmtext
	ld a, STARTER2
	ld [wRivalStarterTemp], a
	ld a, $3
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER1
	ld b, $2
	jr OaksLabScript_1d133

OaksLabText3:
	db NO_TEXTBOX
	asmtext
	ld a, STARTER3
	ld [wRivalStarterTemp], a
	ld a, $4
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER2
	ld b, $3
	jr OaksLabScript_1d133

OaksLabText4:
	db NO_TEXTBOX
	asmtext
	ld a, STARTER1
	ld [wRivalStarterTemp], a
	ld a, $2
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER3
	ld b, $4

OaksLabScript_1d133:
	ld [wcf91], a
	ld [wd11e], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, OaksLabScript_1d22d
	CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	jr nz, OaksLabScript_1d157
	ld hl, OaksLabText39
	ret

OaksLabText39:
	textbox DEFAULT_SPEECH_TEXTBOX
	fartext _OaksLabText39
	done

OaksLabScript_1d157:
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
	cp $2
	jr z, OaksLabLookAtCharmander
	cp $3
	jr z, OaksLabLookAtSquirtle
	jr OaksLabLookAtBulbasaur

OaksLabLookAtCharmander:
	ld hl, OaksLabCharmanderText
	ret
OaksLabCharmanderText:
	textbox DEFAULT_SPEECH_TEXTBOX
	fartext _OaksLabCharmanderText
	gototext OaksLabYesNoText

OaksLabLookAtSquirtle:
	ld hl, OaksLabSquirtleText
	ret
OaksLabSquirtleText:
	textbox DEFAULT_SPEECH_TEXTBOX
	fartext _OaksLabSquirtleText
	gototext OaksLabYesNoText

OaksLabLookAtBulbasaur:
	ld hl, OaksLabBulbasaurText
	ret
OaksLabBulbasaurText:
	textbox DEFAULT_SPEECH_TEXTBOX
	fartext _OaksLabBulbasaurText
	; fall through

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
	ld hl, OaksLabMonEnergeticText
	call PrintText
	ld hl, OaksLabReceivedMonText
	call PrintText
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
	jp TextScriptEnd

OaksLabMonEnergeticText:
	fartext _OaksLabMonEnergeticText
	done

OaksLabReceivedMonText:
	fartext _OaksLabReceivedMonText
	sfxtext SFX_GET_KEY_ITEM
	done

OaksLabScript_1d22d:
	ld a, $5
	ld [H_SPRITEINDEX], a
	ld a, $9
	ld [H_SPRITEDATAOFFSET], a
	call GetPointerWithinSpriteStateData1
	ld [hl], $0
	ld hl, OaksLabLastMonText
	ret

OaksLabLastMonText:
	textbox DEFAULT_SPEECH_TEXTBOX
	fartext _OaksLabLastMonText
	done

OaksLabText5:
	asmtext
	CheckEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	jr nz, .asm_1d266
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 2
	jr c, .asm_1d279
	CheckEvent EVENT_GOT_POKEDEX
	jr z, .asm_1d279
.asm_1d266
	ld hl, OaksLabText_1d31d
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	predef DisplayDexRating
	jp .asm_1d2ed
.asm_1d279
	ld b, POKE_BALL
	call IsItemInBag
	jr nz, .asm_1d2e7
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr nz, .asm_1d2d0
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .asm_1d2c8
	CheckEventReuseA EVENT_BATTLED_RIVAL_IN_OAKS_LAB
	jr nz, .asm_1d2a9
	ld a, [wd72e]
	bit 3, a
	jr nz, .asm_1d2a1
	ld hl, OaksLabText_1d2f0
	call PrintText
	jr .asm_1d2ed
.asm_1d2a1
	ld hl, OaksLabText_1d2f5
	call PrintText
	jr .asm_1d2ed
.asm_1d2a9
	ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, .asm_1d2b8
	ld hl, OaksLabText_1d2fa
	call PrintText
	jr .asm_1d2ed
.asm_1d2b8
	ld hl, OaksLabDeliverParcelText
	call PrintText
	call OaksLabScript_RemoveParcel
	ld a, 5
	ld [wOaksLabCurScript], a
	jr .asm_1d2ed
.asm_1d2c8
	ld hl, OaksLabAroundWorldText
	call PrintText
	jr .asm_1d2ed
.asm_1d2d0
	CheckAndSetEvent EVENT_GOT_POKEBALLS_FROM_OAK
	jr nz, .asm_1d2e7
	lb bc, POKE_BALL, 5
	call GiveItem
	ld hl, OaksLabGivePokeballsText
	call PrintText
	jr .asm_1d2ed
.asm_1d2e7
	ld hl, OaksLabPleaseVisitText
	call PrintText
.asm_1d2ed
	jp TextScriptEnd

OaksLabText_1d2f0:
	fartext _OaksLabText_1d2f0
	done

OaksLabText_1d2f5:
	fartext _OaksLabText_1d2f5
	done

OaksLabText_1d2fa:
	fartext _OaksLabText_1d2fa
	done

OaksLabDeliverParcelText:
	fartext _OaksLabDeliverParcelText1
	sfxtext SFX_GET_KEY_ITEM
	fartext _OaksLabDeliverParcelText2
	done

OaksLabAroundWorldText:
	fartext _OaksLabAroundWorldText
	done

OaksLabGivePokeballsText:
	fartext _OaksLabGivePokeballsText1
	sfxtext SFX_GET_KEY_ITEM
	fartext _OaksLabGivePokeballsText2
	done

OaksLabPleaseVisitText:
	fartext _OaksLabPleaseVisitText
	done

OaksLabText_1d31d:
	fartext _OaksLabText_1d31d
	done

OaksLabText7:
OaksLabText6:
	asmtext
	ld hl, OaksLabText_1d32c
	call PrintText
	jp TextScriptEnd

OaksLabText_1d32c:
	fartext _OaksLabText_1d32c
	done

OaksLabText8:
	fartext _OaksLabText8
	done

OaksLabText9:
	asmtext
	ld hl, OaksLabText_1d340
	call PrintText
	jp TextScriptEnd

OaksLabText_1d340:
	fartext _OaksLabText_1d340
	done

OaksLabText11:
OaksLabText10:
	text "I study POKéMON as"
	next "PROF.OAK's AIDE."
	done
