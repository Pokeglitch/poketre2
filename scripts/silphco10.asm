SilphCo10Script:
	call SilphCo10Script_5a14f
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo10TrainerHeader0
	ld de, SilphCo10ScriptPointers
	ld a, [wSilphCo10CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo10CurScript], a
	ret

SilphCo10Script_5a14f:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo10GateCoords
	call SilphCo2Script_59d43
	call SilphCo10Text_5a176
	CheckEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 4, 5
	predef_jump ReplaceTileBlock

SilphCo10GateCoords:
	db $04,$05
	db $FF

SilphCo10Text_5a176:
	ld a, [$ffe0]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_10_UNLOCKED_DOOR
	ret

SilphCo10ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo10TextPointers:
	dw SilphCo10Text1
	dw SilphCo10Text2
	dw SilphCo10Text3
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

SilphCo10TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SILPH_CO_10F_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SILPH_CO_10F_TRAINER_0
	dw SilphCo10BattleText1 ; TextBeforeBattle
	dw SilphCo10AfterBattleText1 ; TextAfterBattle
	dw SilphCo10EndBattleText1 ; TextEndBattle
	dw SilphCo10EndBattleText1 ; TextEndBattle

SilphCo10TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_SILPH_CO_10F_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SILPH_CO_10F_TRAINER_1
	dw SilphCo10BattleText2 ; TextBeforeBattle
	dw SilphCo10AfterBattleText2 ; TextAfterBattle
	dw SilphCo10EndBattleText2 ; TextEndBattle
	dw SilphCo10EndBattleText2 ; TextEndBattle

	db $ff

SilphCo10Text1:
	text ""
	asmtext
	ld hl, SilphCo10TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo10Text2:
	text ""
	asmtext
	ld hl, SilphCo10TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo10Text3:
	text ""
	asmtext
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SilphCo10Text_5a1d8
	jr nz, .asm_cf85f
	ld hl, SilphCo10Text_5a1d3
.asm_cf85f
	call PrintText
	jp TextScriptEnd

SilphCo10Text_5a1d3:
	text ""
	fartext _SilphCo10Text_5a1d3
	done

SilphCo10Text_5a1d8:
	text ""
	fartext _SilphCo10Text_5a1d8
	done

SilphCo10BattleText1:
	text ""
	fartext _SilphCo10BattleText1
	done

SilphCo10EndBattleText1:
	text ""
	fartext _SilphCo10EndBattleText1
	done

SilphCo10AfterBattleText1:
	text ""
	fartext _SilphCo10AfterBattleText1
	done

SilphCo10BattleText2:
	text ""
	fartext _SilphCo10BattleText2
	done

SilphCo10EndBattleText2:
	text ""
	fartext _SilphCo10EndBattleText2
	done

SilphCo10AfterBattleText2:
	text ""
	fartext _SilphCo10AfterBattleText2
	done
