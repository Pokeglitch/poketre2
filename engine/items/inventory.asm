; function to add an item (in varying quantities) to the player's bag or PC box
; INPUT:
; [wcf91] = item ID
; [wItemQuantity] = item quantity
; sets carry flag if successful, unsets carry flag if unsuccessful
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
	ret c ; if the new value is negative, then fail
	ld [hl], a ; store new quantity
	ret

; For the item in a, returns the RAM pointer in hl
; TODO - currently inefficient, in future will just have the group/offset mapped to the item index
GetItemRAMPointer:
	push bc
	ld b, a
	sub HM_01
	jr c, .notMachineItem
	ld c, a
	ld hl, wMachineItemQuantities
	jr .finish

.notMachineItem
	ld hl, BattleItems
	call GetItemIndexInTable
	ld hl, wBattleItemQuantities
	jr nc, .finish
	
	ld hl, HealthItems
	call GetItemIndexInTable
	ld hl, wHealthItemQuantities
	jr nc, .finish
	
	ld hl, FieldItems
	call GetItemIndexInTable
	ld hl, wFieldItemQuantities
	jr nc, .finish

	ld hl, UnusedItems
	call GetItemIndexInTable
	ld hl, wUnusedItemQuantities

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


BattleItems:
    db GREAT_BALL, MASTER_BALL, POKE_BALL, ULTRA_BALL
    db -1

HealthItems:
    db ANTIDOTE, AWAKENING, BURN_HEAL, CALCIUM, CARBOS
    db DIRE_HIT, ELIXER, ETHER, FRESH_WATER, FULL_HEAL
    db FULL_RESTORE, GUARD_SPEC, HP_UP, HYPER_POTION, ICE_HEAL
    db IRON, LEMONADE, MAX_ELIXER, MAX_ETHER, MAX_POTION
    db MAX_REVIVE, PARLYZ_HEAL, POTION, PP_UP, PP_UP_2
    db PROTEIN, RARE_CANDY, REVIVE, SODA_POP, SUPER_POTION
    db X_ACCURACY, X_ATTACK, X_DEFEND, X_SPECIAL, X_SPEED
    db -1

FieldItems:
    db BICYCLE, BIKE_VOUCHER, CARD_KEY, COIN_CASE
    db DOME_FOSSIL, ESCAPE_ROPE, EXP_ALL, FIRE_STONE
    db GOLD_TEETH, GOOD_ROD, HELIX_FOSSIL, ITEMFINDER
    db LEAF_STONE, LIFT_KEY, MAX_REPEL, MOON_STONE
    db NUGGET, OAKS_PARCEL, OLD_AMBER, OLD_ROD
    db POKE_DOLL, POKE_FLUTE, REPEL, S_S_TICKET
    db SECRET_KEY, SILPH_SCOPE, SUPER_REPEL, SUPER_ROD
    db SURFBOARD, THUNDER_STONE, TOWN_MAP, WATER_STONE
    db -1

UnusedItems:
    db BOULDERBADGE, CASCADEBADGE, COIN, EARTHBADGE
    db MARSHBADGE, POKEDEX, RAINBOWBADGE, SAFARI_BALL
    db SOULBADGE, THUNDERBADGE, UNUSED_ITEM, VOLCANOBADGE
    db -1
