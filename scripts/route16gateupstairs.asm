Route16GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route16GateUpstairsTextPointers:
	dw Route16GateUpstairsText1
	dw Route16GateUpstairsText2
	dw Route16GateUpstairsText3
	dw Route16GateUpstairsText4

Route16GateUpstairsText1:
	text ""
	asmtext
	ld hl, Route16GateUpstairsText_49820
	call PrintText
	jp TextScriptEnd

Route16GateUpstairsText_49820:
	text ""
	fartext _Route16GateUpstairsText_49820
	done

Route16GateUpstairsText2:
	text ""
	asmtext
	ld hl, Route16GateUpstairsText_4982f
	call PrintText
	jp TextScriptEnd

Route16GateUpstairsText_4982f:
	text ""
	fartext _Route16GateUpstairsText_4982f
	done

Route16GateUpstairsText3:
	text ""
	asmtext
	ld hl, Route16GateUpstairsText_4983b
	jp GateUpstairsScript_PrintIfFacingUp

Route16GateUpstairsText_4983b:
	text ""
	fartext _Route16GateUpstairsText_4983b
	done

Route16GateUpstairsText4:
	text ""
	asmtext
	ld hl, Route16GateUpstairsText_49847
	jp GateUpstairsScript_PrintIfFacingUp

Route16GateUpstairsText_49847:
	text ""
	fartext _Route16GateUpstairsText_49847
	done
