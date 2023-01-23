ReadNextCounter: MACRO
    ld a, [hImageBit]
    ld h, a ; h = current bit index
    ld a, [hImageByte] ; a = current byte (has already been shifted)
    ld c, 1 ; c = number of bits to count

.nextBitLoop_ReadNextCounter_\1
    rla ; read next bit into carry
    jr nc, .headerFinished_ReadNextCounter_\1
    inc c
    dec h
    jr nz, .nextBitLoop_ReadNextCounter_\1
    
    MoveToNextByte \1_1
    jr .nextBitLoop_ReadNextCounter_\1

.headerFinished_ReadNextCounter_\1
    ; skip the 0 bit
    dec h
    jr nz, .skipMoveToNextByte_ReadNextCounter_\1
    MoveToNextByte \1_2

.skipMoveToNextByte_ReadNextCounter_\1
    ld b, c
    ReadBits \1_2
    ld a, b
    dec a
    add a
    ld b, 0
    ld c, a
    ld hl, CounterOffsetTable
    add hl, bc ; hl points to value in table
    ld a, [hli]
    ld h, [hl]
    ld l, a ; hl = offset amount

    add hl, de
    ld d, h
    ld e, l ; de = final value
ENDM


; read c bits into de
; h = bits remaining in this byte
ReadBits: MACRO
    ld de, 0 ; de = value of bits

.readNextBitLoop_ReadBits_\1
    rla ; shift next bit into carry
    rl e ; shift bit from carry to bit 0 of e
    rl d
    dec h
    jr z, .MoveToNextByte_ReadBits_\1

    dec c
    jr nz, .readNextBitLoop_ReadBits_\1
    jr .finish_ReadBits_\1

.MoveToNextByte_ReadBits_\1
    MoveToNextByte \1_3
    dec c
    jr nz, .readNextBitLoop_ReadBits_\1

.finish_ReadBits_\1
    ld [hImageByte], a ;store the byte
    ld a, h
    ld [hImageBit], a ;store the bit counter
ENDM


; h = number of bits remaining
; a = byte to read bits from
; hImageAddress = pointer to current byte
MoveToNextByte: MACRO
    ; move to next byte
    ld hl, hImageAddress+1
    inc [hl]
    ld a, [hl] ; a = low byte of pointer
    dec hl ; wont affect flags
    jr nz, .noCarry_MoveToNextByte_\1

    inc [hl]
.noCarry_MoveToNextByte_\1
    ; get next byte
    ld h, [hl]
    ld l, a ; hl = image address
    
    ld a, [hl] ; a = next byte
    ld h, 8 ; reset bit counter
ENDM

SubtractAndCompareColor: MACRO
    SubtractColor \1, b, c

    ; only for the first comparison, check for end of image
    IF \1 == 2
        or c ; combine high byte (a) with low byte (e)
        jp z, .exit ; exit if no bits are set
    ENDC

    ; compare new amount for this color to new amount for previous color
    ld a, c
    sub e
    ld a, b
    sbc d
ENDM

InsertPreviousAndUpdateColor: MACRO
    ShiftColor \1, Previous, d, e
    UpdateCountTilColor \2, b, c
ENDM

ShiftColor: MACRO
    ld a, [hColor\2]
    ld [hColor\1], a
    UpdateCountTilColor \1, \3, \4
ENDM

UpdateCountTilColor: MACRO
    ld a, \2
    ld [hCountTilColor\1], a
    ld a, \3
    ld [hCountTilColor\1+1], a
ENDM

SubtractAndUpdateColor: MACRO
    SubtractColor \1, [hCountTilColor\1], [hCountTilColor\1+1]
ENDM

SubtractColor: MACRO
    ld a, [hCountTilColor\1+1]
    sub l
    ld \3, a

    ld a, [hCountTilColor\1]
    sbc h
    ld \2, a
ENDM

ReadHeaderColor: MACRO
    ld a, [hli]
    add c
    ld e, a
    ld a, 0
    adc b
    ld d, a
    ld a, [de]
    ld [hColor\1], a
ENDM

ReadHeaderCounter: MACRO
    ReadNextCounter \1 ; de = counter
    ld a, d
    ld [hCountTilColor\1], a
    ld a, e
    ld [hCountTilColor\1+1], a
ENDM

LoadMainPCEImageToVRAM:
    ld a, PokemonPropertyFrontOffset ; shared with all other front sprites
	ld [wWhichProperty], a
    ; fall through

