GymStatues:
; if in a gym and have the corresponding badge, a = GymStatueText2_id and jp PrintPredefTextID
; if in a gym and don’t have the corresponding badge, a = GymStatueText1_id and jp PrintPredefTextID
; else ret
	call EnableAutoTextBoxDrawing
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	ld hl, .BadgeFlags
	ld a, [wCurMap]
	ld b, a
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, .match
	inc hl
	jr .loop
.match
	ld b, [hl]
	ld a, [wBeatGymFlags]
	and b
	cp b
	tx_pre_id GymStatueText2
	jr z, .haveBadge
	tx_pre_id GymStatueText1
.haveBadge
	jp PrintPredefTextID

.BadgeFlags:
	db PEWTER_GYM,   %00000001
	db CERULEAN_GYM, %00000010
	db VERMILION_GYM,%00000100
	db CELADON_GYM,  %00001000
	db FUCHSIA_GYM,  %00010000
	db SAFFRON_GYM,  %00100000
	db CINNABAR_GYM, %01000000
	db VIRIDIAN_GYM, %10000000
	db $ff

GymStatueText1:
	fartext _GymStatueText1
	done

GymStatueText2:
	fartext _GymStatueText2
	done

PrintBenchGuyText:
	call EnableAutoTextBoxDrawing
	ld hl, BenchGuyTextPointers
	ld a, [wCurMap]
	ld b, a
.loop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, .match
	inc hl
	inc hl
	jr .loop
.match
	ld a, [hli]
	ld b, a
	ld a, [wSpriteStateData1 + 9]
	cp b
	jr nz, .loop ; player isn't facing left at the bench guy
	ld a, [hl]
	jp PrintPredefTextID

; format: db map id, player sprite facing direction, text id of PredefTextIDPointerTable
BenchGuyTextPointers:
	db VIRIDIAN_POKECENTER,   SPRITE_FACING_LEFT
	db_tx_pre ViridianCityPokecenterBenchGuyText
	db PEWTER_POKECENTER,     SPRITE_FACING_LEFT
	db_tx_pre PewterCityPokecenterBenchGuyText
	db CERULEAN_POKECENTER,   SPRITE_FACING_LEFT
	db_tx_pre CeruleanCityPokecenterBenchGuyText
	db LAVENDER_POKECENTER,   SPRITE_FACING_LEFT
	db_tx_pre LavenderCityPokecenterBenchGuyText
	db VERMILION_POKECENTER,  SPRITE_FACING_LEFT
	db_tx_pre VermilionCityPokecenterBenchGuyText
	db CELADON_POKECENTER,    SPRITE_FACING_LEFT
	db_tx_pre CeladonCityPokecenterBenchGuyText
	db CELADON_HOTEL,         SPRITE_FACING_LEFT
	db_tx_pre CeladonCityHotelText
	db FUCHSIA_POKECENTER,    SPRITE_FACING_LEFT
	db_tx_pre FuchsiaCityPokecenterBenchGuyText
	db CINNABAR_POKECENTER,   SPRITE_FACING_LEFT
	db_tx_pre CinnabarIslandPokecenterBenchGuyText
	db SAFFRON_POKECENTER,    SPRITE_FACING_LEFT
	db_tx_pre SaffronCityPokecenterBenchGuyText
	db MT_MOON_POKECENTER,    SPRITE_FACING_LEFT
	db_tx_pre MtMoonPokecenterBenchGuyText
	db ROCK_TUNNEL_POKECENTER,SPRITE_FACING_LEFT
	db_tx_pre RockTunnelPokecenterBenchGuyText
	db $FF

ViridianCityPokecenterBenchGuyText:
	fartext _ViridianCityPokecenterGuyText
	done

PewterCityPokecenterBenchGuyText:
	fartext _PewterCityPokecenterGuyText
	done

CeruleanCityPokecenterBenchGuyText:
	fartext _CeruleanPokecenterGuyText
	done

LavenderCityPokecenterBenchGuyText:
	fartext _LavenderPokecenterGuyText
	done

MtMoonPokecenterBenchGuyText:
	fartext _MtMoonPokecenterBenchGuyText
	done

RockTunnelPokecenterBenchGuyText:
	fartext _RockTunnelPokecenterGuyText
	done

UnusedBenchGuyText1:
	fartext _UnusedBenchGuyText1
	done

UnusedBenchGuyText2:
	fartext _UnusedBenchGuyText2
	done

UnusedBenchGuyText3:
	fartext _UnusedBenchGuyText3
	done

VermilionCityPokecenterBenchGuyText:
	fartext _VermilionPokecenterGuyText
	done

CeladonCityPokecenterBenchGuyText:
	fartext _CeladonCityPokecenterGuyText
	done

FuchsiaCityPokecenterBenchGuyText:
	fartext _FuchsiaCityPokecenterGuyText
	done

CinnabarIslandPokecenterBenchGuyText:
	fartext _CinnabarPokecenterGuyText
	done

SaffronCityPokecenterBenchGuyText:
	asmtext
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SaffronCityPokecenterBenchGuyText2
	jr nz, .asm_624f2
	ld hl, SaffronCityPokecenterBenchGuyText1
.asm_624f2
	call PrintText
	jp TextScriptEnd

SaffronCityPokecenterBenchGuyText1:
	fartext _SaffronCityPokecenterGuyText1
	done

SaffronCityPokecenterBenchGuyText2:
	fartext _SaffronCityPokecenterGuyText2
	done

CeladonCityHotelText:
	fartext _CeladonCityHotelText
	done

	ret

UnusedPredefText:
	db "@"

PrintBookcaseText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump BookcaseText

BookcaseText:
	fartext _BookcaseText
	done

OpenPokemonCenterPC:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP ; check to see if player is facing up
	ret nz
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	tx_pre_jump PokemonCenterPCText

PokemonCenterPCText:
	TX_POKECENTER_PC
