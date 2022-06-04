Route1Script:
	jp EnableAutoTextBoxDrawing

Route1TextPointers:
	dw Route1Text1
	dw Route1Text2
	dw Route1Text3

Route1Text1:
	text ""
	asmtext
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .asm_1cada
	ld hl, Route1ViridianMartSampleText
	call PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, Route1Text_1cae8
	jr .asm_1cadd
.BagFull
	ld hl, Route1Text_1caf3
	jr .asm_1cadd
.asm_1cada
	ld hl, Route1Text_1caee
.asm_1cadd
	call PrintText
	jp TextScriptEnd

Route1ViridianMartSampleText:
	text ""
	fartext _Route1ViridianMartSampleText
	done

Route1Text_1cae8:
	text ""
	fartext _Route1Text_1cae8
	sfxtext SFX_GET_ITEM_1
	done

Route1Text_1caee:
	text ""
	fartext _Route1Text_1caee
	done

Route1Text_1caf3:
	text ""
	fartext _Route1Text_1caf3
	done

Route1Text2:
	text ""
	fartext _Route1Text2
	done

Route1Text3:
	text ""
	fartext _Route1Text3
	done
