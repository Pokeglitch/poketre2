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
    FOR I, 2, PCEPaletteSize+2
        db PCEPixel\<I>
    ENDR
ENDM

    Table PCEPalette, Color0, Byte, Color1, Byte, Color2, Byte, Color3, Byte, Color4, Byte
    Entry StandardAlphaBG, White, Light, Dark, Black, Alpha
    Entry StandardWhiteBG, White, Light, Dark, Black, White
    Entry StandardLightBG, White, Light, Dark, Black, Light
    Entry StandardDarkBG, White, Light, Dark, Black, Dark 
    Entry StandardBlackBG, White, Light, Dark, Black, Black
    Entry SilhouetteAlphaBG, Black, Black, Black, Black, Alpha 
    Entry SilhouetteWhiteBG, Black, Black, Black, Black, White

    DEF PCEPalettePrevious = -1
