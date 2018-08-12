DisplayTitleScreen:
	; Load the permanent data
	callab LoadPermanentData
	
	; Load the saved data
	call CheckForPlayerNameInSRAM
	jr c, .load_save
	
	ld a, NO_SAVE_EXISTS
	ld [wSaveFileStatus], a
	jr .next
	
.load_save
	predef LoadSAV
	
.next
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
	set LCD_TILE_DATA_F, [hl] ; use vChars0 for tiles
	
	; load the gfx
	ld hl, vChars0
	ld de, TitleScreenSharedGFX
	lb bc, BANK(TitleScreenSharedGFX), (TitleScreenMenuBoxBottomGFXEnd - TitleScreenSharedGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	ld hl, vChars0 + TITLE_SCREEN_SOLID_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenSolidGFX
	lb bc, BANK(TitleScreenSolidGFX), (TitleScreenExpendableGFXEnd - TitleScreenSolidGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	ld hl, vChars0 + MENU_BOX_TOP_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenMenuBoxTopSmallGFX
	lb bc, BANK(TitleScreenMenuBoxTopSmallGFX), (TitleScreenPressStartGFXEnd - TitleScreenMenuBoxTopSmallGFX) / BYTES_PER_TILE
	call CopyVideoData

	; draw the background gfx
	ld bc, TitleScreenBackgroundTilesEnd - TitleScreenBackgroundTiles
	ld hl, TitleScreenBackgroundTiles
	ld de, wTileMap
	call CopyData
	
	; make sure the background has been copied before updating the Palettes
	call Delay3
	
	ld a, MUSIC_TITLE_SCREEN
	ld [wNewSoundID], a
	call PlaySound		;play music
	
	call GBPalNormal
	
	ld c, 32
	call DelayFrames
	
	; load the pokemon text
	ld hl, vChars0 + POKEMON_TEXT_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenPokemonTextGFX
	lb bc, BANK(TitleScreenPokemonTextGFX), (TitleScreenPokemonTextGFXEnd - TitleScreenPokemonTextGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld c, 16
	call DelayFrames
	
	; load the tre text
	ld hl, vChars0 + TRE_TEXT_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenTRETextGFX
	lb bc, BANK(TitleScreenTRETextGFX), (TitleScreenTRETextGFXEnd - TitleScreenTRETextGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld c, 16
	call DelayFrames
	
	; load the team rocket edition text
	ld hl, vChars0 + TEAM_ROCKET_EDITION_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenTeamRocketEditionTextGFX
	lb bc, BANK(TitleScreenTeamRocketEditionTextGFX), (TitleScreenTeamRocketEditionTextGFXEnd - TitleScreenTeamRocketEditionTextGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld c, 32
	call DelayFrames

IntroWaitForKeypress:
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
	lb bc, (TitleScreenPressStartGFXEnd - TitleScreenPressStartGFX) / BYTES_PER_TILE, PRESS_START_TILE_START ; # of tiles, starting tile
	lb de, PRESS_START_Y, PRESS_START_X ; starting OAM coordinates

.loop
	ld a, d
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
	ld c, (TitleScreenPressStartGFXEnd - TitleScreenPressStartGFX) / BYTES_PER_TILE
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

INCLUDE "data/intro/titlescreen_tiles.asm"
