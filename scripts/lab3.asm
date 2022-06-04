Lab3Script:
	jp EnableAutoTextBoxDrawing

Lab3TextPointers:
	dw Lab3Text1
	dw Lab3Text2
	dw Lab3Text3
	dw Lab3Text4
	dw Lab3Text5

Lab3Text1:
	text ""
	asmtext
	CheckEvent EVENT_GOT_TM35
	jr nz, .asm_e551a
	ld hl, TM35PreReceiveText
	call PrintText
	lb bc, TM_35, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM35Text
	call PrintText
	SetEvent EVENT_GOT_TM35
	jr .asm_eb896
.BagFull
	ld hl, TM35NoRoomText
	call PrintText
	jr .asm_eb896
.asm_e551a
	ld hl, TM35ExplanationText
	call PrintText
.asm_eb896
	jp TextScriptEnd

TM35PreReceiveText:
	text ""
	fartext _TM35PreReceiveText
	done

ReceivedTM35Text:
	text ""
	fartext _ReceivedTM35Text
	sfxtext SFX_GET_ITEM_1
	done

TM35ExplanationText:
	text ""
	fartext _TM35ExplanationText
	done

TM35NoRoomText:
	text ""
	fartext _TM35NoRoomText
	done

Lab3Text2:
	text ""
	fartext _Lab3Text2
	done

Lab3Text4:
Lab3Text3:
	text ""
	fartext _Lab3Text3
	done

Lab3Text5:
	text ""
	fartext _Lab3Text5
	done
