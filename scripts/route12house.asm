Route12HouseScript:
	jp EnableAutoTextBoxDrawing

Route12HouseTrainerHeader0:
	db TrainerHeaderTerminator

Route12HouseTextPointers:
	dw Route12HouseText1

Route12HouseText1:
	asmtext
	ld a, [wd728]
	bit 5, a
	jr nz, .asm_b4cad
	ld hl, Route12HouseText_564c0
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_a2d76
	lb bc, SUPER_ROD, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, wd728
	set 5, [hl]
	ld hl, Route12HouseText_564c5
	jr .asm_df984
.BagFull
	ld hl, Route12HouseText_564d9
	jr .asm_df984
.asm_a2d76
	ld hl, Route12HouseText_564cf
	jr .asm_df984
.asm_b4cad
	ld hl, Route12HouseText_564d4
.asm_df984
	call PrintText
	jp TextScriptEnd

Route12HouseText_564c0:
	fartext _Route12HouseText_564c0
	done

Route12HouseText_564c5:
	fartext _Route12HouseText_564c5
	sfxtext SFX_GET_ITEM_1
	fartext _Route12HouseText_564ca
	done

Route12HouseText_564cf:
	fartext _Route12HouseText_564cf
	done

Route12HouseText_564d4:
	fartext _Route12HouseText_564d4
	done

Route12HouseText_564d9:
	fartext _Route12HouseText_564d9
	done
