CopycatsHouse1FScript:
	jp EnableAutoTextBoxDrawing

CopycatsHouse1FTrainerHeader0:
	db TrainerHeaderTerminator

CopycatsHouse1FTextPointers:
	dw CopycatsHouse1FText1
	dw CopycatsHouse1FText2
	dw CopycatsHouse1FText3

CopycatsHouse1FText1:
	fartext _CopycatsHouse1FText1
	done

CopycatsHouse1FText2:
	fartext _CopycatsHouse1FText2
	done

CopycatsHouse1FText3:
	fartext _CopycatsHouse1FText3
	asmtext
	ld a, CHANSEY
	call PlayCry
	jp TextScriptEnd
