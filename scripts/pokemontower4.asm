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
	dbEventFlagBit EVENT_BEAT_POKEMONTOWER_4_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_POKEMONTOWER_4_TRAINER_0
	dw PokemonTower4BattleText1 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText1 ; TextAfterBattle
	dw PokemonTower4EndBattleText1 ; TextEndBattle
	dw PokemonTower4EndBattleText1 ; TextEndBattle

PokemonTower4TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_POKEMONTOWER_4_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_POKEMONTOWER_4_TRAINER_1
	dw PokemonTower4BattleText2 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText2 ; TextAfterBattle
	dw PokemonTower4EndBattleText2 ; TextEndBattle
	dw PokemonTower4EndBattleText2 ; TextEndBattle

PokemonTower4TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_POKEMONTOWER_4_TRAINER_2
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_POKEMONTOWER_4_TRAINER_2
	dw PokemonTower4BattleText3 ; TextBeforeBattle
	dw PokemonTower4AfterBattleText3 ; TextAfterBattle
	dw PokemonTower4EndBattleText3 ; TextEndBattle
	dw PokemonTower4EndBattleText3 ; TextEndBattle

	db $ff

PokemonTower4Text1:
	TX_ASM
	ld hl, PokemonTower4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4Text2:
	TX_ASM
	ld hl, PokemonTower4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4Text3:
	TX_ASM
	ld hl, PokemonTower4TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower4BattleText1:
	text ""
	fartext _PokemonTower4BattleText1
	done

PokemonTower4EndBattleText1:
	text ""
	fartext _PokemonTower4EndBattleText1
	done

PokemonTower4AfterBattleText1:
	text ""
	fartext _PokemonTower4AfterBattleText1
	done

PokemonTower4BattleText2:
	text ""
	fartext _PokemonTower4BattleText2
	done

PokemonTower4EndBattleText2:
	text ""
	fartext _PokemonTower4EndBattleText2
	done

PokemonTower4AfterBattleText2:
	text ""
	fartext _PokemonTower4AfterBattleText2
	done

PokemonTower4BattleText3:
	text ""
	fartext _PokemonTower4BattleText3
	done

PokemonTower4EndBattleText3:
	text ""
	fartext _PokemonTower4EndBattleText3
	done

PokemonTower4AfterBattleText3:
	text ""
	fartext _PokemonTower4AfterBattleText3
	done
