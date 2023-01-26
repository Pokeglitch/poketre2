PickUpItem:
	call EnableAutoTextBoxDrawing

	ld a, [hSpriteIndexOrTextID]
	ld b, a
	ld hl, wMissableObjectList
.missableObjectsListLoop
	ld a, [hli]
	cp $ff
	ret z
	cp b
	jr z, .isMissable
	inc hl
	jr .missableObjectsListLoop

.isMissable
	ld a, [hl]
	ld [$ffdb], a

	ld hl, wMapSpriteExtraData
	ld a, [hSpriteIndexOrTextID]
	dec a
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld b, a ; item
	ld a, [hl]
	ld c, a ; quantity
	call GiveItem
	jr nc, .BagFull

	ld a, [$ffdb]
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a

	ld hl, FoundItemText
	ld a, [wItemQuantity]
	dec a
	jr z, .print
	
	ld hl, FoundItemsText
	jr .print

.BagFull
	ld hl, NoMoreRoomForItemText
.print
	call PrintText
	ret

FoundItemText:
	fartext _FoundItemText
	sfxtext SFX_GET_ITEM_1
	prompt

FoundItemsText:
	fartext _FoundItemsText
	sfxtext SFX_GET_ITEM_1
	prompt

NoMoreRoomForItemText:
	fartext _NoMoreRoomForItemText
	prompt
