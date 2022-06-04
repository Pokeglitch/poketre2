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
	fartext _ProgrammerText
	done

GraphicArtistText:
	fartext _GraphicArtistText
	done

WriterText:
	fartext _WriterText
	done

DirectorText:
	asmtext

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
	fartext _GameDesignerText
	done

.CompletedDexText
	fartext _CompletedDexText
	wait
	asmtext
	callab DisplayDiploma
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

GameFreakPCText1:
	fartext _CeladonMansion3Text5
	done

GameFreakPCText2:
	fartext _CeladonMansion3Text6
	done

GameFreakPCText3:
	fartext _CeladonMansion3Text7
	done

GameFreakSignText:
	fartext _CeladonMansion3Text8
	done
