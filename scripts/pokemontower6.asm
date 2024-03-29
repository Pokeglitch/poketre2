PokemonTower6Script:
	call EnableAutoTextBoxDrawing
	ld de, PokemonTower6ScriptPointers
	ld a, [wPokemonTower6CurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower6CurScript], a
	ret

PokemonTower6Script_60b02:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower6CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower6ScriptPointers:
	dw PokemonTower6Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PokemonTower6Script3
	dw PokemonTower6Script4

PokemonTower6Script0:
	CheckEvent EVENT_BEAT_GHOST_MAROWAK
	jp nz, CheckFightingMapTrainers
	ld hl, CoordsData_60b45
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyHeld], a
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	PrepareBattle MAROWAK, 30
	ld a, $4
	ld [wPokemonTower6CurScript], a
	ld [wCurMapScript], a
	ret

CoordsData_60b45:
	db $10,$0A,$FF

PokemonTower6Script4:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower6Script_60b02
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, [wd72d]
	bit 6, a
	ret nz
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, [wBattleResult]
	and a
	jr nz, .asm_60b82
	SetEvent EVENT_BEAT_GHOST_MAROWAK
	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wPokemonTower6CurScript], a
	ld [wCurMapScript], a
	ret
.asm_60b82
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, $10
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData2 + $06], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	ld hl, wd730
	set 7, [hl]
	ld a, $3
	ld [wPokemonTower6CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower6Script3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wPokemonTower6CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower6TextPointers:
	dw PokemonTower6Text1
	dw PokemonTower6Text2
	dw PokemonTower6Text3
	dw PickUpItemText
	dw PickUpItemText
	dw PokemonTower6Text6
	dw PokemonTower6Text7

PokemonTower6TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower6BattleText1 ; TextBeforeBattle
	dw PokemonTower6AfterBattleText1 ; TextAfterBattle
	dw PokemonTower6EndBattleText1 ; TextEndBattle
	dw PokemonTower6EndBattleText1 ; TextEndBattle

PokemonTower6TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower6BattleText2 ; TextBeforeBattle
	dw PokemonTower6AfterBattleText2 ; TextAfterBattle
	dw PokemonTower6EndBattleText2 ; TextEndBattle
	dw PokemonTower6EndBattleText2 ; TextEndBattle

PokemonTower6TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower6BattleText3 ; TextBeforeBattle
	dw PokemonTower6AfterBattleText3 ; TextAfterBattle
	dw PokemonTower6EndBattleText3 ; TextEndBattle
	dw PokemonTower6EndBattleText3 ; TextEndBattle

	db $ff

PokemonTower6Text1:
	asmtext
	ld hl, PokemonTower6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6Text2:
	asmtext
	ld hl, PokemonTower6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6Text3:
	asmtext
	ld hl, PokemonTower6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower6Text7:
	asmtext
	ld hl, PokemonTower2Text_60c1f
	call PrintText
	ld a, MAROWAK
	call PlayCry
	call WaitForSoundToFinish
	ld c, 30
	call DelayFrames
	ld hl, PokemonTower2Text_60c24
	call PrintText
	jp TextScriptEnd

PokemonTower2Text_60c1f:
	fartext _PokemonTower2Text_60c1f
	done

PokemonTower2Text_60c24:
	fartext _PokemonTower2Text_60c24
	done

PokemonTower6BattleText1:
	fartext _PokemonTower6BattleText1
	done

PokemonTower6EndBattleText1:
	fartext _PokemonTower6EndBattleText1
	done

PokemonTower6AfterBattleText1:
	fartext _PokemonTower6AfterBattleText1
	done

PokemonTower6BattleText2:
	fartext _PokemonTower6BattleText2
	done

PokemonTower6EndBattleText2:
	fartext _PokemonTower6EndBattleText2
	done

PokemonTower6AfterBattleText2:
	fartext _PokemonTower6AfterBattleText2
	done

PokemonTower6BattleText3:
	fartext _PokemonTower6BattleText3
	done

PokemonTower6EndBattleText3:
	fartext _PokemonTower6EndBattleText3
	done

PokemonTower6AfterBattleText3:
	fartext _PokemonTower6AfterBattleText3
	done

PokemonTower6Text6:
	fartext _PokemonTower6Text6
	done
