SilphCo6Script:
	call SilphCo6Script_1a1bf
	call EnableAutoTextBoxDrawing
	ld de, SilphCo6ScriptPointers
	ld a, [wSilphCo6CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo6CurScript], a
	ret

SilphCo6Script_1a1bf:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo6GateCoords
	call SilphCo4Script_19d5d
	call SilphCo6Script_1a1e6
	CheckEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 6, 2
	predef_jump ReplaceTileBlock

SilphCo6GateCoords:
	db $06,$02
	db $FF

SilphCo6Script_1a1e6:
	ld a, [$ffe0]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_6_UNLOCKED_DOOR
	ret

SilphCo6ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo6TextPointers:
	dw SilphCo6Text1
	dw SilphCo6Text2
	dw SilphCo6Text3
	dw SilphCo6Text4
	dw SilphCo6Text5
	dw SilphCo6Text6
	dw SilphCo6Text7
	dw SilphCo6Text8
	dw PickUpItemText
	dw PickUpItemText

SilphCo6TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo6BattleText2 ; TextBeforeBattle
	dw SilphCo6AfterBattleText2 ; TextAfterBattle
	dw SilphCo6EndBattleText2 ; TextEndBattle
	dw SilphCo6EndBattleText2 ; TextEndBattle

SilphCo6TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo6BattleText3 ; TextBeforeBattle
	dw SilphCo6AfterBattleText3 ; TextAfterBattle
	dw SilphCo6EndBattleText3 ; TextEndBattle
	dw SilphCo6EndBattleText3 ; TextEndBattle

SilphCo6TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo6BattleText4 ; TextBeforeBattle
	dw SilphCo6AfterBattleText4 ; TextAfterBattle
	dw SilphCo6EndBattleText4 ; TextEndBattle
	dw SilphCo6EndBattleText4 ; TextEndBattle

	db $ff

SilphCo6Script_1a22f:
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .asm_1a238
	jr .asm_1a23a
.asm_1a238
	ld h, d
	ld l, e
.asm_1a23a
	jp PrintText

SilphCo6Text1:
	asmtext
	ld hl, SilphCo6Text_1a24a
	ld de, SilphCo6Text_1a24f
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo6Text_1a24a:
	fartext _SilphCo6Text_1a24a
	done

SilphCo6Text_1a24f:
	fartext _SilphCo6Text_1a24f
	done

SilphCo6Text2:
	asmtext
	ld hl, SilphCo6Text_1a261
	ld de, SilphCo6Text_1a266
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo6Text_1a261:
	fartext _SilphCo6Text_1a261
	done

SilphCo6Text_1a266:
	fartext _SilphCo6Text_1a266
	done

SilphCo6Text3:
	asmtext
	ld hl, SilphCo6Text_1a278
	ld de, SilphCo6Text_1a27d
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo6Text_1a278:
	fartext _SilphCo6Text_1a278
	done

SilphCo6Text_1a27d:
	fartext _SilphCo6Text_1a27d
	done

SilphCo6Text4:
	asmtext
	ld hl, SilphCo6Text_1a28f
	ld de, SilphCo6Text_1a294
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo6Text_1a28f:
	fartext _SilphCo6Text_1a28f
	done

SilphCo6Text_1a294:
	fartext _SilphCo6Text_1a294
	done

SilphCo6Text5:
	asmtext
	ld hl, SilphCo6Text_1a2a6
	ld de, SilphCo6Text_1a2ab
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo6Text_1a2a6:
	fartext _SilphCo6Text_1a2a6
	done

SilphCo6Text_1a2ab:
	fartext _SilphCo6Text_1a2ab
	done

SilphCo6Text6:
	asmtext
	ld hl, SilphCo6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6BattleText2:
	fartext _SilphCo6BattleText2
	done

SilphCo6EndBattleText2:
	fartext _SilphCo6EndBattleText2
	done

SilphCo6AfterBattleText2:
	fartext _SilphCo6AfterBattleText2
	done

SilphCo6Text7:
	asmtext
	ld hl, SilphCo6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6BattleText3:
	fartext _SilphCo6BattleText3
	done

SilphCo6EndBattleText3:
	fartext _SilphCo6EndBattleText3
	done

SilphCo6AfterBattleText3:
	fartext _SilphCo6AfterBattleText3
	done

SilphCo6Text8:
	asmtext
	ld hl, SilphCo6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo6BattleText4:
	fartext _SilphCo6BattleText4
	done

SilphCo6EndBattleText4:
	fartext _SilphCo6EndBattleText4
	done

SilphCo6AfterBattleText4:
	fartext _SilphCo6AfterBattleText4
	done
