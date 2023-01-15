; TODO
; PrintText function to get name of class instance
; Update all DEX_ constants to just use the pokemon name
; - (update places where DEX is reduced by 1 in PCE code)
; - also all pokemon name calls should use new table (& remove old name strings)

; TODO - make this an input variable to the class macro....(?)
CLASSES_BANK EQU $2D

SECTION "Classes", ROMX, BANK[CLASSES_BANK]

    ; Initialize the Data for the Class Table
    Table Class, Size, Byte, Instances, Pointer
    Entry Pokemon, Front, Sprite
    Entry Other, Sprites, Sprite
    Entry Trainer, Front, Sprite

GetInstancePropertyPointer:
    ld hl, ClassTable
    ld a, [wWhichClass]
    ld c, a
    ld a, ClassSize
    call GetIndexInTable ; hl = pointer to start of class

    ld a, [hli] ; a = size
    push af

    ld a, [hli]
    ld h, [hl]
    ld l, a ; hl = pointer to class instance table
    
    ld a, [wWhichProperty]
    ld e, a

    ld a, [wWhichInstance]
    ld c, a
    pop af ; a = class size
    jp GetPropertyAddressInTable

; returns 2 bytes at properly value into HL
; high byte is in l
GetInstanceProperty:
    call GetInstancePropertyPointer
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

; hl = table
; c = Index
; e = Property
; a = Size
; returns address into HL
GetPropertyAddressInTable:
    ld d, 0
    add hl, de
    ; Fall Through

; c = index
GetIndexInTable:
    ld b, 0
.loop
    add hl, bc
    dec a
    jr nz, .loop
    ret
