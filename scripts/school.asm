SchoolScript:
	jp EnableAutoTextBoxDrawing

SchoolTrainerHeader0:
	db TrainerHeaderTerminator

SchoolTextPointers:
	dw SchoolText1
	dw SchoolText2

SchoolText1:
	fartext _SchoolText1
	done

SchoolText2:
	fartext _SchoolText2
	done
