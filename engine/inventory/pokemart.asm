DisplayPokemartDialogue_:
.loop
	ld a, [wMenuExitMethod]
	cp CANCELLED_MENU
	jp z, .done
	ld a, [wChosenMenuItem]
	and a ; buying?
	jp z, .buyMenu
	call SaveScreenTilesToBuffer1 ; save screen

	ld a, FILTER_POKEMART
	ld [wInventoryFilter], a
	
	xor a
    ld [wUpdateSpritesEnabled], a ; Disable sprite updates

	call DisplayItemMenu

.handleInventoryChosen
	jr nc, .confirmItemSale ; if an item was selected

	; Otherwise, return to the Greeting menu
	call ReloadPokemartDataFromInventory

	ld hl, PokemartAnythingElseText
	call PrintText
	jr .loop

.confirmItemSale ; if the player is trying to sell a specific item
	ld a, [wcf91]
	ld [wWhichItem], a
	
	call GetCurrentItemQuantityPointer
	ld a, [hl]
	ld [wMaxItemQuantity], a

	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	
    ld de, ItemPrices
    ld hl, wItemPrices
    ld [hl], e
    inc hl
    ld [hl], d
    call GetItemPrice

	ld [hHalveItemPrices], a ; halve prices when selling
	call DisplayChooseQuantityMenu
	inc a
	jr z, .reenterSellMenu ; if the player closed the choose quantity menu with the B button
	
	call ClearTextBox

	coord hl, 1, 14
	ld de, QuantityMenuConfirmString
	call PlaceString
	
	coord hl, 2, 16
	ld de, SellString
	call PlaceString
	
	coord hl, 11, 16
	ld de, CancelText
	call PlaceString

	coord de, 1, 16
	farcall HandleTwoOptionMenuInputs_DrawInitialRadios
	ld a, d

	push af
	ld a, SFX_PRESS_AB
	call PlaySound
	pop af

	and a
	jr nz, .reenterSellMenu

	call AddAmountSoldToMoney
	call RemoveItemFromInventory

.reenterSellMenu	
	call ReEnterItemMenu
	jp .handleInventoryChosen

.buyMenu
; the same variables are set again below, so this code has no effect
	ld a, 1
	ld [wPrintItemPrices], a
	ld a, INIT_OTHER_ITEM_LIST
	ld [wInitListType], a
	callab InitList
	call SaveScreenTilesToBuffer1
.buyMenuLoop
	call LoadScreenTilesFromBuffer1
	call FullyRevealWindow
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wCurrentMenuItem], a
	inc a
	ld [wPrintItemPrices], a
	inc a ; a = 2 (PRICEDITEMLISTMENU)
	ld [wListMenuID], a
	call DisplayListMenuID
	jr c, .returnToMainPokemartMenu ; if the player closed the menu
	ld a, 99
	ld [wMaxItemQuantity], a
	xor a
	ld [hHalveItemPrices], a ; don't halve item prices when buying
	call DisplayChooseQuantityMenu
	inc a
	jr z, .buyMenuLoop ; if the player closed the choose quantity menu with the B button
	ld a, [wcf91] ; item ID
	ld [wd11e], a ; store item ID for GetItemName
	call GetItemName
	call CopyStringToCF4B ; copy name to wcf4b
	ld hl, PokemartTellBuyPriceText
	call PrintText
	coord hl, 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM
	jp z, .buyMenuLoop ; if the player chose No or pressed the B button

; The following code is supposed to check if the player chose No, but the above
; check already catches it.
	ld a, [wChosenMenuItem]
	dec a
	jr z, .buyMenuLoop

.buyItem
	call .isThereEnoughMoney
	jr c, .notEnoughMoney
	call AddItemToInventory
	jr nc, .bagFull
	call SubtractAmountPaidFromMoney
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld hl, PokemartBoughtItemText
	call PrintText
	jp .buyMenuLoop
.returnToMainPokemartMenu
	call LoadScreenTilesFromBuffer1
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a ; hide the window
	call UpdateSprites
	ld hl, PokemartAnythingElseText
	call PrintText
	jp .loop
.isThereEnoughMoney
	ld de, wPlayerMoney
	ld hl, hMoney
	ld c, 3 ; length of money in bytes
	jp StringCmp
.notEnoughMoney
	ld hl, PokemartNotEnoughMoneyText
	call PrintText
	jr .returnToMainPokemartMenu
.bagFull
	ld hl, PokemartItemBagFullText
	call PrintText
	jr .returnToMainPokemartMenu
.done
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	call UpdateSprites
	ld a, [wSavedListScrollOffset]
	ld [wListScrollOffset], a
	ret

ReloadPokemartDataFromInventory:
	ld c, 2
	call GBFadeOutToWhiteCustomDelay
	
    ld hl, rLCDC
    res LCD_TILE_DATA_F, [hl] ; switch tiles back

	ld a, 1
	ld [wUpdateSpritesEnabled], a ; re-enable sprites

	; Move window offscreen
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a

	call ReloadMapSpriteTilePatterns
	call LoadScreenTilesFromBuffer1
	call UpdateSprites
	call Delay3
	
	ld c, 2
	jp GBFadeInFromWhiteCustomDelay

PokemartTellBuyPriceText:
	TX_FAR _PokemartTellBuyPriceText
	db "@"

PokemartBoughtItemText:
	TX_FAR _PokemartBoughtItemText
	db "@"

