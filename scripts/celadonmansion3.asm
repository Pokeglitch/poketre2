CeladonMansion3Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion3TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText

ProgrammerText:
	text ""
	fartext _ProgrammerText
	done

GraphicArtistText:
	text ""
	fartext _GraphicArtistText
	done

WriterText:
	text ""
	fartext _WriterText
	done

DirectorText:
	TX_ASM

	; check pokédex
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 150
	jr nc, .CompletedDex
	ld hl, .GameDesigner
	jr .done
.CompletedDex
	ld hl, .CompletedDexText
.done
	call PrintText
	jp TextScriptEnd

.GameDesigner
	text ""
	fartext _GameDesignerText
	done

.CompletedDexText
	text ""
	fartext _CompletedDexText
	wait
	asmtext
	callab DisplayDiploma
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

GameFreakPCText1:
	text ""
	fartext _CeladonMansion3Text5
	done

GameFreakPCText2:
	text ""
	fartext _CeladonMansion3Text6
	done

GameFreakPCText3:
	text ""
	fartext _CeladonMansion3Text7
	done

GameFreakSignText:
	text ""
	fartext _CeladonMansion3Text8
	done
