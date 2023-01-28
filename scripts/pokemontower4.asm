PokemonTower4Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower4TrainerHeader0
	ld de, PokemonTower4ScriptPointers
	ld a, [wPokemonTower4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower4CurScript], a
	ret

PokemonTower4ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PokemonTower4TextPointers:
	dw PokemonTower4Text1
	dw PokemonTower4Text2
	dw PokemonTower4Text3
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

PokemonTower4TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower4BattleText1 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText1 ; TextAfterBattle
	dw PokemonTower4EndBattleText1 ; TextEndBattle
	dw PokemonTower4EndBattleText1 ; TextEndBattle

PokemonTower4TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower4BattleText2 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText2 ; TextAfterBattle
	dw PokemonTower4EndBattleText2 ; TextEndBattle
	dw PokemonTower4EndBattleText2 ; TextEndBattle

PokemonTower4TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower4BattleText3 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText3 ; TextAfterBattle
	dw PokemonTower4EndBattleText3 ; TextEndBattle
	dw PokemonTower4EndBattleText3 ; TextEndBattle

	db $ff

PokemonTower4Text1:
	asmtext
	ld hl, PokemonTower4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4Text2:
	asmtext
	ld hl, PokemonTower4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4Text3:
	asmtext
	ld hl, PokemonTower4TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4BattleText1:
	fartext _PokemonTower4BattleText1
	done

PokemonTower4EndBattleText1:
	fartext _PokemonTower4EndBattleText1
	done

PokemonTower4AfterBattleText1:
	fartext _PokemonTower4AfterBattleText1
	done

PokemonTower4BattleText2:
	fartext _PokemonTower4BattleText2
	done

PokemonTower4EndBattleText2:
	fartext _PokemonTower4EndBattleText2
	done

PokemonTower4AfterBattleText2:
	fartext _PokemonTower4AfterBattleText2
	done

PokemonTower4BattleText3:
	fartext _PokemonTower4BattleText3
	done

PokemonTower4EndBattleText3:
	fartext _PokemonTower4EndBattleText3
	done

PokemonTower4AfterBattleText3:
	fartext _PokemonTower4AfterBattleText3
	done
