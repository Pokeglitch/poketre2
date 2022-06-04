CeladonMart3Script:
	jp EnableAutoTextBoxDrawing

CeladonMart3TextPointers:
	dw CeladonMart3Text1
	dw CeladonMart3Text2
	dw CeladonMart3Text3
	dw CeladonMart3Text4
	dw CeladonMart3Text5
	dw CeladonMart3Text6
	dw CeladonMart3Text7
	dw CeladonMart3Text8
	dw CeladonMart3Text9
	dw CeladonMart3Text10
	dw CeladonMart3Text11
	dw CeladonMart3Text12
	dw CeladonMart3Text13
	dw CeladonMart3Text14
	dw CeladonMart3Text15
	dw CeladonMart3Text16
	dw CeladonMart3Text17

CeladonMart3Text1:
	text ""
	asmtext
	CheckEvent EVENT_GOT_TM18
	jr nz, .asm_a5463
	ld hl, TM18PreReceiveText
	call PrintText
	lb bc, TM_18, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_TM18
	ld hl, ReceivedTM18Text
	jr .asm_81359
.BagFull
	ld hl, TM18NoRoomText
	jr .asm_81359
.asm_a5463
	ld hl, TM18ExplanationText
.asm_81359
	call PrintText
	jp TextScriptEnd

TM18PreReceiveText:
	text ""
	fartext _TM18PreReceiveText
	done

ReceivedTM18Text:
	text ""
	fartext _ReceivedTM18Text
	sfxtext SFX_GET_ITEM_1
	done

TM18ExplanationText:
	text ""
	fartext _TM18ExplanationText
	done

TM18NoRoomText:
	text ""
	fartext _TM18NoRoomText
	done

CeladonMart3Text2:
	text ""
	fartext _CeladonMart3Text2
	done

CeladonMart3Text3:
	text ""
	fartext _CeladonMart3Text3
	done

CeladonMart3Text4:
	text ""
	fartext _CeladonMart3Text4
	done

CeladonMart3Text5:
	text ""
	fartext _CeladonMart3Text5
	done

CeladonMart3Text12:
CeladonMart3Text10:
CeladonMart3Text8:
CeladonMart3Text6:
	text ""
	fartext _CeladonMart3Text6
	done

CeladonMart3Text7:
	text ""
	fartext _CeladonMart3Text7
	done

CeladonMart3Text9:
	text ""
	fartext _CeladonMart3Text9
	done

CeladonMart3Text11:
	text ""
	fartext _CeladonMart3Text11
	done

CeladonMart3Text13:
	text ""
	fartext _CeladonMart3Text13
	done

CeladonMart3Text14:
	text ""
	fartext _CeladonMart3Text14
	done

CeladonMart3Text17:
CeladonMart3Text16:
CeladonMart3Text15:
	text ""
	fartext _CeladonMart3Text15
	done
