ShowPokedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wLastMenuItem], a
	inc a
	ld [wd11e], a
	ld [hJoy7], a
.setUpGraphics
	ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	callab LoadPokedexTilePatterns
.doPokemonListMenu
	ld hl, wTopMenuItemY
	ld a, 3
	ld [hli], a ; top menu item Y
	xor a
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], D_LEFT | D_RIGHT | B_BUTTON | A_BUTTON
	call HandlePokedexListMenu
	jr c, .goToSideMenu ; if the player chose a pokemon from the list
.exitPokedex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld [hJoy7], a
	ld [wWastedByteCD3A], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	pop af
	ld [wListScrollOffset], a
	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
	jp ReloadMapData
.goToSideMenu
	call HandlePokedexSideMenu
	dec b
	jr z, .exitPokedex ; if the player chose Quit
	dec b
	jr z, .doPokemonListMenu ; if pokemon not seen or player pressed B button
	jp .setUpGraphics ; if pokemon data or area was shown

; handles the menu on the lower right in the pokedex screen
; OUTPUT:
; b = reason for exiting menu
; 00: showed pokemon data or area
; 01: the player chose Quit
; 02: the pokemon has not been seen yet or the player pressed the B button
HandlePokedexSideMenu:
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	push af
	ld b, a
	ld a, [wLastMenuItem]
	push af
	ld a, [wListScrollOffset]
	push af
	add b
	inc a
	ld [wd11e], a
	ld a, [wd11e]
	push af
	ld a, [wDexMaxSeenMon]
	push af ; this doesn't need to be preserved
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	ld b, 2
	jr z, .exitSideMenu
	call PokedexToIndex
	ld hl, wTopMenuItemY
	ld a, 10
	ld [hli], a ; top menu item Y
	ld a, 15
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, 3
	ld [hli], a ; max menu item ID
	;ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; menu watched keys (A button and B button)
	xor a
	ld [hli], a ; old menu item ID
	ld [wMenuWatchMovingOutOfBounds], a
.handleMenuInput
	call HandleMenuInput
	bit 1, a ; was the B button pressed?
	ld b, 2
	jr nz, .buttonBPressed
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseData
	dec a
	jr z, .choseCry
	dec a
	jr z, .choseArea
.choseQuit
	ld b, 1
.exitSideMenu
	pop af
	ld [wDexMaxSeenMon], a
	pop af
	ld [wd11e], a
	pop af
	ld [wListScrollOffset], a
	pop af
	ld [wLastMenuItem], a
	pop af
	ld [wCurrentMenuItem], a
	push bc
	coord hl, 0, 3
	ld de, 20
	lb bc, " ", 13
	call DrawTileLine ; cover up the menu cursor in the pokemon list
	pop bc
	ret

.buttonBPressed
	push bc
	coord hl, 15, 10
	ld de, 20
	lb bc, " ", 7
	call DrawTileLine ; cover up the menu cursor in the side menu
	pop bc
	jr .exitSideMenu

.choseData
	call ShowPokedexDataInternal
	ld b, 0
	jr .exitSideMenu

; play pokemon cry
.choseCry
	ld a, [wd11e]
	call GetCryData
	call PlaySound
	jr .handleMenuInput

.choseArea
	predef LoadTownMap_Nest ; display pokemon areas
	ld b, 0
	jr .exitSideMenu

; handles the list of pokemon on the left of the pokedex screen
; sets carry flag if player presses A, unsets carry flag if player presses B
HandlePokedexListMenu:
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
; draw the horizontal line separating the seen and owned amounts from the menu
	coord hl, 15, 8
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	coord hl, 14, 0
	ld [hl], $71 ; vertical line tile
	coord hl, 14, 1
	call DrawPokedexVerticalLine
	coord hl, 14, 9
	call DrawPokedexVerticalLine
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	coord hl, 16, 3
	lb bc, 1, 3
	call PrintNumber ; print number of seen pokemon
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	coord hl, 16, 6
	lb bc, 1, 3
	call PrintNumber ; print number of owned pokemon
	coord hl, 16, 2
	ld de, PokedexSeenText
	call PlaceString
	coord hl, 16, 5
	ld de, PokedexOwnText
	call PlaceString
	coord hl, 1, 1
	ld de, PokedexContentsText
	call PlaceString
	coord hl, 16, 10
	ld de, PokedexMenuItemsText
	call PlaceString
; find the highest pokedex number among the pokemon the player has seen
	ld hl, wPokedexSeenEnd - 1
	ld b, (wPokedexSeenEnd - wPokedexSeen) * 8 + 1
.maxSeenPokemonLoop
	ld a, [hld]
	ld c, 8
