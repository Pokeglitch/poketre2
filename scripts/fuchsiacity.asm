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
	fartext _FuchsiaCityText1
	done

FuchsiaCityText2:
	fartext _FuchsiaCityText2
	done

FuchsiaCityText3:
	fartext _FuchsiaCityText3
	done

FuchsiaCityText4:
	fartext _FuchsiaCityText4
	done

FuchsiaCityText5:
FuchsiaCityText6:
FuchsiaCityText7:
FuchsiaCityText8:
FuchsiaCityText9:
FuchsiaCityText10:
	fartext _FuchsiaCityText5
	done

FuchsiaCityText12:
FuchsiaCityText11:
	fartext _FuchsiaCityText11
	done

FuchsiaCityText13:
	fartext _FuchsiaCityText13
	done

FuchsiaCityText16:
	fartext _FuchsiaCityText16
	done

FuchsiaCityText17:
	fartext _FuchsiaCityText17
	done

FuchsiaCityText18:
	fartext _FuchsiaCityText18
	done

FuchsiaCityText19:
	asmtext
	ld hl, FuchsiaCityChanseyText
	call PrintText
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityChanseyText:
	fartext _FuchsiaCityChanseyText
	done

FuchsiaCityText20:
	asmtext
	ld hl, FuchsiaCityVoltorbText
	call PrintText
	ld a, VOLTORB
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityVoltorbText:
	fartext _FuchsiaCityVoltorbText
	done

FuchsiaCityText21:
	asmtext
	ld hl, FuchsiaCityKangaskhanText
	call PrintText
	ld a, KANGASKHAN
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityKangaskhanText:
	fartext _FuchsiaCityKangaskhanText
	done

FuchsiaCityText22:
	asmtext
	ld hl, FuchsiaCitySlowpokeText
	call PrintText
	ld a, SLOWPOKE
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCitySlowpokeText:
	fartext _FuchsiaCitySlowpokeText
	done

FuchsiaCityText23:
	asmtext
	ld hl, FuchsiaCityLaprasText
	call PrintText
	ld a, LAPRAS
	call DisplayPokedex
	jp TextScriptEnd

FuchsiaCityLaprasText:
	fartext _FuchsiaCityLaprasText
	done

FuchsiaCityText24:
	asmtext
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
	fartext _FuchsiaCityOmanyteText
	done

FuchsiaCityKabutoText:
	fartext _FuchsiaCityKabutoText
	done

FuchsiaCityText_19b2a:
	fartext _FuchsiaCityText_19b2a
	done
