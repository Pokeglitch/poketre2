Route2GateScript:
	jp EnableAutoTextBoxDrawing

Route2GateTrainerHeader0:
	db TrainerHeaderTerminator

Route2GateTextPointers:
	dw Route2GateText1
	dw Route2GateText2

Route2GateText1:
	asmtext
	CheckEvent EVENT_GOT_HM05
	jr nz, .asm_5d60d
	ld a, 10 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, HM_05 ; oak's aide reward
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
	jr nz, .asm_5d613
	SetEvent EVENT_GOT_HM05
.asm_5d60d
	ld hl, Route2GateText_5d616
	call PrintText
.asm_5d613
	jp TextScriptEnd

Route2GateText_5d616:
	fartext _Route2GateText_5d616
	done

Route2GateText2:
	fartext _Route2GateText2
	done
