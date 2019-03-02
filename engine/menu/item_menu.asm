; TODO

; Create macro for the pocket attribute table
; - ues constants when checking for Moves pocket
; - Create a list of the TMs in alphabetical order for Moves pocket

; Create macro for new table for the item attributes combined table for now
; - Finish real descriptions and filter masks
; - Make sure filter is set before loading inventory screen

; Add in Sound effects
; - Start menu have sound effects?
; - Place empty radio buttons on the options screen instead of black tile

; Check "Drawing Screen.txt" to see whats next

; Finish properly loading the item menu from all locations
; Finish the Quick Use actions battle and field

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add in santa's sack cheat for quantity on-key items

; Create separate key/regular items tables
; - Update all functions which refer to an item to specify which type
; - Update the RAM to hav a single list of quantities in index ID order
;    instead of being grouped by pocket

; Remove "FilteredBag" references (is that location used anywhere else?)

; To get the pointer for the current item's quantity (hl)
GetCurrentItemQuantityPointer:
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    ld a, [hli]
    jr GetPointerToPositionInList

; To get the current item id
GetCurrentItemID:
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    ld a, [hl]
    ;fall through

; To get the item id for the given item index (a)
GetItemIDAtPosition:
    push af
    ld a, POCKET_ATTRIBUTE_ITEMS
    call GetActivePocketAttributePointer
    pop af
    call GetPointerToPositionInList
    ld a, [hl]
    ret

; To get the pointer to the quantity (hl) for the given item index (a)
GetItemQuantityPointer:
    push af
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    inc hl
    pop af
    ; fall through

; To get the pointer (hl) to the given index (a) in the given list (hl)
GetPointerToPositionInList:
    add l
    ld l, a
    ret nc
    inc h
    ret

; To get the pointer for the given attribute (a) for the active pocket
GetActivePocketAttributePointer:
    call GetPointerToActivePocketAttributeData
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ret

; To get the pointer to the given attribute (a) for the active pocket
GetPointerToActivePocketAttributeData:
    ld hl, PocketAttributesTable
    add a
    add l
    ld l, a
    jr nc, .noCarry
    inc h

.noCarry
    call GetActivePocketID
    lb bc, 0, POCKET_ATTRIBUTE_DATA_LENGTH

.loop
    and a
    ret z
    add hl, bc
    dec a
    jr .loop

; Returns the active pocket id (a)
GetActivePocketID:
    ld a, [wInventoryProperties]
    and MASK_ACTIVE_POCKET
    ret
    
; Update the active pocket based on the given direction (c)
ChangeActivePocket:
    call GetActivePocketID
    add c ; a = new pocket id
    cp -1
    jr nz, .notNegative
    ld a, NUM_POCKETS-1
    jr .updatePocket

.notNegative
    cp NUM_POCKETS
    jr nz, .updatePocket
    xor a
    
.updatePocket
    ld c, a
    ld a, [wInventoryProperties]
    and ~MASK_ACTIVE_POCKET
    add c
    ld [wInventoryProperties], a
    ret

; Returns the cursor position (a)
GetCursorPosition:
    ld a, [wInventoryProperties]
    and MASK_CURSOR_POSITION
    swap a
    ret

; Saves the cursor position (a) to wInventoryProperties
SaveCursorPosition:
    ld hl, wInventoryProperties
    res BIT_CURSOR_POSITION_HI, [hl]
    res BIT_CURSOR_POSITION_LO, [hl]
    swap a
    add [hl]
    ld [hl], a
    swap a
    ret

DisplayItemMenu:
    call GBPalWhiteOutWithDelay3
    call HideSprites

    call ClearScreen
    call InitializeInventoryScreen

    ;TODO - should this be reset afterwards?    
    ; Configure the joypad
    ld a, 1
    ld hl, hJoy6
    ld [hli], a
    ld [hl], a

.tabLoop
    call UpdateDisplayForActivePocket

.filterLoop
    call PopulateInventoryBuffer

.textLoop
    call TryWrapAroundInventoryList
    call DisplayInventoryList

.cursorLoop
    call DrawInventoryCursor
    call SaveActivePocketPosition
    call UpdateItemDescription

