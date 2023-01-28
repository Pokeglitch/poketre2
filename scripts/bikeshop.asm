BikeShopScript:
	jp EnableAutoTextBoxDrawing

BikeShopTrainerHeader0:
	db TrainerHeaderTerminator

BikeShopTextPointers:
	dw BikeShopText1
	dw BikeShopText2
	dw BikeShopText3

BikeShopText1:
	asmtext
	CheckEvent EVENT_GOT_BICYCLE
	jr z, .asm_260d4
	ld hl, BikeShopText_1d82f
	call PrintText
	jp .Done
.asm_260d4
	ld b, BIKE_VOUCHER
	call IsItemInBag
	jr z, .asm_41190
	ld hl, BikeShopText_1d81f
	call PrintText
	lb bc, BICYCLE, 1
	call GiveItem
	jr nc, .BagFull
	ld a, BIKE_VOUCHER
	ld [$ffdb], a
	callba RemoveItemByID
	SetEvent EVENT_GOT_BICYCLE
	ld hl, BikeShopText_1d824
	call PrintText
	jr .Done
.BagFull
	ld hl, BikeShopText_1d834
	call PrintText
	jr .Done
.asm_41190
	ld hl, BikeShopText_1d810
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, $1
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
	ld hl, wd730
	set 6, [hl]
	coord hl, 0, 0
	ld b, $4
	ld c, $f
	call TextBoxBorder
	call UpdateSprites
	coord hl, 2, 2
	ld de, BikeShopMenuText
	call PlaceString
	coord hl, 8, 3
	ld de, BikeShopMenuPrice
	call PlaceString
	ld hl, BikeShopText_1d815
	call PrintText
	call HandleMenuInput
	bit 1, a
	jr nz, .cancel
	ld hl, wd730
	res 6, [hl]
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cancel
	ld hl, BikeShopCantAffordText
	call PrintText
.cancel
	ld hl, BikeShopComeAgainText
	call PrintText
.Done
	jp TextScriptEnd

BikeShopMenuText:
	db   "BICYCLE"
	next "CANCEL@"

BikeShopMenuPrice:
	str "$1000000"

BikeShopText_1d810:
	fartext _BikeShopText_1d810
	done

BikeShopText_1d815:
	fartext _BikeShopText_1d815
	done

BikeShopCantAffordText:
	fartext _BikeShopCantAffordText
	done

BikeShopText_1d81f:
	fartext _BikeShopText_1d81f
	done

BikeShopText_1d824:
	fartext _BikeShopText_1d824
	sfxtext SFX_GET_KEY_ITEM
	done

BikeShopComeAgainText:
	fartext _BikeShopComeAgainText
	done

BikeShopText_1d82f:
	fartext _BikeShopText_1d82f
	done

BikeShopText_1d834:
	fartext _BikeShopText_1d834
	done

BikeShopText2:
	asmtext
	ld hl, BikeShopText_1d843
	call PrintText
	jp TextScriptEnd

BikeShopText_1d843:
	fartext _BikeShopText_1d843
	done

BikeShopText3:
	asmtext
	CheckEvent EVENT_GOT_BICYCLE
	ld hl, BikeShopText_1d861
	jr nz, .asm_34d2d
	ld hl, BikeShopText_1d85c
.asm_34d2d
	call PrintText
	jp TextScriptEnd

BikeShopText_1d85c:
	fartext _BikeShopText_1d85c
	done

BikeShopText_1d861:
	fartext _BikeShopText_1d861
	done
