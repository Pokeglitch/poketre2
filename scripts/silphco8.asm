SilphCo8Script:
	call SilphCo8Script_5651a
	call EnableAutoTextBoxDrawing
	ld de, SilphCo8ScriptPointers
	ld a, [wSilphCo8CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo8CurScript], a
	ret

SilphCo8Script_5651a:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo8GateCoords
	call SilphCo8Script_56541
	call SilphCo8Script_5656d
	CheckEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 3
	predef_jump ReplaceTileBlock

SilphCo8GateCoords:
	db $04,$03
	db $FF

SilphCo8Script_56541:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ld [$ffe0], a
	pop hl
.asm_5654d
	ld a, [hli]
	cp $ff
	jr z, .asm_56569
	push hl
	ld hl, $ffe0
	inc [hl]
	pop hl
	cp b
	jr z, .asm_5655e
	inc hl
	jr .asm_5654d
.asm_5655e
	ld a, [hli]
	cp c
	jr nz, .asm_5654d
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.asm_56569
	xor a
	ld [$ffe0], a
	ret

SilphCo8Script_5656d:
	ld a, [$ffe0]
	and a
	ret z
	SetEvent EVENT_SILPH_CO_8_UNLOCKED_DOOR
	ret

SilphCo8ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo8TextPointers:
	dw SilphCo8Text1
	dw SilphCo8Text2
	dw SilphCo8Text3
	dw SilphCo8Text4

SilphCo8TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo8BattleText1 ; TextBeforeBattle
	dw SilphCo8AfterBattleText1 ; TextAfterBattle
	dw SilphCo8EndBattleText1 ; TextEndBattle
	dw SilphCo8EndBattleText1 ; TextEndBattle

SilphCo8TrainerHeader1:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo8BattleText2 ; TextBeforeBattle
	dw SilphCo8AfterBattleText2 ; TextAfterBattle
	dw SilphCo8EndBattleText2 ; TextEndBattle
	dw SilphCo8EndBattleText2 ; TextEndBattle

SilphCo8TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo8BattleText3 ; TextBeforeBattle
	dw SilphCo8AfterBattleText3 ; TextAfterBattle
	dw SilphCo8EndBattleText3 ; TextEndBattle
	dw SilphCo8EndBattleText3 ; TextEndBattle

	db $ff

SilphCo8Text1:
	asmtext
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ld hl, SilphCo8Text_565c3
	jr nz, .asm_565b8
	ld hl, SilphCo8Text_565be
.asm_565b8
	call PrintText
	jp TextScriptEnd

SilphCo8Text_565be:
	fartext _SilphCo8Text_565be
	done

SilphCo8Text_565c3:
	fartext _SilphCo8Text_565c3
	done

SilphCo8Text2:
	asmtext
	ld hl, SilphCo8TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8Text3:
	asmtext
	ld hl, SilphCo8TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8Text4:
	asmtext
	ld hl, SilphCo8TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo8BattleText1:
	fartext _SilphCo8BattleText1
	done

SilphCo8EndBattleText1:
	fartext _SilphCo8EndBattleText1
	done

SilphCo8AfterBattleText1:
	fartext _SilphCo8AfterBattleText1
	done

SilphCo8BattleText2:
	fartext _SilphCo8BattleText2
	done

SilphCo8EndBattleText2:
	fartext _SilphCo8EndBattleText2
	done

SilphCo8AfterBattleText2:
	fartext _SilphCo8AfterBattleText2
	done

SilphCo8BattleText3:
	fartext _SilphCo8BattleText3
	done

SilphCo8EndBattleText3:
	fartext _SilphCo8EndBattleText3
	done

SilphCo8AfterBattleText3:
	fartext _SilphCo8AfterBattleText3
	done
