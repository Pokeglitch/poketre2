Class: MACRO
    Prop Size, Byte, \1EntrySize
    Prop Instances, Pointer, \1Table
ENDM

    ; Initialize the Data for the Class Table
    Table Class
    Entry Pokemon
    Entry Trainer
    Entry Other

GetInstancePropertyPointer:
    ld hl, ClassTable
    ld a, [wWhichClass]
    ld c, a
    ld a, ClassEntrySize
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
