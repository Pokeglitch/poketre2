PowerPlantScript:
	call EnableAutoTextBoxDrawing
	ld hl, Voltorb0TrainerHeader
	ld de, .ScriptPointers
	ld a, [wPowerPlantCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPowerPlantCurScript], a
	ret

.ScriptPointers
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PowerPlantTrainerHeader0:
	db TrainerHeaderTerminator

PowerPlantTextPointers:
	dw Voltorb0Text
	dw Voltorb1Text
	dw Voltorb2Text
	dw Voltorb3Text
	dw Voltorb4Text
	dw Voltorb5Text
	dw Voltorb6Text
	dw Voltorb7Text
	dw ZapdosText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

Voltorb0TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb1TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb2TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb3TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb4TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb5TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb6TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

Voltorb7TrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw VoltorbBattleText ; TextBeforeBattle
	dw VoltorbBattleText ; TextAfterBattle
	dw VoltorbBattleText ; TextEndBattle
	dw VoltorbBattleText ; TextEndBattle

ZapdosTrainerHeader:
	db 0 ; former event flag bit index
	db 0 ; view range
	dw 0 ; former event flag address
	dw ZapdosBattleText ; TextBeforeBattle
	dw ZapdosBattleText ; TextAfterBattle
	dw ZapdosBattleText ; TextEndBattle
	dw ZapdosBattleText ; TextEndBattle

	db $ff

InitVoltorbBattle:
	call TalkToTrainer
	ld a, [wCurMapScript]
	ld [wPowerPlantCurScript], a
	jp TextScriptEnd

Voltorb0Text:
	asmtext
	ld hl, Voltorb0TrainerHeader
	jr InitVoltorbBattle

Voltorb1Text:
	asmtext
	ld hl, Voltorb1TrainerHeader
	jr InitVoltorbBattle

Voltorb2Text:
	asmtext
	ld hl, Voltorb2TrainerHeader
	jr InitVoltorbBattle

Voltorb3Text:
	asmtext
	ld hl, Voltorb3TrainerHeader
	jr InitVoltorbBattle

Voltorb4Text:
	asmtext
	ld hl, Voltorb4TrainerHeader
	jr InitVoltorbBattle

Voltorb5Text:
	asmtext
	ld hl, Voltorb5TrainerHeader
	jr InitVoltorbBattle

Voltorb6Text:
	asmtext
	ld hl, Voltorb6TrainerHeader
	jr InitVoltorbBattle

Voltorb7Text:
	asmtext
	ld hl, Voltorb7TrainerHeader
	jr InitVoltorbBattle

ZapdosText:
	asmtext
	ld hl, ZapdosTrainerHeader
	jr InitVoltorbBattle

VoltorbBattleText:
	fartext _VoltorbBattleText
	done

ZapdosBattleText:
	fartext _ZapdosBattleText
	asmtext
	ld a, ZAPDOS
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
