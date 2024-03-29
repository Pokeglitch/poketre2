SilphCo9Script:
	call SilphCo9Script_5d7d1
	call EnableAutoTextBoxDrawing
	ld de, SilphCo9ScriptPointers
	ld a, [wSilphCo9CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSilphCo9CurScript], a
	ret

SilphCo9Script_5d7d1:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, SilphCo9GateCoords
	call SilphCo9Script_5d837
	call SilphCo9Script_5d863
	CheckEvent EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	jr nz, .asm_5d7f8
	push af
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 4, 1
	predef ReplaceTileBlock
	pop af
.asm_5d7f8
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR2, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	jr nz, .asm_5d80b
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 2, 9
	predef ReplaceTileBlock
	pop af
.asm_5d80b
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR3, EVENT_SILPH_CO_9_UNLOCKED_DOOR2
	jr nz, .asm_5d81e
	push af
	ld a, $54
	ld [wNewTileBlockID], a
	lb bc, 5, 9
	predef ReplaceTileBlock
	pop af
.asm_5d81e
	CheckEventAfterBranchReuseA EVENT_SILPH_CO_9_UNLOCKED_DOOR4, EVENT_SILPH_CO_9_UNLOCKED_DOOR3
	ret nz
	ld a, $5f
	ld [wNewTileBlockID], a
	lb bc, 6, 5
	predef_jump ReplaceTileBlock

SilphCo9GateCoords:
	db $04,$01
	db $02,$09
	db $05,$09
	db $06,$05
	db $FF

SilphCo9Script_5d837:
	push hl
	ld hl, wCardKeyDoorY
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	xor a
	ld [$ffe0], a
	pop hl
.asm_5d843
	ld a, [hli]
	cp $ff
	jr z, .asm_5d85f
	push hl
	ld hl, $ffe0
	inc [hl]
	pop hl
	cp b
	jr z, .asm_5d854
	inc hl
	jr .asm_5d843
.asm_5d854
	ld a, [hli]
	cp c
	jr nz, .asm_5d843
	ld hl, wCardKeyDoorY
	xor a
	ld [hli], a
	ld [hl], a
	ret
.asm_5d85f
	xor a
	ld [$ffe0], a
	ret

SilphCo9Script_5d863:
	EventFlagAddress hl, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ld a, [$ffe0]
	and a
	ret z
	cp $1
	jr nz, .next1
	SetEventReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.next1
	cp $2
	jr nz, .next2
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR2, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.next2
	cp $3
	jr nz, .next3
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR3, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret
.next3
	cp $4
	ret nz
	SetEventAfterBranchReuseHL EVENT_SILPH_CO_9_UNLOCKED_DOOR4, EVENT_SILPH_CO_9_UNLOCKED_DOOR1
	ret

SilphCo9ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SilphCo9TextPointers:
	dw SilphCo9Text1
	dw SilphCo9Text2
	dw SilphCo9Text3
	dw SilphCo9Text4

SilphCo9TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo9BattleText1 ; TextBeforeBattle
	dw SilphCo9AfterBattleText1 ; TextAfterBattle
	dw SilphCo9EndBattleText1 ; TextEndBattle
	dw SilphCo9EndBattleText1 ; TextEndBattle

SilphCo9TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo9BattleText2 ; TextBeforeBattle
	dw SilphCo9AfterBattleText2 ; TextAfterBattle
	dw SilphCo9EndBattleText2 ; TextEndBattle
	dw SilphCo9EndBattleText2 ; TextEndBattle

SilphCo9TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SilphCo9BattleText3 ; TextBeforeBattle
	dw SilphCo9AfterBattleText3 ; TextAfterBattle
	dw SilphCo9EndBattleText3 ; TextEndBattle
	dw SilphCo9EndBattleText3 ; TextEndBattle

	db $ff

SilphCo9Text1:
	asmtext
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	jr nz, .asm_5d8dc
	ld hl, SilphCo9Text_5d8e5
	call PrintText
	predef HealParty
	call GBFadeOutToWhite
	call Delay3
	call GBFadeInFromWhite
	ld hl, SilphCo9Text_5d8ea
	call PrintText
	jr .asm_5d8e2
.asm_5d8dc
	ld hl, SilphCo9Text_5d8ef
	call PrintText
.asm_5d8e2
	jp TextScriptEnd

SilphCo9Text_5d8e5:
	fartext _SilphCo9Text_5d8e5
	done

SilphCo9Text_5d8ea:
	fartext _SilphCo9Text_5d8ea
	done

SilphCo9Text_5d8ef:
	fartext _SilphCo9Text_5d8ef
	done

SilphCo9Text2:
	asmtext
	ld hl, SilphCo9TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9Text3:
	asmtext
	ld hl, SilphCo9TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9Text4:
	asmtext
	ld hl, SilphCo9TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SilphCo9BattleText1:
	fartext _SilphCo9BattleText1
	done

SilphCo9EndBattleText1:
	fartext _SilphCo9EndBattleText1
	done

SilphCo9AfterBattleText1:
	fartext _SilphCo9AfterBattleText1
	done

SilphCo9BattleText2:
	fartext _SilphCo9BattleText2
	done

SilphCo9EndBattleText2:
	fartext _SilphCo9EndBattleText2
	done

SilphCo9AfterBattleText2:
	fartext _SilphCo9AfterBattleText2
	done

SilphCo9BattleText3:
	fartext _SilphCo9BattleText3
	done

SilphCo9EndBattleText3:
	fartext _SilphCo9EndBattleText3
	done

SilphCo9AfterBattleText3:
	fartext _SilphCo9AfterBattleText3
	done
