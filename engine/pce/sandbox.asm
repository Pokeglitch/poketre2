
; Arguments:
; 1 - Screen 
; 2 - Start Row
; 3 - Key Column
; 4 - Value Column
; 5 - Cursor Column
; 6 - Row Spacing
; Repeating:
; - Key Names
MACRO Menu
    REDEF SCREEN EQUS "\1"
    DEF ROW = \2
    DEF KEY_COL = \3
    DEF VAL_COL = \4
    DEF CURSOR_COL = \5
    DEF ROW_SPACING EQU \6

    DEF \1TopRow = ROW
    DEF \1KeyCol = KEY_COL
    DEF \1ValueCol = VAL_COL
    DEF \1CursorCol = CURSOR_COL
    DEF \1RowSpacing = ROW_SPACING

    DEF INDEX = 0
    SHIFT 6

    REPT _NARG
        DEF {SCREEN}\1Row = ROW
        DEF {SCREEN}\1Index = INDEX

        DEF ROW += ROW_SPACING

        DEF INDEX += 1
        SHIFT
    ENDR

    DEF {SCREEN}KeyCount = INDEX
ENDM

    Menu PCESandbox, 1, 1, 8, 7, 2, Type, Sprite, Color1, Color2, Color3, Color4, Color5, Scene

PCE_SANDBOX_SLIDER_COL = 13
PCE_SANDBOX_SLIDER_ROW = 17

PCE_SANDBOX_SPRITE_COL = 12
PCE_SANDBOX_SPRITE_ROW = 6
PCE_SANDBOX_SPRITE_DIMENSION = 7

MACRO SandboxType
    IF _NARG == 3
        ConvertName \2
        REDEF NAME_STRING EQUS "\"\1\""
        SHIFT
    ELSE
        ConvertName \1
    ENDC

    Prop Class, Byte, {NAME_VALUE}Class
    Prop Max, Byte, {NAME_VALUE}EntryCount - 1
    Prop Property, Byte, {NAME_VALUE}Property\2Offset
    Prop Name, String, NAME_STRING
ENDM

    Table SandboxType
    Entry Pokémon, Front
    Entry Trainer, Front
    Entry Other, Sprites
    Entry Mon Backs, Pokémon, Back

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
    ld [wPCESandboxScene], a

    coord hl, PCESandboxKeyCol, PCESandboxTypeRow
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
    ld de, SceneString
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
    call DrawPCESprite

    ld a, PCEPalettePrevious
	ld [wPCEPaletteID], a
    
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
    coord hl, PCESandboxCursorCol, PCESandboxTopRow
    lb bc, PCESandboxKeyCount * PCESandboxRowSpacing - 1, 1
    call ClearScreenArea

    ; find current cursor location
    coord hl, PCESandboxCursorCol, PCESandboxTopRow
    ld de, SCREEN_WIDTH*PCESandboxRowSpacing

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
    ld a, PCESandboxKeyCount-1
    jr .storeCurrentMenuItem

.downPressed
    ld a, [wCurrentMenuItem]
    inc a
    cp PCESandboxKeyCount
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
    jr z, .updateScene
    and a
    jr z, .updateList
    dec a
    jr z, .updateSprite
    
    call UpdatePaletteColor
    jr .keypressLoop

.updateScene
    ld hl, wPCESandboxScene
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
    coord hl, PCE_SANDBOX_SLIDER_COL, PCE_SANDBOX_SLIDER_ROW
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

    ld a, PCEPaletteEntrySize-1
    jr .storeColor

.checkMax
    cp PCEPaletteEntrySize
    jr nz, .storeColor

    xor a

.storeColor
    ld b, a
    ld [hl], a
    coord hl, PCESandboxValueCol, PCESandboxColor1Row
    ld de, SCREEN_WIDTH*PCESandboxRowSpacing
    
    ld a, [wCurrentMenuItem]
    sub PCESandboxColor1Index
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
    ld a, SandboxTypeEntryCount-1
    jr LoadPCESandboxList

