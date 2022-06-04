LavenderTownScript:
	jp EnableAutoTextBoxDrawing

LavenderTownTextPointers:
	dw LavenderTownText1
	dw LavenderTownText2
	dw LavenderTownText3
	dw LavenderTownText4
	dw LavenderTownText5
	dw MartSignText
	dw PokeCenterSignText
	dw LavenderTownText8
	dw LavenderTownText9

LavenderTownText1:
	text ""
	asmtext
	ld hl, LavenderTownText_4413c
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, LavenderTownText_44146
	jr nz, .asm_40831
	ld hl, LavenderTownText_44141
.asm_40831
	call PrintText
	jp TextScriptEnd

LavenderTownText_4413c:
	text ""
	fartext _LavenderTownText_4413c
	done

LavenderTownText_44141:
	text ""
	fartext _LavenderTownText_44141
	done

LavenderTownText_44146:
	text ""
	fartext _LavenderTownText_44146
	done

LavenderTownText2:
	text ""
	fartext _LavenderTownText2
	done

LavenderTownText3:
	text ""
	fartext _LavenderTownText3
	done

LavenderTownText4:
	text ""
	fartext _LavenderTownText4
	done

LavenderTownText5:
	text ""
	fartext _LavenderTownText5
	done

LavenderTownText8:
	text ""
	fartext _LavenderTownText8
	done

LavenderTownText9:
	text ""
	fartext _LavenderTownText9
	done
