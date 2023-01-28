Route11GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route11GateUpstairsTrainerHeader0:
	db TrainerHeaderTerminator

Route11GateUpstairsTextPointers:
	dw Route11GateUpstairsText1
	dw Route11GateUpstairsText2
	dw Route11GateUpstairsText3
	dw Route11GateUpstairsText4

Route11GateUpstairsText1:
	asmtext
	xor a
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
Route11GateUpstairsScriptEnd:
	jp TextScriptEnd

Route11GateUpstairsText2:
	asmtext
	CheckEvent EVENT_GOT_ITEMFINDER, 1
	jr c, .asm_4949b
	ld a, 30 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, ITEMFINDER ; oak's aide reward
	ld [hOaksAideRewardItem], a
	ld [wd11e], a
	call GetItemName
	ld h, d
	ld l, e
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ld a, [hOaksAideResult]
	dec a
	jr nz, .asm_494a1
	SetEvent EVENT_GOT_ITEMFINDER
.asm_4949b
	ld hl, Route11GateUpstairsText_494a3
	call PrintText
.asm_494a1
	jr Route11GateUpstairsScriptEnd

Route11GateUpstairsText_494a3:
	fartext _Route11GateUpstairsText_494a3
	done

Route11GateUpstairsText3:
	asmtext
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	jp nz, GateUpstairsScript_PrintIfFacingUp
	CheckEvent EVENT_BEAT_ROUTE12_SNORLAX
	ld hl, BinocularsSnorlaxText
	jr z, .print
	ld hl, BinocularsNoSnorlaxText
.print
	call PrintText
	jp TextScriptEnd

BinocularsSnorlaxText:
	fartext _BinocularsSnorlaxText
	done

BinocularsNoSnorlaxText:
	fartext _BinocularsNoSnorlaxText
	done

Route11GateUpstairsText4:
	asmtext
	ld hl, Route11GateUpstairsText_494d5
	jp GateUpstairsScript_PrintIfFacingUp

Route11GateUpstairsText_494d5:
	fartext _Route11GateUpstairsText_494d5
	done
