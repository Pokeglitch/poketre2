GetQuantityOfItemInBag:
; In: b = item ID
; Out: b = how many of that item are in the bag
	call GetPredefRegisters
	ld a, b
	call GetItemRAMPointer
	ld b, [hl]
	ret
