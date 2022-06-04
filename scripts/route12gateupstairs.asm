Route12GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route12GateUpstairsTextPointers:
	dw Route12GateUpstairsText1
	dw Route12GateUpstairsText2
	dw Route12GateUpstairsText3

Route12GateUpstairsText1:
	text ""
	asmtext
	CheckEvent EVENT_GOT_TM39, 1
	jr c, .asm_0ad3c
	ld hl, TM39PreReceiveText
	call PrintText
	lb bc, TM_39, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM39Text
	call PrintText
	SetEvent EVENT_GOT_TM39
	jr .asm_4ba56
.BagFull
	ld hl, TM39NoRoomText
	call PrintText
	jr .asm_4ba56
.asm_0ad3c
	ld hl, TM39ExplanationText
	call PrintText
.asm_4ba56
	jp TextScriptEnd

TM39PreReceiveText:
	text ""
	fartext _TM39PreReceiveText
	done

ReceivedTM39Text:
	text ""
	fartext _ReceivedTM39Text
	sfxtext SFX_GET_ITEM_1
	done

TM39ExplanationText:
	text ""
	fartext _TM39ExplanationText
	done

TM39NoRoomText:
	text ""
	fartext _TM39NoRoomText
	done

Route12GateUpstairsText2:
	text ""
	asmtext
	ld hl, Route12GateUpstairsText_495b8
	jp GateUpstairsScript_PrintIfFacingUp

Route12GateUpstairsText_495b8:
	text ""
	fartext _Route12GateUpstairsText_495b8
	done

Route12GateUpstairsText3:
	text ""
	asmtext
	ld hl, Route12GateUpstairsText_495c4
	jp GateUpstairsScript_PrintIfFacingUp

Route12GateUpstairsText_495c4:
	text ""
	fartext _Route12GateUpstairsText_495c4
	done

GateUpstairsScript_PrintIfFacingUp:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	jr z, .up
	ld a, $1
	jr .done
.up
	call PrintText
	xor a
.done
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd
