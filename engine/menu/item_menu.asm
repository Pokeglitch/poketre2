; TODO - Use Common names
; - 'Inventory' instead of Item/Item Screen
; - 'Moves' instead of 'Machine'
; - 'Pocket' instead of Tab
; - Cursor instead of Pointer
; - Buffer instead of 'Visible Items List'
; Make sure constants are used in all possible areas
; the in menu variables for index refer to the Top Value on the screen, not the last selected value
; Only need 1 $FF between the pocket item id lists, not 2
; Cleanup and add proper comments/routine names
; Add in printing the names for the "Machines" list
; - and price/quantity

TABS_START_TILE_ID = $C0
TAB_TILE_WIDTH = 5
TAB_BOTTOM_BORDER_TILE = $D4
ITEM_MENU_LIGHT_GRAY_TILE = $D8
BAGS_GFX_WIDTH = 8
BAGS_GFX_HEIGHT = 9

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
    call InitializeInventoryItemsBuffer

.textLoop
    call UpdateInventoryList

.cursorLoop
    call UpdateInventoryCursor
    ;call UpdateItemDescription

.keypressLoop
    push bc
    call JoypadLowSensitivity
    pop bc
    ld a, [hJoy5]
    and ~START ; Ignore START
    jr z, .keypressLoop

    bit BIT_A_BUTTON, a
    jr nz, .aPressed

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
    ld b, 1
    ld c, a
    jp FindPreviousItemsForBuffer

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
    inc de
    inc a ; increment to the next index
    ld b, 4
    ld c, a
    jp FindNextItemsForBuffer

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
; TODO - when using a single FF betweens lists, move the pointer to after the FF and remove the +1
    dw BattleItems + 1
    dw FieldItems + 1
    dw HealthItems + 1
    ;dw MachineItems + 1
    ;TODO - temp for now...
    dw HealthItems + 1

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

; To get the pocket item (hl) and quantity (de) pointers based on index (a) and pocket (c)
GetPocketItemAndQuantityPointers:
    ld hl, PocketItemQuantityPointers
    call GetPocketIndexPointer
    ld d, h
    ld e, l ; de = pointer to quantity of last selected item
    
    ld hl, PocketItemListPointers
    jp GetPocketIndexPointer ; hl = pointer to ID of last selected item
    
; Populate the list of current items visible on the inventory
InitializeInventoryItemsBuffer:
    push bc

    ld hl, SavedPocketItemIndexPointers
    call GetPocketPointer
    ld a, [hl] ; a = index to last selected item

    call GetPocketItemAndQuantityPointers
    ld c, a ; c = index of last selected item

    push hl
    push de
    push bc
    call FindNextItemsForBuffer
    pop bc

    call GetCurrentItemPointer
    ld a, [hl]
    cp -1
    jr nz, .dontIncB

    ; If there is no item at the current cursor position
    ; then increase the b position so the first "previous" item
    ; found will be stored at the current cursor position
    inc b

.dontIncB
    pop de
    pop hl
    call FindPreviousItemsForBuffer
    pop bc
    ret

; Search downwards for next items
FindNextItemsForBuffer:
.loop
    ld a, [hl]
    cp -1
    jr z, .endOfList

    ld a, [de]
    and a
    jr z, .moveToNextItem

    call .storeNextItem
    ret z

.moveToNextItem
    inc c
    inc de
    inc hl
    jr .loop

.endOfList
    ld c, a

.endOfListLoop
    call .storeNextItem
    jr nz, .endOfListLoop
    ret

.storeNextItem:
    call StoreItemToInventoryBuffer
    inc b
    ld a, 5
    cp b
    ret

FindPreviousItemsForBuffer:
; Search upwards for previous items
.loop
    dec c
    dec de
    dec hl

    ld a, [hl]
    cp -1
    jr z, .startOfList

    ld a, [de]
    and a
    jr z, .loop

    call .storePreviousItem
    ret z

    jr .loop

.startOfList
    ld c, a

.startOfListLoop
    call .storePreviousItem
    jr nz, .startOfListLoop
    ret

.storePreviousItem:
    dec b
    push af
    call StoreItemToInventoryBuffer
    pop af
    ret

; Store the index (c) to buffer at index (b-1)
StoreItemToInventoryBuffer:
    push hl
    call GetCurrentItemPointer
    ld [hl], c
    pop hl
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
    ld [hl], ITEM_MENU_LIGHT_GRAY_TILE
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
    ld b, SCREEN_WIDTH
    ld a, TAB_BOTTOM_BORDER_TILE
.drawTabsBottomBorderLoop
    ld [hli], a
    dec b
    jr nz, .drawTabsBottomBorderLoop

    coord hl, 0, 2
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
    ld b, $DA ; cursor start tile

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

    ret

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

    ld hl, PocketItemListPointers
    call GetPocketIndexPointer
    ld a, [hl] ; item id
    ld [wd11e], a
    call GetItemName
    
    ld de, wcd6d
    pop hl
    push hl
    call PlaceString

    ; TODO - price and quantity

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
