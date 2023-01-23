; copy into de
GetInstanceName_Far:
    ld a, [H_LOADEDROMBANK]
    push af ;store the previous bank
    ld a, [wWhichClass]
    call SetNewBank
    call GetInstanceName
    pop af
    jp SetNewBank

GetInstanceName:
    push de
    xor a ; PropertyNameOffset is always the first property
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
GetInstanceProperties_Far:
    ld a, [H_LOADEDROMBANK]
    push af ;store the previous bank
    ld a, [wWhichClass]
    call SetNewBank
    call GetInstanceProperties_Common
    pop af
    jp SetNewBank

GetInstanceProperties:
	ld [wWhichProperty], a

GetInstanceProperties_Common:
    push bc
    push de
    call GetInstancePropertyPointer_Common
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
GetInstanceProperty_Far:
    ld [wWhichProperty], a
    ld a, [H_LOADEDROMBANK]
    push af ;store the previous bank
    ld a, [wWhichClass]
    call SetNewBank
    
    call GetInstancePropertyPointer_Common
    ld a, [hli]
    ld h, [hl]
    ld l, a

    pop af
    jp SetNewBank

GetInstanceProperty:
    call GetInstancePropertyPointer
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

GetInstancePropertyPointer:
    ld [wWhichProperty], a

GetInstancePropertyPointer_Common:
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
