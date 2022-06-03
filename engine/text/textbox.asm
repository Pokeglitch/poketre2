; function that performs initialization for DisplayTextID
DisplayTextIDInit:
	xor a
	ld [wListMenuID], a

	ld hl, wFontLoaded
	set 0, [hl]
	ld hl, wFlags_0xcd60
	bit 4, [hl]
	res 4, [hl]
	jr nz, .skipMovingSprites
	call UpdateSprites
.skipMovingSprites
; loop to copy C1X9 (direction the sprite is facing) to C2X9 for each sprite
; this is done because when you talk to an NPC, they turn to look your way
; the original direction they were facing must be restored after the dialogue is over
	ld hl, wSpriteStateData1 + $19
	ld c, $0f
	ld de, $0010
.spriteFacingDirectionCopyLoop
	ld a, [hl]
	inc h
	ld [hl], a
	dec h
	add hl, de
	dec c
	jr nz, .spriteFacingDirectionCopyLoop
; loop to force all the sprites in the middle of animation to stand still
; (so that they don't like they're frozen mid-step during the dialogue)
	ld hl, wSpriteStateData1 + 2
	ld de, $0010
	ld c, e
.spriteStandStillLoop
	ld a, [hl]
	cp $ff ; is the sprite visible?
	jr z, .nextSprite
; if it is visible
	and $fc
	ld [hl], a
.nextSprite
	add hl, de
	dec c
	jr nz, .spriteStandStillLoop

	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a ; enable continuous WRAM to VRAM transfer each V-blank
	ret

ResetTextbox:
	call GetTextBoxStartCoordsHL
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	add a
	inc a ; a = number of text lines in textbox
	ld b, a
	ld c, SCREEN_WIDTH-2
	call ClearScreenArea
	call Delay3
	jp ResetRowsAndColumnTilesRemaining

InitializeTextbox_:
	ld a, [wTextboxSettings]
	push af

	ld hl, wLetterPrintingDelayFlags
	res 1, [hl] ; disable delays

	bit BIT_DONT_REVEAL, a
	jr nz, .dontEnableDelay

	bit BIT_NO_DELAY, a
	jr nz, .dontEnableDelay

	set 1, [hl] ; enable delays

.dontEnableDelay
	and FONT_COLOR_MASK
	jr z, .blackOnWhite
	srl a
	srl a
	dec a
	jr z, .blackOnLight
	dec a
	jr z, .whiteOnBlack
	; otherwite, glyphs
	
	call LoadGlyphFontTilePatterns
	jr .drawTextbox

.blackOnWhite
	inc a ; load the border tiles
	call LoadBlackOnWhiteFontTilePatterns
	jr .drawTextbox

.blackOnLight
	inc a ; load the border tiles
	call LoadBlackOnLightFontTilePatterns
	jr .drawTextbox

.whiteOnBlack
	inc a ; load the border tiles
	call LoadWhiteOnBlackFontTilePatterns

.drawTextbox
	pop af
	push af

	and TEXT_LINES_MASK
	inc a
	add a
	
	coord hl, 0, 0
	; set bc to be in the middle of the clear screen input and the draw textbox input
	ld b, a
	ld c, SCREEN_WIDTH-1

	pop af
	push af
	push bc ; store the text lines value
	bit BIT_DRAW_BORDER, a
	jr z, .noBorder

	dec b
	dec c
	call NewTextBoxBorder
	jr .scroll

.noBorder
	inc b
	inc c
	call ClearScreenArea

.scroll
	pop bc
	pop af
	bit BIT_DONT_REVEAL, a
	ret nz
	; fall through
	
ScrollTextboxCommon:
	; Initialize textbox position
	call InitializeWindowReveal

	ld a, b
	inc a ; true number of tiles of the textbox
	sla a
	sla a
	sla a ; a * 8, 8 pixels per tile
	sub 4 ; last 4 tiles go offscreen
	jp ScrollTextboxUp

RevealTextbox:
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	add a ;double
	add 2 ; additional tiles
	ld b, a
	jr ScrollTextboxCommon
