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
	jr LoadFontTilePatternsCommon
    
LoadWhiteOnBlackFontTilePatterns_::
	ld hl, WhiteOnBlackFontLettersGFX
	ld de, WhiteOnBlackFontSymbolsGFX
    ld bc, BlackTileGFX
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
    jr z, .dontLoadBorder ; skip loading border if not requested

    push hl
    ld h, b
    ld l, c
    ld de, vChars2 + $770
    ; TODO - use white on black for consistency
    ld bc, LightTextboxBorderGFXEnd - LightTextboxBorderGFX
    ld a, BANK(WhiteOnBlackFontLettersGFX)
    call FarCopyData
    pop hl
    
.dontLoadBorder
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
    jr z, .dontLoadBorder2
    ld d, b
    ld e, c
    ld hl, vChars2 + $770
    lb bc, BANK(WhiteOnBlackFontLettersGFX), (LightTextboxBorderGFXEnd - LightTextboxBorderGFX) / BYTES_PER_TILE
    call CopyVideoData
	
.dontLoadBorder2
    pop de
	ld hl, vChars1
	lb bc, BANK(WhiteOnBlackFontLettersGFX), (BlackOnWhiteFontLettersGFXEnd - BlackOnWhiteFontLettersGFX) / BYTES_PER_TILE
	call CopyVideoData

	pop de
	ld hl, vChars0 + FONT_SYMBOLS_TILE_START * BYTES_PER_TILE
	lb bc, BANK(WhiteOnBlackFontLettersGFX), (BlackOnWhiteFontSymbolsGFXEnd - BlackOnWhiteFontSymbolsGFX) / BYTES_PER_TILE
	jp CopyVideoData ; if LCD is on, transfer during V-blank
