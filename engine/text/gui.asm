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

UpdateTextboxPosition:
    ld hl, wTextboxScrollDelta
    ld a, [hWY]
    add [hl]
    ld [hWY], a
	dec hl
    dec [hl]
	ret

UpdateTextboxPositionAndCheckSpritesToReveal:
	call UpdateTextboxPosition
	
	; check if sprites need to be restored
	ld a, [hWY]
	ld c, a

	;check each sprite
	ld a, [wSpritesHiddenByTextbox]
	ld b, a
	ld a, 16
	ld hl, PlayerYPixels
	ld de, wSpriteImageIndexBackup

.downwardsLoop
	push hl
	push af
	; skip if this sprite wasn't 
	bit 0, b
	jr z, .checkNextSpriteDownwards

	; check the y position
	; sprite data is from the top of the sprite, so add 16 to get bottom
	ld a, 16
	push hl
	ld hl, wTextboxScrollDelta
	sub [hl]
	sub [hl] ; it takes two frames for the sprite to appear, so calculate 2 frames ahead
	pop hl
	add [hl]
	dec hl
	cp c
	jr nc, .checkNextSpriteDownwards

	ld a, [de]
	dec hl
	ld [hl], a ; restore the value

	; clear the ram values
	xor a
	ld [de], a
	res 0, b

.checkNextSpriteDownwards
	rrc b
	inc de
	pop af
	call TryStoreHiddenSpriteFlags
	pop hl
	dec a
	ret z
	swap l
	inc hl
	swap l
	jr .downwardsLoop

UpdateTextboxPositionAndCheckSpritesToHide:
	call UpdateTextboxPosition

	; check if sprites need to be hidden
	ld a, [hWY]
	sub 15 ; the sprite data refers to the top of the sprite
	ld c, a

	; If this isnt the last iteration, then hide the sprite
	; when its touching the top of the window
	; if it is the last iteration, then don't do so
	ld a, [hl]
	and a
	jr z, .dontDecC
	dec c

.dontDecC
	ld a, [wSpritesHiddenByTextbox]
	ld b, a
	ld a, 16
	ld hl, PlayerSpriteImageIdx
	ld de, wSpriteImageIndexBackup

.upwardsLoop
	push hl
	push af
	ld a, [hli]

	; skip if sprite is already hidden
	cp $FF
	jr z, .checkNextSpriteUpwards
	inc hl ; hl = y position in pixels
	ld a, [hld]
	; skip if sprite is partially offscreen
	cp $F0
	jr nc, .checkNextSpriteUpwards
	; skip if sprite is not below window position
	cp c ; compare to the window position
	jr c, .checkNextSpriteUpwards
	; otherwise, hide
	dec hl
	ld a, [hl]
	ld [hl], $FF
	
	ld [de], a
	set 0, b

.checkNextSpriteUpwards
	rrc b
	inc de
	pop af
	call TryStoreHiddenSpriteFlags
	pop hl
	dec a
	ret z

	swap l
	inc l
	swap l ; move to next sprite
	jr .upwardsLoop

TryStoreHiddenSpriteFlags::
	ld hl, wSpritesHiddenByTextbox

	cp 9
	jr z, .storeByte

	cp 1
	ret nz

	; store last byte
	inc hl
	ld [hl], b
	ret

.storeByte
	ld [hl], b
	push af
	ld a, [wSpritesHiddenByTextbox+1]
	ld b, a
	pop af
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
	bit LCD_ENABLE_F, a ; is the LCD enabled?
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
	ld de, 8 * BYTES_PER_TILE ; skip the 8 border tiles
	add hl, de
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
	ld hl, 8 * BYTES_PER_TILE ; skip the 8 border tiles
	add hl, de
	ld d, h
	ld e, l
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