.checkMax
    cp SandboxTypeEntryCount
    jr nz, LoadPCESandboxList
    xor a
    ; fall through

LoadPCESandboxList:
    ld [wPCESandboxList], a
    coord hl, PCESandboxValueCol, PCESandboxTypeRow
    lb bc, 1, SCREEN_WIDTH - PCESandboxValueCol
    call ClearScreenArea
    
    ld hl, SandboxTypeTable
    ld d, 0
    ld a, [wPCESandboxList]
    ld e, a

    ld a, SandboxTypeEntrySize

.listNameLoop
    add hl, de
    dec a
    jr nz, .listNameLoop

    ld a, [hli] ;a = class
    ld [wWhichClass], a

    ld a, [hli] ;a = max size
    ld [wPCESandboxListMax], a

    ld a, [hli] ;a = property offset
    ld [wWhichProperty], a
    
    ld e, [hl]
    inc hl
    ld d, [hl] ; de = type name string
    coord hl, PCESandboxValueCol, PCESandboxTypeRow
    call PlaceString

    ; Go to the start of the list
    xor a
	ld [wWhichInstance], a

    ; update the name
    call UpdatePCESandboxInstanceName
    
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
    call UpdatePCESandboxInstanceName

    ; fall through

; load sprite if auto update is enabled
TryLoadPCESandboxSprite:
    ld a, [wPCESandboxUpdateType]
    and a
    ret nz ;return if disabled
    ; fall through

LoadPCESandboxSprite:
    call FillScene
    ld de, vFrontPic
	jp LoadPCEImageToVRAM

UpdatePCESandboxInstanceName:
    coord hl, PCESandboxValueCol, PCESandboxSpriteRow
    lb bc, 1, SCREEN_WIDTH - PCESandboxValueCol
    call ClearScreenArea

    ld a, [wWhichProperty]
    push af

    ld de, wBuffer
	call GetInstanceName_Far

    pop af
	ld [wWhichProperty], a

    ld de, wBuffer
    coord hl, PCESandboxValueCol, PCESandboxSpriteRow
    jp PlaceString

DrawPCESprite:
    ld a, PCE_SANDBOX_SPRITE_DIMENSION

    ld b, a
    ld c, a
    ld a, SCREEN_WIDTH
    sub b
    ld e, a

	ld a, 0
	coord hl, PCE_SANDBOX_SPRITE_COL, PCE_SANDBOX_SPRITE_ROW

.rowLoop
    push bc
    push af
    ld d, b

.colLoop
	ld [hli], a
	add d
	dec b
	jr nz, .colLoop

    ld d, 0
	add hl, de
    pop af
    inc a
    pop bc
	dec c
	jr nz, .rowLoop

	ret

PlaceSandboxMenuItem:
	push hl
	call PlaceString
	pop hl
	ld de, SCREEN_WIDTH * PCESandboxRowSpacing
	add hl, de
	ret

Color1String:
    str "Color1 ", PCESandboxPaletteWhiteTile

Color2String:
    str "Color2 ", PCESandboxPaletteLightTile

Color3String:
    str "Color3 ", PCESandboxPaletteDarkTile

Color4String:
    str "Color4 ", PCESandboxPaletteBlackTile

Color5String:
    str "Color5 ", PCESandboxPaletteAlphaTile

SceneString:
    str "Scene  ", PCESandboxPaletteWhiteTile

TypeString:
    str "Type"

SpriteString:
    str "Sprite"

ToggleString:
    str PCESandboxButtonsSelectTiles, " Apply: ", PCESandboxButtonsATile, PCESandboxGUISliderRightLightTiles, "Auto"

InstantString:
    str "Instant"

APressString:
    str "A Press"

FillScene:
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBank], a

    ld a, [wPCESandboxScene]
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
    ld de, PCE_SANDBOX_SPRITE_DIMENSION * PCE_SANDBOX_SPRITE_DIMENSION * BYTES_PER_TILE/2

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
