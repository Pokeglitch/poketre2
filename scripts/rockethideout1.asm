RocketHideout1Script:
	call RocketHideout1Script_44be0
	call EnableAutoTextBoxDrawing
	ld de, RocketHideout1ScriptPointers
	ld a, [wRocketHideout1CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRocketHideout1CurScript], a
	ret

RocketHideout1Script_44be0:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_677
	jr nz, .asm_44c01
	CheckEventReuseA EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4
	jr nz, .asm_44bf7
	ld a, $54
	jr .asm_44c03
.asm_44bf7
	ld a, SFX_GO_INSIDE
	call PlaySound
	CheckEventHL EVENT_677
.asm_44c01
	ld a, $e
.asm_44c03
	ld [wNewTileBlockID], a
	lb bc, 8, 12
	predef_jump ReplaceTileBlock

RocketHideout1ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

RocketHideout1TextPointers:
	dw RocketHideout1Text1
	dw RocketHideout1Text2
	dw RocketHideout1Text3
	dw RocketHideout1Text4
	dw RocketHideout1Text5
	dw PickUpItemText
	dw PickUpItemText

RocketHideout1TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RocketHideout1BattleText2 ; TextBeforeBattle
	dw RocketHideout1AfterBattleTxt2 ; TextAfterBattle
	dw RocketHideout1EndBattleText2 ; TextEndBattle
	dw RocketHideout1EndBattleText2 ; TextEndBattle

RocketHideout1TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RocketHideout1BattleText3 ; TextBeforeBattle
	dw RocketHideout1AfterBattleTxt3 ; TextAfterBattle
	dw RocketHideout1EndBattleText3 ; TextEndBattle
	dw RocketHideout1EndBattleText3 ; TextEndBattle

RocketHideout1TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RocketHideout1BattleText4 ; TextBeforeBattle
	dw RocketHideout1AfterBattleTxt4 ; TextAfterBattle
	dw RocketHideout1EndBattleText4 ; TextEndBattle
	dw RocketHideout1EndBattleText4 ; TextEndBattle

RocketHideout1TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RocketHideout1BattleText5 ; TextBeforeBattle
	dw RocketHideout1AfterBattleTxt5 ; TextAfterBattle
	dw RocketHideout1EndBattleText5 ; TextEndBattle
	dw RocketHideout1EndBattleText5 ; TextEndBattle

RocketHideout1TrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RocketHideout1BattleText6 ; TextBeforeBattle
	dw RocketHideout1AfterBattleTxt6 ; TextAfterBattle
	dw RocketHideout1EndBattleText6 ; TextEndBattle
	dw RocketHideout1EndBattleText6 ; TextEndBattle

	db $ff

RocketHideout1Text1:
	asmtext
	ld hl, RocketHideout1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout1Text2:
	asmtext
	ld hl, RocketHideout1TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout1Text3:
	asmtext
	ld hl, RocketHideout1TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout1Text4:
	asmtext
	ld hl, RocketHideout1TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout1Text5:
	asmtext
	ld hl, RocketHideout1TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

RocketHideout1EndBattleText6:
	fartext _RocketHideout1EndBattleText6
	asmtext
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_1_TRAINER_4
	ld hl, RocketHideout1Text_44c9f
	ret

RocketHideout1Text_44c9f:
	wait
	done

RocketHideout1BattleText2:
	fartext _RocketHideout1BattleText2
	done

RocketHideout1EndBattleText2:
	fartext _RocketHideout1EndBattleText2
	done

RocketHideout1AfterBattleTxt2:
	fartext _RocketHideout1AfterBattleTxt2
	done

RocketHideout1BattleText3:
	fartext _RocketHideout1BattleText3
	done

RocketHideout1EndBattleText3:
	fartext _RocketHideout1EndBattleText3
	done

RocketHideout1AfterBattleTxt3:
	fartext _RocketHideout1AfterBattleTxt3
	done

RocketHideout1BattleText4:
	fartext _RocketHideout1BattleText4
	done

RocketHideout1EndBattleText4:
	fartext _RocketHideout1EndBattleText4
	done

RocketHideout1AfterBattleTxt4:
	fartext _RocketHideout1AfterBattleTxt4
	done

RocketHideout1BattleText5:
	fartext _RocketHideout1BattleText5
	done

RocketHideout1EndBattleText5:
	fartext _RocketHideout1EndBattleText5
	done

RocketHideout1AfterBattleTxt5:
	fartext _RocketHideout1AfterBattleTxt5
	done

RocketHideout1BattleText6:
	fartext _RocketHideout1BattleText6
	done

RocketHideout1AfterBattleTxt6:
	fartext _RocketHideout1AfterBattleTxt6
	done
