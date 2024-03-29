SilphCo4Script:
	call SilphCo4Script_19d21
	call EnableAutoTextBoxDrawing
	ld de, SilphCo4ScriptPointers
	ld a, [wSilphCo4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo4CurScript], a
	ret

SilphCo4Script_19d21:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo4GateCoords
	call SilphCo4Script_19d5d
	call SilphCo4Script_19d89
	CheckEvent EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	jr nz, .asm_19d48
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 6, 2
	predef ReplaceTileBlock
	pop af
.asm_19d48
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_4_UNLOCKED_DOOR2, EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 4, 6
	predef_jump ReplaceTileBlock

SilphCo4GateCoords:
	db $06,$02
	db $04,$06
	db $FF

SilphCo4Script_19d5d:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ld [$ffe0], a
	pop hl
.asm_19d69
	ld a, [hli]
	cp $ff
	jr z, .asm_19d85
	push hl
	ld hl, $ffe0
	inc [hl]
	pop hl
	cp b
	jr z, .asm_19d7a
	inc hl
	jr .asm_19d69
.asm_19d7a
	ld a, [hli]
	cp c
	jr nz, .asm_19d69
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.asm_19d85
	xor a
	ld [$ffe0], a
	ret

SilphCo4Script_19d89:
	EventFlagAddress hl, EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	ld a, [$ffe0]
	and a
	ret z
	cp $1
	jr nz, .next
	SetEventReuseHL EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	ret
.next
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_4_UNLOCKED_DOOR2, EVENT_SILPH_CO_4_UNLOCKED_DOOR1
	ret

SilphCo4ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo4TextPointers:
	dw SilphCo4Text1
	dw SilphCo4Text2
	dw SilphCo4Text3
	dw SilphCo4Text4
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

SilphCo4TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo4BattleText2 ; TextBeforeBattle
	dw SilphCo4AfterBattleText2 ; TextAfterBattle
	dw SilphCo4EndBattleText2 ; TextEndBattle
	dw SilphCo4EndBattleText2 ; TextEndBattle

SilphCo4TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo4BattleText3 ; TextBeforeBattle
	dw SilphCo4AfterBattleText3 ; TextAfterBattle
	dw SilphCo4EndBattleText3 ; TextEndBattle
	dw SilphCo4EndBattleText3 ; TextEndBattle

SilphCo4TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo4BattleText4 ; TextBeforeBattle
	dw SilphCo4AfterBattleText4 ; TextAfterBattle
	dw SilphCo4EndBattleText4 ; TextEndBattle
	dw SilphCo4EndBattleText4 ; TextEndBattle

	db $ff

SilphCo4Text1:
	asmtext
	ld hl, SilphCo4Text_19de0
	ld de, SilphCo4Text_19de5
	call SilphCo6Script_1a22f
	jp TextScriptEnd

SilphCo4Text_19de0:
	fartext _SilphCo4Text_19de0
	done

SilphCo4Text_19de5:
	fartext _SilphCo4Text_19de5
	done

SilphCo4Text2:
	asmtext
	ld hl, SilphCo4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo4BattleText2:
	fartext _SilphCo4BattleText2
	done

SilphCo4EndBattleText2:
	fartext _SilphCo4EndBattleText2
	done

SilphCo4AfterBattleText2:
	fartext _SilphCo4AfterBattleText2
	done

SilphCo4Text3:
	asmtext
	ld hl, SilphCo4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo4BattleText3:
	fartext _SilphCo4BattleText3
	done

SilphCo4EndBattleText3:
	fartext _SilphCo4EndBattleText3
	done

SilphCo4AfterBattleText3:
	fartext _SilphCo4AfterBattleText3
	done

SilphCo4Text4:
	asmtext
	ld hl, SilphCo4TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo4BattleText4:
	fartext _SilphCo4BattleText4
	done

SilphCo4EndBattleText4:
	fartext _SilphCo4EndBattleText4
	done

SilphCo4AfterBattleText4:
	fartext _SilphCo4AfterBattleText4
	done
