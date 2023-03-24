/*
-- enable auto textbox drawing should simply be called before executing map script??

Get the Hide/Show to work

Make 'ExecuteSpinnerMotion' generic and exec before map script getting called?
*/
	pre
		ld hl, Gym8CityName
		ld de, Gym8LeaderName
		call LoadGymLeaderAndCityName
		jp EnableAutoTextBoxDrawing

Gym8CityName:
	str "VIRIDIAN CITY"
Gym8LeaderName:
	str "GIOVANNI"

	script CheckForSpinnerTiles
		ld a, [wYCoord]
		ld b, a
		ld a, [wXCoord]
		ld c, a
		ld hl, ViridianGymArrowTilePlayerMovement
		call DecodeArrowMovementRLE
		cp -1
		ret z
		
		call StartSimulatingJoypadStates

		; TODO:
		; PlayerIsSpinning@set 7, hl / a (optional)
		set_hl 7, wd736

		ld a, SFX_ARROW_TILES
		call PlaySound
		
		IgnoreButtons All
		set_script 1;ExecuteSpinnerMotion
		ret

;format:
;db y,x
;dw pointer to movement
ViridianGymArrowTilePlayerMovement:
	db $b,$13
	dw ViridianGymArrowMovement1
	db $1,$13
	dw ViridianGymArrowMovement2
	db $2,$12
	dw ViridianGymArrowMovement3
	db $2,$b
	dw ViridianGymArrowMovement4
	db $a,$10
	dw ViridianGymArrowMovement5
	db $6,$4
	dw ViridianGymArrowMovement6
	db $d,$5
	dw ViridianGymArrowMovement7
	db $e,$4
	dw ViridianGymArrowMovement8
	db $f,$0
	dw ViridianGymArrowMovement9
	db $f,$1
	dw ViridianGymArrowMovement10
	db $10,$d
	dw ViridianGymArrowMovement11
	db $11,$d
	dw ViridianGymArrowMovement12
	db $FF

;format: direction, count
ViridianGymArrowMovement1:
	db D_UP,$09,$FF

ViridianGymArrowMovement2:
	db D_LEFT,$08,$FF

ViridianGymArrowMovement3:
	db D_DOWN,$09,$FF

ViridianGymArrowMovement4:
	db D_RIGHT,$06,$FF

ViridianGymArrowMovement5:
	db D_DOWN,$02,$FF

ViridianGymArrowMovement6:
	db D_DOWN,$07,$FF

ViridianGymArrowMovement7:
	db D_RIGHT,$08,$FF

ViridianGymArrowMovement8:
	db D_RIGHT,$09,$FF

ViridianGymArrowMovement9:
	db D_UP,$08,$FF

ViridianGymArrowMovement10:
	db D_UP,$06,$FF

ViridianGymArrowMovement11:
	db D_LEFT,$06,$FF

ViridianGymArrowMovement12:
	db D_LEFT,$0C,$FF

	script ExecuteSpinnerMotion
		ld a, [wSimulatedJoypadStatesIndex]
		and a
		jr nz, .stillSpinning

		res_hl 7, wd736
		jp ResetViridianGymScript

	.stillSpinning
		jpba LoadSpinnerArrowTiles


	script AfterDefeatGiovanni
		IgnoreButtons DPad
		;fall through

AfterDefeatGiovanniText:
		text "The EARTHBADGE"
		next "makes POKéMON of"
		cont "any level obey!"

		para "It is evidence of"
		next "your mastery as a"
		cont "POKéMON trainer!"

		para "With it, you can"
		next "enter the POKéMON"
		cont "LEAGUE!"

		para "It is my gift for"
		next "your POKéMON"
		cont "LEAGUE challenge!"
		done

	SetEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI

	give_item TM_27
	jr nc, .BagFull

		text "<PLAYER> received"
		next "TM27!"
		sfxtext SFX_GET_ITEM_1
		para "TM27 is FISSURE!"
		next "It will take out"
		cont "POKéMON with just"
		cont "one hit!"
	
		para "I made it when I"
		next "ran the GYM here,"
		cont "too long ago..."
		done

	SetEvent EVENT_GOT_TM27
	jr .finish

.BagFull
		text "You do not have"
		next "space for this!"
		done
	
.finish
	set_hl 7, wObtainedBadges
	set_hl 7, wBeatGymFlags

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7

	ld a, HS_ROUTE_22_RIVAL_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	SetEvents EVENT_2ND_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

ResetViridianGymScript:
	IgnoreButtons None
	set_script 0;CheckForSpinnerTiles
	ret
