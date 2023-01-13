NUM_PCE_SANDBOX_OPTIONS EQU 8

SandboxType: MACRO
    DEF SandboxType\1 = SandboxTypeCount
    db \1Class
    db \1Count - 1
    IF _NARG == 2
        dw \2
    ELSE
        dw \1TypesName
    ENDC
    DEF SandboxTypeCount += 1
ENDM

    Table SandboxType, Byte, Byte, Pointer
    SandboxType Pokemon
    SandboxType Other

PCESandboxScreen::
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a

	call SaveScreenTilesToBuffer2
	call GBPalWhiteOutWithDelay3
	call ClearScreen

    xor a
    ld [wPCESandboxUpdateType], a
    ld [wPCESandboxBacking], a

    coord hl, 1, 1
    ld de, TypeString
    call PlaceSandboxMenuItem
    ld de, SpriteString
    call PlaceSandboxMenuItem
    ld de, Color1String
    call PlaceSandboxMenuItem
    ld de, Color2String
    call PlaceSandboxMenuItem
    ld de, Color3String
    call PlaceSandboxMenuItem
    ld de, Color4String
    call PlaceSandboxMenuItem
    ld de, Color5String
    call PlaceSandboxMenuItem
    ld de, BackingString
    call PlaceSandboxMenuItem
    ld de, ToggleString
    call PlaceString

	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]

    call LoadBlackOnWhiteFontTilePatterns
    
    load_tiles $C0, PCESandbox, GUICursor, GUISliderLeftLight, GUISliderRightLight, Palette, ButtonsA, ButtonsSelect

    ld a, PCEPaletteStandardAlphaBG
	ld [wPCEPaletteID], a

    ld a, SandboxTypePokemon
    call LoadPCESandboxList

    ld a, PCEPalettePrevious
	ld [wPCEPaletteID], a

	coord hl, 12, 6
	ld a, 0
	call DrawPCESprite
    
    ld b, SET_PAL_GENERIC
	call RunPaletteCommand
	call Delay3
	call GBPalNormal

    call PCESandboxKeypressHandler

	ld hl, wd730
	res 6, [hl]
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
    call ReloadTilesetTilePatterns
	call Delay3

    pop af
	ld [hTilesetType], a

	jp GBPalNormal

PCESandboxKeypressHandler:
    xor a ; current menu item

.storeCurrentMenuItem
    ld [wCurrentMenuItem], a

.updateCursorLocation
    ; erase all possible previous cursor locations
    coord hl, 8, 1
    lb bc, NUM_PCE_SANDBOX_OPTIONS*2-1, 1
    call ClearScreenArea

    ; find current cursor location
    coord hl, 8, 1
    ld de, SCREEN_WIDTH*2

    ld a, [wCurrentMenuItem]
.findCursorLocationLoop
    and a
    jr z, .placeCursor
    add hl, de
    dec a
    jr .findCursorLocationLoop

.placeCursor
    ld [hl], PCESandboxGUICursorTile

.keypressLoop
	call JoypadLowSensitivity
	ld a, [hJoy5]

	and D_LEFT | D_RIGHT | D_UP | D_DOWN | B_BUTTON | A_BUTTON | SELECT
	jr z, .keypressLoop
    
    bit BIT_SELECT, a
    jr nz, .toggleUpdateMode

	bit BIT_D_UP, a
	jr nz, .upPressed

    bit BIT_D_DOWN, a
    jr nz, .downPressed

	bit BIT_D_LEFT, a
	jr nz, .leftPressed

	bit BIT_D_RIGHT, a
	jr nz, .rightPressed

    bit BIT_B_BUTTON, a
    ret nz

    ;otherwise, it was A
    ld a, [wPCESandboxUpdateType]
    and a
    jr z, .keypressLoop ; if the update type is auto, then no need to draw sprite again
    
    ; if it was not auto, then draw
    call LoadPCESandboxSprite
    jr .keypressLoop

.upPressed
    ld a, [wCurrentMenuItem]
    dec a
    cp -1
    jr nz, .storeCurrentMenuItem
    ld a, NUM_PCE_SANDBOX_OPTIONS-1
    jr .storeCurrentMenuItem

.downPressed
    ld a, [wCurrentMenuItem]
    inc a
    cp NUM_PCE_SANDBOX_OPTIONS
    jr nz, .storeCurrentMenuItem
    xor a
    jr .storeCurrentMenuItem

.leftPressed
    ld b, -1
    jr .adjustMenuOption

.rightPressed
    ld b, 1

.adjustMenuOption
    ld a, [wCurrentMenuItem]
    cp 7
    jr z, .updateBacking
    and a
    jr z, .updateList
    dec a
    jr z, .updateSprite
    
    call UpdatePaletteColor
    jr .keypressLoop

.updateBacking
    ld hl, wPCESandboxBacking
    call UpdateColor
    jr .keypressLoop

.toggleUpdateMode
    call ToggleUpdateMode
    jr .keypressLoop

.updateList
    call UpdatePCESandboxList
    jr .keypressLoop

.updateSprite
	call UpdatePCESandboxSprite
    jr .keypressLoop

ToggleUpdateMode:
    ld a, [wPCESandboxUpdateType]
    xor 1
    ld [wPCESandboxUpdateType], a
    and a
    ld a, PCESandboxGUISliderRightLightTile
    jr z, .updateSliderTiles
    ld a, PCESandboxGUISliderLeftLightTile

.updateSliderTiles
    coord hl, 13, 17
    ld [hli], a
    inc a
    ld  [hl], a
    jp TryLoadPCESandboxSprite

