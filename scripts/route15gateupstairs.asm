Route15GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route15GateUpstairsTrainerHeader0:
	db TrainerHeaderTerminator

Route15GateUpstairsTextPointers:
	dw Route15GateUpstairsText1
	dw Route15GateUpstairsText2

Route15GateUpstairsText1:
	asmtext
	CheckEvent EVENT_GOT_EXP_ALL
	jr nz, .asm_49683
	ld a, 50 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, EXP_ALL ; oak's aide reward
	ld [hOaksAideRewardItem], a
	ld [wd11e], a
	call GetItemName
	ld hl, wcd6d
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ld a, [hOaksAideResult]
	cp $1
	jr nz, .asm_49689
	SetEvent EVENT_GOT_EXP_ALL
.asm_49683
	ld hl, Route15GateUpstairsText_4968c
	call PrintText
.asm_49689
	jp TextScriptEnd

Route15GateUpstairsText_4968c:
	fartext _Route15GateUpstairsText_4968c
	done

Route15GateUpstairsText2:
	asmtext
	ld hl, Route15GateUpstairsText_49698
	jp GateUpstairsScript_PrintIfFacingUp

Route15GateUpstairsText_49698:
	fartext _Route15GateUpstairsText_49698
	done
