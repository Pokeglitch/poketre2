LoadPCEPalette:
    ld a, [wPCEPaletteID]
    cp PCEPalettePrevious
    ret z ; dont change if using previous palette

    ld hl, PCEPaletteTable
    ld b, 0
    ld c, a
    ld a, PCEPaletteSize

.paletteRowLoop
    and a
    jr z, .paletteRowFound
    add hl, bc
    dec a
    jr .paletteRowLoop

.paletteRowFound
    ; hl = palette row
    ld de, wPCEPalette
    ld b, PCEPaletteSize

.copyPaletteLoop
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .copyPaletteLoop
    ret

PCEPalette: MACRO
    DEF PCEPalette\1 = PCEPaletteCount
    FOR I, 2, PCEPaletteSize+2
        db PCEPixel\<I>
    ENDR
    DEF PCEPaletteCount += 1
ENDM

    Table PCEPalette, Byte, Byte, Byte, Byte, Byte
    PCEPalette StandardAlphaBG, White, Light, Dark, Black, Alpha
    PCEPalette StandardWhiteBG, White, Light, Dark, Black, White
    PCEPalette StandardLightBG, White, Light, Dark, Black, Light
    PCEPalette StandardDarkBG, White, Light, Dark, Black, Dark 
    PCEPalette StandardBlackBG, White, Light, Dark, Black, Black
    PCEPalette SilhouetteAlphaBG, Black, Black, Black, Black, Alpha 
    PCEPalette SilhouetteWhiteBG, Black, Black, Black, Black, White

    DEF PCEPalettePrevious = -1
