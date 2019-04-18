DisplayPokemonCenterDialogue_:
	ld hl, PokemonCenterWelcomeText
	call PrintText
	ld hl, wd72e
	bit 2, [hl]
	set 1, [hl]
	set 2, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	call PrintText
.skipShallWeHealYourPokemon
	call HealCancelTextboxOption ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done ; if the player chose No
	call ClearTextboxAndDelay
	call SetLastBlackoutMap
	ld hl, NeedYourPokemonText
	call PrintText
	ld a, $18
	ld [wSpriteStateData1 + $12], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	callba AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlaySound
	ld hl, PokemonFightingFitText
	call PrintText
	ld a, $14
	ld [wSpriteStateData1 + $12], a ; make the nurse bow
	ld c, a
	call DelayFrames
.done
	ld hl, PokemonCenterFarewellText
	call PrintText
	jp UpdateSprites

PokemonCenterWelcomeText:
	TX_FAR _PokemonCenterWelcomeText
	db "@"

ShallWeHealYourPokemonText:
	TX_DELAY
	TX_FAR _ShallWeHealYourPokemonText
	db "@"

NeedYourPokemonText:
	TX_FAR _NeedYourPokemonText
	db "@"

PokemonFightingFitText:
	TX_FAR _PokemonFightingFitText
	db "@"

PokemonCenterFarewellText:
	TX_DELAY
	TX_FAR _PokemonCenterFarewellText
	db "@"
