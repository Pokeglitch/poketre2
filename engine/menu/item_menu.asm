; 5 visible, but only 3 on the screen are selectable
TABS_START_TILE_ID = $C0
TAB_TILE_WIDTH = 5
TAB_BOTTOM_BORDER_TILE = $D4
BAGS_GFX_WIDTH = 8
BAGS_GFX_HEIGHT = 9

DisplayItemMenu:
    call GBPalWhiteOutWithDelay3
    call HideSprites

    call ClearScreen

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

    coord hl, 0, 12
    lb bc, 4, 18
    call TextBoxBorder

    ; Initialize the values
    ; b, c, d, e = Most recent accessed item index for each tab
    ; h = current tab
    ; l = current pointer position (0-2)

    
    ld a, [wWhichInventoryTab]
    inc a
    ld h, a ; h = current tab

.tabLoop
    push bc
    push de
    push hl
    call UpdateDisplayForCurrentTab
    pop hl
    pop de
    pop bc
.textLoop
    ; Print item names for current tab

.oamLoop

.keypressLoop
    call JoypadLowSensitivity
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
    jr .finish


.leftPressed
    dec h
    jr nz, .tabLoop
    ld h, 4
    jr .tabLoop

.rightPressed
    inc h
    ld a, 5
    cp h
    jr nz, .tabLoop
    ld h, 1
    jr .tabLoop

.aPressed
.selectPressed
.upPressed
.downPressed
    scf

.finish
    push af

    ; If there are item prices, then it is the "sell" menu, so don't save
    ld a, [wPrintItemPrices]
    and a
    jr nz, .exit

    ld a, h
    dec a
    ld [wWhichInventoryTab], a

.exit
    pop af
    ret

UpdateDisplayForCurrentTab:
    ld a, h
    push af

   ; Fill in the bottom border
    coord hl, 0, 1
    ld b, SCREEN_WIDTH
    ld a, TAB_BOTTOM_BORDER_TILE
.drawTabsBottomBorderLoop
    ld [hli], a
    dec b
    jr nz, .drawTabsBottomBorderLoop

    pop af
    push af
    ld c, a
    xor a

.getTabTileOffset
    dec c
    jr z, .foundTabTileOffset
    add TAB_TILE_WIDTH
    jr .getTabTileOffset

.foundTabTileOffset
    ld d, 0
    ld e, a

    ; Erase the bottom border tiles
    coord hl, 0, 1
    add hl, de
    ld b, TAB_TILE_WIDTH
    ld a, " "

.eraseTabBottomBorderLoop
    ld [hli], a
    dec b
    jr nz, .eraseTabBottomBorderLoop

    pop af
    push de

    ld de, ItemMenuBattleBagGFX
    dec a
    jr z, .loadBagGFX

    ld de, ItemMenuFieldBagGFX
    dec a
    jr z, .loadBagGFX

    ld de, ItemMenuHealthBagGFX
    dec a
    jr z, .loadBagGFX

    ld de, ItemMenuMovesBagGFX

.loadBagGFX
    ld hl, vChars2
    lb bc, BANK(ItemMenuBattleBagGFX), BAGS_GFX_WIDTH * BAGS_GFX_HEIGHT
    call CopyVideoData

; Update the OAM
    pop de
    coord hl, 0, 0
    add hl, de

    ld a, e
    inc a
    add a
    add a
    add a ; a = e * 8
    ld b, a
    ld d, h
    ld e, l

    ld hl, wOAMBuffer
    ld c, TAB_TILE_WIDTH

.updateOAMTilesLoop
    ld [hl], $10
    inc hl
    ld a, b
    ld [hli], a
    add 8
    ld b, a
    ld a, [de]
    inc de
    ld [hli], a
    xor a
    ld [hli], a
    dec c
    jr nz, .updateOAMTilesLoop

    jp GBPalNormal