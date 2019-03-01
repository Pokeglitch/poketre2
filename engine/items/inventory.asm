; function to add an item (in varying quantities) to the player's bag or PC box
; INPUT:
; [wcf91] = item ID
; [wItemQuantity] = item quantity
; sets carry flag if successful, unsets carry flag if unsuccessful
; TODO - should it just set to 250 instead of fail?
AddItemToInventory_:
	ld a, [wcf91] ; a = item ID
	call GetItemRAMPointer ; hl = RAM pointer
	ld a, [wItemQuantity]
	ld b, a ; b = quantity to add
	ld a, [hl] ; a = existing item quantity
	add b ; a = new item quantity
	jp c, .fail ;if the quantity overflowed, then fail
	cp 251
	ret nc ; if the new quantity exceeds 250, then fail (carry flag already unset)
	ld [hl], a
	scf
	ret

.fail
	and a
	ret

; function to remove an item (in varying quantities) from the player's bag
; INPUT:
; [wWhichItem] = ID of the item to remove
; [wItemQuantity] = quantity to remove
RemoveItemFromInventory_:
	ld a, [wWhichItem] ; ID of the item being removed
	call GetItemRAMPointer ; hl = RAM pointer
	ld a, [wItemQuantity] ; quantity being removed
	ld b, a
	ld a, [hl] ; a = current quantity
	sub b
	jr nc, .storeNewQuantity
	
	; if the new value is negative, set to 0
	xor a

.storeNewQuantity
	ld [hl], a ; store new quantity
	ret

GetQuantityOfItemInBag:
; In: b = item ID
; Out: b = how many of that item are in the bag
	call GetPredefRegisters
	ld a, b
	call GetItemRAMPointer
	ld b, [hl]
	ret

; For the item in a, returns the RAM pointer in hl
; TODO - currently inefficient, in future will just have the group/offset mapped to the item index
; It also doesn't consider "unused" items
GetItemRAMPointer:
	push bc
	ld b, a
	sub HM_01
	jr c, .notMachineItem
	ld c, a
	ld hl, wMovesPocketQuantities
	jr .finish

.notMachineItem
	ld hl, BattlePocketItems
	call GetItemIndexInTable
	ld hl, wBattlePocketQuantities
	jr nc, .finish
	
	ld hl, HealthPocketItems
	call GetItemIndexInTable
	ld hl, wHealthPocketQuantities
	jr nc, .finish
	
	ld hl, FieldPocketItems
	call GetItemIndexInTable
	ld hl, wFieldPocketQuantities

.finish
	ld b,0
	add hl, bc
	pop bc
	ret

; To get the index of the item in b from the table in hl
; Returns the index in c, or the carry flag if not in the table
GetItemIndexInTable:
	ld c, 0
.loop
	ld a, [hli]
	cp b
	ret z
	inc c
	cp -1
	jr nz, .loop
	scf
	ret



BattlePocketItems:
    db GREAT_BALL
	db MASTER_BALL
	db POKE_BALL
	db ULTRA_BALL
BattlePocketItemsEnd:

HealthPocketItems:
    db ANTIDOTE
	db AWAKENING
	db BURN_HEAL
	db CALCIUM
	db CARBOS
    db DIRE_HIT
	db ELIXER
	db ETHER
	db FRESH_WATER
	db FULL_HEAL
    db FULL_RESTORE
	db GUARD_SPEC
	db HP_UP
	db HYPER_POTION
	db ICE_HEAL
    db IRON
	db LEMONADE
	db MAX_ELIXER
	db MAX_ETHER
	db MAX_POTION
    db MAX_REVIVE
	db PARLYZ_HEAL
	db POTION
	db PP_UP
    db PROTEIN
	db RARE_CANDY
	db REVIVE
	db SODA_POP
	db SUPER_POTION
    db X_ACCURACY
	db X_ATTACK
	db X_DEFEND
	db X_SPECIAL
	db X_SPEED
HealthPocketItemsEnd:

FieldPocketItems:
    db BICYCLE
	db BIKE_VOUCHER
	db CARD_KEY
	db COIN_CASE
    db DOME_FOSSIL
	db ESCAPE_ROPE
	db EXP_ALL
	db FIRE_STONE
    db GOLD_TEETH
	db GOOD_ROD
	db HELIX_FOSSIL
	db ITEMFINDER
    db LEAF_STONE
	db LIFT_KEY
	db MAX_REPEL
	db MOON_STONE
    db NUGGET
	db OAKS_PARCEL
	db OLD_AMBER
	db OLD_ROD
    db POKE_DOLL
	db POKE_FLUTE
	db REPEL
	db S_S_TICKET
    db SECRET_KEY
	db SILPH_SCOPE
	db SUPER_REPEL
	db SUPER_ROD
	db THUNDER_STONE
	db TOWN_MAP
	db WATER_STONE
FieldPocketItemsEnd:
