InstanceAccessor: MACRO
    GetInstance\1:
        ld a, [H_LOADEDROMBANK]
        push af ;store the previous bank
        ld a, [wWhichClass]
        call SetNewBank
        call GetInstance\1_SameBank
        pop af
        jp SetNewBank

    GetInstance\1_SameBank:
ENDM

; copy into de
; GetInstanceName:
    InstanceAccessor Name
    push de
    xor a ; PropertyNameOffset is always the first property
    ld [wWhichProperty], a
    call GetInstancePropertyPointer
    ld a, [hli]
    ld h, [hl]
    ld l, a ; hl = pointer to string
    pop de

.copyLoop
    ld a, [hli]
    ld [de], a
    inc de
    cp "@"
    jr nz, .copyLoop

    ret

; copy c bytes into de
; GetInstanceProperties:
    InstanceAccessor Properties
    push bc
    push de
    call GetInstancePropertyPointer
    pop de
    pop bc

.loop
    ld a, [hli]
    ld [de], a
    inc de
    dec c
    jr nz, .loop
    ret

; returns 2 bytes at property value into HL
; high byte is in l
; GetInstanceProperty:
    InstanceAccessor Property
    call GetInstancePropertyPointer
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

GetInstancePropertyPointer:
    ld hl, ClassInstanceTableAddress ; all tables start at $4000
    ld a, [hli] ; a = class entry size
    push af

    ld a, [wWhichProperty]
    ld b, 0
    ld c, a
    add hl, bc ; hl = address to property in first instance

    ld a, [wWhichInstance]
    ld c, a

    pop af ; a = class entry size
.loop
    add hl, bc
    dec a
    jr nz, .loop
    ret