.keypressLoop
    call JoypadLowSensitivity

    ld a, [hJoy5]

    bit BIT_D_UP, a
    jr nz, .upPressed
    
    bit BIT_D_DOWN, a
    jr nz, .downPressed

    ld a, [hJoyPressed]

    bit BIT_SELECT, a
    jr nz, .selectPressed

    bit BIT_A_BUTTON, a
    jr nz, .aPressed

    bit BIT_START, a
    jr nz, .startPressed

    bit BIT_D_LEFT, a
    jr nz, .leftPressed

    bit BIT_D_RIGHT, a
    jr nz, .rightPressed

    bit BIT_B_BUTTON, a
    jr nz, .bPressed

    jr .keypressLoop

.bPressed
    scf
    ret

.startPressed
    call ToggleInventoryFilter
    jr .filterLoop

.leftPressed
    ld c, -1
    jr .changePocket

.rightPressed
    ld c, 1

.changePocket
    call ChangeActivePocket
    jr .tabLoop

.aPressed
    jr .keypressLoop

.selectPressed
    call AssignSelectItem
    jr .keypressLoop

.upPressed
    ld b, -1
    jr .handleNavigation

.downPressed
    ld b, 1

.handleNavigation
    call GetCursorPosition
    add b
    ld b, a
    call GetBufferValueAtPosition
    cp -1
    jr z, .keypressLoop ; do nothing if the new position is empty
    
.navigate
    ld a, b ; a = new cursor position

    and a
    jr z, .shiftBufferDown

    cp INVENTORY_BUFFER_SIZE - 1
    jr z, .shiftBufferUp

    ; update cursor if it moved
    call SaveCursorPosition
    jr .cursorLoop

.shiftBufferDown
    call ShiftInventoryBufferDown
    jr .textLoop

.shiftBufferUp
    call ShiftInventoryBufferUp
    jr .textLoop

GetJoypadUpDownHeld:
    ret

; To load the gfx and draw the static portions of the Inventory screen
InitializeInventoryScreen:
    ld de, InventoryScreen2GFX
    ld hl, vChars2 + (TILE_FILTER_TEXT_START * BYTES_PER_TILE)
    lb bc, BANK(InventoryScreen2GFX), (InventoryScreen2GFXEnd-InventoryScreen2GFX) / BYTES_PER_TILE
    call CopyVideoData

    ld de, InventoryScreenGFX
    ld hl, vChars0 + TILE_TABS_START * BYTES_PER_TILE
    lb bc, BANK(InventoryScreenGFX), (InventoryScreenGFXEnd-InventoryScreenGFX) / BYTES_PER_TILE
    call CopyVideoData

    ; Place the tab top tiles
    coord hl, 0, 0
    ld a, TILE_TABS_START
    ld b, NUM_POCKETS * GFX_TAB_WIDTH

.drawTabsLoop
    ld [hli], a
    inc a
    dec b
    jr nz, .drawTabsLoop

   ; Place the tab bottom tiles
    ld b, SCREEN_WIDTH
    ld a, TILE_TAB_BOTTOM_SOLID
.drawTabsBottomBorderLoop
    ld [hli], a
    dec b
    jr nz, .drawTabsBottomBorderLoop

    ; Place the Pocket GFX tiles
    coord hl, 0, 2
    lb bc, GFX_POCKETS_WIDTH, GFX_POCKETS_HEIGHT
    ld de, SCREEN_WIDTH - GFX_POCKETS_WIDTH
    xor a ; TILE_POCKETS_START = $00

.placePocketsGFXOuterLoop
    push bc
    
.placePocketsGFXInnerLoop
    ld [hli], a
    inc a
    dec b
    jr nz, .placePocketsGFXInnerLoop

    pop bc
    add hl, de
    dec c
    jr nz, .placePocketsGFXOuterLoop

    ; Place the text box
    coord hl, 0, 13
    lb bc, 3, 18
    call TextBoxBorder

    coord hl, 1, 13
    ld b, 18
    ld a, TILE_TEXTBOX_BORDER_TOP