.maxSeenPokemonInnerLoop
	dec b
	sla a
	jr c, .storeMaxSeenPokemon
	dec c
	jr nz, .maxSeenPokemonInnerLoop
	jr .maxSeenPokemonLoop

.storeMaxSeenPokemon
	ld a, b
	ld [wDexMaxSeenMon], a
.loop
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 4, 2
	lb bc, 14, 10
	call ClearScreenArea
	coord hl, 1, 3
	ld a, [wListScrollOffset]
	ld [wd11e], a
	ld d, 7
	ld a, [wDexMaxSeenMon]
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld [wMaxMenuItem], a
; loop to print pokemon pokedex numbers and names
; if the player has owned the pokemon, it puts a pokeball beside the name
.printPokemonLoop
	ld a, [wd11e]
	inc a
	ld [wd11e], a
	push af
	push de
	push hl
	ld de, -SCREEN_WIDTH
	add hl, de
	ld de, wd11e
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; print the pokedex number
	ld de, SCREEN_WIDTH
	add hl, de
	dec hl
	push hl
	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop hl
	ld a, " "
	jr z, .writeTile
	ld a, $72 ; pokeball tile
.writeTile
	ld [hl], a ; put a pokeball next to pokemon that the player has owned
	push hl
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr nz, .getPokemonName ; if the player has seen the pokemon
	ld de, .dashedLine ; print a dashed line in place of the name if the player hasn't seen the pokemon
	jr .skipGettingName
.dashedLine ; for unseen pokemon in the list
	str "----------"
.getPokemonName
	call PokedexToIndex
	call GetMonName
.skipGettingName
	pop hl
	inc hl
	call PlaceString
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	pop af
	ld [wd11e], a
	dec d
	jr nz, .printPokemonLoop
	ld a, 01
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	call GBPalNormal
	call HandleMenuInput
	bit 1, a ; was the B button pressed?
	jp nz, .buttonBPressed
.checkIfUpPressed
	bit 6, a ; was Up pressed?
	jr z, .checkIfDownPressed
.upPressed ; scroll up one row
	ld a, [wListScrollOffset]
	and a
	jp z, .loop
	dec a
	ld [wListScrollOffset], a
	jp .loop
.checkIfDownPressed
	bit 7, a ; was Down pressed?
	jr z, .checkIfRightPressed
.downPressed ; scroll down one row
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop
	inc a
	ld [wListScrollOffset], a
	jp .loop
.checkIfRightPressed
	bit 4, a ; was Right pressed?
	jr z, .checkIfLeftPressed
.rightPressed ; scroll down 7 rows
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 6
	ld b, a
	ld a, [wListScrollOffset]
	add 7
	ld [wListScrollOffset], a
	cp b
	jp c, .loop
	dec b
	ld a, b
	ld [wListScrollOffset], a
	jp .loop
.checkIfLeftPressed ; scroll up 7 rows
	bit 5, a ; was Left pressed?
	jr z, .buttonAPressed
.leftPressed
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop
.buttonAPressed
	scf
	ret
.buttonBPressed
	and a
	ret

DrawPokedexVerticalLine:
	ld c, 9 ; height of line
	ld de, SCREEN_WIDTH
	ld a, $71 ; vertical line tile
.loop
	ld [hl], a
	add hl, de
	xor 1 ; toggle between vertical line tile and box tile
	dec c
	jr nz, .loop
	ret

PokedexSeenText:
	str "SEEN"

PokedexOwnText:
	str "OWN"

PokedexContentsText:
	str "CONTENTS"

PokedexMenuItemsText:
	db   "DATA"
	next "CRY"
	next "AREA"
	next "QUIT@"

; tests if a pokemon's bit is set in the seen or owned pokemon bit fields
; INPUT:
; [wd11e] = pokedex number
; hl = address of bit field
IsPokemonBitSet:
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret

; function to display pokedex data from outside the pokedex
; TODO
; - add white tile
; - add angles tiles surrounding pokedex #
; - add " and ' tiles
; - fix description and blinking arrow
ShowPokedexData:
	callab LoadPokedexTilePatterns ; load pokedex tiles

