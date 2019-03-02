; To get the pointer for the current item's quantity (hl)
GetCurrentItemQuantityPointer:
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    ld a, [hli]
    jr GetPointerToPositionInList

; To get the current item id
GetCurrentItemID:
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    ld a, [hl]
    ;fall through

; To get the item id for the given item index (a)
GetItemIDAtPosition:
    push af
    ld a, POCKET_ATTRIBUTE_ITEMS
    call GetActivePocketAttributePointer
    pop af
    call GetPointerToPositionInList
    ld a, [hl]
    ret

; To get the pointer to the quantity (hl) for the given item index (a)
GetItemQuantityPointer:
    push af
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    inc hl
    pop af
    ; fall through

; To get the pointer (hl) to the given index (a) in the given list (hl)
GetPointerToPositionInList:
    add l
    ld l, a
    ret nc
    inc h
    ret

; To get the pointer for the given attribute (a) for the active pocket
GetActivePocketAttributePointer:
    call GetPointerToActivePocketAttributeData
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

; To get the pointer to the given attribute (a) for the active pocket
GetPointerToActivePocketAttributeData:
    ld hl, PocketAttributesTable
    add a
    add l
    ld l, a
    jr nc, .noCarry
    inc h

.noCarry
    call GetActivePocketID
    lb bc, 0, POCKET_ATTRIBUTE_DATA_LENGTH

.loop
    and a
    ret z
    add hl, bc
    dec a
    jr .loop

; Returns the active pocket id (a)
GetActivePocketID:
    ld a, [wInventoryProperties]
    and MASK_ACTIVE_POCKET
    ret
    
; Update the active pocket based on the given direction (c)
ChangeActivePocket:
    call GetActivePocketID
    add c ; a = new pocket id
    cp -1
    jr nz, .notNegative
    ld a, NUM_POCKETS-1
    jr .updatePocket

.notNegative
    cp NUM_POCKETS
    jr nz, .updatePocket
    xor a
    
.updatePocket
    ld c, a
    ld a, [wInventoryProperties]
    and ~MASK_ACTIVE_POCKET
    add c
    ld [wInventoryProperties], a
    ret