.replaceTopBorderLoop
    ;ld [hli], a
    dec b
    jr nz, .replaceTopBorderLoop

    ; Place the cursor 
    ld hl, wOAMBuffer + (GFX_TAB_WIDTH*2) * OAM_BYTE_SIZE ; skip the tab tiles
    ld a, GFX_CURSOR_SIZE ; number of tiles
    ld b, TILE_CURSOR_START ; cursor start tile

.cursorLoop
    push af

    ld [hl], 0 ; initial y position
    inc hl
    
    bit 0, a ; is this a left or right tile?
    ld a, OAM_CURSOR_X ; left tile x position
    jr z, .placeXPosition
    add a, PIXELS_PER_TILE ; right tile x position
.placeXPosition
    ld [hli], a ; x position

    ld a, b
    inc b
    ld [hli], a ; tile id
    
    xor a
    ld [hli], a ; flags

    pop af
    dec a
    jr nz, .cursorLoop

    coord hl, 2, 12
    ld a, TILE_FILTER_TEXT_START
    ld b, GFX_FILTER_WIDTH

.placeFilterTopLoop
    ld [hli], a
    inc a
    dec b
    jr nz, .placeFilterTopLoop

    ;fall through

PlaceInventoryFilterRadioTile:
    ld a, [wInventoryProperties]
    bit BIT_INVENTORY_FILTER, a ; Is the Filter enabled?
    ld a, TILE_FILTER_OFF_START
    
    jr z, .placeTile
    ld a, TILE_FILTER_ON_START

.placeTile
    coord hl, 0, 12
    ld [hli], a
    inc a
    ld [hl], a
    ret

; To toggle the filter
ToggleInventoryFilter:
    ld hl, wInventoryProperties
    bit BIT_INVENTORY_FILTER, [hl]
    set BIT_INVENTORY_FILTER, [hl]
    jr z, .placeTile
    res BIT_INVENTORY_FILTER, [hl]
.placeTile
    call PlaceInventoryFilterRadioTile
    ret

; To update the screen based on the active pocket
UpdateDisplayForActivePocket:
    ; Update the active pocket's GFX
    ld a, POCKET_ATTRIBUTE_GFX
    call GetActivePocketAttributePointer
    ld d, h
    ld e, l
    ld hl, vChars2
    lb bc, BANK(InventoryBattlePocketGFX), GFX_POCKETS_WIDTH * GFX_POCKETS_HEIGHT
    call CopyVideoData
    
    ; Update the active pocket's tab GFX
    call GetActivePocketID
    ld b, a
    add a
    add a
    add b ; a = tab start tile location, pocket id * 5 (5 tiles per tab)

    push af
    add TILE_TABS_START
    ld c, a ; c = tab start tile id
    pop af

    inc a ; increase the number of tiles since OAM starts 1 tile offscreen
    add a
    add a
    add a
    ld b, a ; a = tab start pixel location, tile location * 8 (8 pixels per tile)
    
    ld hl, wOAMBuffer
    lb de, GFX_TAB_WIDTH, -3 ; the -3 gets added to hl at the very end

.drawTabLoop
    ; Tab top tile
    ld a, OAM_TAB_TOP_Y
    ld [hli], a ; y position
    
    ld a, b
    ld [hli], a ; x position

    ld a, c
    ld [hli], a ; tile id
    inc c ; next tile id

    xor a
    ld [hli], a ; flags

    ; Tab bottom tile
    ld a, OAM_TAB_BOTTOM_Y
    ld [hli], a ; y position

    ld a, b
    inc a ; shift right 1 pixel
    ld [hli], a ; x position
    add PIXELS_PER_TILE - 1 ; next tile x position
    ld b, a

    ld a, TILE_TAB_BOTTOM_HIDDEN
    ld [hli], a ; tile id 

    xor a
    ld [hli], a ; flags

    dec d
    jr nz, .drawTabLoop

    ; Shift the last tab bottom tile left 2 pixels
    dec d
    add hl, de
    dec [hl]
    dec [hl]
    jp GBPalNormal

; Returns value (a) in inventory buffer at the current cursor position
GetCurrentBufferValue:
    call GetCursorPosition
    ; fall through

