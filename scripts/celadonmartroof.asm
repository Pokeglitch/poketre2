CeladonMartRoofScript:
	jp EnableAutoTextBoxDrawing

CeladonMartRoofScript_GetDrinksInBag:
; construct a list of all drinks in the player's bag
	xor a
	ld [wFilteredBagItemsCount], a
	ld de, wFilteredBagItems
	ld hl, CeladonMartRoofDrinkList
.loop
	ld a, [hli]
	and a
	jr z, .done
	push hl
	push de
	ld [wd11e], a
	ld b, a
	predef GetQuantityOfItemInBag
	pop de
	pop hl
	ld a, b
	and a
	jr z, .loop ; if the item isn't in the bag
	ld a, [wd11e]
	ld [de], a
	inc de
	push hl
	ld hl, wFilteredBagItemsCount
	inc [hl]
	pop hl
	jr .loop
.done
	ld a, $ff
	ld [de], a
	ret

CeladonMartRoofDrinkList:
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	db $00

CeladonMartRoofScript_GiveDrinkToGirl:
	ld hl, wd730
	set 6, [hl]
	ld hl, CeladonMartRoofText_484ee
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld [wMaxMenuItem], a
	ld a, 2
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	ld a, [wFilteredBagItemsCount]
	dec a
	ld bc, 2
	ld hl, 3
	call AddNTimes
	dec l
	ld b, l
	ld c, 12
	coord hl, 0, 0
	call TextBoxBorder
	call UpdateSprites
	call CeladonMartRoofScript_PrintDrinksInBag
	ld hl, wd730
	res 6, [hl]
	call HandleMenuInput
	bit 1, a ; pressed b
	ret nz
	ld hl, wFilteredBagItems
	ld a, [wCurrentMenuItem]
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [hItemToRemoveID], a
	cp FRESH_WATER
	jr z, .gaveFreshWater
	cp SODA_POP
	jr z, .gaveSodaPop
; gave Lemonade
	CheckEvent EVENT_GOT_TM49
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofText_48515
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_49, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, ReceivedTM49Text
	call PrintText
	SetEvent EVENT_GOT_TM49
	ret
.gaveSodaPop
	CheckEvent EVENT_GOT_TM48
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofText_48504
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_48, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, CeladonMartRoofText_4850a
	call PrintText
	SetEvent EVENT_GOT_TM48
	ret
.gaveFreshWater
	CheckEvent EVENT_GOT_TM13
	jr nz, .alreadyGaveDrink
	ld hl, CeladonMartRoofText_484f3
	call PrintText
	call RemoveItemByIDBank12
	lb bc, TM_13, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, CeladonMartRoofText_484f9
	call PrintText
	SetEvent EVENT_GOT_TM13
	ret
.bagFull
	ld hl, CeladonMartRoofText_48526
	jp PrintText
.alreadyGaveDrink
	ld hl, CeladonMartRoofText_4852c
	jp PrintText

RemoveItemByIDBank12:
	jpba RemoveItemByID

CeladonMartRoofText_484ee:
	fartext _CeladonMartRoofText_484ee
	done

CeladonMartRoofText_484f3:
	fartext _CeladonMartRoofText_484f3
	wait
	done

CeladonMartRoofText_484f9:
	fartext _CeladonMartRoofText_484f9
	sfxtext SFX_GET_ITEM_1
	fartext _CeladonMartRoofText_484fe
	wait
	done

CeladonMartRoofText_48504:
	fartext _CeladonMartRoofText_48504
	wait
	done

CeladonMartRoofText_4850a:
	fartext _CeladonMartRoofText_4850a
	sfxtext SFX_GET_ITEM_1
	fartext _CeladonMartRoofText_4850f
	wait
	done

CeladonMartRoofText_48515:
	fartext _CeladonMartRoofText_48515
	wait
	done

ReceivedTM49Text:
	fartext _ReceivedTM49Text
	sfxtext SFX_GET_ITEM_1
	fartext _CeladonMartRoofText_48520
	wait
	done

CeladonMartRoofText_48526:
	fartext _CeladonMartRoofText_48526
	wait
	done

CeladonMartRoofText_4852c:
	fartext _CeladonMartRoofText_4852c
	wait
	done

CeladonMartRoofScript_PrintDrinksInBag:
	ld hl, wFilteredBagItems
	xor a
	ld [hItemCounter], a
.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	ld [wd11e], a
	call GetItemName
	coord hl, 2, 2
	ld a, [hItemCounter]
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld de, wcd6d
	call PlaceString
	ld hl, hItemCounter
	inc [hl]
	pop hl
	jr .loop

CeladonMartRoofTrainerHeader0:
	db TrainerHeaderTerminator

CeladonMartRoofTextPointers:
	dw CeladonMartRoofText1
	dw CeladonMartRoofText2
	dw CeladonMartRoofText5
	dw CeladonMartRoofText5
	dw CeladonMartRoofText5
	dw CeladonMartRoofText6

CeladonMartRoofText1:
	fartext _CeladonMartRoofText1
	done

CeladonMartRoofText2:
	asmtext
	call CeladonMartRoofScript_GetDrinksInBag
	ld a, [wFilteredBagItemsCount]
	and a
	jr z, .noDrinksInBag
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeladonMartRoofText4
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	call CeladonMartRoofScript_GiveDrinkToGirl
	jr .done
.noDrinksInBag
	ld hl, CeladonMartRoofText3
	call PrintText
.done
	jp TextScriptEnd

CeladonMartRoofText3:
	fartext _CeladonMartRoofText_48598
	done

CeladonMartRoofText4:
	fartext _CeladonMartRoofText4
	done

CeladonMartRoofText5:
	TX_VENDING_MACHINE

CeladonMartRoofText6:
	fartext _CeladonMartRoofText6
	done
