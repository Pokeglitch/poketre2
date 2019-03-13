;TODO - Use this for main manu
LoadWhiteOnBlackFontTilePatterns_::
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?

	ld hl, WhiteOnBlackFontLettersGFX
	ld de, WhiteOnBlackFontSymbolsGFX
    ld bc, BlackTileGFX
	ld a, BANK(WhiteOnBlackFontLettersGFX)
	jr z, LoadFontTilePatternsLCDOff
	jr LoadFontTliePatternsLCDOn

LoadFontTilePatternsLCDOff:
	push de
    push hl
	push af
    ld h, b
    ld l, c
    ld de, vChars2 + $7F0
    ld bc, BYTES_PER_TILE
    call FarCopyData

    pop af
    pop hl
    push af
	ld de, vChars1
	ld bc, WhiteOnBlackFontLettersGFXEnd - WhiteOnBlackFontLettersGFX
	call FarCopyData

	pop af
	pop hl
	ld de, vChars0 + FONT_SYMBOLS_TILE_START * BYTES_PER_TILE
	ld bc, WhiteOnBlackFontSymbolsGFXEnd - WhiteOnBlackFontSymbolsGFX
	jp FarCopyData

LoadFontTilePatterns_::
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?

	ld hl, BlackOnWhiteFontLettersGFX
	ld de, BlackOnWhiteFontSymbolsGFX
    ld bc, WhiteTileGFX
	ld a, BANK(BlackOnWhiteFontLettersGFX)
	jr z, LoadFontTilePatternsLCDOff

; fall through
LoadFontTliePatternsLCDOn:
	push de
    push hl
	push af
    ld d, b
    ld e, c
    ld b, a
    ld hl, vChars2 + $7F0
    ld c, 1
    call CopyVideoData
	
    pop bc
    pop de
    push bc
	ld hl, vChars1
	ld c, (BlackOnWhiteFontLettersGFXEnd - BlackOnWhiteFontLettersGFX) / BYTES_PER_TILE
	call CopyVideoData

	pop bc
	pop de

	ld hl, vChars0 + FONT_SYMBOLS_TILE_START * BYTES_PER_TILE
	ld c, (BlackOnWhiteFontSymbolsGFXEnd - BlackOnWhiteFontSymbolsGFX) / BYTES_PER_TILE
	jp CopyVideoData ; if LCD is on, transfer during V-blank