; Returns value (a) in inventory buffer at provided position (a)
GetBufferValueAtPosition:
    call GetBufferPointerAtPosition
    ld a, [hl]
    ret

; Returns pointer (hl) to inventory buffer at the current cursor position
GetCurrentBufferPointer:
    call GetCursorPosition
    ; fall through
    
; Returns pointer (hl) to inventory buffer at provided position (a)
GetBufferPointerAtPosition:
    ld hl, wInventoryBuffer
    add l
    ld l, a
    ret nc
    inc hl
    ret

; To populate the inventory item list buffer based on active pocket and cursor position
PopulateInventoryBuffer:
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    ld a, [hl] ; a = saved position
    
    push af
    call GetCurrentItemQuantityPointer
    push hl

    ld a, POCKET_ATTRIBUTE_SIZE
    call GetPointerToActivePocketAttributeData
    ld c, [hl] ; c = stop when end of list reached

    call GetCursorPosition
    ld b, a ; b = current buffer index
    
    pop hl ; hl = current item quantity pointer
    pop af ; a = start index
    ld de, 1 ; de = search downwards

    push af
    push hl
    push bc
    call PopulateRemainingInventoryBufferItems

    call GetCurrentBufferValue
    cp -1
    pop bc ; b = current buffer index
    jr z, .isEmpty

    ; If the current buffer position is not empty,
    ; then shift the search start to the precending entry
    dec b

.isEmpty
    pop hl
    pop af
    dec hl
    dec a ; start at the preceding item (current item was already searched)
    ld c, -1 ; c = stop when start of list reached
    ld de, -1 ; de = search upwards
    ; fall through

    jp PopulateRemainingInventoryBufferItems

; Search for the remaining items
; a = item start index
; hl = quantity pointer
; de = direction
; bc = buffer start position, item stop index
PopulateRemainingInventoryBufferItems:
.loop
    push af
    cp c
    jr z, .endOfList ; if the current index == stop index, then fill out remainder with $FF

    ld a, [hl]
    and a
    jr z, .moveToNextItem ; if the quantity is 0, move to the next item

    ld a, [wInventoryProperties]
    bit BIT_INVENTORY_FILTER, a
    jr z, .noFilter

    pop af
    push af
    push hl
    push de
    push bc
    call GetItemIDAtPosition
    call IsItemFiltered
    pop bc
    pop de
    pop hl
    jr z, .moveToNextItem ; if the item is filtered, then don't draw

.noFilter
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
    push af
    ld a, b
    call GetBufferPointerAtPosition
    pop af
    ld [hl], a ; store the index to the buffer
    ld a, b
    add e
    ld b, a ; move to next buffer position
    cp -1
    ret z
    cp INVENTORY_BUFFER_SIZE
    ret

; If there are empty slots in the buffer, try to wrap around to the other end of the list
; If the list is shorter than 5 items, then don't do this
TryWrapAroundInventoryList:
    ld a, [wInventoryBuffer]
    ld hl, wInventoryBuffer + 4
    cp -1
    ld a, [hl]
    jr nz, .checkEndOfList

    cp -1
    ret z ; if both sides end in -1, then exit

    ; Start of the list is empty
    push af ; store the last item in the buffer
    ld hl, wInventoryBuffer + 1 ; start the buffer search from the 2nd position
    ld b, 0 ; set initial buffer position to 0 (already know its empty)
    ld de, 1 ; search upwards
    call .findNonEmptyBufferPosition ; b = buffer position to start from

    push bc
    ld a, POCKET_ATTRIBUTE_SIZE
    call GetPointerToActivePocketAttributeData
    ld e, [hl]
    dec e ; e = index of last item in list

    ld a, e
    call GetItemQuantityPointer ; hl = pointer to quantity of last item in list
    pop bc

    pop af
    ld c, a ; c = stop index, the last item index stored in buffer
    ld a, e ; a = start index, end of list
    ld de, -1 ; search upwards

    push bc
    call PopulateRemainingInventoryBufferItems
    pop bc
    
    ; If the list still starts with FF, then undo everything
    ld a, [wInventoryBuffer]
    cp -1
    ret nz
    
    ld hl, wInventoryBuffer+1
    ld a, b
    inc a ; a = number of entries to erase
    jr .reset

