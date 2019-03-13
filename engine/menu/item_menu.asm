; TODO

; Finish properly loading item menu from Pokemart
; - Move quantity menu location
; - Make sure price and max amount is correct
; - - Get price from new table
; - Make sure screen is drawn properly after item is sold
; Show players current quantity for each item when Buying

; Need new sell screen to show description and quantity player already has
; - should show if holdable item or not as well

; Description should be clear if an item is holdable or not (or place a tile)

; Finish the Quick Use actions battle and field

; Add in santa's sack cheat for quantity on-key items

; Rename ItemMenu, item_menu, etc to Inventory

;----------------------------------------------------------

; More efficient if the quantities are stored in index order
; - rather than grouped by pocket?

; Load all item data into the new table
; - Keep 'price' as a single byte

; - Give each item an additional byte, which is the input to their Use action
; -- ie. balls will have catch rate, potions are HP restored
; -- Separate value for their Hold action?

; - Give TMs their own table...keep 'KeyItems' as regular items
; -- Store the move id here
; -- TMs use a bitfield instead of invidivual bytes

; - Update all functions to pull data from this table
; -- Update all TM function calls to use separate function
; -- Check everywhere HM_01 or TM_01 is used

;-------------------------------------------------------------

; Move Descriptions should show the type, power, accuracy, and PP

; Remove "FilteredBag" references (is that RAM location used anywhere else?)
; Find a better home for wInventoryBuffer and wInventoryFilter here since they dont need to be saved?

; Add in 'Give' item function, and way ti view inventory from party menu (for "Give" or "Use")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

ReEnterItemMenu:
    call ConfigureInventoryJoypad
    push bc
    jr DisplayItemMenu.filterLoop

ConfigureInventoryJoypad:
    ld a, 1
    ld hl, hJoy6
    ld b, [hl]
    ld [hli], a
    ld c, [hl]
    ld [hl], a
    ret

DisplayItemMenu:
    ld c, 2
    call GBFadeOutToWhiteCustomDelay
    
    ld hl, rLCDC
    set LCD_TILE_DATA_F, [hl] ; use upper sprites

    call HideSprites

    call ClearScreen
    call InitializeInventoryScreen

    ; Configure the joypad
    call ConfigureInventoryJoypad
    push bc

    call UpdateDisplayForActivePocket

    ld c, 2
    call GBFadeInFromWhiteCustomDelay
    jr .filterLoop

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

.descriptionLoop
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
    jr z, .keypressLoop

.bPressed
	ld a, SFX_PRESS_AB
	call PlaySound
    scf
    jp RestoreSetting

.aPressed
    call CanUserSelectItem
    jp nz, SelectItem
	ld a, SFX_DENIED
    call PlaySound
    jr .keypressLoop

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

.selectPressed
    call AssignQuickUse
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
    jp .textLoop

.shiftBufferUp
    call ShiftInventoryBufferUp
    jp .textLoop

; To load the gfx and draw the static portions of the Inventory screen
InitializeInventoryScreen:
    ld hl, rLCDC
    res LCD_ENABLE_F, [hl] ; turn LCD off

    ld a, BANK(InventoryScreen2GFX)
    ld hl, InventoryScreen2GFX
    ld bc, InventoryScreen2GFXEnd-InventoryScreen2GFX
    ld de, vChars0 + (TILE_FILTER_TEXT_START * BYTES_PER_TILE)
    call FarCopyData

    ld a, BANK(InventoryScreenGFX)
    ld hl, InventoryScreenGFX
    ld bc, InventoryScreenGFXEnd-InventoryScreenGFX
    ld de, vChars0 + (TILE_TABS_START * BYTES_PER_TILE)
    call FarCopyData

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
    call PlaceInventoryFilterRadioTile
    ld hl, rLCDC
    set LCD_ENABLE_F, [hl] ; turn LCD back on
    ret

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
	ld a, SFX_PRESS_AB
	call PlaySound
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
    ld hl, vChars0
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
    ret

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
    jr z, .skipQuantity

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

.skipQuantity
    ld hl, wFieldQuickUse - 1
    ld a, [wInventoryFilter]
    cp FILTER_FIELD
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
AssignQuickUse:
    xor a ; initialize a to mean do nothing
    push af
    call GetCurrentBufferValue
    cp -1
    jr z, .keypressLoop ; dont change the text if the pocket's empty

    call ClearTextBox

    ; If it is not the start menu or battle menu, then display 'cant assign' text
    ld de, .cantAssignQuickUseHereText
    ld a, [wInventoryFilter]
    and FILTER_FIELD | FILTER_BATTLE
    jr z, .placeString

    ; See if the item can be quick used
    push af
    call GetCurrentItemID
    call GetItemFilter
    ld e, a
    pop af
    bit BIT_FIELD_USE, a
    ld a, FIELD_QUICK_USE
    jr nz, .bitFound
    ld a, BATTLE_QUICK_USE

.bitFound
    and e
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
	ld a, SFX_PRESS_AB
	call PlaySound

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
UpdateItemDescription:
    ; Disable screen updates
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a

    call ClearTextBox
    call GetCurrentBufferValue
    cp -1
    ld de, PocketsEmptyText
    jr z, .placeString
    
    call GetCurrentItemID
    call GetItemDescription
    ld d, h
    ld e, l

.placeString
    ld b, BANK(PocketsEmptyText)
    coord hl, 1, 14 
    call PlaceFarString
    
    ; Enable screen updates
	ld a, 1
	ld [H_AUTOBGTRANSFERENABLED], a

    ret

; To see if the given item (a) is filtered
; Returns zero flag if its filtered
IsItemFiltered:
    call GetItemFilter
    ld hl, wInventoryFilter
    bit BIT_FIELD_USE, [hl]
    jr nz, .isField

.checkFilter
    and [hl]
    ret

; Field filtering should also hide items that get applied to a pokemon
.isField
    bit BIT_FIELD_USE, a
    ret z ; if item isn't field use, then return

    bit BIT_APPLY_TO_PK, a
    jr z, .checkFilter ; if item isn't applied to party, return success

    ; otherwise, check if there are pokemon in the party
    ld a, [wPartyCount]
    and a
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

; To select the current item
SelectItem:
    ld a, SFX_PRESS_AB
	call PlaySound
    
    call GetCurrentItemID
    ld [wcf91], a

    xor a ; unset the carry flag
    ;fall through

; To restore the prior settings
RestoreSetting:
    pop bc
    ld hl, hJoy6
    ld [hl], b
    inc hl
    ld [hl], c
    ret

; To see if the user can select the current item
; returns zero flag if user cannot select
CanUserSelectItem:
    call GetCurrentBufferValue
    cp -1
    ret z
    ld hl, wInventoryFilter
    bit BIT_FIELD_USE, [hl]
    jr nz, .field
    call GetItemIDAtPosition
    call IsItemFiltered
    ret

.field
    call GetItemIDAtPosition
    call GetItemFilter
    bit BIT_FIELD_USE, a
    jr z, .checkHold

    ; If item have a field use, check it gets applied to a pokemon
    bit BIT_APPLY_TO_PK, a
    jr z, .canUse ; if it doesnt, then it can be used (and a isnt zero since BIT_FIELD_USE is set)
    jr .checkPartyCount ; if it does, check the party count

.checkHold
    bit BIT_HOLDABLE, a
    ret z ; return if its not holdable

    ;check the party
.checkPartyCount
    ld a, [wPartyCount]
.canUse
    and a
    ret
