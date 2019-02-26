; TODO
; Add in price/quantity/description
; Check "Drawing Screen.txt" to see whats next

; Clean up:
; - Update the Item Lists to not include any unused items in the pocket item lists
; -- update ram size accordingly
; - combine all of the pocket information into a single dataset
; Comment all routines
; Make sure constants are used in all possible areas
; Use Common names
; - 'Inventory' instead of Item/Item Screen
; - 'Moves' instead of 'Machine'
; - 'Pocket' instead of Tab
; - Cursor instead of Pointer
; - Buffer instead of 'Visible Items List'

TABS_START_TILE_ID = $C0
TAB_TILE_WIDTH = 5
TAB_BOTTOM_BORDER_TILE = $D4
TAB_BOTTOM_BORDER_HIDDEN_TILE = $D8
BAGS_GFX_WIDTH = 8
BAGS_GFX_HEIGHT = 10

DisplayItemMenu:
    call GBPalWhiteOutWithDelay3
    call HideSprites

    call ClearScreen
    call DrawItemMenuScreen

    ; Load the tab index    
    ld a, [wWhichInventoryTab]
    ld c, a

    ld b, 2 ; initialize the cursor position

.tabLoop
    call UpdateDisplayForCurrentTab

.filterLoop
    call InitializeInventoryItemsBuffer

.textLoop
    call TryWrapAroundInventoryList
    call UpdateInventoryList

.cursorLoop
    call UpdateInventoryCursor
    ;call UpdateItemDescription

.keypressLoop
    push bc
    call JoypadLowSensitivity
    pop bc
    ld a, [hJoy5]
    and a
    jr z, .keypressLoop

    bit BIT_A_BUTTON, a
    jr nz, .aPressed

    bit BIT_START, a
    jr nz, .startPressed

    bit BIT_SELECT, a
    jr nz, .selectPressed

    bit BIT_D_LEFT, a
    jr nz, .leftPressed

    bit BIT_D_RIGHT, a
    jr nz, .rightPressed

    bit BIT_D_UP, a
    jr nz, .upPressed

    bit BIT_D_DOWN, a
    jr nz, .downPressed

    ; Otherwise, B was pressed, so exit with carry
    scf
    ret


.leftPressed
    call SaveCurrentPocketItemIndex
    dec c
    ld a, -1
    cp c
    jr nz, .saveCurrentTab
    ld c, 3
    jr .saveCurrentTab

.rightPressed
    call SaveCurrentPocketItemIndex
    inc c
    ld a, 4
    cp c
    jr nz, .saveCurrentTab
    ld c, 0

.saveCurrentTab
    ld a, c
    ld [wWhichInventoryTab], a
    jr .tabLoop

.startPressed
    call ToggleInventoryFilter
    jr .filterLoop

.aPressed
.selectPressed
    jr .keypressLoop

.upPressed
    ld a, -1
    jr .handleNavigation

.downPressed
    ld a, 1

.handleNavigation
    push bc
    add b
    ld b, a
    call GetSelectedItemIndex
    cp -1
    jr nz, .navigate
    
    ; don't update the cursor position if the new position has no item
    pop bc
    jr .keypressLoop

.navigate
    ld a, b

    and a
    jr z, .shiftBufferDown

    cp 4
    jr z, .shiftBufferUp

    ; update cursor if it is not at the top
    pop hl
    jr .cursorLoop

.shiftBufferDown
    call ShiftInventoryBufferDown
    jr .finishedUpdatingBuffer

.shiftBufferUp
    call ShiftInventoryBufferUp

.finishedUpdatingBuffer
    pop bc
    jr .textLoop

ShiftInventoryBufferDown:
    ld hl, wItemsVisibleInInventory + 4
    ld de, wItemsVisibleInInventory + 3
    ld b, 4

.loop
    ld a, [de]
    dec de
    ld [hld], a
    dec b
    jr nz, .loop

    ; Find the first item in the list
    ld a, [hl] ; the previous "first" item index
    call GetPocketItemAndQuantityPointers
    dec a
    dec hl ; shift to previous item
    ld c, -1
    ld de, -1
    ld b, 0
    jp FindRemainingBufferItems

ShiftInventoryBufferUp:
    ld hl, wItemsVisibleInInventory
    ld de, wItemsVisibleInInventory + 1 
    ld b, 4

.loop
    ld a, [de]
    inc de
    ld [hli], a
    dec b
    jr nz, .loop

    ; Find the last item in the list
    ld a, [hl] ; the previous "last" item index
    call GetPocketItemAndQuantityPointers
    inc hl
    inc a ; shift to next item
    ld de, 1
    ld b, 4
    jp FindRemainingBufferItems

PocketGFXPointers:
    dw ItemMenuBattleBagGFX
    dw ItemMenuFieldBagGFX
    dw ItemMenuHealthBagGFX
    dw ItemMenuMovesBagGFX

