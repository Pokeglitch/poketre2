LavenderMartScript:
	jp EnableAutoTextBoxDrawing

LavenderMartTrainerHeader0:
	db TrainerHeaderTerminator

LavenderMartTextPointers:
	dw LavenderCashierText
	dw LavenderMartText2
	dw LavenderMartText3

LavenderMartText2:
	fartext _LavenderMartText2
	done

LavenderMartText3:
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
	fartext _LavenderMartReviveText
	done

.NuggetText
	fartext _LavenderMartNuggetText
	done
