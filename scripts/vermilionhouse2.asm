VermilionHouse2Script:
	jp EnableAutoTextBoxDrawing

VermilionHouse2TrainerHeader0:
	db TrainerHeaderTerminator

VermilionHouse2TextPointers:
	dw VermilionHouse2Text1

VermilionHouse2Text1:
	asmtext
	ld a, [wd728]
	bit 3, a
	jr nz, .asm_03ef5
	ld hl, VermilionHouse2Text_560b1
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_eb1b7
	lb bc, OLD_ROD, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, wd728
	set 3, [hl]
	ld hl, VermilionHouse2Text_560b6
	jr .asm_5dd95
.BagFull
	ld hl, VermilionHouse2Text_560ca
	jr .asm_5dd95
.asm_eb1b7
	ld hl, VermilionHouse2Text_560c0
	jr .asm_5dd95
.asm_03ef5
	ld hl, VermilionHouse2Text_560c5
.asm_5dd95
	call PrintText
	jp TextScriptEnd

VermilionHouse2Text_560b1:
	fartext _VermilionHouse2Text_560b1
	done

VermilionHouse2Text_560b6:
	fartext _VermilionHouse2Text_560b6
	sfxtext SFX_GET_ITEM_1
	fartext _VermilionHouse2Text_560bb
	done

VermilionHouse2Text_560c0:
	fartext _VermilionHouse2Text_560c0
	done

VermilionHouse2Text_560c5:
	fartext _VermilionHouse2Text_560c5
	done

VermilionHouse2Text_560ca:
	fartext _VermilionHouse2Text_560ca
	done