SavedPocketItemIndexPointers:
    dw wSavedBattleItemIndex
    dw wSavedFieldItemIndex
    dw wSavedHealthItemIndex
    dw wSavedMachineItemIndex
    
PocketItemQuantityPointers:
    dw wBattleItemQuantities
    dw wFieldItemQuantities
    dw wHealthItemQuantities
    dw wMachineItemQuantities
    
PocketItemListPointers:
    dw BattleItems
    dw FieldItems
    dw HealthItems
    dw 0

PocketItemListLengths:
    db (BattleItemsEnd - BattleItems)
    db (FieldItemsEnd - FieldItems)
    db (HealthItemsEnd - HealthItems)
    db TM_50 - HM_01 + 1 ; Machine

; To get the pointer (hl) from the list (hl) for pocket (c)
GetPocketPointer:
    push bc
    ld b, 0
    add hl, bc
    add hl, bc
    ld b, [hl]
    inc hl
    ld h, [hl]
    ld l, b
    pop bc
    ret

; To get the pointer (hl) from the index (a) from list (hl) for pocket (c)
GetPocketIndexPointer:
    push af
    call GetPocketPointer
    add l
    ld l, a
    jr nc, .finish
    inc h
.finish
    pop af
    ret

; To get the pocket max number of items (c) and quantity (hl) pointers based on index (a) and pocket (c)
GetPocketItemAndQuantityPointers:
    ld hl, PocketItemQuantityPointers
    call GetPocketIndexPointer
    push hl
    ld hl, PocketItemListLengths
    ld d, 0
    ld e, c
    add hl, de
    ld c, [hl] ; c = length of pocket items list
    pop hl
    ret

; Populate the list of current items visible on the inventory
InitializeInventoryItemsBuffer:
    push bc

    ld hl, SavedPocketItemIndexPointers
    call GetPocketPointer
    ld a, [hl] ; a = index to last selected item

    call GetPocketItemAndQuantityPointers
    push af
    push hl
    push bc
    ld de, 1
    call FindRemainingBufferItems
    pop bc

    call GetCurrentItemPointer
    ld a, [hl]
    cp -1
    jr z, .dontDecB

    ; Decrease cursor position if item is at current cursor position
    dec b

.dontDecB
    pop hl
    pop af
    dec a
    dec hl ; the current item was already searched, so reduce by 1
    ld c, -1
    ld de, -1
    call FindRemainingBufferItems
    pop bc
    ret

; Search for the remaining items
; a = current index
; hl = Quantity Position
; de = direction
; bc = buffer position, stop index
FindRemainingBufferItems:

.loop
    push af
    cp c
    jr z, .endOfList ; if the current index == last index, then fill out remainder with $FF

    ld a, [hl]
    and a
    jr z, .moveToNextItem ; if the quantity is 0, move to the next item

    pop af
    push af
    push hl
    call .storeNextItem
    pop hl
    jr z, .finish

.moveToNextItem
    pop af
    add e
    add hl, de
    jr .loop

.endOfList
    ld a, -1
    call .storeNextItem
    jr nz, .endOfList

.finish
    pop af
    ret

.storeNextItem
    call GetCurrentItemPointer
    ld [hl], a
    ld a, b
    add e
    ld b, a
    cp -1
    ret z
    cp 5
    ret

SaveCurrentPocketItemIndex:
    push bc
    call GetSelectedItemIndex
    cp -1
    jr nz, .notFF
    xor a ; set a to 0 instead of FF
.notFF
    ld hl, SavedPocketItemIndexPointers
    call GetPocketPointer
    ld [hl], a
    pop bc
    ret

; Returns the current item in pointer in hl based on cursor position in b
GetCurrentItemPointer:
    push af
    ld hl, wItemsVisibleInInventory
    ld a, b
    add l
    ld l, a
    jr nc, .finish
    inc h

.finish
    pop af
    ret

; Returns the item index in a based on the cursor position in b
GetSelectedItemIndex:
    call GetCurrentItemPointer
    ld a, [hl] ; a = Current selected item
    ret

UpdateDisplayForCurrentTab:
    push bc

    ; Load the GFX for this pocket
    ld hl, PocketGFXPointers
    call GetPocketPointer
    ld d, h
    ld e, l
    ld hl, vChars2
    lb bc, BANK(ItemMenuBattleBagGFX), BAGS_GFX_WIDTH * BAGS_GFX_HEIGHT
    call CopyVideoData
    
    pop bc
    push bc

    ; Get the tile offset for this pocket's tab
    ld a, c
    add a
    add a
    add c ; a = 5 * c (5 tiles per tab)

    ; Tile ID for the start of this tab
    add TABS_START_TILE_ID
    ld c, a
    sub TABS_START_TILE_ID

    ; Get the pixel offset for this pocket's tab
    inc a ; increase the number of tiles since OAM starts 1 tile offscreen
    add a
    add a
    add a ; a = 8 * a (8 pixels per tile)
    
    ld b, a ; b = OAM pixel offset
    
    ld hl, wOAMBuffer
    ld a, TAB_TILE_WIDTH

.updateOAMTilesLoop
    push af
    ; tab tile y position
    ld [hl], $10
    inc hl

    ; tab tile x position
    ld a, b
    push af ; store for "border bottom" use
    ld [hli], a
    add 8 ; move to the next tile position
    ld b, a

    ; tab tile id
    ld a, c
    inc c ; move to next tile id
    ld [hli], a

    ; tab tile flags
    xor a
    ld [hli], a

    ; "border bottom" y position
    ld [hl], $18
    inc hl

    ; "border bottom" x position
    pop af
    inc a ; shift right 1 pixel
    ld [hli], a

    ; "border bottom" tile id
    ld [hl], TAB_BOTTOM_BORDER_HIDDEN_TILE
    inc hl

    ; "border bottom" flags
    xor a
    ld [hli], a

    pop af
    dec a
    jr nz, .updateOAMTilesLoop

    ; Shift the last "border bottom" tile left 2 pixels
    ld bc, -3
    add hl, bc
    dec [hl]
    dec [hl]

    call GBPalNormal
    
    ; Restore the in-menu variables
    pop bc
    ret

UpdateInventoryCursor:
    push bc
    
    call GetSelectedItemIndex
    cp -1
    jr nz, .notEmpty

    ld bc, 0
    jr .foundYpos

.notEmpty
    ld a, $1C ; y position for top menu item
.yLoop
    add $10
    dec b
    jr nz, .yLoop
    
    ld b, a ; b = top row y pos
    add 8
    ld c, a ; c = bottom row y pos

.foundYpos
    ld hl, wOAMBuffer + 10 * 4 ; skip the TAB tiles
    ld de, 4 ; size of single OAM data
    ld a, 4 ; tile size of cursor

.loop
    ld [hl], b
    add hl, de
    cp 3
    jr nz, .noNewLine
    ld b, c
.noNewLine
    dec a
    jr nz, .loop

    pop bc
    ret

DrawItemMenuScreen:
    ld de, ItemMenuTextBoxBorderGFX
    ld hl, vChars2 + $79 * BYTES_PER_TILE
    lb bc, BANK(ItemMenuTextBoxBorderGFX), (ItemMenuTextBoxBorderGFXEnd-ItemMenuTextBoxBorderGFX) / BYTES_PER_TILE
    call CopyVideoData

    ld de, ItemMenuBattleTabGFX
    ld hl, vChars0 + TABS_START_TILE_ID * BYTES_PER_TILE
    lb bc, BANK(ItemMenuBattleTabGFX), (ItemMenuPointerGFXEnd-ItemMenuBattleTabGFX) / BYTES_PER_TILE
    call CopyVideoData

    ; Draw the tabs
    coord hl, 0, 0
    ld a, TABS_START_TILE_ID
    ld b, SCREEN_WIDTH

.drawTabsLoop
    ld [hli], a
    inc a
    dec b
    jr nz, .drawTabsLoop

   ; Fill in the bottom border
    ld b, SCREEN_WIDTH - BAGS_GFX_WIDTH
    ld a, TAB_BOTTOM_BORDER_TILE
    ld de, BAGS_GFX_WIDTH
    add hl, de
.drawTabsBottomBorderLoop
    ld [hli], a
    dec b
    jr nz, .drawTabsBottomBorderLoop

    coord hl, 0, 1
    lb bc, BAGS_GFX_WIDTH, BAGS_GFX_HEIGHT
    ld de, SCREEN_WIDTH - BAGS_GFX_WIDTH
    xor a

.drawBagsGFXOuterLoop
    push bc
    
.drawBagsGFXInnerLoop
    ld [hli], a
    inc a
    dec b
    jr nz, .drawBagsGFXInnerLoop

    pop bc
    add hl, de
    dec c
    jr nz, .drawBagsGFXOuterLoop

    ; Text box
    coord hl, 0, 12
    lb bc, 4, 18
    call TextBoxBorder

    ; Cursor
    ld hl, wOAMBuffer + 10 * 4 ; skip the TAB tiles
    ld a, 4 ; number of tiles
    ld b, $D9 ; cursor start tile

.cursorLoop
    push af
    ld [hl], 0 ; y position, will get updated during navigation
    inc hl
    bit 0, a
    ld a, $38 ; x position for the left tile
    jr z, .notRightTile
    add a, 8 ; the right tile is one tile to the right
.notRightTile
    ld [hli], a ; x position
    ld [hl], b ; tile id
    inc b
    inc hl
    ld [hl], 0 ; flags
    inc hl
    pop af
    dec a
    jr nz, .cursorLoop
