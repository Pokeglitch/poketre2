PlayIntro:
	xor a
	ld [hJoyHeld], a
	ld [hWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call DrawVersionScreen	
	call DrawCreatedByScreen
	call PlayIntroBattle
	call GBPalBlackOut
	call DelayFrame
	
	xor a
	ld [hSCX], a ; reset the window location
	
	call ClearSprites
	call DelayFrame
	
	ret

; c = which sprite to draw
DrawEkansTiles:
	ld b, 0
	ld hl, EkansSpriteDims
	ld a, 5
	call AddNTimes
	push hl ; hl = row for this sprite
	call IntroClearMiddleOfScreen
	pop hl
	ld a, [hli]
	push af
	ld b, [hl]
	inc hl
	ld c, [hl] ; bc = sprite dims
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = location to draw
	pop af ; a = first sprite offset
	jp DrawSprite
	
EkansSpriteDims:
; starting tile id, height, width, location on screen
	db 0, 5, 6
	dwCoord 11, 9
	db (FightIntroEkans2 - FightIntroEkans) / BYTES_PER_TILE, 7, 7
	dwCoord 11, 7
	db (FightIntroEkans3 - FightIntroEkans) / BYTES_PER_TILE, 5, 9
	dwCoord 11, 9
	
PlayIntroBattle:
	xor a
	ld [wCurOpponent], a
	call DrawIntroBattleBackground
	call LoadIntroBattleGraphics
	
	ld hl, rLCDC
	res LCD_WINDOW_ENABLE_F, [hl] ; turn off the window
	
	ld c, 16
	call DelayFrames
	
	ld a, BANK(Music_IntroBattle)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, MUSIC_INTRO_BATTLE
	ld [wNewSoundID], a
	call PlaySound
	
	call ClearSprites
	call Delay3

	call GBPalStandard
	
	ld a, -16
	ld [hSCX], a
	ld c, 0
	call DrawEkansTiles
	ld a, 0
	ld [wBaseCoordX], a
	ld a, 72
	ld [wBaseCoordY], a
	lb bc, 7, 6
	call InitIntroMeowthOAM
	lb de, 80 / 2, MOVE_MEOWTH_RIGHT
	call IntroMoveMon
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	xor a
	ld [wIntroMeowthBaseTile], a
	ld de, IntroMeowthAnimation1
	call AnimateIntroMeowth
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroMeowthAnimation2
	call AnimateIntroMeowth
	ld c, 10
	call CheckForUserInterruption
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	ld de, IntroMeowthAnimation1
	call AnimateIntroMeowth
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroMeowthAnimation2
	call AnimateIntroMeowth
	ld c, 30
	call CheckForUserInterruption
	ret c

; raise
	ld c, 1
	call DrawEkansTiles
	ld a, SFX_INTRO_RAISE
	call PlaySound
	lb de, 8 / 2, MOVE_EKANS_LEFT
	call IntroMoveMon
	ld c, 30
	call CheckForUserInterruption
	ret c

; slash
	ld c, 2
	call DrawEkansTiles
	ld a, SFX_INTRO_CRASH
	call PlaySound
	lb de, 16 / 2, MOVE_EKANS_RIGHT
	call IntroMoveMon
; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	ld a, (FightIntroMeowth2 - FightIntroMeowth) / BYTES_PER_TILE
	ld [wIntroMeowthBaseTile], a
	ld de, IntroMeowthAnimation3
	call AnimateIntroMeowth
	ld c, 30
	call CheckForUserInterruption
	ret c

	lb de, 8 / 2, MOVE_EKANS_LEFT
	call IntroMoveMon
	ld c, 0
	call DrawEkansTiles
	ld c, 60
	call CheckForUserInterruption
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	xor a
	ld [wIntroMeowthBaseTile], a
	ld de, IntroMeowthAnimation4
	call AnimateIntroMeowth
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroMeowthAnimation5
	call AnimateIntroMeowth
	ld c, 20
	call CheckForUserInterruption
	ret c

	ld a, (FightIntroMeowth2 - FightIntroMeowth) / BYTES_PER_TILE
	ld [wIntroMeowthBaseTile], a
	ld de, IntroMeowthAnimation6
	call AnimateIntroMeowth
	ld c, 30
	call CheckForUserInterruption
	ret c

; lunge
	ld a, SFX_INTRO_LUNGE
	call PlaySound
	ld a, (FightIntroMeowth3 - FightIntroMeowth) / BYTES_PER_TILE
	ld [wIntroMeowthBaseTile], a
	ld de, IntroMeowthAnimation7
	; fall through

AnimateIntroMeowth:
	ld a, [de]
	cp ANIMATION_END
	ret z
	ld [wBaseCoordY], a
	inc de
	ld a, [de]
	ld [wBaseCoordX], a
	push de
	ld c, 6 * 7
	call UpdateIntroMeowthOAM
	ld c, 5
	call DelayFrames
	pop de
	inc de
	jr AnimateIntroMeowth

UpdateIntroMeowthOAM:
	; The sprite is 2 tiles too large for OAM,
	; so skip the first 2 because they are
	; blank in each sprite anyway
	ld hl, wOAMBuffer - 2 * 4
	ld a, [wIntroMeowthBaseTile]
	ld d, a
.loop
	ld a, [wBaseCoordY]
	add [hl]
	ld [hli], a ; Y
	ld a, [wBaseCoordX]
	add [hl]
	ld [hli], a ; X
	ld a, d
	ld [hli], a ; tile
	inc hl
	inc d
	dec c
	jr nz, .loop
	ret

InitIntroMeowthOAM:
	; The sprite is 2 tiles too large for OAM,
	; so skip the first 2 because they are
	; blank in each sprite anyway
	ld hl, wOAMBuffer - 2 * 4
	ld d, 0
.loop
	push bc
	ld a, [wBaseCoordY]
	ld e, a
.innerLoop
	ld a, e
	add 8
	ld e, a
	ld [hli], a ; Y
	ld a, [wBaseCoordX]
	ld [hli], a ; X
	ld a, d
	ld [hli], a ; tile
	ld a, OAM_BEHIND_BG
	ld [hli], a ; attributes
	inc d
	dec c
	jr nz, .innerLoop
	ld a, [wBaseCoordX]
	add 8
	ld [wBaseCoordX], a
	pop bc
	dec b
	jr nz, .loop
	ret

IntroClearScreen:
	ld hl, vBGMap0
	ld bc, BG_MAP_WIDTH * SCREEN_HEIGHT
	jr IntroClearCommon

IntroClearMiddleOfScreen:
; clear the area of the tile map between the black bars on the top and bottom
	coord hl, 0, 4
	ld bc, SCREEN_WIDTH * 10

IntroClearCommon:
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, IntroClearCommon
	ret

IntroPlaceBlackTiles:
	ld a, $1B ; Ekans conveniently has an all black tile
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

IntroMoveMon:
; d = number of times to move the mon (2 pixels each time)
; e: 0 = move Ekans right, 1 = move Ekans left, -1 = move Meowth right
	ld a, e
	cp MOVE_MEOWTH_RIGHT
	jr z, .moveMeowthRight
	cp MOVE_EKANS_LEFT
	jr z, .moveEkansLeft
; move Ekans right
	ld a, [hSCX]
	dec a
	dec a
	jr .next
.moveMeowthRight
	push de
	ld a, 2
	ld [wBaseCoordX], a
	xor a
	ld [wBaseCoordY], a
	ld c, 6 * 7
	call UpdateIntroMeowthOAM
	pop de
.moveEkansLeft
	ld a, [hSCX]
	inc a
	inc a
.next
	ld [hSCX], a
	push de
	ld c, 2
	call CheckForUserInterruption
	pop de
	ret c
	dec d
	jr nz, IntroMoveMon
	ret

CopyTileIDsFromList_ZeroBaseTileID:
	ld c, 0
	predef_jump CopyTileIDsFromList

LoadIntroBattleGraphics:
	ld de, FightIntroEkans
	ld hl, vChars2
	lb bc, BANK(FightIntroEkans), (FightIntroEkansEnd - FightIntroEkans) / BYTES_PER_TILE
	call CopyVideoData
	
	ld de, FightIntroMeowth
	ld hl, vChars0
	lb bc, BANK(FightIntroMeowth), (FightIntroMeowthEnd - FightIntroMeowth) / BYTES_PER_TILE
	jp CopyVideoData

DrawIntroBattleBackground:
; clear the screen and draw black bars on the top and bottom
	call ClearScreen
	call IntroClearScreen	
	coord hl, 0, 0
	ld c, SCREEN_WIDTH * 4
	call IntroPlaceBlackTiles
	coord hl, 0, 14
	ld c, SCREEN_WIDTH * 4
	call IntroPlaceBlackTiles
	
	; Draw the black bars to the full width of the bg map
	ld hl, vBGMap0 + 12
	call SetBGTransferDestination
	
	; return the tilemap transfer destination back to the normal position
	ld hl, vBGMap0
	jp SetBGTransferDestination

DrawVersionScreen:
	ld de, VersionGFX
	ld hl, vChars2
	lb bc, BANK(VersionGFX), (VersionGFXEnd-VersionGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	; Fill the screen with black tiles
	lb bc, SCREEN_HEIGHT, SCREEN_WIDTH
	coord hl, 0, 0
	call IntroBlackoutScreen
	
	xor a
	lb bc, 6, 18
	coord hl, 1, 5
	
	push bc
	push hl
	
	call DrawSprite
	call DisplayIntroScreen
	
	; Fill the text area with black tiles
	pop hl
	pop bc
	; fall through
	
IntroBlackoutScreen:
	ld a, 72 ; black tile in the version gfx and created by gfx
	jp FillScreenArea
	
DrawCreatedByScreen:
	ld de, CreatedByGFX
	ld hl, vChars2
	lb bc, BANK(CreatedByGFX), (CreatedByGFXEnd-CreatedByGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	xor a
	lb bc, 8, 10
	coord hl, 5, 4
	call DrawSprite
	
	ld a, 80
	lb bc, 2, 16
	coord hl, 2, 16
	call DrawSprite
	; fall through
	
DisplayIntroScreen:
	ld c, 5
	call DelayFrames
	call GBPalStandard
	ld c, 160
	call DelayFrames
	jp GBPalBlackOut
	
IntroMeowthAnimation0:
	db 0, 0
	db ANIMATION_END

IntroMeowthAnimation1:
; This is a sequence of pixel movements for part of the Meowth animation. This
; list describes how Meowth should hop.
; First byte is y movement, second byte is x movement
	db  0, 0
	db -2, 2
	db -1, 2
	db  1, 2
	db  2, 2
	db ANIMATION_END

IntroMeowthAnimation2:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db  0,  0
	db -2, -2
	db -1, -2
	db  1, -2
	db  2, -2
	db ANIMATION_END

IntroMeowthAnimation3:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db   0, 0
	db -12, 6
	db  -8, 6
	db   8, 6
	db  12, 6
	db ANIMATION_END

IntroMeowthAnimation4:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db  0,  0
	db -8, -4
	db -4, -4
	db  4, -4
	db  8, -4
	db ANIMATION_END

IntroMeowthAnimation5:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db  0, 0
	db -8, 4
	db -4, 4
	db  4, 4
	db  8, 4
	db ANIMATION_END

IntroMeowthAnimation6:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db 0, 0
	db 2, 0
	db 2, 0
	db 0, 0
	db ANIMATION_END

IntroMeowthAnimation7:
; This is a sequence of pixel movements for part of the Meowth animation.
; First byte is y movement, second byte is x movement
	db -8, -16
	db -7, -14
	db -6, -12
	db -4, -10
	db ANIMATION_END

FightIntroEkans:
	INCBIN "gfx/intro_ekans_1.2bpp"
FightIntroEkans2:
	INCBIN "gfx/intro_ekans_2.2bpp"
FightIntroEkans3:
	INCBIN "gfx/intro_ekans_3.2bpp"
FightIntroEkansEnd:

FightIntroMeowth:
	INCBIN "gfx/intro_meowth_1.2bpp"
FightIntroMeowth2:
	INCBIN "gfx/intro_meowth_2.2bpp"
FightIntroMeowth3:
	INCBIN "gfx/intro_meowth_3.2bpp"
FightIntroMeowthEnd:

VersionGFX:
	INCBIN "gfx/version.2bpp"
VersionGFXEnd:

CreatedByGFX:
	INCBIN "gfx/created_by.2bpp"
	INCBIN "gfx/url.2bpp"
CreatedByGFXEnd: