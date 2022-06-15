; To get the item filter in wd11e, returns in wd11e
GetItemFilterwD11E:
    ld a, [wd11e]
    call GetItemFilter
    ld [wd11e], a
    ret

; To get the item price halved
GetHalfItemPriceFromCF91:
    ld a, 1
    push af
    jr GetItemPriceCommon

; To get the full item price
GetItemPriceFromCF91:
    xor a
    push af
    ; fall through

; Stores item's price at hItemPrice (3 bytes)
; Input: [wcf91] = item id
; TODO - only need to store 2 bytes in hItemPrice
GetItemPriceCommon:
    ld a, [wcf91]
    call LookupItemPrice
    bit BIT_FIFTY_BUCKS, a
    res BIT_FIFTY_BUCKS, a
    push af
    ld h, 0
    ld l, a
    add hl, hl ; hl = 2x
    ld b, h
    ld c, l ; bc = 2x price
    add hl, hl ; hl = 4x
    add hl, hl ; hl = 8x
    add hl, hl ; hl = 16x
    ld d, h
    ld e, l ; de = 16x
    add hl, hl ;hl = 32x
    add hl, de ;hl = 48x (32x + 16x)
    add hl, bc ;hl = 50x (48x + 2x)
    pop af
    jr z, .dontAdd25
    ld bc, 25
    add hl, bc

.dontAdd25
    pop af
    and a
    jr nz, .dontDouble

    add hl, hl ; hl = 100x

.dontDouble
    ld d, h
    ld e, l
    ld hl, hItemPrice
    ld [hl], 0
    inc hl
    ld a, d
    ld [hli], a
    ld [hl], e
    ret  

; To get the price (a) for the given item (a)
LookupItemPrice:
    ; todo - remove this when machines are no longer items
    ; GetMachinePrice
    cp HM_01
    jr c, .notMove

    xor a
    ret

.notMove
    ld e, ITEM_PRICE
    call GetPointerToItemAttributeData
    ld a, [hl]
    ret

; To get the filter (a) for the given item (a)
GetItemFilter:
    ; todo - remove this when machines are no longer items
    cp HM_01
    jr c, .notMove

    cp TM_01
    ld a, FIELD_USE | APPLY_TO_PK
    ret c
    
    or SELLABLE
    ret

.notMove
    ld e, ITEM_FILTER
    call GetPointerToItemAttributeData
    ld a, [hl]
    ret
    
; To get the pointer (de) to the description for the given item (a)
GetItemDescription:
    ; todo - change this when its a TM
    cp HM_01
    jr c, .notMove

    ld hl, MovesDescription
    ret

.notMove
    ld e, ITEM_DESCRIPTION
    ; fall through

; To get the pointer (hl) from the item attribute table for given attribute (e) of given item (a)
GetItemAttributeDataPointer:
    call GetPointerToItemAttributeData
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

; To get the pointer (hl) to the given attribute (e) for the given item (a)
GetPointerToItemAttributeData:
    ld hl, ItemAttributeTable
    ld d, 0
    add hl, de
    ld e, ITEM_ATTRIBUTE_DATA_SIZE
.loop
    dec a
    ret z
    add hl, de
    jr .loop
