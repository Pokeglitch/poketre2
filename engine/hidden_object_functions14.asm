PrintNotebookText:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, [wHiddenObjectFunctionArgument]
	jp PrintPredefTextID

TMNotebook:
	fartext TMNotebookText
	wait
	done

ViridianSchoolNotebook:
	asmtext
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
	fartext _TurnPageText
	done

ViridianSchoolNotebookText5:
	fartext _ViridianSchoolNotebookText5
	wait
	done

ViridianSchoolNotebookText1:
	fartext _ViridianSchoolNotebookText1
	done

ViridianSchoolNotebookText2:
	fartext _ViridianSchoolNotebookText2
	done

ViridianSchoolNotebookText3:
	fartext _ViridianSchoolNotebookText3
	done

ViridianSchoolNotebookText4:
	fartext _ViridianSchoolNotebookText4
	done

PrintFightingDojoText2:
	call EnableAutoTextBoxDrawing
	tx_pre_jump EnemiesOnEverySideText

EnemiesOnEverySideText:
	fartext _EnemiesOnEverySideText
	done

PrintFightingDojoText3:
	call EnableAutoTextBoxDrawing
	tx_pre_jump WhatGoesAroundComesAroundText

WhatGoesAroundComesAroundText:
	fartext _WhatGoesAroundComesAroundText
	done

PrintFightingDojoText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump FightingDojoText

FightingDojoText:
	fartext _FightingDojoText
	done

PrintIndigoPlateauHQText:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump IndigoPlateauHQText

IndigoPlateauHQText:
	fartext _IndigoPlateauHQText
	done