.checkEndOfList
    cp -1
    ret nz ; if neither side ends in -1, then exit
    
    ; End of the list is empty
    dec hl ; start the buffer search from 4th position
    ld b, INVENTORY_BUFFER_SIZE - 1 ; set initial buffer position to 4 (already know its empty)
    ld de, -1 ; search downwards
    call .findNonEmptyBufferPosition ; b = buffer position to start from
    
    push bc
    xor a
    call GetItemQuantityPointer ; hl = pointer to quantity of first item in list
    pop bc
    
    ld a, [wInventoryBuffer]
    ld c, a ; c = stop index = first index in buffer
    xor a ; a = start index, start of list
    ld de, 1 ; search downwards
    push bc
    call PopulateRemainingInventoryBufferItems
    pop bc

    ;If the list still ends with FF, then undo everything
    ld a, [wInventoryBuffer + 4]
    cp -1
    ret nz
    
    ld hl, wInventoryBuffer
    ld c, b
    ld b, 0
    add hl, bc ; hl = starting position
    ld a, INVENTORY_BUFFER_SIZE
    sub c ; a = number of entries to erase

.reset
    dec a
    ret z
    ld [hl], -1
    inc hl
    jr .reset
    
.findNonEmptyBufferPosition
    ld a, [hl]
    cp -1
    ret nz
    add hl, de
    ld a, b
    add e
    ld b, a
    jr .findNonEmptyBufferPosition

; To print the inventory list on the screen
DisplayInventoryList:

    ; Disable screen updates
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a

    ; Erase the previous entries
    coord hl, 8, 2
    push hl
    lb bc, 10, 12
    call ClearScreenArea
    
    pop hl
    xor a ; first buffer position

.placeItem
    push af
    push hl
    call GetBufferValueAtPosition
    cp -1
    jp z, .nextItem
    
    push af
    ld a, [hl]
    call GetItemIDAtPosition
    ld [wd11e], a
    ld [wcf91], a

    cp HM_01
    jr c, .notMove

    call GetMachineMoveName
    jr .nameFound

.notMove
    call GetItemName
    
.nameFound
    pop af
    pop hl
    push hl
    push af
    ld de, wcd6d
    call PlaceString

    call IsKeyItem
    ld a, [wIsKeyItem]
    ld b, a
    pop af
    dec b
    jr z, .nextItem

    call GetItemQuantityPointer
    ld d, h
    ld e, l
    pop hl

    push hl
    push de

    ld de, SCREEN_WIDTH + 1
    add hl, de
    ld a, "x"
    ld [hli], a
    lb bc, LEFT_ALIGN + 1, 3
    pop de
    call PrintNumber

    ld hl, wFieldQuickUse - 1
    ld a, [wInventoryFilter]
    cp FILTER_START_MENU
    jr z, .checkQuickUse

    ld hl, wBattleQuickUse - 1
    cp FILTER_BATTLE
    jr z, .checkQuickUse

    cp FILTER_POKEMART
    jr nz, .nextItem

    ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
    ld de, ItemPrices
    ld hl, wItemPrices
    ld [hl], e
    inc hl
    ld [hl], d
    call GetItemPrice

    ; TODO - Just check the filter
    ; If the price is zero, dont print
    ld hl, hItemPrice
    xor a
    cp [hl]
    jr nz, .notZero
    inc hl
    cp [hl]
    jr nz, .notZero
    inc hl
    cp [hl]
    jr z, .nextItem

.notZero
    push de
    call HalveItemPrice
    pop de
    pop hl
    push hl
    ld bc, SCREEN_WIDTH + 4
    add hl, bc
    ld c, LEADING_ZEROES | MONEY_SIGN | 3
    call PrintBCDNumber
    jr .nextItem

.checkQuickUse
    ; See if the item is a quick use
    ld a, [wd11e]
    ld d, 5