PokemartNotEnoughMoneyText:
	TX_FAR _PokemartNotEnoughMoneyText
	db "@"

PokemartItemBagFullText:
	TX_FAR _PokemartItemBagFullText
	db "@"

PokemartAnythingElseText:
	TX_FAR _PokemartAnythingElseText
	db "@"

DisplayChooseQuantityMenu::
	call ClearTextBox

	ld a, [wcf91]
	ld [wd11e], a
	call GetItemName

	coord hl, 1, 14
	ld de, QuantityMenuSellItemString
	call PlaceString

	ld a, 1
	ld [wItemQuantity], a ; initialize current quantity to 1
	jp .handleNewQuantity

.waitForKeyPressLoop
	call JoypadLowSensitivity

	ld a, [hJoyPressed] ; newly pressed buttons
	bit BIT_A_BUTTON, a ; was the A button pressed?
	jp nz, .buttonAPressed

	bit BIT_B_BUTTON, a ; was the B button pressed?
	jp nz, .buttonBPressed
	
	bit BIT_D_RIGHT, a ; was Right pressed?
	jr nz, .incrementQuantityBy10

	bit BIT_D_LEFT, a ; was Left pressed?
	jr nz, .decrementQuantityBy10

	bit BIT_D_UP, a ; was Up pressed?
	jr nz, .incrementQuantity

	bit BIT_D_DOWN, a ; was Down pressed?
	jr nz, .decrementQuantity

	jr .waitForKeyPressLoop

.incrementQuantityBy10
	ld a, [wItemQuantity]
	ld b, a

	ld a, [wMaxItemQuantity]
	sub b
	jr z, .waitForKeyPressLoop ;do nothing if at max already

	cp 10
	; if the difference to max is less than 10, set it to the max
	jr c, .setToMax

	ld a, b
	add a, 10
	jr .storeNewQuantity

.setToMax
	ld a, [wMaxItemQuantity]

.storeNewQuantity
	ld [wItemQuantity], a
	jr .handleNewQuantity

.incrementQuantity
	ld a, [wMaxItemQuantity]
	inc a
	ld b, a
	ld hl, wItemQuantity ; current quantity
	inc [hl]
	ld a, [hl]
	cp b
	jr nz, .handleNewQuantity

	cp 1
	jr z, .waitForKeyPressLoop ; do nothing if max is 1

; wrap to 1 if the player goes above the max quantity
	ld a, 1
	ld [hl], a
	jr .handleNewQuantity

.decrementQuantityBy10
	ld a, [wItemQuantity]
	cp 1
	jr z, .waitForKeyPressLoop ; do nothing if at 1 already

	cp 11
	; if the quatity is <= 10, set it to 1
	jr c, .setToOne

	sub a, 10
	jr .storeNewQuantity

.setToOne
	ld a, 1
	jr .storeNewQuantity

.decrementQuantity
	ld hl, wItemQuantity ; current quantity
	dec [hl]
	jr nz, .handleNewQuantity
; wrap to the max quantity if the player goes below 1
	ld a, [wMaxItemQuantity]
	ld [hl], a
	
	cp 1
	jr z, .waitForKeyPressLoop ; do nothing if max is 1

.handleNewQuantity
	; print price
	ld c, $03
	ld a, [wItemQuantity]
	ld b, a
	ld hl, hMoney ; total price
	
	; initialize total price to 0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.addLoop ; loop to multiply the individual price by the quantity to get the total price
	ld de, hMoney + 2
	ld hl, hItemPrice + 2
	push bc
	predef AddBCDPredef ; add the individual price to the current sum
	pop bc
	dec b
	jr nz, .addLoop
	ld a, [hHalveItemPrices]
	and a ; should the price be halved (for selling items)?
	jr z, .skipHalvingPrice
	xor a
	ld [hDivideBCDDivisor], a
	ld [hDivideBCDDivisor + 1], a
	ld a, 2
	ld [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3 ; halves the price
; store the halved price
	ld a, [hDivideBCDQuotient]
	ld [hMoney], a
	ld a, [hDivideBCDQuotient + 1]
	ld [hMoney + 1], a
	ld a, [hDivideBCDQuotient + 2]
	ld [hMoney + 2], a
.skipHalvingPrice

	coord hl, 3, 16
	lb bc, 1, 14
	call ClearScreenArea

	coord hl, 3, 16
	ld de, QuantityMenuSelectionString
	call PlaceString

	jp .waitForKeyPressLoop
.buttonAPressed ; the player chose to make the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ret
.buttonBPressed ; the player chose to cancel the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ld a, $ff
	ret

SellString:
	str "Sell"

QuantityMenuSellItemString:
	db "Sell "
	ramtext wcd6d
	db ":"
	next TILE_UP_DOWN
	done

QuantityMenuSelectionString:
	numtext wItemQuantity, (3 << 3) | 1 ; 1 byte, 3 digits
	db " for "
	bcdtext hMoney, LEFT_ALIGN | NO_LEADING_ZEROES | MONEY_SIGN | 3
	done

QuantityMenuConfirmString:
	db "x"
	numtext wItemQuantity, LEFT_ALIGN | (3 << 3) | 1 ; 1 byte, 3 digits
	db " for "
	bcdtext hMoney, LEFT_ALIGN | NO_LEADING_ZEROES | MONEY_SIGN | 3
	db "?"
	done