LoadPCEImageToVRAM:
    push de ; store the sprite destination
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a
    
    call LoadPCEPalette
    call LoadPCEDataIntoBuffer
    call DrawPCEImage
    
    ; bank doesnt matter, sram wont change bank
    ld de, sPCESpriteBuffer
    ld c, 7*7
    pop hl ; hl = final sprite destination
    call CopyVideoData

	ld a, SRAM_DISABLE
	ld [MBC1SRamEnable], a
    ret

LoadPCEDataIntoBuffer:
    ld c, SpriteAllocate
    ld de, wBuffer
	call GetInstanceProperties_Far

    ld hl, wBuffer
    ld c, [hl]
    inc hl
    ld b, [hl] ; bc = size
    inc hl
    ld e, [hl] ; e = bank 
    inc hl
    ld a, [hli]
    ld h, [hl]
    ld l, a ; hl - sprite pointer
    ld a, e ; a = bank
    ld de, sPCESpriteBufferRaw
    jp FarCopyData

DrawPCEImage:
    ld bc, wPCEPalette
    ld hl, sPCESpriteBufferRaw

    ; store the colors (converted from palette)
    ReadHeaderColor 0
    ReadHeaderColor 1
    ReadHeaderColor 2
    ReadHeaderColor 3
    ReadHeaderColor 4
 
    ld a, h
    ld [hImageAddress], a
    ld a, l
    ld [hImageAddress+1], a
    ld a, [hl]
    ld [hImageByte], a
    ld a, 8
    ld [hImageBit], a
    dec a
    ld [hImageDestinationBit], a

    ReadHeaderCounter 1
    ReadHeaderCounter 2
    ReadHeaderCounter 3
    ReadHeaderCounter 4

    ld hl, sPCESpriteBuffer
    push hl ; push the image destination

.loop
    pop hl ; recover image destination pointer
    ld a, [hCountTilColor1]
    ld d, a
    ld a, [hCountTilColor1+1]
    ld e, a ; de = pixel count

    call PlacePixels
    
    push hl ; store the image destination pointer

    ReadNextCounter 5 ; de = new amount for previous color
    ld a, [hColor0]
    ld [hColorPrevious], a
    
    ; shift next color into current color
    ld a, [hColor1]
    ld [hColor0], a

    ld a, [hCountTilColor1]
    ld h, a
    ld a, [hCountTilColor1+1]
    ld l, a ; hl = count of pixels that were just placed
    
    ; update the next desintation bit
    ld a, [hImageDestinationBit]
    sub l ; subtract number of pixels that wereplaced
    and %00000111 ; get mod 8, next bit number
    ld [hImageDestinationBit], a

    ; compare color 2
    SubtractAndCompareColor 2
    jr c, .shiftColor2 ; shift if this colors new amount < previous colors new amonut

    InsertPreviousAndUpdateColor 1, 2
    jp .updateColor3

.shiftColor2
    ShiftColor 1, 2, b, c

    ; compare color 3
    SubtractAndCompareColor 3
    jr c, .shiftColor3 ; shift if this colors new amount < previous colors new amonut

    InsertPreviousAndUpdateColor 2, 3
    jp .updateColor4

.shiftColor3
    ShiftColor 2, 3, b, c

    ; compare color 4
    SubtractAndCompareColor 4
    jr c, .shiftColor4 ; shift if this colors new amount < previous colors new amonut

    InsertPreviousAndUpdateColor 3, 4
    jp .loop

.shiftColor4
    ShiftColor 3, 4, b, c
    ShiftColor 4, Previous, d, e
    jp .loop

; this portion of the code ONLY update stored values, does not compare to new value
; gets entered after the new amount of previous color has already been placed
.updateColor3
    SubtractAndUpdateColor 3
.updateColor4
    SubtractAndUpdateColor 4
    jp .loop

.exit
    pop hl ; remove the pushed image destination pointer
    ret

CounterOffsetTable:
	dw %0000000000000001
	dw %0000000000000011
	dw %0000000000000111
	dw %0000000000001111
	dw %0000000000011111
	dw %0000000000111111
	dw %0000000001111111
	dw %0000000011111111
	dw %0000000111111111
	dw %0000001111111111
	dw %0000011111111111
	dw %0000111111111111
	dw %0001111111111111
	dw %0011111111111111
	dw %0111111111111111
	dw %1111111111111111

