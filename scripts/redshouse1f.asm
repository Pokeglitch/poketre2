RedsHouse1FScript:
	jp EnableAutoTextBoxDrawing

RedsHouse1FTextPointers:
	dw RedsHouse1FText1
	dw RedsHouse1FText2

RedsHouse1FText1: ; Mom
	text ""
	asmtext
	ld a, [wd72e]
	bit 3, a
	jr nz, .heal ; if player has received a Pokémon from Oak, heal team
	ld hl, MomWakeUpText
	call PrintText
	jr .done
.heal
	call MomHealPokemon
.done
	jp TextScriptEnd

MomWakeUpText:
	text ""
	fartext _MomWakeUpText
	done

MomHealPokemon:
	ld hl, MomHealText1
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, MomHealText2
	jp PrintText

MomHealText1:
	text ""
	fartext _MomHealText1
	done
MomHealText2:
	text ""
	fartext _MomHealText2
	done

RedsHouse1FText2: ; TV
	text ""
	asmtext
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ld hl, TVWrongSideText
	jr nz, .notUp
	ld hl, StandByMeText
.notUp
	call PrintText
	jp TextScriptEnd

StandByMeText:
	text ""
	fartext _StandByMeText
	done

TVWrongSideText:
	text ""
	fartext _TVWrongSideText
	done
