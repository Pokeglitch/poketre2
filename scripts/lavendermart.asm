LavenderMartScript:
	jp EnableAutoTextBoxDrawing

LavenderMartTextPointers:
	dw LavenderCashierText
	dw LavenderMartText2
	dw LavenderMartText3

LavenderMartText2:
	text ""
	fartext _LavenderMartText2
	done

LavenderMartText3:
	text ""
	asmtext
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .Nugget
	ld hl, .ReviveText
	call PrintText
	jr .done
.Nugget
	ld hl, .NuggetText
	call PrintText
.done
	jp TextScriptEnd

.ReviveText
	text ""
	fartext _LavenderMartReviveText
	done

.NuggetText
	text ""
	fartext _LavenderMartNuggetText
	done
