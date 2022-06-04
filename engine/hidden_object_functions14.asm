PrintNotebookText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenObjectFunctionArgument]
	jp PrintPredefTextID

TMNotebook:
	text ""
	fartext TMNotebookText
	wait
	done

ViridianSchoolNotebook:
	TX_ASM
	ld hl, ViridianSchoolNotebookText1
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText2
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText3
	call PrintText
	call TurnPageSchoolNotebook
	jr nz, .doneReading
	ld hl, ViridianSchoolNotebookText4
	call PrintText
	ld hl, ViridianSchoolNotebookText5
	call PrintText
.doneReading
	jp TextScriptEnd

TurnPageSchoolNotebook:
	ld hl, TurnPageText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

TurnPageText:
	text ""
	fartext _TurnPageText
	done

ViridianSchoolNotebookText5:
	text ""
	fartext _ViridianSchoolNotebookText5
	wait
	done

ViridianSchoolNotebookText1:
	text ""
	fartext _ViridianSchoolNotebookText1
	done

ViridianSchoolNotebookText2:
	text ""
	fartext _ViridianSchoolNotebookText2
	done

ViridianSchoolNotebookText3:
	text ""
	fartext _ViridianSchoolNotebookText3
	done

ViridianSchoolNotebookText4:
	text ""
	fartext _ViridianSchoolNotebookText4
	done

PrintFightingDojoText2:
	call EnableAutoTextBoxDrawing
	tx_pre_jump EnemiesOnEverySideText

EnemiesOnEverySideText:
	text ""
	fartext _EnemiesOnEverySideText
	done

PrintFightingDojoText3:
	call EnableAutoTextBoxDrawing
	tx_pre_jump WhatGoesAroundComesAroundText

WhatGoesAroundComesAroundText:
	text ""
	fartext _WhatGoesAroundComesAroundText
	done

PrintFightingDojoText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump FightingDojoText

FightingDojoText:
	text ""
	fartext _FightingDojoText
	done

PrintIndigoPlateauHQText:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump IndigoPlateauHQText

IndigoPlateauHQText:
	text ""
	fartext _IndigoPlateauHQText
	done
