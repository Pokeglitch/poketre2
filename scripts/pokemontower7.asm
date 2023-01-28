PokemonTower7Script:
	call EnableAutoTextBoxDrawing
	ld de, PokemonTower7ScriptPointers
	ld a, [wPokemonTower7CurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower7CurScript], a
	ret

PokemonTower7Script_60d18:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower7CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw PokemonTower7Script2
	dw PokemonTower7Script3
	dw PokemonTower7Script4

PokemonTower7Script2:
	ld hl, wFlags_0xcd60
	res 0, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower7Script_60d18
	call EndTrainerBattle
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call PokemonTower7Script_60db6
	ld a, $3
	ld [wPokemonTower7CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7Script3:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld hl, wMissableObjectList
	ld a, [wSpriteIndex]
	ld b, a
.missableObjectsListLoop
	ld a, [hli]
	cp b            ; search for sprite ID in missing objects list
	ld a, [hli]
	jr nz, .missableObjectsListLoop
	ld [wMissableObjectIndex], a   ; remove missable object
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld [wSpriteIndex], a
	ld [wUnusedDA38], a
	ld a, $0
	ld [wPokemonTower7CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7Script4:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, HS_POKEMONTOWER_7_MR_FUJI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 9], a
	ld a, LAVENDER_HOUSE_1
	ld [hWarpDestinationMap], a
	ld a, $1
	ld [wDestinationWarpID], a
	ld a, LAVENDER_TOWN
	ld [wLastMap], a
	ld hl, wd72d
	set 3, [hl]
	ld a, $0
	ld [wPokemonTower7CurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower7Script_60db6:
	ld hl, CoordsData_60de3
	ld a, [wSpriteIndex]
	dec a
	swap a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
.asm_60dcb
	ld a, [hli]
	cp b
	jr nz, .asm_60dde
	ld a, [hli]
	cp c
	jr nz, .asm_60ddf
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [wSpriteIndex]
	ld [H_SPRITEINDEX], a
	jp MoveSprite
.asm_60dde
	inc hl
.asm_60ddf
	inc hl
	inc hl
	jr .asm_60dcb

CoordsData_60de3:
	db $0C,$09
	dw MovementData_60e13
	db $0B,$0A
	dw MovementData_60e1b
	db $0B,$0B
	dw MovementData_60e22
	db $0B,$0C
	dw MovementData_60e22
	db $0A,$0C
	dw MovementData_60e28
	db $09,$0B
	dw MovementData_60e30
	db $09,$0A
	dw MovementData_60e22
	db $09,$09
	dw MovementData_60e22
	db $08,$09
	dw MovementData_60e37
	db $07,$0A
	dw MovementData_60e22
	db $07,$0B
	dw MovementData_60e22
	db $07,$0C
	dw MovementData_60e22

MovementData_60e13:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db $FF

MovementData_60e1b:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

MovementData_60e22:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

MovementData_60e28:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

MovementData_60e30:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

MovementData_60e37:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

PokemonTower7TextPointers:
	dw PokemonTower7Text1
	dw PokemonTower7Text2
	dw PokemonTower7Text3
	dw PokemonTower7FujiText

PokemonTower7TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower7BattleText1 ; TextBeforeBattle
	dw PokemonTower7AfterBattleText1 ; TextAfterBattle
	dw PokemonTower7EndBattleText1 ; TextEndBattle
	dw PokemonTower7EndBattleText1 ; TextEndBattle

PokemonTower7TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower7BattleText2 ; TextBeforeBattle
	dw PokemonTower7AfterBattleText2 ; TextAfterBattle
	dw PokemonTower7EndBattleText2 ; TextEndBattle
	dw PokemonTower7EndBattleText2 ; TextEndBattle

PokemonTower7TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw PokemonTower7BattleText3 ; TextBeforeBattle
	dw PokemonTower7AfterBattleText3 ; TextAfterBattle
	dw PokemonTower7EndBattleText3 ; TextEndBattle
	dw PokemonTower7EndBattleText3 ; TextEndBattle

	db $ff

PokemonTower7Text1:
	asmtext
	ld hl, PokemonTower7TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7Text2:
	asmtext
	ld hl, PokemonTower7TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7Text3:
	asmtext
	ld hl, PokemonTower7TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

PokemonTower7FujiText:
	asmtext
	ld hl, TowerRescueFujiText
	call PrintText
	SetEvent EVENT_RESCUED_MR_FUJI
	SetEvent EVENT_RESCUED_MR_FUJI_2
	ld a, HS_LAVENDER_HOUSE_1_MR_FUJI
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_SAFFRON_CITY_E
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SAFFRON_CITY_F
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $4
	ld [wPokemonTower7CurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

TowerRescueFujiText:
	fartext _TowerRescueFujiText
	done

PokemonTower7BattleText1:
	fartext _PokemonTower7BattleText1
	done

PokemonTower7EndBattleText1:
	fartext _PokemonTower7EndBattleText1
	done

PokemonTower7AfterBattleText1:
	fartext _PokemonTower7AfterBattleText1
	done

PokemonTower7BattleText2:
	fartext _PokemonTower7BattleText2
	done

PokemonTower7EndBattleText2:
	fartext _PokemonTower7EndBattleText2
	done

PokemonTower7AfterBattleText2:
	fartext _PokemonTower7AfterBattleText2
	done

PokemonTower7BattleText3:
	fartext _PokemonTower7BattleText3
	done

PokemonTower7EndBattleText3:
	fartext _PokemonTower7EndBattleText3
	done

PokemonTower7AfterBattleText3:
	fartext _PokemonTower7AfterBattleText3
	done
