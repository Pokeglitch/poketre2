Route24Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route24TrainerHeader0
	ld de, Route24ScriptPointers
	ld a, [wRoute24CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute24CurScript], a
	ret

Route24Script_513c0:
	xor a
	ld [wJoyIgnore], a
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24ScriptPointers:
	dw Route24Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw Route24Script3
	dw Route24Script4

Route24Script0:
	CheckEvent EVENT_GOT_NUGGET
	jp nz, CheckFightingMapTrainers
	ld hl, CoordsData_5140e
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyHeld], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckAndResetEvent EVENT_NUGGET_REWARD_AVAILABLE
	ret z
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $4
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

CoordsData_5140e:
	db $0F,$0A,$FF

Route24Script4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $0
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route24Script_513c0
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROUTE24_ROCKET
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	ret

Route24TextPointers:
	dw Route24Text1
	dw Route24Text2
	dw Route24Text3
	dw Route24Text4
	dw Route24Text5
	dw Route24Text6
	dw Route24Text7
	dw PickUpItemText

Route24TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText1 ; TextBeforeBattle
	dw Route24AfterBattleText1 ; TextAfterBattle
	dw Route24EndBattleText1 ; TextEndBattle
	dw Route24EndBattleText1 ; TextEndBattle

Route24TrainerHeader1:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText2 ; TextBeforeBattle
	dw Route24AfterBattleText2 ; TextAfterBattle
	dw Route24EndBattleText2 ; TextEndBattle
	dw Route24EndBattleText2 ; TextEndBattle

Route24TrainerHeader2:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText3 ; TextBeforeBattle
	dw Route24AfterBattleText3 ; TextAfterBattle
	dw Route24EndBattleText3 ; TextEndBattle
	dw Route24EndBattleText3 ; TextEndBattle

Route24TrainerHeader3:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText4 ; TextBeforeBattle
	dw Route24AfterBattleText4 ; TextAfterBattle
	dw Route24EndBattleText4 ; TextEndBattle
	dw Route24EndBattleText4 ; TextEndBattle

Route24TrainerHeader4:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText5 ; TextBeforeBattle
	dw Route24AfterBattleText5 ; TextAfterBattle
	dw Route24EndBattleText5 ; TextEndBattle
	dw Route24EndBattleText5 ; TextEndBattle

Route24TrainerHeader5:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route24BattleText6 ; TextBeforeBattle
	dw Route24AfterBattleText6 ; TextAfterBattle
	dw Route24EndBattleText6 ; TextEndBattle
	dw Route24EndBattleText6 ; TextEndBattle

	db $ff

Route24Text1:
	asmtext
	ResetEvent EVENT_NUGGET_REWARD_AVAILABLE
	CheckEvent EVENT_GOT_NUGGET
	jr nz, .asm_514f9
	ld hl, Route24Text_51510
	call PrintText
	lb bc, NUGGET, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_NUGGET
	ld hl, Route24Text_5151a
	call PrintText
	ld hl, Route24Text_51526
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route24Text_5152b
	ld de, Route24Text_5152b
	call SaveEndBattleTextPointers
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wRoute24CurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd
.asm_514f9
	ld hl, Route24Text_51530
	call PrintText
	jp TextScriptEnd
.BagFull
	ld hl, Route24Text_51521
	call PrintText
	SetEvent EVENT_NUGGET_REWARD_AVAILABLE
	jp TextScriptEnd

Route24Text_51510:
	fartext _Route24Text_51510
	sfxtext SFX_GET_ITEM_1
	fartext _Route24Text_51515
	done

Route24Text_5151a:
	fartext _Route24Text_5151a
	sfxtext SFX_GET_ITEM_1
	wait
	done

Route24Text_51521:
	fartext _Route24Text_51521
	done

Route24Text_51526:
	fartext _Route24Text_51526
	done

Route24Text_5152b:
	fartext _Route24Text_5152b
	done

Route24Text_51530:
	fartext _Route24Text_51530
	done

Route24Text2:
	asmtext
	ld hl, Route24TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route24Text3:
	asmtext
	ld hl, Route24TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route24Text4:
	asmtext
	ld hl, Route24TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route24Text5:
	asmtext
	ld hl, Route24TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route24Text6:
	asmtext
	ld hl, Route24TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route24Text7:
	asmtext
	ld hl, Route24TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route24BattleText1:
	fartext _Route24BattleText1
	done

Route24EndBattleText1:
	fartext _Route24EndBattleText1
	done

Route24AfterBattleText1:
	fartext _Route24AfterBattleText1
	done

Route24BattleText2:
	fartext _Route24BattleText2
	done

Route24EndBattleText2:
	fartext _Route24EndBattleText2
	done

Route24AfterBattleText2:
	fartext _Route24AfterBattleText2
	done

Route24BattleText3:
	fartext _Route24BattleText3
	done

Route24EndBattleText3:
	fartext _Route24EndBattleText3
	done

Route24AfterBattleText3:
	fartext _Route24AfterBattleText3
	done

Route24BattleText4:
	fartext _Route24BattleText4
	done

Route24EndBattleText4:
	fartext _Route24EndBattleText4
	done

Route24AfterBattleText4:
	fartext _Route24AfterBattleText4
	done

Route24BattleText5:
	fartext _Route24BattleText5
	done

Route24EndBattleText5:
	fartext _Route24EndBattleText5
	done

Route24AfterBattleText5:
	fartext _Route24AfterBattleText5
	done

Route24BattleText6:
	fartext _Route24BattleText6
	done

Route24EndBattleText6:
	fartext _Route24EndBattleText6
	done

Route24AfterBattleText6:
	fartext _Route24AfterBattleText6
	done
