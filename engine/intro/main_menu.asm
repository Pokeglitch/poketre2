MainMenu:
	ld a, SFX_SLOTS_NEW_SPIN
	call PlaySound
	
	; Initialize some data
	xor a ; LINK_STATE_NONE
	ld [wLinkState], a
	ld [wDefaultMap], a
	ld hl, wd72e
	res 6, [hl] ; reset the flag indicating the link feature is being used
	
	; disable OAM
	ld hl, rLCDC
	res LCD_OBJ_DISPLAY_F, [hl]
	
	; set the oam palette
	; rOBP0 is already set properly
	ldPal a, BLACK, BLACK, DARK_GRAY, BLACK
	ld [rOBP1], a
	
	ld a, 1 ; no delay
	ld [wLetterPrintingDelayFlags], a
	
	; Check save file
	ld a, [wSaveFileStatus]
	dec a
	jr nz, .save_exists
	
	; Initialize the options
	ld a, 3 ; medium speed
	ld [wOptions], a
	
	coord hl, 2, 3
	lb bc, 6, 16
	
	jr .draw_screen

.save_exists
	; load the alternative "menu box top" tiles
	ld hl, vChars0 + MENU_BOX_TOP_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenMenuBoxTopLargeGFX
	lb bc, BANK(TitleScreenMenuBoxTopLargeGFX), (TitleScreenMenuBoxTopLargeGFXEnd - TitleScreenMenuBoxTopLargeGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	coord hl, 2, 2
	lb bc, 7, 16
	
.draw_screen
	push bc
	
	; draw the top box
	lb bc, 1, TRE_TEXT_TILE_START - MENU_BOX_TOP_TILE_START
	ld a, MENU_BOX_TOP_TILE_START
	call DrawSprite
	
	ld bc, SCREEN_WIDTH
	add hl, bc	; set hl to correct position
	
	pop bc
	call ClearScreenArea
	
	ld hl, TitleScreenMenuBoxBottomTiles
	coord de, 2, 10
	ld bc, TitleScreenMenuBoxBottomTilesEnd - TitleScreenMenuBoxBottomTiles
	call CopyData
	
	push hl
	
	ld c, 5
	call DelayFrames ; takes 3 frames to redraw the screen
	
	; text box
	
	ld hl, vChars0 + TEXT_BOX_TOP_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenTextBoxTopGFX
	lb bc, BANK(TitleScreenTextBoxTopGFX), (TitleScreenTextBoxBottomGFXEnd - TitleScreenTextBoxTopGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	ld hl, TitleScreenTextBoxTopTiles
	coord de, 2, 11
	ld bc, TitleScreenTextBoxTopTilesEnd - TitleScreenTextBoxTopTiles
	call CopyData
	
	call ClearMainMenuTextBox
	
	ld hl, TitleScreenTextBoxBottomTiles
	coord de, 9, 15
	ld bc, TitleScreenTextBoxBottomTilesEnd - TitleScreenTextBoxBottomTiles
	call CopyData
	
	ld c, 5
	call DelayFrames
	
	ld hl, vChars0 + TITLE_SCREEN_MENU_LETTERS_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenMenuLettersGFX
	lb bc, BANK(TitleScreenMenuLettersGFX), (TitleScreenMenuLettersGFXEnd - TitleScreenMenuLettersGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	call LoadWhiteOnBlackFontTilePatterns
	call InitMainMenuOAM
	
	; enable OAM
	ld hl, rLCDC
	set LCD_OBJ_DISPLAY_F, [hl]
	
.update_cursor_loop
	call UpdateMainMenuCursor

.keypress_loop
	push bc
	call JoypadLowSensitivity
	pop bc
	ld a, [hJoy5]
	and A_BUTTON | B_BUTTON | D_UP | D_DOWN | START
	jr z, .keypress_loop
	
	bit BIT_B_BUTTON, a
	jr nz, .b_pressed
	
	bit BIT_D_UP, a
	jr nz, .up_pressed
	
	bit BIT_D_DOWN, a
	jr nz, .down_pressed
	
	; otherwise, a/start
	push bc
	
	ld a, c
	and a
	jr z, .continue_selected
	
	dec a
	jr z, .adventure_selected
	
	dec a
	jr z, .challenge_selected
	
	ld a, SFX_PRESS_AB
	call PlaySound
	
	; otherwise, options selected
	push bc	
	
	call SaveScreenTilesToBuffer1 ; backup the current screen tiles
	
	ld hl, rLCDC
	res LCD_OBJ_DISPLAY_F, [hl] ; disable oam
	
	call DisplayOptionMenu
	
	; restore previous screen tiles
	call LoadScreenTilesFromBuffer1
	call Delay3
	
	ld hl, rLCDC
	set LCD_OBJ_DISPLAY_F, [hl] ; enable OAM
	
	pop bc
	jr .update_cursor_loop
	
.continue_selected
	ld a, [wSaveFileStatus]
	cp SAVE_CORRUPTED
	jp nz, ContinueGame
	
	ld a, SFX_DAMAGE
	call PlaySound
	jr .keypress_loop
	
.adventure_selected
	ld hl, wOptions
	res CHALLENGE_MODE_F, [hl]
	jp StartNewGame
	
.challenge_selected
	ld hl, wOptions
	set CHALLENGE_MODE_F, [hl]
	jp StartNewGame
	
.down_pressed
	call ClearMainMenuCursor
	inc c
	ld a, NUM_MAIN_MENU_OPTIONS
	cp c
	jr nz, .update_cursor_loop
	ld c, b ; top option
	jr .update_cursor_loop
	
.up_pressed
	call ClearMainMenuCursor
	ld a, c
	dec c
	cp b ; was it previously at the first option?
	jr nz, .update_cursor_loop ; if not, loop
	ld c, NUM_MAIN_MENU_OPTIONS - 1 ; otherwise, set to bottom option
	jr .update_cursor_loop
	
.b_pressed
	ld a, SFX_PRESS_AB
	call PlaySound
	
	call ClearMainMenuTextBox
	call ClearSprites
	
	call Delay3
	
	; load tiles to replace text tiles
	ld hl, vChars1
	ld de, TitleScreenExpendableGFX
	lb bc, BANK(TitleScreenExpendableGFX), (TitleScreenExpendableGFXEnd - TitleScreenExpendableGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	ld hl, vChars0 + $E00
	ld de, TitleScreenTRETextGFX
	lb bc, BANK(TitleScreenTRETextGFX), (TitleScreenTRETextGFXEnd - TitleScreenTRETextGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	ld hl, vChars0 + PRESS_START_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenPressStartGFX
	lb bc, BANK(TitleScreenPressStartGFX), (TitleScreenPressStartGFXEnd - TitleScreenPressStartGFX) / BYTES_PER_TILE
	call CopyVideoData
	
	; draw tiles to replace text box
	coord hl, 0, 11, TitleScreenBackgroundTiles
	coord de, 0, 11
	ld bc, 5 * SCREEN_WIDTH
	call CopyData
	
	call Delay3
	
	; load tiles to replace the option box (only part of the TitleScreenPokemonTextGFX)
	ld hl, vChars0 + TEXT_BOX_TOP_TILE_START * BYTES_PER_TILE
	ld de, TitleScreenPokemonTextGFX + (TEXT_BOX_TOP_TILE_START - POKEMON_TEXT_TILE_START) * BYTES_PER_TILE
	lb bc, BANK(TitleScreenPokemonTextGFX), TEAM_ROCKET_EDITION_TILE_START - TEXT_BOX_TOP_TILE_START
	call CopyVideoData
	
	; draw tiles to replace menu box
	coord hl, 0, 2, TitleScreenBackgroundTiles
	coord de, 0, 2
	ld bc, 9 * SCREEN_WIDTH
	call CopyData
	
	ld c, 16
	call DelayFrames
	
	; jump to press start loop
	jp IntroWaitForKeypress
	
InitMainMenuOAM:
	ld a, [wSaveFileStatus]
	dec a
	jr nz, .print_continue
	
	lb bc, 1, 1 ; initial option id
	push bc
	
	ld d, 53
	ld a, 16
	ld hl, wOAMBuffer + (ContinueTilesEnd - ContinueTiles) * 4
	push af
	
	jr .skip_continue
	
.print_continue	
	lb bc, 0, 0	; initial option id
	push bc
	
	ld d, 44
	ld a, 14	
	ld hl, wOAMBuffer
	push af
	
	ld e, 56
	ld bc, ContinueTiles
	ld a, ContinueTilesEnd - ContinueTiles
	call CopyStringToOAM

	pop af
	push af
	add d
	ld d, a ; next row
	
.skip_continue
	ld [wChosenMenuItem], a
	
	ld e, 52
	ld bc, AdventureTiles
	ld a, AdventureTilesEnd - AdventureTiles
	call CopyStringToOAM

	pop af
	push af
	add d
	ld d, a ; next row
	
	ld e, 52
	ld bc, ChallengeTiles
	ld a, ChallengeTilesEnd - ChallengeTiles
	call CopyStringToOAM

	pop af
	add d
	ld d, a ; next row
	
	ld e, 56
	ld bc, SettingTiles
	ld a, SettingTilesEnd - SettingTiles
	call CopyStringToOAM
	
	pop bc ; restore the initial option id data
	ret
	
CopyStringToOAM:
	push af
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	add a, PIXELS_PER_TILE
	ld e, a
	ld a, [bc]
	inc bc
	ld [hli], a
	ld a, OAM_OBP1
	ld [hli], a
	pop af
	dec a
	jr nz, CopyStringToOAM
	ret
	
MainMenuCursorCommon:
	ld hl, .MainMenuOAMLocationsTable
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a ; c = number of tiles
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = oam start location
	ld de, OAM_BYTE_SIZE ; size of oam sprite data
	ret
	
.MainMenuOAMLocationsTable
	dbw ContinueTilesEnd - ContinueTiles,   wOAMBuffer + OAM_FLAGS
	dbw AdventureTilesEnd - AdventureTiles, wOAMBuffer + OAM_FLAGS + (ContinueTilesEnd - ContinueTiles) * OAM_BYTE_SIZE
	dbw ChallengeTilesEnd - ChallengeTiles, wOAMBuffer + OAM_FLAGS + (AdventureTilesEnd - ContinueTiles) * OAM_BYTE_SIZE
	dbw SettingTilesEnd - SettingTiles,     wOAMBuffer + OAM_FLAGS + (ChallengeTilesEnd - ContinueTiles) * OAM_BYTE_SIZE
	
ClearMainMenuCursor:
	push bc
	call MainMenuCursorCommon
.loop
	set OAM_OBP_NUM, [hl] ; switch the palette
	add hl, de
	dec c
	jr nz, .loop
	call ClearMainMenuTextBox
	pop bc
	ret
	
ClearMainMenuTextBox:
	coord hl, 2, 12
	lb bc, 3, 16
	jp ClearScreenArea

UpdateMainMenuCursor:
	push bc
	call MainMenuCursorCommon
.loop
	res OAM_OBP_NUM, [hl] ; switch the palette
	add hl, de
	dec c
	jr nz, .loop
	
	; set the text
	pop bc
	push bc
	
	ld b, 0
	ld hl, .MainMenuTextJumpTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = script for current option
	ld bc, .return
	push bc
	jp hl
	
.return
	pop bc
	ret
	
.MainMenuTextJumpTable
	dw ContinueTextScript
	dw AdventureTextScript
	dw ChallengeTextScript
	dw SettingsTextScript
	
ContinueTextScript:
	ld a, [wSaveFileStatus]
	cp SAVE_CORRUPTED
	jr z, .corrupted
	
	coord hl, 3, 12
	ld de, wPlayerName
	call PlaceString
	
	coord hl, 3, 14
	ld de, .AwardsText
	call PlaceString

	coord hl, 12, 14
	ld de, wAwardPoints
	lb bc, wAwardPointsEnd - wAwardPoints, AWARD_POINTS_LENGTH
	jp PrintNumber
	
.corrupted
	coord hl, 3, 12
	ld de, .CorruptedText
	jp PlaceString

.CorruptedText
	db   "Saved data has"
	next "been corrupted@"
	
.AwardsText
	db "Awards:@"
	
AdventureTextScript:
	ld hl, wBestTime
	lb bc, wBestTimeEnd - wBestTime, 0
	call CountSetBits
	ld a, [wNumSetBits]
	and a
	jr nz, .best_time ; if the best time is not 0, then display it

	coord hl, 5, 12
	ld de, .AdventureText
	jp PlaceString
	
.AdventureText
	db   "Play a New"
	next " Campaign@"
	
.best_time
	coord hl, 3, 12
	ld de, .FastestByText
	call PlaceString
	
	coord hl, 7, 14
	ld de, wBestTimeName
	call RightAlignString
	
	; print the time
	coord hl, 11, 12
	ld de, wBestTimeHours
	lb bc, wBestTimeMinutes - wBestTimeHours, 3
	call PrintNumber
	ld [hl], ":"
	inc hl
	ld de, wBestTimeMinutes
	lb bc,  LEADING_ZEROES | (wBestTimeEnd - wBestTimeMinutes), 2
	jp PrintNumber

.FastestByText
	db "Fastest:"
	next "By:@"
	
ChallengeTextScript:
	ld hl, wHighScore
	lb bc, wHighScoreEnd - wHighScore, 0
	call CountSetBits
	ld a, [wNumSetBits]
	and a
	jr nz, .high_score ; if the high_score is not 0, then display it

	coord hl, 3, 12
	ld de, .ChallengeText
	jp PlaceString

.ChallengeText:
	db   "-Arcade Style-"
	next "Only One Life!@"
	
.high_score
	coord hl, 3, 12
	ld de, .BestByText
	call PlaceString
	
	coord hl, 7, 14
	ld de, wHighScoreName
	call RightAlignString
	
	; print the score
	coord hl, 11, 12
	ld de, wHighScore
	lb bc, wHighScoreEnd - wHighScore, HIGH_SCORE_LENGTH
	jp PrintNumber
	
.BestByText
	db "Best:"
	next "By:@"
	
SettingsTextScript:
	coord hl, 5, 12
	ld de, .SettingsText
	jp PlaceString

.SettingsText
	db "Tweak Game"
	next "Parameters@"

RightAlignString:
	ld bc, NAME_LENGTH
	push de
	
.loop
	dec bc
	ld a, [de]
	inc de
	cp "@"
	jr nz, .loop
	
	add hl, bc
	pop de
	jp PlaceString

; restore the ram to be as it was in pokemon red
RestoreProperRAMValues:
	ld hl, rLCDC
	res LCD_TILE_DATA_F, [hl] ; switch which tiles are used
	set LCD_WINDOW_ENABLE_F, [hl] ; enable the window
	
	ld hl, vBGMap1
	jp SetBGTransferDestination
	
ContinueGame:
	ld a, SFX_PRESS_AB
	call PlaySound
	
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call RestoreProperRAMValues
	
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerDirection], a
	ld c, 10
	call DelayFrames
	ld a, [wNumHoFTeams]
	and a
	jp z, SpecialEnterMap
	ld a, [wCurMap] ; map ID
	cp HALL_OF_FAME
	jp nz, SpecialEnterMap
	xor a
	ld [wDestinationMap], a
	ld hl, wd732
	set 2, [hl] ; fly warp or dungeon warp
	call SpecialWarpIn
	jp SpecialEnterMap

StartNewGame:
	ld a, SFX_PRESS_AB
	call PlaySound

	call GBPalWhiteOutWithDelay3
	call ClearSprites
	call ClearScreen
	call RestoreProperRAMValues
	
	ld c, 16
	call DelayFrames
	
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	
	call GBPalStandard
	
	ld hl, wd732
	res 1, [hl]
	call OakSpeech
	ld c, 20
	call DelayFrames

; enter map after using a special warp or loading the game from the main menu
SpecialEnterMap:
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [hJoy5], a
	ld [wd72d], a
	ld hl, wd732
	set 0, [hl] ; count play time
	call ResetPlayerSpriteData
	ld c, 20
	call DelayFrames
	ld a, [wEnteringCableClub]
	and a
	ret nz
	jp EnterMap

DisplayOptionMenu:	
	call ClearScreen
	call Delay3

	coord hl, 1, 1 ; SPEED_Y - 2
	ld de, TextSpeedOptionText
	call PlaceString
	coord hl, 1, 6 ; ANIMATION_Y - 2
	ld de, BattleAnimationOptionText
	call PlaceString
	coord hl, 1, 11 ; STYLE_Y - 2
	ld de, BattleStyleOptionText
	call PlaceString
	coord hl, 2, CANCEL_Y
	ld de, OptionMenuCancelText
	call PlaceString
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	inc a
	ld [wLetterPrintingDelayFlags], a
	ld [wUnusedCD40], a
	ld a, SPEED_Y ; text speed cursor Y coordinate
	ld [wTopMenuItemY], a
	call SetCursorPositionsFromOptions
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	ld [wTopMenuItemX], a
	
.loop
	call PlaceMenuCursor
	call SetOptionsFromCursorPositions
.getJoypadStateLoop
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	and A_BUTTON | B_BUTTON | START | D_RIGHT | D_LEFT | D_UP | D_DOWN ; any key besides select pressed?
	jr z, .getJoypadStateLoop
	bit BIT_B_BUTTON, b ; B button pressed?
	jr nz, .exit_options
	bit BIT_START, b ; Start button pressed?
	jr nz, .exit_options
	bit BIT_A_BUTTON, b ; A button pressed?
	jr z, .checkDirectionKeys
	ld a, [wTopMenuItemY]
	cp CANCEL_Y ; is the cursor on Cancel?
	jr nz, .loop
	
.exit_options
	ld a, SFX_PRESS_AB
	jp PlaySound
	
.eraseOldMenuCursor
	ld [wTopMenuItemX], a
	call EraseMenuCursor
	jp .loop
.checkDirectionKeys
	ld a, [wTopMenuItemY]
	bit BIT_D_DOWN, b ; Down pressed?
	jr nz, .downPressed
	bit BIT_D_UP, b ; Up pressed?
	jr nz, .upPressed
	cp ANIMATION_Y ; cursor in Battle Animation section?
	jr z, .cursorInBattleAnimation
	cp STYLE_Y ; cursor in Battle Style section?
	jr z, .cursorInBattleStyle
	cp CANCEL_Y ; cursor on Cancel?
	jr z, .loop
.cursorInTextSpeed
	bit BIT_D_LEFT, b ; Left pressed?
	jp nz, .pressedLeftInTextSpeed
	jp .pressedRightInTextSpeed
.downPressed
	cp CANCEL_Y
	ld b, SPEED_Y - CANCEL_Y
	ld hl, wOptionsTextSpeedCursorX
	jr z, .updateMenuVariables
	ld b, ANIMATION_Y - SPEED_Y
	cp SPEED_Y
	inc hl
	jr z, .updateMenuVariables
	cp ANIMATION_Y
	inc hl
	jr z, .updateMenuVariables
	ld b, CANCEL_Y - STYLE_Y
	inc hl
	jr .updateMenuVariables
.upPressed
	cp ANIMATION_Y
	ld b, SPEED_Y - ANIMATION_Y
	ld hl, wOptionsTextSpeedCursorX
	jr z, .updateMenuVariables
	cp STYLE_Y
	inc hl
	jr z, .updateMenuVariables
	cp CANCEL_Y
	ld b, STYLE_Y - CANCEL_Y
	inc hl
	jr z, .updateMenuVariables
	ld b, STYLE_Y
	inc hl
.updateMenuVariables
	add b
	ld [wTopMenuItemY], a
	ld a, [hl]
	ld [wTopMenuItemX], a
	call PlaceUnfilledArrowMenuCursor
	jp .loop
.cursorInBattleAnimation
	ld a, [wOptionsBattleAnimCursorX] ; battle animation cursor X coordinate
	xor $0b ; toggle between 1 and 10
	ld [wOptionsBattleAnimCursorX], a
	jp .eraseOldMenuCursor
.cursorInBattleStyle
	ld a, [wOptionsBattleStyleCursorX] ; battle style cursor X coordinate
	xor $0b ; toggle between 1 and 10
	ld [wOptionsBattleStyleCursorX], a
	jp .eraseOldMenuCursor
.pressedLeftInTextSpeed
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	cp FAST_X
	jr z, .fromFastToSlow
	cp MEDIUM_X
	jr nz, .fromSlowToMedium
	sub MEDIUM_X - FAST_X
	jr .updateTextSpeedXCoord
.fromSlowToMedium
	sub SLOW_X - MEDIUM_X
	jr .updateTextSpeedXCoord
.fromFastToSlow
	add SLOW_X - FAST_X
	jr .updateTextSpeedXCoord
	
.pressedRightInTextSpeed
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	cp SLOW_X
	jr z, .fromSlowToFast
	cp MEDIUM_X
	jr nz, .fromFastToMedium
	add SLOW_X - MEDIUM_X
	jr .updateTextSpeedXCoord
.fromFastToMedium
	add MEDIUM_X - FAST_X
	jr .updateTextSpeedXCoord
.fromSlowToFast
	sub SLOW_X - FAST_X
	
.updateTextSpeedXCoord
	ld [wOptionsTextSpeedCursorX], a ; text speed cursor X coordinate
	jp .eraseOldMenuCursor

TextSpeedOptionText:
	db   "TEXT SPEED"
	next " FAST  MEDIUM SLOW@"

BattleAnimationOptionText:
	db   "BATTLE ANIMATION"
	next " ON       OFF@"

BattleStyleOptionText:
	db   "BATTLE STYLE"
	next " SHIFT    SET@"

OptionMenuCancelText:
	db "CANCEL@"

; sets the options variable according to the current placement of the menu cursors in the options menu
SetOptionsFromCursorPositions:
	ld hl, TextSpeedOptionData
	ld a, [wOptionsTextSpeedCursorX] ; text speed cursor X coordinate
	ld c, a
.loop
	ld a, [hli]
	cp c
	jr z, .textSpeedMatchFound
	inc hl
	jr .loop
.textSpeedMatchFound
	ld a, [hl]
	ld d, a
	ld a, [wOptionsBattleAnimCursorX] ; battle animation cursor X coordinate
	dec a
	jr z, .battleAnimationOn
.battleAnimationOff
	set BATTLE_ANIMATION_F, d
	jr .checkBattleStyle
.battleAnimationOn
	res BATTLE_ANIMATION_F, d
.checkBattleStyle
	ld a, [wOptionsBattleStyleCursorX] ; battle style cursor X coordinate
	dec a
	jr z, .battleStyleShift
.battleStyleSet
	set BATTLE_STYLE_F, d
	jr .storeOptions
.battleStyleShift
	res BATTLE_STYLE_F, d
.storeOptions
	ld a, d
	ld [wOptions], a
	ret

; reads the options variable and places menu cursors in the correct positions within the options menu
SetCursorPositionsFromOptions:
	ld hl, TextSpeedOptionData + 1
	ld a, [wOptions]
	ld c, a
	and $3f
	push bc
	ld de, 2
	call IsInArray
	pop bc
	dec hl
	ld a, [hl]
	ld [wOptionsTextSpeedCursorX], a ; text speed cursor X coordinate
	coord hl, 0, SPEED_Y
	call .placeUnfilledRightArrow
	sla c
	ld a, OPTION_ON ; On
	jr nc, .storeBattleAnimationCursorX
	ld a, OPTION_OFF ; Off
.storeBattleAnimationCursorX
	ld [wOptionsBattleAnimCursorX], a ; battle animation cursor X coordinate
	coord hl, 0, ANIMATION_Y
	call .placeUnfilledRightArrow
	sla c
	ld a, OPTION_ON
	jr nc, .storeBattleStyleCursorX
	ld a, OPTION_OFF
.storeBattleStyleCursorX
	ld [wOptionsBattleStyleCursorX], a ; battle style cursor X coordinate
	coord hl, 0, STYLE_Y
	call .placeUnfilledRightArrow
; cursor in front of Cancel
	coord hl, 0, CANCEL_Y
	ld a, OPTION_ON
.placeUnfilledRightArrow
	ld e, a
	ld d, 0
	add hl, de
	ld [hl], $ec ; unfilled right arrow menu cursor
	ret

; table that indicates how the 3 text speed options affect frame delays
; Format:
; 00: X coordinate of menu cursor
; 01: delay after printing a letter (in frames)
TextSpeedOptionData:
	db SLOW_X,   SLOW_MASK   ; Slow
	db MEDIUM_X, MEDIUM_MASK ; Medium
	db FAST_X,   FAST_MASK   ; Fast
	db MEDIUM_X ; default X coordinate (Medium)
	db -1 ; terminator

CheckForPlayerNameInSRAM:
; Check if the player name data in SRAM has a string terminator character
; (indicating that a name may have been saved there) and return whether it does
; in carry.
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ld a, 1
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamBank], a
	ld b, NAME_LENGTH
	ld hl, sPlayerName
.loop
	ld a, [hli]
	cp "@"
	jr z, .found
	dec b
	jr nz, .loop
; not found
	xor a
	ld [MBC1SRamEnable], a
	ld [MBC1SRamBankingMode], a
	and a
	ret
.found
	xor a
	ld [MBC1SRamEnable], a
	ld [MBC1SRamBankingMode], a
	scf
	ret