; fall through
PlaceFilterTile:
    coord hl, 0, 11
    ld a, [wItemMenuFlags]
    bit 0, a ; Is the Filter enabled?
    ld a, $EC ; Empty radio tile
    jr z, .placeTile
    inc a ; Filled radio tile

.placeTile
    ld [hli], a
    ld de, .filterText
    jp PlaceString

.filterText:
    db "Filter@"

UpdateInventoryList:
    push bc
    
    ; Erase the previous entries
    coord hl, 8, 2
    push hl
    lb bc, 10, 12
    call ClearScreenArea
    
    pop hl
    pop bc
    push bc
    ld a, 0 ; buffer index

.placeItem
    push af
    push hl
    ld hl, wItemsVisibleInInventory
    ld e, a
    ld d, 0
    add hl, de ; hl = inventory index
    ld a, [hl]
    cp -1
    jr z, .noItem
    push af
    ld a, c
    cp 3 ; Machines tab
    ld a, [hl]
    jr nz, .notMachines

    add HM_01
    jr .foundID

.notMachines
    ld hl, PocketItemListPointers
    call GetPocketIndexPointer
    ld a, [hl] ; item id

.foundID
    ld [wd11e], a
    call GetItemName
    pop af
    pop hl
    push hl
    push bc
    push af
    ld de, wcd6d
    call PlaceString

    pop af
    pop bc
    ld hl, PocketItemQuantityPointers
    call GetPocketIndexPointer
    ld d, h
    ld e, l
    pop hl
    push hl
    push de
    ld de, SCREEN_WIDTH + 1
    add hl, de
    ld a, $F1 ; 'x' tile
    ld [hli], a
    lb bc, 1, 3
    pop de
    call PrintNumber

.noItem
    pop hl
    ld e, SCREEN_WIDTH
    ld d, 0
    add hl, de
    add hl, de ; HL = next line

    pop af
    pop bc
    push bc
    inc a
    cp 5
    jr nz, .placeItem

    pop bc
    ret

; If there are more than 4 elements, then wrap around
TryWrapAroundInventoryList:
    push bc
    ld a, [wItemsVisibleInInventory]
    ld hl, wItemsVisibleInInventory + 4
    cp -1
    ld a, [hld]
    jr nz, .checkEndOfList

    cp -1
    jr z, .exit ; if both sides end in -1, then exit

; Find which index to start from
    push af
    ld b, 0
    ld hl, wItemsVisibleInInventory + 1
    ld de, 1
    call .findStartBufferPosition
    ; b = starting buffer position

    xor a
    call GetPocketItemAndQuantityPointers
    ; c = max number of items
    dec c

    push bc
    ld b, 0
    add hl, bc ; hl = pocket quantity pointer
    pop bc

    pop af
    ld e, c
    ld c, a ; stop index = last index in buffer
    
    ld a, e ; start index = end of list
    ld de, -1 ; direction = updwards
    push bc
    call FindRemainingBufferItems
    pop bc
    ; If the list still starts with FF, then undo everything
    ld a, [wItemsVisibleInInventory]
    cp -1
    jr nz, .exit
    
    ld hl, wItemsVisibleInInventory+1
    jr .reset

.checkEndOfList
    cp -1
    jr nz, .exit ; if neither side ends in -1, then exit

; Search downwards
    ld b, 4
    ld de, -1
    call .findStartBufferPosition
    ; b = starting buffer position

    xor a
    call GetPocketItemAndQuantityPointers
    ; hl = pocket quantity pointer

    ld a, [wItemsVisibleInInventory]
    ld c, a ; stop index = first index in buffer
    xor a ; start index = start of list
    ld de, 1 ; direction = downwards
    push bc
    call FindRemainingBufferItems
    pop bc

    ;If the list still ends with FF, then undo everything
    ld a, [wItemsVisibleInInventory + 4]
    cp -1
    jr nz, .exit
    
    ld hl, wItemsVisibleInInventory
    ld c, b
    ld b, 0
    add hl, bc ; hl = starting position
    ld a, 4
    sub c
    ld b, a

.reset
    ld a, b
    and a
    jr z, .exit
    ld [hl], -1
    inc hl
    dec b
    jr .reset

.exit
    pop bc
    ret
    
.findStartBufferPosition
    ld a, [hl]
    cp -1
    ret nz
    add hl, de
    ld a, b
    add e
    ld b, a
    jr .findStartBufferPosition

ToggleInventoryFilter:
    push bc
    call SaveCurrentPocketItemIndex
    ld a, [wItemMenuFlags]
    bit 0, a
    set 0, a
    jr z, .storeFilterFlag
    res 0, a
.storeFilterFlag
    ld [wItemMenuFlags], a
    call PlaceFilterTile
    pop bc
    ret

