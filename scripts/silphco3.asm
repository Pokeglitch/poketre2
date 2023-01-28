SilphCo3Script:
	call SilphCo3Script_59f71
	call EnableAutoTextBoxDrawing
	ld hl, SilphCo3TrainerHeader0
	ld de, SilphCo3ScriptPointers
	ld a, [wSilphCo3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo3CurScript], a
	ret

SilphCo3Script_59f71:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo3GateCoords
	call SilphCo2Script_59d43
	call SilphCo3Script_59fad
	CheckEvent EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	jr nz, .asm_59f98
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 4
	predef ReplaceTileBlock
	pop af
.asm_59f98
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 8
	predef_jump ReplaceTileBlock

SilphCo3GateCoords:
	db $04,$04
	db $04,$08
	db $FF

SilphCo3Script_59fad:
	EventFlagAddress hl, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ld a, [$ffe0]
	and a
	ret z
	cp $1
	jr nz, .next
	SetEventReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret
.next
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_3_UNLOCKED_DOOR2, EVENT_SILPH_CO_3_UNLOCKED_DOOR1
	ret

SilphCo3ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo3TextPointers:
	dw SilphCo3Text1
	dw SilphCo3Text2
	dw SilphCo3Text3
	dw PickUpItemText

SilphCo3TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo3BattleText1 ; TextBeforeBattle
	dw SilphCo3AfterBattleText1 ; TextAfterBattle
	dw SilphCo3EndBattleText1 ; TextEndBattle
	dw SilphCo3EndBattleText1 ; TextEndBattle

SilphCo3TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo3BattleText2 ; TextBeforeBattle
	dw SilphCo3AfterBattleText2 ; TextAfterBattle
	dw SilphCo3EndBattleText2 ; TextEndBattle
	dw SilphCo3EndBattleText2 ; TextEndBattle

	db $ff

SilphCo3Text1:
	asmtext
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SilphCo3Text_59ffe
	jr nz, .asm_59fee
	ld hl, SilphCo3Text_59ff9
.asm_59fee
	call PrintText
	jp TextScriptEnd

SilphCo3Text_59ff9:
	fartext _SilphCo3Text_59ff9
	done

SilphCo3Text_59ffe:
	fartext _SilphCo3Text_59ffe
	done

SilphCo3Text2:
	asmtext
	ld hl, SilphCo3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3BattleText1:
	fartext _SilphCo3BattleText1
	done

SilphCo3EndBattleText1:
	fartext _SilphCo3EndBattleText1
	done

SilphCo3AfterBattleText1:
	fartext _SilphCo3AfterBattleText1
	done

SilphCo3Text3:
	asmtext
	ld hl, SilphCo3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo3BattleText2:
	fartext _SilphCo3BattleText2
	done

SilphCo3EndBattleText2:
	fartext _SilphCo3EndBattleText2
	done

SilphCo3AfterBattleText2:
	fartext _SilphCo3AfterBattleText2
	done