FillPixelsMacro: MACRO
    ld a, [hImageDestinationBit]
    
    ld hl, SetBitsLookupTable
    ld b, 0
    ld c, a
    add hl, bc
    ld b, [hl] ; b = SetBits mask from table

    ; Check if the amount of pixels to set exceeds pixel amount remaining in byte
    inc d
    dec d
    jr nz, .applyBitMask ; if d is not zero, then number of pixels to set exceeds amount remaining in byte

    inc a
    sub e ; subtract number of pixels to modify (a is already starting bit)
    jr z, .applyBitMaskAndExit ; if number of pixels matches amount remaining, apply mask then exit
    jr c, .applyBitMask ; if carry, then number of pixels to modify > amount remaining in byte (b = mask value)
 
    dec a
    ld hl, SetBitsLookupTable
    ld d, 0
    ld e, a
    add hl, de
    ld a, [hl]

    xor b ; a = merged bit mask

    ld b, a ; b = merged bit mask
    ApplyPixelMask \1, \2, hld
    ret

.applyBitMaskAndExit
    ld a, b
    ApplyPixelMask \1, \2, hli
    ret

.applyBitMask
    ld a, b
    ApplyPixelMask \1, \2, hli

    inc d ; inc d so dec-ing will trigger zero flag

    ld a, [hImageDestinationBit]
    inc a
    ld b, a ; b = number of pixels that were just modified

    ld a, e
    sub b ; a = remaining number of pixels to modify

    ; if carry, dec d
    jr nc, .loop

    ; no need to check if 0 because thats handled before this portion of code
    dec d

.loop
    sub 8
    jr nc, .fillByte ; if num pixels remaining >= 8, then fill in the pixels

    ; otherwise, check d
    dec d
    jr z, .finish ; if d is zero, then finish

.fillByte
    ld [hl], \1
    inc hl
    ld [hl], \2
    inc hl
    jr nz, .loop ; loop if not exactly 8 remaining
    
    ; if exactly 8, then exit if d = 0
    dec d
    ret z ; return if no more pixels remain

    sub 8
    jr .fillByte

.finish
    push hl
    
    ld hl, SetBitsLookupTable
    ld b, $FF
    ld c, a
    add hl, bc
    ld b, [hl]
    ld a, b
    ApplyPixelMask \1, \2, hld
    ret
ENDM

; a and b should equal the mask
ApplyPixelMask: MACRO
    pop hl
    IF \1 == 0
        cpl
        and [hl]
    ELSE
        or [hl]
    ENDC
    ld [hli], a

    ld a, b
    IF \2 == 0
        cpl
        and [hl]
    ELSE
        or [hl]
    ENDC
    ld [\3], a
ENDM

PlacePixels:
    push hl ; store the destination address
    ld a, [hColor0]
    add a
    ld b, 0
    ld c, a
    ld hl, PCEPixelTable
    add hl, bc
    ld a, [hli]
    ld h, [hl]
    ld l, a ; hl = start address for place pixel function
    jp hl

; de = pixel count
; hl = dest address
FillAlphaPixels:
    pop hl
    ld a, [hImageDestinationBit]

    inc d
    dec d
    jr nz, .continue ; if d > 0, then no need to compare to e

    cp e
    ret nc ; don't adjust the byte if e is less than number of bits remaining

.continue
    inc a
    ld b, a
    ld a, e
    sub b ; a = remaining number of pixels to modify
    ; if carry, dec d
    jr nc, .dontDecD
    dec d

.dontDecD
    srl d
    rra ; divide de by 2
    srl d
    rra ; divide de by 2 again (4)
    srl d
    rra ; divide de by 2 again (8)

    inc a ; move at least 1 byte (due to finishing out initial byte)
    ld e, a

    add hl, de
    add hl, de ; add twice to hl
    ret


FillWhitePixels:
    FillPixelsMacro 0, 0
    
FillLightPixels:
    FillPixelsMacro -1, 0

FillDarkPixels:
    FillPixelsMacro 0, -1
    
FillBlackPixels:
    FillPixelsMacro -1, -1

ResetBitsLookupTable:
    db %00000000
    db %10000000
    db %11000000
    db %11100000
    db %11110000
    db %11111000
    db %11111100
    db %11111110

SetBitsLookupTable:
    db %00000001
    db %00000011
    db %00000111
    db %00001111
    db %00011111
    db %00111111
    db %01111111
    db %11111111

PCEPixel: MACRO
    Prop Fill, Pointer, Fill\1Pixels
ENDM

    Table PCEPixel
    Entry White
    Entry Light
    Entry Dark
    Entry Black
    Entry Alpha
