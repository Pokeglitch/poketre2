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

LoadFontTilePatterns_::
	ld hl, BlackOnWhiteFontLettersGFX
	ld de, BlackOnWhiteFontSymbolsGFX
    ld bc, WhiteTileGFX
	ld a, BANK(BlackOnWhiteFontLettersGFX)
	jr LoadFontTilePatternsCommon
    
LoadWhiteOnBlackFontTilePatterns_::
	ld hl, WhiteOnBlackFontLettersGFX
	ld de, WhiteOnBlackFontSymbolsGFX
    ld bc, BlackTileGFX
	ld a, BANK(WhiteOnBlackFontLettersGFX)
	jr LoadFontTilePatternsCommon


LoadBlackOnLightFontTilePatterns_::
	ld hl, BlackOnLightFontLettersGFX
	ld de, BlackOnLightFontSymbolsGFX
    ld bc, LightTextboxBorderGFX
	ld a, BANK(BlackOnLightFontLettersGFX)
    ; fall through

LoadFontTilePatternsCommon:
    push af
	ld a, [rLCDC]
	bit 7, a ; is the LCD enabled?
    jr nz, .lcdOn

    pop af
	push de
    push hl
	push af
    ld h, b
    ld l, c
    ld de, vChars2 + $770
    ; TODO - use white on black for consistency
    ld bc, LightTextboxBorderGFXEnd - LightTextboxBorderGFX
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


.lcdOn
    pop af
	push de
    push hl
	push af
    ld d, b
    ld e, c
    ld b, a
    ld hl, vChars2 + $770
    ld c, (LightTextboxBorderGFXEnd - LightTextboxBorderGFX) / BYTES_PER_TILE
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
