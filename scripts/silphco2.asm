SilphCo2Script:
	call SilphCo2Script_59d07
	call EnableAutoTextBoxDrawing
	ld de, SilphCo2ScriptPointers
	ld a, [wSilphCo2CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo2CurScript], a
	ret

SilphCo2Script_59d07:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo2GateCoords
	call SilphCo2Script_59d43
	call SilphCo2Script_59d6f
	CheckEvent EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	jr nz, .asm_59d2e
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	predef ReplaceTileBlock
	pop af
.asm_59d2e
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_2_UNLOCKED_DOOR2, EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret nz
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 5, 2
	predef_jump ReplaceTileBlock

SilphCo2GateCoords:
	db $02,$02
	db $05,$02
	db $FF

SilphCo2Script_59d43:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ld [$ffe0], a
	pop hl
.asm_59d4f
	ld a, [hli]
	cp $ff
	jr z, .asm_59d6b
	push hl
	ld hl, $ffe0
	inc [hl]
	pop hl
	cp b
	jr z, .asm_59d60
	inc hl
	jr .asm_59d4f
.asm_59d60
	ld a, [hli]
	cp c
	jr nz, .asm_59d4f
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.asm_59d6b
	xor a
	ld [$ffe0], a
	ret

SilphCo2Script_59d6f:
	EventFlagAddress hl, EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ld a, [$ffe0]
	and a
	ret z
	cp $1
	jr nz, .next
	SetEventReuseHL EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret
.next
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_2_UNLOCKED_DOOR2, EVENT_SILPH_CO_2_UNLOCKED_DOOR1
	ret

SilphCo2ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo2TextPointers:
	dw SilphCo2Text1
	dw SilphCo2Text2
	dw SilphCo2Text3
	dw SilphCo2Text4
	dw SilphCo2Text5

SilphCo2TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo2BattleText1 ; TextBeforeBattle
	dw SilphCo2AfterBattleText1 ; TextAfterBattle
	dw SilphCo2EndBattleText1 ; TextEndBattle
	dw SilphCo2EndBattleText1 ; TextEndBattle

SilphCo2TrainerHeader1:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo2BattleText2 ; TextBeforeBattle
	dw SilphCo2AfterBattleText2 ; TextAfterBattle
	dw SilphCo2EndBattleText2 ; TextEndBattle
	dw SilphCo2EndBattleText2 ; TextEndBattle

SilphCo2TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo2BattleText3 ; TextBeforeBattle
	dw SilphCo2AfterBattleText3 ; TextAfterBattle
	dw SilphCo2EndBattleText3 ; TextEndBattle
	dw SilphCo2EndBattleText3 ; TextEndBattle

SilphCo2TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo2BattleText4 ; TextBeforeBattle
	dw SilphCo2AfterBattleText4 ; TextAfterBattle
	dw SilphCo2EndBattleText4 ; TextEndBattle
	dw SilphCo2EndBattleText4 ; TextEndBattle

	db $ff

SilphCo2Text1:
	asmtext
	CheckEvent EVENT_GOT_TM36
	jr nz, .asm_59de4
	ld hl, SilphCo2Text_59ded
	call PrintText
	lb bc, TM_36, 1
	call GiveItem
	ld hl, TM36NoRoomText
	jr nc, .asm_59de7
	SetEvent EVENT_GOT_TM36
	ld hl, ReceivedTM36Text
	jr .asm_59de7
.asm_59de4
	ld hl, TM36ExplanationText
.asm_59de7
	call PrintText
	jp TextScriptEnd

SilphCo2Text_59ded:
	fartext _SilphCo2Text_59ded
	done

ReceivedTM36Text:
	fartext _ReceivedTM36Text
	sfxtext SFX_GET_ITEM_1
	done

TM36ExplanationText:
	fartext _TM36ExplanationText
	done

TM36NoRoomText:
	fartext _TM36NoRoomText
	done

SilphCo2Text2:
	asmtext
	ld hl, SilphCo2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2Text3:
	asmtext
	ld hl, SilphCo2TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2Text4:
	asmtext
	ld hl, SilphCo2TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2Text5:
	asmtext
	ld hl, SilphCo2TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SilphCo2BattleText1:
	fartext _SilphCo2BattleText1
	done

SilphCo2EndBattleText1:
	fartext _SilphCo2EndBattleText1
	done

SilphCo2AfterBattleText1:
	fartext _SilphCo2AfterBattleText1
	done

SilphCo2BattleText2:
	fartext _SilphCo2BattleText2
	done

SilphCo2EndBattleText2:
	fartext _SilphCo2EndBattleText2
	done

SilphCo2AfterBattleText2:
	fartext _SilphCo2AfterBattleText2
	done

SilphCo2BattleText3:
	fartext _SilphCo2BattleText3
	done

SilphCo2EndBattleText3:
	fartext _SilphCo2EndBattleText3
	done

SilphCo2AfterBattleText3:
	fartext _SilphCo2AfterBattleText3
	done

SilphCo2BattleText4:
	fartext _SilphCo2BattleText4
	done

SilphCo2EndBattleText4:
	fartext _SilphCo2EndBattleText4
	done

SilphCo2AfterBattleText4:
	fartext _SilphCo2AfterBattleText4
	done