; function to display pokedex data from inside the pokedex
ShowPokedexDataInternal:
	ld hl, wd72c
	set 1, [hl]
	ld a, $33 ; 3/7 volume
	ld [rNR50], a
	call ClearScreen
	ld a, [wd11e] ; pokemon ID
	ld [wcf91], a
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	pop af
	ld [wd11e], a
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a

	call DrawPokemonPicFrame
	call DrawPokemonDescription

	; TODO - Load type tiles to VRAM

	; Pokemon's name to VRAM
	call GetMonName
	ld de, wcd6d
	ld hl, vChars2 + $600
	ld a, 11
	call CopyStringToVRAM_BlackOnLight
	push hl
	
	; Pokemon's species to VRAM
	ld hl, PokedexEntryPointers
	ld a, [wd11e]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl] ; de = address of pokedex entry

	pop hl
	ld a, 11
	call CopyStringToVRAM_BlackOnLight

	; Pokemon's Index to VRAM
	push de
	ld h, b
	ld l, c
	ld a, [wd11e]
	push af
	call IndexToPokedex

	ld de, wd11e
	lb bc, LEADING_ZEROES | 1, 3
	ld hl, wcf4b
	call PrintNumber ; copy pokedex number to CF4B

	ld hl, vChars1 + $710
	ld de, wcf4b
	ld a, 3
	call CopyStringToVRAM_BlackOnWhite

	; Pokemon's Height to VRAM
.heightVRAM
	pop af
	pop de
	push de
	push af

	inc de ; address of feet (height)
	push de
	ld hl, wcf4b
	ld [hl], " " ; since no leading zero's, initialize the first digit to be empty
	lb bc, 1, 2
	call PrintNumber ; print feet (height)
	pop de

	inc de ; address of inches (height)
	push de
	ld hl, wcf4b + 2
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber ; print inches (height)

	ld hl, vChars2 + $760
	ld de, wcf4b
	ld a, 4
	call CopyStringToVRAM_BlackOnLight

	; Pokemon's Weight to VRAM
.weight
	pop de
	inc de
	inc de
	push de
	; put weight in big-endian order at hDexWeight
	ld hl, hDexWeight
	ld a, [hl] ; save existing value of [hDexWeight]
	push af
	ld a, [de] ; a = upper byte of weight
	ld [hli], a ; store upper byte of weight in [hDexWeight]
	ld a, [hl] ; save existing value of [hDexWeight + 1]
	push af
	dec de
	ld a, [de] ; a = lower byte of weight
	ld [hl], a ; store lower byte of weight in [hDexWeight + 1]
	ld de, hDexWeight
	ld hl, wcf4b
	push hl
	; Prefill with "   00 "
	; the last space is so the space tile will be loaded into $7F
	ld a, " "
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], "0"
	inc hl
	ld [hl], "0"
	inc hl
	ld [hl], a
	pop hl
	lb bc, 2, 5 ; 2 bytes, 5 digits
	call PrintNumber ; print weight

	ld hl, vChars2 + $7A0
	ld de, wcf4b
	ld a, 6
	call CopyStringToVRAM_BlackOnLight
	
	pop af
	ld [hDexWeight + 1], a ; restore original value of [hDexWeight + 1]
	pop af
	ld [hDexWeight], a ; restore original value of [hDexWeight]

	pop de
	inc de ; de = pointer to description


	ld hl, wPokedexOwned
	call IsPokemonBitSet
	ld a, [wd11e] 
	pop af
	ld [wd11e], a
	ld a, [wcf91]
	ld [wd0b5], a
	pop de

	push af
	push bc
	push de
	push hl

	; a already points to the dex id
	call GetMonHeader ; load pokemon picture location
	ld de, vChars1
	call LoadMonFrontSprite

	call FullyRevealWindow
	ld a, [wcf91]
	call PlayCry ; play pokemon cry

	pop hl
	pop de
	pop bc
	pop af

	ld a, c
	and a
	jp z, .waitForButtonPress ; if the pokemon has not been owned, don't print the height, weight, or description
	
	inc de ; de = address of feet (height)
	
	;coord hl, 13, 4
	;lb bc, 1, 2
	;call PrintNumber ; print feet (height)
	;ld a, $60 ; feet symbol tile (one tick)
	;ld [hl], a
	inc de
	inc de ; de = address of inches (height)
	;coord hl, 16, 4
	;lb bc, LEADING_ZEROES | 1, 2
	;call PrintNumber ; print inches (height)
	;ld a, $61 ; inches symbol tile (two ticks)
	;ld [hl], a

; now print the weight (note that weight is stored in tenths of pounds internally)
	inc de
	inc de
	inc de ; de = address of upper byte of weight
	push de

	pop hl
	inc hl ; hl = address of pokedex description text
	coord bc, 1, 12
	ld a, 2
	ld [$fff4], a
	;call TextCommandProcessor ; print pokedex description text
	xor a
	ld [$fff4], a
.waitForButtonPress
	call JoypadLowSensitivity
	ld a, [hJoy5]
	and A_BUTTON | B_BUTTON
	jr z, .waitForButtonPress
	pop af
	ld [hTilesetType], a

	; TODO
	; - hide description, move sprite to $80, draw those tiles
	; - reload the tileset
	; - close text display (need to make sure overworld is drawn properly)
	; - load proper font/textbox tiles
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call CloseTextDisplay
	
	ld hl, wd72c
	res 1, [hl]
	ld a, $77 ; max volume
	ld [rNR50], a
	ret