.findInListLoop
    inc hl
    dec d
    jr z, .nextItem

    cp [hl]
    jr nz, .findInListLoop

    ; Draw the SEL tiles
    pop hl
    push hl
    ld bc, SCREEN_WIDTH + 7
    add hl, bc

    ; Place the SEL tiles
    ld a, TILE_SELECT_START
    ld [hli], a
    inc a
    ld [hli], a
    inc a
    ld [hli], a

    ; place the arrow tile
    ld a, TILE_ARROW_TILES_START - 1
    add d
    ld [hl], a

.nextItem
    pop hl
    ld de, SCREEN_WIDTH*2
    add hl, de ; skip 2 lines

    pop af
    inc a
    cp INVENTORY_BUFFER_SIZE
    jp nz, .placeItem

    ; Enable screen updates
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a
    ret

; To draw the cursor on screen at the current position
DrawInventoryCursor:    
    call GetCurrentBufferValue
    cp -1
    jr nz, .notEmpty

    ld bc, 0
    jr .foundYpos

.notEmpty
    call GetCursorPosition
    swap a ; shorthand for: a * 2 * PIXELS_PER_TILE 
    add OAM_CURSOR_Y_START ; y position for top menu item

    ld b, a ; b = top row y pos
    add PIXELS_PER_TILE
    ld c, a ; c = bottom row y pos

.foundYpos
    ld hl, wOAMBuffer + (GFX_TAB_WIDTH*2) * OAM_BYTE_SIZE ; skip the TAB tiles
    ld de, OAM_BYTE_SIZE ; size of single OAM data
    ld a, GFX_CURSOR_SIZE ; tile size of cursor

.loop
    ld [hl], b
    add hl, de
    cp 3
    jr nz, .noNewLine
    ld b, c ; shift to the bottom row after 2 tiles

.noNewLine
    dec a
    jr nz, .loop
    ret

; Saves the current item index to the active pocket's "SavedIndex" RAM location
SaveActivePocketPosition:
    call GetCurrentBufferValue
    cp -1
    jr nz, .notFF
    xor a ; set to 0 instead of FF
.notFF
    push af
    ld a, POCKET_ATTRIBUTE_POSITION
    call GetActivePocketAttributePointer
    pop af
    ld [hl], a
    ret

; To shift the inventory buffer up 1 slot and replace the last position
ShiftInventoryBufferDown:
    ld hl, wInventoryBuffer + 4
    ld de, wInventoryBuffer + 3
    ld b, INVENTORY_BUFFER_SIZE - 1

.loop
    ld a, [de]
    dec de
    ld [hld], a
    dec b
    jr nz, .loop
    
    push af
    call GetItemQuantityPointer ; hl = quantity pointer for first item in buffer
    pop af
    lb bc, 0, -1 ; b = first slot in buffer, c = stop when start of list reached
    ld de, -1 ; search upwards
    jp PopulateLastInventoryBufferSlot

; To shift the inventory buffer down 1 slot and replace the first position
ShiftInventoryBufferUp:
    ld hl, wInventoryBuffer
    ld de, wInventoryBuffer + 1 
    ld b, INVENTORY_BUFFER_SIZE - 1

.loop
    ld a, [de]
    inc de
    ld [hli], a
    dec b
    jr nz, .loop

    push af
    call GetItemQuantityPointer ; hl = quantity pointer for last item in buffer
    push hl
    ld a, POCKET_ATTRIBUTE_SIZE
    call GetPointerToActivePocketAttributeData
    ld c, [hl] ; c = stop when end of list reached
    pop hl
    pop af
    ld de, 1 ; search downwards
    ld b, INVENTORY_BUFFER_SIZE - 1 ; place it at the last slot in the buffer
    ;fall through

; To fill the remaining item in the inventory buffer
PopulateLastInventoryBufferSlot:
    add hl, de
    add e ; shift so it doesnt check the previous item
    jp PopulateRemainingInventoryBufferItems

