PalletTownScript:
	call EnableAutoTextBoxDrawing

	CheckEvent EVENT_OAK_APPEARED_IN_PALLET
	jr z, CheckOakAppear

	CheckEvent EVENT_DAISY_WALKING
	jr nz, .next
	CheckBothEventsSet EVENT_GOT_TOWN_MAP, EVENT_ENTERED_BLUES_HOUSE, 1
	jr nz, .next
	SetEvent EVENT_DAISY_WALKING
	ld a, HS_DAISY_SITTING
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_DAISY_WALKING
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

.next
	CheckEvent EVENT_GOT_POKEBALLS_FROM_OAK
	ret z
	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS
	ret

CheckOakAppear:
	ld a, [wYCoord]
	cp 1 ; is player near north exit?
	ret nz

	SetEvent EVENT_OAK_APPEARED_IN_PALLET
	xor a
	ld [hJoyHeld], a
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, $FF
	call PlaySound ; stop music
	ld a, BANK(Music_MeetProfOak)
	ld c, a
	ld a, MUSIC_MEET_PROF_OAK ; “oak appears” music
	call PlayMusic
	ld a, $FC
	ld [wJoyIgnore], a

	ld hl, OakAppearsText
	call DisplayTextInTextbox

	ld a, $FF
	ld [wJoyIgnore], a
	ld a, HS_PALLET_TOWN_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject

	ld a, 1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_UP
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	ld a, 1
	ld [wYCoord], a
	ld a, 1
	ld [hNPCPlayerRelativePosPerspective], a
	ld a, 1
	swap a
	ld [hNPCSpriteOffset], a
	predef CalcPositionOfPlayerRelativeToNPC
	ld hl, hNPCPlayerYDistance
	dec [hl]
	predef FindPathToPlayer ; load Oak’s movement into wNPCMovementDirections2
	ld de, wNPCMovementDirections2
	ld a, 1 ; oak
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, $FF
	ld [wJoyIgnore], a

	call WaitForTrainerSprite

	xor a ; ld a, SPRITE_FACING_DOWN
	ld [wSpriteStateData1 + 9], a
	
	ld a, $FC
	ld [wJoyIgnore], a

	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a

	ld hl, OakWalksUpText
	call DisplayTextInTextbox

; set up movement script that causes the player to follow Oak to his lab
	ld a, $FF
	ld [wJoyIgnore], a
	ld a, 1
	ld [wSpriteIndex], a
	xor a
	ld [wNPCMovementScriptFunctionNum], a
	ld a, 1
	ld [wNPCMovementScriptPointerTableNum], a
	ld a, [H_LOADEDROMBANK]
	ld [wNPCMovementScriptBank], a

	jp WaitForNPCMovementScript

PalletTownTrainerHeader0:
	db TrainerHeaderTerminator

PalletTownTextPointers:
	dw 0
	dw PalletTownText2
	dw PalletTownText3
	dw PalletTownText4
	dw PalletTownText5
	dw PalletTownText6
	dw PalletTownText7

OakAppearsText:
	text "OAK: Hey! Wait!"
	next "Don't go out!"

	asmtext
	ld c, 10
	call DelayFrames
	xor a
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

OakWalksUpText:
	text "OAK: It's unsafe!"
	next "Wild POKéMON live"
	cont "in tall grass!"

	para "You need your own"
	next "POKéMON for your"
	cont "protection."
	cont "I know!"

	para "Here, come with"
	next "me!"
	done

PalletTownText2: ; girl
	fartext _PalletTownText2
	done

PalletTownText3: ; fat man
	fartext _PalletTownText3
	done

PalletTownText4: ; sign by lab
	fartext _PalletTownText4
	done

PalletTownText5: ; sign by fence
	fartext _PalletTownText5
	done

PalletTownText6: ; sign by Red’s house
	fartext _PalletTownText6
	done

PalletTownText7: ; sign by Blue’s house
	fartext _PalletTownText7
	done
