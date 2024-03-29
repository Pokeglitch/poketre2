SilphCo5Script:
	call SilphCo5Script_19f4d
	call EnableAutoTextBoxDrawing
	ld de, SilphCo5ScriptPointers
	ld a, [wSilphCo5CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo5CurScript], a
	ret

SilphCo5Script_19f4d:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo5GateCoords
	call SilphCo4Script_19d5d
	call SilphCo5Script_19f9e
	CheckEvent EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, .asm_19f74
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 2, 3
	predef ReplaceTileBlock
	pop af
.asm_19f74
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	jr nz, .asm_19f87
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 6, 3
	predef ReplaceTileBlock
	pop af
.asm_19f87
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR2
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 5, 7
	predef_jump ReplaceTileBlock

SilphCo5GateCoords:
	db $02,$03
	db $06,$03
	db $05,$07
	db $FF

SilphCo5Script_19f9e:
	EventFlagAddress hl, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ld a, [$ffe0]
	and a
	ret z
	cp $1
	jr nz, .next1
	SetEventReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
.next1
	cp $2
	jr nz, .next2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR2, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret
.next2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_5_UNLOCKED_DOOR3, EVENT_SILPH_CO_5_UNLOCKED_DOOR1
	ret

SilphCo5ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo5TextPointers:
	dw SilphCo5Text1
	dw SilphCo5Text2
	dw SilphCo5Text3
	dw SilphCo5Text4
	dw SilphCo5Text5
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw SilphCo5Text9
	dw SilphCo5Text10
	dw SilphCo5Text11

SilphCo5TrainerHeader0:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo5BattleText2 ; TextBeforeBattle
	dw SilphCo5AfterBattleText2 ; TextAfterBattle
	dw SilphCo5EndBattleText2 ; TextEndBattle
	dw SilphCo5EndBattleText2 ; TextEndBattle

SilphCo5TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo5BattleText3 ; TextBeforeBattle
	dw SilphCo5AfterBattleText3 ; TextAfterBattle
	dw SilphCo5EndBattleText3 ; TextEndBattle
	dw SilphCo5EndBattleText3 ; TextEndBattle

SilphCo5TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo5BattleText4 ; TextBeforeBattle
	dw SilphCo5AfterBattleText4 ; TextAfterBattle
	dw SilphCo5EndBattleText4 ; TextEndBattle
	dw SilphCo5EndBattleText4 ; TextEndBattle

SilphCo5TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo5BattleText5 ; TextBeforeBattle
	dw SilphCo5AfterBattleText5 ; TextAfterBattle
	dw SilphCo5EndBattleText5 ; TextEndBattle
	dw SilphCo5EndBattleText5 ; TextEndBattle

	db $ff

SilphCo5Text1:
	asmtext
	ld hl, SilphCo5Text_1a010
	ld de, SilphCo5Text_1a015
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo5Text_1a010:
	fartext _SilphCo5Text_1a010
	done

SilphCo5Text_1a015:
	fartext _SilphCo5Text_1a015
	done

SilphCo5Text2:
	asmtext
	ld hl, SilphCo5TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5BattleText2:
	fartext _SilphCo5BattleText2
	done

SilphCo5EndBattleText2:
	fartext _SilphCo5EndBattleText2
	done

SilphCo5AfterBattleText2:
	fartext _SilphCo5AfterBattleText2
	done

SilphCo5Text3:
	asmtext
	ld hl, SilphCo5TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5BattleText3:
	fartext _SilphCo5BattleText3
	done

SilphCo5EndBattleText3:
	fartext _SilphCo5EndBattleText3
	done

SilphCo5AfterBattleText3:
	fartext _SilphCo5AfterBattleText3
	done

SilphCo5Text4:
	asmtext
	ld hl, SilphCo5TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5BattleText4:
	fartext _SilphCo5BattleText4
	done

SilphCo5EndBattleText4:
	fartext _SilphCo5EndBattleText4
	done

SilphCo5AfterBattleText4:
	fartext _SilphCo5AfterBattleText4
	done

SilphCo5Text5:
	asmtext
	ld hl, SilphCo5TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo5BattleText5:
	fartext _SilphCo5BattleText5
	done

SilphCo5EndBattleText5:
	fartext _SilphCo5EndBattleText5
	done

SilphCo5AfterBattleText5:
	fartext _SilphCo5AfterBattleText5
	done

SilphCo5Text9:
	fartext _SilphCo5Text9
	done

SilphCo5Text10:
	fartext _SilphCo5Text10
	done

SilphCo5Text11:
	fartext _SilphCo5Text11
	done
