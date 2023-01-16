LoadPCEPalette:
    ld a, [wPCEPaletteID]
    cp PCEPalettePrevious
    ret z ; dont change if using previous palette

    ld hl, PCEPaletteTable
    ld b, 0
    ld c, a
    ld a, PCEPaletteEntrySize

.paletteRowLoop
    and a
    jr z, .paletteRowFound
    add hl, bc
    dec a
    jr .paletteRowLoop

.paletteRowFound
    ; hl = palette row
    ld de, wPCEPalette
    ld b, PCEPaletteEntrySize

.copyPaletteLoop
    ld a, [hli]
    ld [de], a
    inc de
    dec b
    jr nz, .copyPaletteLoop
    ret

PCEPalette: MACRO
    Prop Color0, Byte, PCEPixel\2
    Prop Color1, Byte, PCEPixel\3
    Prop Color2, Byte, PCEPixel\4
    Prop Color3, Byte, PCEPixel\5
    Prop Color4, Byte, PCEPixel\6
ENDM

    Table PCEPalette
    Entry StandardAlphaBG, White, Light, Dark, Black, Alpha
    Entry StandardWhiteBG, White, Light, Dark, Black, White
    Entry StandardLightBG, White, Light, Dark, Black, Light
    Entry StandardDarkBG, White, Light, Dark, Black, Dark 
    Entry StandardBlackBG, White, Light, Dark, Black, Black
    Entry SilhouetteAlphaBG, Black, Black, Black, Black, Alpha 
    Entry SilhouetteWhiteBG, Black, Black, Black, Black, White

    DEF PCEPalettePrevious = -1
