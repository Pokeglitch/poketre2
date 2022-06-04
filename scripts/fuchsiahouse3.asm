FuchsiaHouse3Script:
	jp EnableAutoTextBoxDrawing

FuchsiaHouse3TextPointers:
	dw FuchsiaHouse3Text1

FuchsiaHouse3Text1:
	asmtext
	ld a, [wd728]
	bit 4, a
	jr nz, .after

	ld hl, FuchsiaHouse3Text_561bd
	call PrintText

	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused

	lb bc, GOOD_ROD, 1
	call GiveItem
	jr nc, .full

	ld hl, wd728
	set 4, [hl]

	ld hl, FuchsiaHouse3Text_561c2
	jr .talk

.full
	ld hl, FuchsiaHouse3Text_5621c
	jr .talk

.refused
	ld hl, FuchsiaHouse3Text_56212
	jr .talk

.after
	ld hl, FuchsiaHouse3Text_56217

.talk
	call PrintText
	jp TextScriptEnd

FuchsiaHouse3Text_561bd:
	fartext _FuchsiaHouse3Text_561bd
	done

FuchsiaHouse3Text_561c2:
	fartext _FuchsiaHouse3Text_561c2
	sfxtext SFX_GET_ITEM_1
	done

FuchsiaHouse3Text_56212:
	fartext _FuchsiaHouse3Text_56212
	done

FuchsiaHouse3Text_56217:
	fartext _FuchsiaHouse3Text_56217
	done

FuchsiaHouse3Text_5621c:
	fartext _FuchsiaHouse3Text_5621c
	done
