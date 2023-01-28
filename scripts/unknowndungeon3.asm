UnknownDungeon3Script:
	call EnableAutoTextBoxDrawing
	ld hl, MewtwoTrainerHeader
	ld de, .ScriptPointers
	ld a, [wUnknownDungeon3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wUnknownDungeon3CurScript], a
	ret

.ScriptPointers
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

UnknownDungeon3TrainerHeader0:
	db TrainerHeaderTerminator

UnknownDungeon3TextPointers:
	dw MewtwoText
	dw PickUpItemText
	dw PickUpItemText

MewtwoTrainerHeader:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MewtwoBattleText ; TextBeforeBattle
	dw MewtwoBattleText ; TextAfterBattle
	dw MewtwoBattleText ; TextEndBattle
	dw MewtwoBattleText ; TextEndBattle

	db $ff

MewtwoText:
	asmtext
	ld hl, MewtwoTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MewtwoBattleText:
	fartext _MewtwoBattleText
	asmtext
	ld a, MEWTWO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
