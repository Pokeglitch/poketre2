DisplayPokemartDialogue_:
	xor a
	ld [wBoughtOrSoldItemInMart], a
.loop
	ld a, [wMenuExitMethod]
	cp CANCELLED_MENU
	jp z, .done
	ld a, [wChosenMenuItem]
	and a ; buying?
	jp z, .buyMenu
	call SaveScreenTilesToBuffer1 ; save screen

.sellMenuLoop
	ld a, FILTER_POKEMART
	ld [wInventoryFilter], a
	
	xor a
    ld [wUpdateSpritesEnabled], a ; Disable sprite updates

	farcall DisplayItemMenu

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
	ld a, PRICEDITEMLISTMENU
	ld [wListMenuID], a
	ld [hHalveItemPrices], a ; halve prices when selling
	call DisplayChooseQuantityMenu
	inc a
	jr z, .reenterSellMenu ; if the player closed the choose quantity menu with the B button
	ld hl, PokemartTellSellPriceText
	lb bc, 14, 1 ; location that PrintText always prints to, this is useless
	call PrintText
	coord hl, 14, 7
	lb bc, 8, 15
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wMenuExitMethod]
	cp CHOSE_SECOND_ITEM
	jr nz, .sellItem

.reenterSellMenu
	farcall ReEnterItemMenu
	jr .handleInventoryChosen

.sellItem
	ld a, [wBoughtOrSoldItemInMart]
	and a
	jr nz, .skipSettingFlag1
	inc a
	ld [wBoughtOrSoldItemInMart], a

.skipSettingFlag1
	call AddAmountSoldToMoney
	call RemoveItemFromInventory
	jp .sellMenuLoop

.buyMenu
; the same variables are set again below, so this code has no effect
	ld a, 1
	ld [wPrintItemPrices], a
	ld a, INIT_OTHER_ITEM_LIST
	ld [wInitListType], a
	callab InitList

	ld hl, PokemartBuyingGreetingText
	call PrintText
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
	ld a, [wBoughtOrSoldItemInMart]
	and a
	jr nz, .skipSettingFlag2
	ld a, 1
	ld [wBoughtOrSoldItemInMart], a
.skipSettingFlag2
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
	ld hl, PokemartThankYouText
	call PrintText
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

PokemartBuyingGreetingText:
	TX_FAR _PokemartBuyingGreetingText
	db "@"

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

PokemartTellSellPriceText:
	TX_FAR _PokemartTellSellPriceText
	db "@"

PokemartThankYouText:
	TX_FAR _PokemartThankYouText
	db "@"

PokemartAnythingElseText:
	TX_FAR _PokemartAnythingElseText
	db "@"
