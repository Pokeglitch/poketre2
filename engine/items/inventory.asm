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
; TODO - just get from new table
GetItemRAMPointer:
	push bc
	cp HM_01
	jr c, .notMachineItem
	
	sub HM_01
	ld c, a
	ld hl, wMovesPocketQuantities
	jr .finish

.notMachineItem
	ld b, (BattlePocketItemsEnd - BattlePocketItems)
	ld hl, BattlePocketItems
	call GetItemIndexInTable
	ld hl, wBattlePocketQuantities
	jr nc, .finish
	
	ld b, (HealthPocketItemsEnd - HealthPocketItems)
	ld hl, HealthPocketItems
	call GetItemIndexInTable
	ld hl, wHealthPocketQuantities
	jr nc, .finish
	
	ld b, (FieldPocketItemsEnd - FieldPocketItems)
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
	cp [hl]
	ret z
	inc hl
	inc c
	dec b
	jr nz, .loop
	scf
	ret

; To get the name of the machine with the given item id
GetMachineMoveName:
    sub TM_01
    jr nc, .notHM
    add (TM_50 - HM_01) + 1
.notHM
	inc a
	ld [wd11e], a 
	predef TMToMove ; get move ID from TM/HM ID
	ld a, [wd11e]
	ld [wMoveNum], a
	jp GetMoveName