; To assign the current item to the select button + direction
AssignSelectItem:
    xor a ; initialize a to mean do nothing
    push af
    call GetCurrentBufferValue
    cp -1
    jr z, .keypressLoop ; dont change the text if the pocket's empty

    call ClearTextBox

    ; If it is not the start menu or battle menu, then display 'cant assign' text
    ld de, .cantAssignQuickUseHereText
    ld a, [wInventoryFilter]
    and FILTER_START_MENU | FILTER_BATTLE
    jr z, .placeString

    ; If the item doesn't pass the filter, then it cant be assigned
    call IsCurrentItemFiltered
    ld de, .cantAssignQuickUseItemText
    jr z, .placeString

    ;Otherwise, can assign quick use
    ld de, .pressDirectionText
    pop af
    inc a
    push af ; set a to 1, meaning handle other keys

.placeString
    coord hl, 1, 14 
    call PlaceString

.keypressLoop
    call JoypadLowSensitivity

    ; Exit only when no keys are pressed
    ld a, [hJoyHeld]
    and a
    jr z, .exit

    pop af
    push af
    and a
    jr z, .keypressLoop  ; do nothing if a is 0

    ld a, [hJoy5]

    ld e, 4 ; start index
    bit BIT_D_DOWN, a
    jr nz, .foundDirection

    dec e
    bit BIT_D_UP, a
    jr nz, .foundDirection

    dec e
    bit BIT_D_LEFT, a
    jr nz, .foundDirection

    dec e
    bit BIT_D_RIGHT, a
    jr z, .keypressLoop

.foundDirection
    ld hl, wFieldQuickUse - 1
    ld a, [wInventoryFilter]
    cp FILTER_BATTLE
    jr nz, .notBattle
    ld hl, wBattleQuickUse -1

.notBattle
    push hl
    call GetCurrentItemID ; a = id of current item
    pop hl
    push hl

; Find the current item in the list
    ld d, SELECT_ACTIONS_LENGTH + 1 ; since HL is 1 less than list start

.findInListLoop
    inc hl
    dec d
    jr z, .notInList

    cp [hl]
    jr nz, .findInListLoop
    
    ; If the item exists in the list, then clear that location
    ld [hl], -1
    ld b, a
    ld a, SELECT_ACTIONS_LENGTH + 1
    sub d
    cp e
    ld a, b
    jr nz, .doStore ; dont store if just erased same slot
    ld a, -1
    
.doStore
    ld d, 0

.notInList
    pop hl
    add hl, de
    ld [hl], a
    ; TODO - set the flag to signify if Key or Regular item

    call DisplayInventoryList
    jr .keypressLoop

.exit
    pop af
    jp UpdateItemDescription

.pressDirectionText
    db "Press ", TILE_DPAD, " to assign"
    next "item for Quick Use@"

.cantAssignQuickUseHereText
    db "Can't assign Quick"
    next "Use item here@"

.cantAssignQuickUseItemText
    db "Can't assign this"
    next "item for Quick Use@"

; To print the description for the current item
; TODO - get from table
UpdateItemDescription:

    ; Disable screen updates
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a

    call ClearTextBox
    call GetCurrentBufferValue
    cp -1
    ld de, .pocketsEmptyText
    jr z, .placeString
    ld de, .comingSoonText

.placeString
    coord hl, 1, 14 
    call PlaceString
    
    ; Enable screen updates
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a

    ret

.pocketsEmptyText
    db "There nothing in"
    line "this pocket!@"

.comingSoonText
    db "Coming Soon...@"

; To see if the current item is filtered
; Returns zero flag if its filtered
IsCurrentItemFiltered:
    call GetCurrentBufferValue
    cp -1
    ret z
    call GetCurrentItemID
    ;fall through

; To see if the given item (a) is filtered
; Returns zero flag if its filtered
IsItemFiltered:
    ; TODO - get from table
    bit 0, a ; fake check for testing
    ret

; To halve the price of the item
HalveItemPrice:
    ld hl, hItemPrice
    ld de, hMoney
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hli]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    
    ; halve the price
    xor a
	ld [hDivideBCDDivisor], a
	ld [hDivideBCDDivisor + 1], a
	ld a, 2
	ld [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3 ; halves the price
; store the halved price
	ld a, [hDivideBCDQuotient]
	ld [hItemPrice], a
	ld a, [hDivideBCDQuotient + 1]
	ld [hItemPrice + 1], a
	ld a, [hDivideBCDQuotient + 2]
	ld [hItemPrice + 2], a
    ret