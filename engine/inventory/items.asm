; To get the item filter in wd11e, returns in wd11e
GetItemFilterwD11E:
    ld a, [wd11e]
    call GetItemFilter
    ld [wd11e], a
    ret

; To get the filter (a) for the given item (a)
GetItemFilter:
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
