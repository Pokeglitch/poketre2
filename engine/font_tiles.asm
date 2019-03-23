TextBoxBorder_::
; Draw a c×b text box at hl.
	; top row
	push hl
	ld a, "┌"
	ld [hli], a
	inc a ; ─
	call NPlaceChar
	inc a ; ┐
	ld [hl], a
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
.next
	push hl
	ld a, "│"
	ld [hli], a
	ld a, " "
	call NPlaceChar
	ld [hl], "│"
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	ld a, "└"
	ld [hli], a
	ld a, "─"
	call NPlaceChar
	ld [hl], "┘"
	ret

; TODO - constants
NewTextBoxBorder_:
; Draw a c×b text box at hl.
	; top row
	push hl
	ld a, $77
	ld [hli], a
	inc a
	call NPlaceChar
	inc a
	ld [hl], a
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
.next
	push hl
	ld a, $7A
	ld [hli], a
	ld a, " "
	call NPlaceChar
	ld [hl], $7B
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	ld a, $7C
	ld [hli], a
	inc a
	call NPlaceChar
    inc a
	ld [hl], a
	ret

; Scroll the textbox
ScrollTextbox::
    ld hl, wTextboxScrollDelta
    ld a, [hWY]
    add [hl]
    ld [hWY], a
    dec hl
    dec [hl]
    ret

LoadGlyphFontTilePatterns_::
	ld hl, GlyphFontLettersGFX
	ld de, GlyphFontSymbolsGFX
    ld bc, GlyphTextboxBorderGFX
	jr LoadFontTilePatternsCommon

LoadBlackOnWhiteFontTilePatterns_::
	ld hl, BlackOnWhiteFontLettersGFX
	ld de, BlackOnWhiteFontSymbolsGFX
    ld bc, WhiteTextboxBorderGFX
	jr LoadFontTilePatternsCommon
    
LoadWhiteOnBlackFontTilePatterns_::
	ld hl, WhiteOnBlackFontLettersGFX
	ld de, WhiteOnBlackFontSymbolsGFX
    ld bc, BlackTextboxBorderGFX
	jr LoadFontTilePatternsCommon


LoadBlackOnLightFontTilePatterns_::
	ld hl, BlackOnLightFontLettersGFX
	ld de, BlackOnLightFontSymbolsGFX
    ld bc, LightTextboxBorderGFX
    ; fall through

LoadFontTilePatternsCommon:
    push af
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
    jr nz, .lcdOn

    pop af
	push de
    push hl
    ld h, b
    ld l, c
    ld de, vChars2 + $770
    ld bc, BlackTextboxBorderGFXEnd - BlackTextboxBorderGFX
    ld a, BANK(WhiteOnBlackFontLettersGFX)
	jr nz, .loadFullBorder

	;only load the space tile
	ld de, vChars2 + $7F0
    ld bc, $10

.loadFullBorder
    call FarCopyData
    pop hl
	ld de, vChars1
	ld bc, WhiteOnBlackFontLettersGFXEnd - WhiteOnBlackFontLettersGFX
	ld a, BANK(WhiteOnBlackFontLettersGFX)
    call FarCopyData

	pop hl
	ld de, vChars0 + FONT_SYMBOLS_TILE_START * BYTES_PER_TILE
	ld bc, WhiteOnBlackFontSymbolsGFXEnd - WhiteOnBlackFontSymbolsGFX
	ld a, BANK(WhiteOnBlackFontLettersGFX)
    jp FarCopyData


.lcdOn
    pop af
	push de
    push hl
    ld d, b
    ld e, c
    ld hl, vChars2 + $770
    lb bc, BANK(WhiteOnBlackFontLettersGFX), (BlackTextboxBorderGFXEnd - BlackTextboxBorderGFX) / BYTES_PER_TILE
    jr nz, .loadFullBorder2

	;only load space
	ld hl, vChars2 + $7F0
	ld c, 1

.loadFullBorder2
	call CopyVideoData

    pop de
	ld hl, vChars1
	lb bc, BANK(WhiteOnBlackFontLettersGFX), (WhiteOnBlackFontLettersGFXEnd - WhiteOnBlackFontLettersGFX) / BYTES_PER_TILE
	call CopyVideoData

	pop de
	ld hl, vChars0 + FONT_SYMBOLS_TILE_START * BYTES_PER_TILE
	lb bc, BANK(WhiteOnBlackFontLettersGFX), (WhiteOnBlackFontSymbolsGFXEnd - WhiteOnBlackFontSymbolsGFX) / BYTES_PER_TILE
	jp CopyVideoData ; if LCD is on, transfer during V-blank
