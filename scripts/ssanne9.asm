SSAnne9Script:
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, SSAnne9TrainerHeader0
	ld de, SSAnne9ScriptPointers
	ld a, [wSSAnne9CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnne9CurScript], a
	ret

SSAnne9ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SSAnne9TextPointers:
	dw SSAnne9Text1
	dw SSAnne9Text2
	dw SSAnne9Text3
	dw SSAnne9Text4
	dw SSAnne9Text5
	dw PickUpItemText
	dw SSAnne9Text7
	dw SSAnne9Text8
	dw PickUpItemText
	dw SSAnne9Text10
	dw SSAnne9Text11
	dw SSAnne9Text12
	dw SSAnne9Text13

SSAnne9TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne9BattleText1 ; TextBeforeBattle
	dw SSAnne9AfterBattleText1 ; TextAfterBattle
	dw SSAnne9EndBattleText1 ; TextEndBattle
	dw SSAnne9EndBattleText1 ; TextEndBattle

SSAnne9TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne9BattleText2 ; TextBeforeBattle
	dw SSAnne9AfterBattleText2 ; TextAfterBattle
	dw SSAnne9EndBattleText2 ; TextEndBattle
	dw SSAnne9EndBattleText2 ; TextEndBattle

SSAnne9TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne9BattleText3 ; TextBeforeBattle
	dw SSAnne9AfterBattleText3 ; TextAfterBattle
	dw SSAnne9EndBattleText3 ; TextEndBattle
	dw SSAnne9EndBattleText3 ; TextEndBattle

SSAnne9TrainerHeader3:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne9BattleText4 ; TextBeforeBattle
	dw SSAnne9AfterBattleText4 ; TextAfterBattle
	dw SSAnne9EndBattleText4 ; TextEndBattle
	dw SSAnne9EndBattleText4 ; TextEndBattle

	db $ff

SSAnne9Text1:
	asmtext
	ld hl, SSAnne9TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text2:
	asmtext
	ld hl, SSAnne9TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text3:
	asmtext
	ld hl, SSAnne9TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text4:
	asmtext
	ld hl, SSAnne9TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSAnne9Text5:
	asmtext
	call SaveScreenTilesToBuffer1
	ld hl, SSAnne9Text_61bf2
	call PrintText
	call LoadScreenTilesFromBuffer1
	ld a, SNORLAX
	call DisplayPokedex
	jp TextScriptEnd

SSAnne9Text_61bf2:
	fartext _SSAnne9Text_61bf2
	done

SSAnne9Text7:
	asmtext
	ld hl, SSAnne9Text_61c01
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c01:
	fartext _SSAnne9Text_61c01
	done

SSAnne9Text8:
	asmtext
	ld hl, SSAnne9Text_61c10
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c10:
	fartext _SSAnne9Text_61c10
	done

SSAnne9Text10:
	asmtext
	ld hl, SSAnne9Text_61c1f
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c1f:
	fartext _SSAnne9Text_61c1f
	done

SSAnne9Text11:
	asmtext
	ld hl, SSAnne9Text_61c2e
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c2e:
	fartext _SSAnne9Text_61c2e
	done

SSAnne9Text12:
	asmtext
	ld hl, SSAnne9Text_61c3d
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c3d:
	fartext _SSAnne9Text_61c3d
	done

SSAnne9Text13:
	asmtext
	ld hl, SSAnne9Text_61c4c
	call PrintText
	jp TextScriptEnd

SSAnne9Text_61c4c:
	fartext _SSAnne9Text_61c4c
	done

SSAnne9BattleText1:
	fartext _SSAnne9BattleText1
	done

SSAnne9EndBattleText1:
	fartext _SSAnne9EndBattleText1
	done

SSAnne9AfterBattleText1:
	fartext _SSAnne9AfterBattleText1
	done

SSAnne9BattleText2:
	fartext _SSAnne9BattleText2
	done

SSAnne9EndBattleText2:
	fartext _SSAnne9EndBattleText2
	done

SSAnne9AfterBattleText2:
	fartext _SSAnne9AfterBattleText2
	done

SSAnne9BattleText3:
	fartext _SSAnne9BattleText3
	done

SSAnne9EndBattleText3:
	fartext _SSAnne9EndBattleText3
	done

SSAnne9AfterBattleText3:
	fartext _SSAnne9AfterBattleText3
	done

SSAnne9BattleText4:
	fartext _SSAnne9BattleText4
	done

SSAnne9EndBattleText4:
	fartext _SSAnne9EndBattleText4
	done

SSAnne9AfterBattleText4:
	fartext _SSAnne9AfterBattleText4
	done
