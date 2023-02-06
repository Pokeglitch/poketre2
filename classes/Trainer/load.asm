CopyIntoTrainerName:
	ld de, wTrainerName
	ld bc, 13
	jp CopyData

LoadTrainer:
	; just load the name if Link Battle
	ld hl, wLinkEnemyTrainerName
	ld a, [wLinkState]
	and a
	jr nz, CopyIntoTrainerName

	ld a, [wTrainerInstance]
	ld [wWhichInstance], a
	ld a, TrainerPropertyTraitsOffset
	call GetInstancePropertyPointer

	bit TrainerPropertyTraitsFlagRivalIndex, [hl]
	jr nz, .loadRivalName ; load rival name if its the Rival

	; not rival, so load name from table	
	ld de, wTrainerName
	call GetInstanceName ; instance was already set earlier
	jr .loadParty

.loadRivalName
	ld hl, wRivalName
	call CopyIntoTrainerName

.loadParty
	; Initialize the enemy party
	ld hl, wEnemyPartyCount
	xor a
	ld [hli], a
	dec a
	ld [hl], a

; get the pointer to trainer data for this class
	ld a, TrainerPropertyPartiesOffset
	call GetInstanceProperty ; instance were already set earlier
	
	; hl = pointer to parties
	ld a, [wTrainerNo]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = party address

.readPartyProperties
	ld a, [hli] ; load the properties
	and a ; if there are no properties, then continue
	jr z, .partyFound

	and PartyDefinitionConditionBitMask
	cp PartyDefinitionConditionRAMValue
	jr z, .ramValue

	cp PartyDefinitionConditionRoutineValue
	jr z, .routineValue

	call ExecuteTeamRoutine
	jr .partyFound ; skip party properties
	
.routineValue
	push hl
	call ExecuteTeamRoutine
	pop hl
	inc hl
	inc hl
	inc hl ; move past the bank/address data
	jr .comparisonValueFound

.ramValue
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a ; bc = ptr compare against
	ld a, [bc]

.comparisonValueFound
	ld b, a ; b = value to compare against

.checkCase
	ld a, [hli]
	cp b
	jr z, .caseFound

	; skip the pointer
	inc hl
	inc hl
	jr .checkCase

.caseFound
	; get the pointer
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = pointer to party
	jr .readPartyProperties

.partyFound
	ld a, [hli]
	bit PartyDataSpecialBitIndex, a ; is the trainer special?
	jr nz, .specialTrainer ; if so, check for special moves

; standard trainer
	ld [wCurEnemyLVL], a
.addNextPokemon_Standard
	ld a, [hli]
	cp PartyDataTerminator ; have we reached the end of the trainer data?
	jr z, .storeTrainerMoney
	
	call AddMonToEnemyParty
	jr .addNextPokemon_Standard

.specialTrainer
	res PartyDataSpecialBitIndex, a ; unset the flag
	ld de, wEnemyMon1Moves

.addNextMon
	ld [wCurEnemyLVL], a
	ld a, [hli]

	push de
	call AddMonToEnemyParty
	pop de

.checkForSpecialMove
	ld a, [hli] ; load next value
	cp PartyDataTerminator
	jr z, .storeTrainerMoney ; add the money if end of data reached
	
	bit PartyDataSpecialBitIndex, a ; if the high bit is set, then this pokemon has a special move
	jr nz, .storeSpecialMove

	; otherwise, update the pointer for the next mon's move and read next data set
	push hl
	ld hl, wEnemyMon2 - wEnemyMon1
	add hl, de
	ld d, h
	ld e, l ;de = pointer to next pokemon's moves
	pop hl
	jr .addNextMon

.storeSpecialMove
	push de

	res PartyDataSpecialBitIndex, a ; unset the flag
	add e
	ld e, a ; shift the move index
	jr nc, .dontIncD

	inc d ; if carry, increase d
	
.dontIncD
	ld a, [hli] ; get the new Move ID
	ld [de], a ; write to the move slot

	pop de
	jr .checkForSpecialMove

.storeTrainerMoney
	; load the base money
	ld a, [wTrainerInstance]
	ld [wWhichInstance], a
	ld a, TrainerPropertyMoneyOffset
	call GetInstanceProperty ; high byte is in l

	ld d, 0
	ld e, l
	ld hl, 0

	ld a, [wCurEnemyLVL]

.calcMoneyLoop
	add hl, de
	dec a
	jr nz, .calcMoneyLoop

	ld d, h
	ld e, l

	ld hl, wAmountMoneyWon
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

ExecuteTeamRoutine:
	ld a, [hli]
	ld b, a ; b = bank to routine
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = ptr to routine
	jp Bankswitch

AddMonToEnemyParty:
	push hl
	ld [wd11e], a
	farcall PokedexToIndex
	ld a, [wd11e]
	ld [wcf91], a
	ld a, ENEMY_PARTY_DATA
	ld [wMonDataLocation], a
	call AddPartyMon
	pop hl
	ret
