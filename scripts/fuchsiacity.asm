FuchsiaCityScript:
	jp EnableAutoTextBoxDrawing

FuchsiaCityTextPointers:
	dw FuchsiaCityText1
	dw FuchsiaCityText2
	dw FuchsiaCityText3
	dw FuchsiaCityText4
	dw FuchsiaCityText5
	dw FuchsiaCityText6
	dw FuchsiaCityText7
	dw FuchsiaCityText8
	dw FuchsiaCityText9
	dw FuchsiaCityText10
	dw FuchsiaCityText11
	dw FuchsiaCityText12
	dw FuchsiaCityText13
	dw MartSignText
	dw PokeCenterSignText
	dw FuchsiaCityText16
	dw FuchsiaCityText17
	dw FuchsiaCityText18
	dw FuchsiaCityText19
	dw FuchsiaCityText20
	dw FuchsiaCityText21
	dw FuchsiaCityText22
	dw FuchsiaCityText23
	dw FuchsiaCityText24

FuchsiaCityText1:
	text ""
	fartext _FuchsiaCityText1
	done

FuchsiaCityText2:
	text ""
	fartext _FuchsiaCityText2
	done

FuchsiaCityText3:
	text ""
	fartext _FuchsiaCityText3
	done

FuchsiaCityText4:
	text ""
	fartext _FuchsiaCityText4
	done

FuchsiaCityText5:
FuchsiaCityText6:
FuchsiaCityText7:
FuchsiaCityText8:
FuchsiaCityText9:
FuchsiaCityText10:
	text ""
	fartext _FuchsiaCityText5
	done

FuchsiaCityText12:
FuchsiaCityText11:
	text ""
	fartext _FuchsiaCityText11
	done

FuchsiaCityText13:
	text ""
	fartext _FuchsiaCityText13
	done

FuchsiaCityText16:
	text ""
	fartext _FuchsiaCityText16
	done

FuchsiaCityText17:
	text ""
	fartext _FuchsiaCityText17
	done

FuchsiaCityText18:
	text ""
	fartext _FuchsiaCityText18
	done

FuchsiaCityText19:
	TX_ASM
	ld hl, FuchsiaCityChanseyText
	call PrintText
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityChanseyText:
	text ""
	fartext _FuchsiaCityChanseyText
	done

FuchsiaCityText20:
	TX_ASM
	ld hl, FuchsiaCityVoltorbText
	call PrintText
	ld a, VOLTORB
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityVoltorbText:
	text ""
	fartext _FuchsiaCityVoltorbText
	done

FuchsiaCityText21:
	TX_ASM
	ld hl, FuchsiaCityKangaskhanText
	call PrintText
	ld a, KANGASKHAN
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityKangaskhanText:
	text ""
	fartext _FuchsiaCityKangaskhanText
	done

FuchsiaCityText22:
	TX_ASM
	ld hl, FuchsiaCitySlowpokeText
	call PrintText
	ld a, SLOWPOKE
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCitySlowpokeText:
	text ""
	fartext _FuchsiaCitySlowpokeText
	done

FuchsiaCityText23:
	TX_ASM
	ld hl, FuchsiaCityLaprasText
	call PrintText
	ld a, LAPRAS
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityLaprasText:
	text ""
	fartext _FuchsiaCityLaprasText
	done

FuchsiaCityText24:
	TX_ASM
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr nz, .asm_3b4e8
	CheckEventReuseA EVENT_GOT_HELIX_FOSSIL
	jr nz, .asm_667d5
	ld hl, FuchsiaCityText_19b2a
	call PrintText
	jr .asm_4343f
.asm_3b4e8
	ld hl, FuchsiaCityOmanyteText
	call PrintText
	ld a, OMANYTE
	jr .asm_81556
.asm_667d5
	ld hl, FuchsiaCityKabutoText
	call PrintText
	ld a, KABUTO
.asm_81556
	call DisplayPokedex
.asm_4343f
	jp TextScriptEnd

FuchsiaCityOmanyteText:
	text ""
	fartext _FuchsiaCityOmanyteText
	done

FuchsiaCityKabutoText:
	text ""
	fartext _FuchsiaCityKabutoText
	done

FuchsiaCityText_19b2a:
	text ""
	fartext _FuchsiaCityText_19b2a
	done