DrawPokemonPicFrame:
	; top border 1
	coord hl, 0, 0
	ld a, $C0
	ld b, 5

.loop1
	ld [hli], a
	inc a
	dec b
	jr nz, .loop1

	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc a
	ld [hl], a

	; top border 2
	coord hl, 0, 1
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], $D9
	inc hl
	ld a, $F1
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], $D9
	inc hl
	ld [hl], $CB

	ld a, $80
	call DrawDexSpriteRow ;row 3
	call DrawDexSpriteRow ;row 4
	call DrawDexSpriteRow ;row 5
	call DrawDexSpriteRow ;row 6
	call DrawDexSpriteRow ;row 7
	call DrawDexSpriteRow ;row 8
	call DrawDexSpriteRow ;row 9

	;bottom border 1
	coord hl, 0, 9
	ld a, $CC
	ld [hli], a
	inc a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], $CD
	inc hl
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], $CD
	inc hl
	inc a
	ld [hl], a	

	;bottom border 2
	coord hl, 0, 10
	inc a
	ld [hli], a
	inc a
	ld b, 4
.loop10
	ld [hli], a
	dec b
	jr nz, .loop10
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], $D4
	inc hl
	inc a
	ld [hl], a
	ret

DrawDexSpriteRow:
	push af
	ld de, 12
	add hl, de
	ld [hl], $CA
	inc hl
	ld b, 7
.loop
	ld [hli], a
	add 7
	dec b
	jr nz, .loop
	ld [hl], $CB
	pop af
	inc a
	ret

DrawPokemonDescription:
	
	
	; Display name
	coord hl, 9, 0
	ld a, $60
	call DrawVRAMTileRow
	push af
	call DrawLightTileRow
	pop af
	
	; Display species
	call DrawVRAMTileRow
	call DrawLightTileRow

	; TODO - If only 1 type, then display that in the row between height & width

	; display 1st type & height
	ld a, $DA ; 1st type tile
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc hl
	inc hl
	ld a, $76
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], "'" ; feet symbol
	inc hl
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], "\"" ; inches symbol
	inc hl
	call DrawLightTileRow

	; Display 2nd type & width
	ld a, $DD ; 2nd type tile
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc hl
	ld a, $7A
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], "." ; decimal
	inc hl
	ld [hli], a
	ld [hl], $D8 ; lb symbol
	inc hl
	call DrawLightTileRow

	;divider 1
	ld a, $E7
	call DrawDividerRow

	;divider 2
	ld a, $EB
	call DrawDividerRow

	;divider 3
	ld a, $ED
	jp DrawDividerRow

; hl = destination
DrawLightTileRow:
	ld de, 9
	add hl, de
	ld a, " "
	ld b, 11
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	
	add hl, de
	ret

; a = start tile
; hl = destination
DrawVRAMTileRow:
	ld b, 11
.loop
	ld [hli], a
	inc a
	dec b
	jr nz, .loop
	ret

DrawDividerRow:
	ld [hli], a
	ld [hli], a
	dec a
	ld [hli], a
	inc a
	ld b, 5
.loop
	ld [hli], a
	dec b
	jr nz, .loop

	dec a
	ld [hli], a
	inc a
	ld [hli], a
	ld [hl], a
	ld de, 10
	add hl, de
	ret

; XXX does anything point to this?
UnusedPokeText:
	str "#"

; draws a line of tiles
; INPUT:
; b = tile ID
; c = number of tile ID's to write
; de = amount to destination address after each tile (1 for horizontal, 20 for vertical)
; hl = destination address
DrawTileLine:
	push bc
	push de
.loop
	ld [hl], b
	add hl, de
	dec c
	jr nz, .loop
	pop de
	pop bc
	ret

INCLUDE "data/pokedex_entries.asm"

PokedexToIndex:
	; converts the Pokédex number at wd11e to an index
	push bc
	push hl
	ld a, [wd11e]
	ld b, a
	ld c, 0
	ld hl, PokedexOrder

.loop ; go through the list until we find an entry with a matching dex number
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, c
	ld [wd11e], a
	pop hl
	pop bc
	ret

IndexToPokedex:
	; converts the index number at wd11e to a Pokédex number
	push bc
	push hl
	ld a, [wd11e]
	dec a
	ld hl, PokedexOrder
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wd11e], a
	pop hl
	pop bc
	ret

INCLUDE "data/pokedex_order.asm"