UpdatePaletteColor:
    dec a
    ld hl, wPCEPalette
    ld d, 0
    ld e, a
    add hl, de ;hl = which palette
    ; fall through

; b = how much to adjust by
UpdateColor:
    ld a, [hl]
    add b
    cp -1
    jr nz, .checkMax

    ld a, PCEPaletteSize-1
    jr .storeColor

.checkMax
    cp PCEPaletteSize
    jr nz, .storeColor

    xor a

.storeColor
    ld b, a
    ld [hl], a
    coord hl, 9, 5
    ld de, SCREEN_WIDTH*2
    
    ld a, [wCurrentMenuItem]
    sub 2
    jr z, .placeColorTile

.findColorTileLocationLoop
    add hl, de
    dec a
    jr nz, .findColorTileLocationLoop

.placeColorTile
    ; hl = location to place tile
    ld a, b
    add PCESandboxPaletteWhiteTile
    ld [hl], a
    jp TryLoadPCESandboxSprite

; b = how much to adjust by
UpdatePCESandboxList:
    ld a, [wPCESandboxList]
    add b
    cp -1
    jr nz, .checkMax
    ld a, SandboxTypeCount-1
    jr LoadPCESandboxList

.checkMax
    cp SandboxTypeCount
    jr nz, LoadPCESandboxList
    xor a
    ; fall through

LoadPCESandboxList:
    ld [wPCESandboxList], a
    coord hl, 9, 1
    lb bc, 1, NAME_LENGTH
    call ClearScreenArea
    
    ld hl, SandboxTypeTable
    ld d, 0
    ld a, [wPCESandboxList]
    ld e, a

    ld a, SandboxTypeSize

.listNameLoop
    add hl, de
    dec a
    jr nz, .listNameLoop

    ld a, [hli] ;a = class
    ld [wWhichClass], a

    ld a, [hli] ;a = max size
    ld [wPCESandboxListMax], a
    
    ld e, [hl]
    inc hl
    ld d, [hl] ; de = name string
    coord hl, 9, 1
    call PlaceString

    ; Go to the start of the list
    xor a
	ld [wWhichInstance], a

    ; update the name
    call UpdatePCESandboxName
    
    ; load sprite if auto is enabled
    jp TryLoadPCESandboxSprite

; b = how much to adjust by
UpdatePCESandboxSprite:
    ld a, [wPCESandboxListMax]
    ld c, a ; load max into c

	ld a, [wWhichInstance]
    add b
    cp -1
    jr nz, .checkMax

    ld a, c ; use max
    jr .storeSprite

.checkMax
    inc c
    cp c
    jr c, .storeSprite

    xor a
.storeSprite
	ld [wWhichInstance], a
    call UpdatePCESandboxName

    ; fall through

; load sprite if auto update is enabled
TryLoadPCESandboxSprite:
    ld a, [wPCESandboxUpdateType]
    and a
    ret nz ;return if disabled
    ; fall through

LoadPCESandboxSprite:
    call FillBacking
    ld de, vFrontPic
	jp LoadFrontPCEImageToVRAM

UpdatePCESandboxName:
    coord hl, 9, 3
    lb bc, 1, NAME_LENGTH
    call ClearScreenArea

    ld a, PokemonName ; All names use the same property ID
	ld [wWhichProperty], a
	call GetInstanceProperty

    ld d, h
    ld e, l
    coord hl, 9, 3
    jp PlaceString

; a = start tile
; hl = coords
DrawPCESprite:
	ld de, 13
	ld c, 7

.rowLoop
    push af
	ld b, 7

.colLoop
	ld [hli], a
	add 7
	dec b
	jr nz, .colLoop

	add hl, de
    pop af
    inc a
	dec c
	jr nz, .rowLoop

	ret

PlaceSandboxMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

Color1String:
    str "Color 1 ", PCESandboxPaletteWhiteTile

Color2String:
    str "Color 2 ", PCESandboxPaletteLightTile

Color3String:
    str "Color 3 ", PCESandboxPaletteDarkTile

Color4String:
    str "Color 4 ", PCESandboxPaletteBlackTile

Color5String:
    str "Color 5 ", PCESandboxPaletteAlphaTile

BackingString:
    str "Backing ", PCESandboxPaletteWhiteTile

TypeString:
    str "Type"

SpriteString:
    str "Sprite"

ToggleString:
    str PCESandboxButtonsSelectTile, PCESandboxButtonsSelectTile+1, PCESandboxButtonsSelectTile+2, " Apply: ", PCESandboxButtonsATile, PCESandboxGUISliderRightLightTile, PCESandboxGUISliderRightLightTile+1, "Auto"

InstantString:
    str "Instant"

APressString:
    str "A Press"

PokemonTypesName:
    str "Pokémon"
    
OtherTypesName:
    str "Other"


FillBacking:
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a

    ld a, [wPCESandboxBacking]
    lb bc, 0, 0
    and a
    jr z, .continue
    lb bc, -1, 0
    dec a
    jr z, .continue
    lb bc, 0, -1
    dec a
    jr z, .continue
    lb bc, -1, -1
    dec a
    ret nz

.continue
    ld hl, sPCESpriteBuffer
    ld de, 7 * 7 * BYTES_PER_TILE/2

.loop
    ld [hl], b
    inc hl
    ld [hl], c
    inc hl
    dec de
    ld a, d
    or e
    jr nz, .loop
    
	ld a, SRAM_DISABLE
	ld [MBC1SRamEnable], a
    ret
