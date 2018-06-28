PRESS_START_Y EQU 112
PRESS_START_X EQU 52
	
DisplayTitleScreen:
	ld a, BANK(Music_TitleScreen)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	
	xor a
	ld [wLetterPrintingDelayFlags], a
	ld hl, wd732
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [hTilesetType], a
	ld [hSCX], a
	ld [hSCY], a
	
	ld hl, rLCDC
	set 4, [hl] ; use vChars0 for tiles
	
	; load the bg and press start gfx
	ld hl, vChars0
	ld de, TitleScreenBackgroundGFX
	lb bc, BANK(TitleScreenBackgroundGFX), (TitleScreenPressStartTextGFXEnd - TitleScreenBackgroundGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	; draw the gfx
	ld bc, TitleScreenBackgroundGFXEnd - TitleScreenBackgroundGFX
	ld hl, TitleScreenBackgroundTiles
	ld de, wTileMap
	call CopyData
	
	ld a, MUSIC_TITLE_SCREEN
	ld [wNewSoundID], a
	call PlaySound		;play music
	call GBPalNormal
	
	ld c, 32
	call DelayFrames
	
	ld hl, vChars0 + $50
	ld de, TitleScreenPokemonTRETextGFX
	lb bc, BANK(TitleScreenPokemonTRETextGFX), (TitleScreenPokemonTRETextGFXEnd - TitleScreenPokemonTRETextGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld c, 32
	call DelayFrames
	
	ld hl, vChars0 + $A60
	ld de, TitleScreenTeamRocketEditionTextGFX
	lb bc, BANK(TitleScreenTeamRocketEditionTextGFX), (TitleScreenTeamRocketEditionTextGFXEnd - TitleScreenTeamRocketEditionTextGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld c, 32
	call DelayFrames

	call InitPressStartText
	ld de, 0 ; initialize the oam flash counter

.loop
	call FlashPressStartText
	
	push de
	call JoypadLowSensitivity
	pop de
	ld a, [hJoy5]
	and a, START | A_BUTTON
	jr z, .loop
	
	call ClearSprites ; clear the Press Start text
	jp MainMenu

InitPressStartText:	
	ld hl, wOAMBuffer
	lb bc, (TitleScreenPressStartTextGFXEnd - TitleScreenPressStartTextGFX) / BYTES_PER_TILE, (TitleScreenBackgroundGFXEnd - TitleScreenBackgroundGFX) / BYTES_PER_TILE ; # of tiles, starting tile
	lb de, PRESS_START_Y, PRESS_START_X ; starting OAM coordinates

.loop
	ld a,d
	ld [hli], a
	ld a, e
	ld [hli], a
	add a, PIXELS_PER_TILE
	ld e, a
	ld a, c
	ld [hli], a
	inc c
	inc hl
	dec b
	jr nz, .loop

	ret
	
FlashPressStartText:
	inc de
	ld c, (TitleScreenPressStartTextGFXEnd - TitleScreenPressStartTextGFX) / BYTES_PER_TILE
	ld a, d
	bit 3, a
	ld a, PRESS_START_Y
	jr z, .skip
	ld a, 0 ; otherwise move offscreen

.skip
	ld hl, wOAMBuffer

.loop
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .loop
	ret

DrawPlayerCharacter:
	ld hl, PlayerCharacterTitleGraphics
	ld de, vSprites
	ld bc, PlayerCharacterTitleGraphicsEnd - PlayerCharacterTitleGraphics
	ld a, BANK(PlayerCharacterTitleGraphics)
	call FarCopyData2
	call ClearSprites
	xor a
	ld [wPlayerCharacterOAMTile], a
	ld hl, wOAMBuffer
	ld de, $605a
	ld b, 7
.loop
	push de
	ld c, 5
.innerLoop
	ld a, d
	ld [hli], a ; Y
	ld a, e
	ld [hli], a ; X
	add 8
	ld e, a
	ld a, [wPlayerCharacterOAMTile]
	ld [hli], a ; tile
	inc a
	ld [wPlayerCharacterOAMTile], a
	inc hl
	dec c
	jr nz, .innerLoop
	pop de
	ld a, 8
	add d
	ld d, a
	dec b
	jr nz, .loop
	ret

LoadCopyrightAndTextBoxTiles:
	xor a
	ld [hWY], a
	call ClearScreen
	call LoadTextBoxTilePatterns

LoadCopyrightTiles:
	ld de, NintendoCopyrightLogoGraphics
	ld hl, vChars2 + $600
	lb bc, BANK(NintendoCopyrightLogoGraphics), (GamefreakLogoGraphicsEnd - NintendoCopyrightLogoGraphics) / $10
	call CopyVideoData
	coord hl, 2, 7
	ld de, CopyrightTextString
	jp PlaceString

CopyrightTextString:
	db   $60,$61,$62,$61,$63,$61,$64,$7F,$65,$66,$67,$68,$69,$6A             ; ©'95.'96.'98 Nintendo
	next $60,$61,$62,$61,$63,$61,$64,$7F,$6B,$6C,$6D,$6E,$6F,$70,$71,$72     ; ©'95.'96.'98 Creatures inc.
	next $60,$61,$62,$61,$63,$61,$64,$7F,$73,$74,$75,$76,$77,$78,$79,$7A,$7B ; ©'95.'96.'98 GAME FREAK inc.
	db   "@"

NintenText: db "NINTEN@"
SonyText:   db "SONY@"

INCLUDE "data/intro/titlescreen_tiles.asm"