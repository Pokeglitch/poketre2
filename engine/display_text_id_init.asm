; function that performs initialization for DisplayTextID
DisplayTextIDInit:
	xor a
	ld [wListMenuID], a
	ld a, [wAutoTextBoxDrawingControl]
	bit 0, a
	jr nz, .skipDrawingTextBoxBorder
	ld a, [hSpriteIndexOrTextID] ; text ID (or sprite ID)
	and a
	jr nz, .notStartMenu

; TODO - slide in all the way for start menu

.notStartMenu
	coord hl, 0, 0
	ld b, 3
	ld c, 18
;	call TextBoxBorder

.skipDrawingTextBoxBorder
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

	coord hl, 0, 0
	lb bc, 5, SCREEN_WIDTH
	call ClearScreenArea
	
	coord hl, 0, 0
	lb bc, 3, SCREEN_WIDTH-2
	call NewTextBoxBorder

	ld a, $01
	ld [H_AUTOBGTRANSFERENABLED], a ; enable continuous WRAM to VRAM transfer each V-blank
	
	call LoadBlackOnLightFontTilePatterns

	; Initialize textbox position
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a

	ld hl, wTextboxScrollCyclesRemaining
	ld [hl], 5 * PIXELS_PER_TILE - 4
	inc hl
	ld a, -1
	ld [hld], a

.scrollIn
	ld a, [hl]
	and a
	ret z ; return if done
	push hl
	farcall ScrollTextbox
	call UpdateSprites
	pop hl
	jr .scrollIn
