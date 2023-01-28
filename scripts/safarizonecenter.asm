SafariZoneCenterScript:
	jp EnableAutoTextBoxDrawing

SafariZoneCenterTrainerHeader0:
	db TrainerHeaderTerminator

SafariZoneCenterTextPointers:
	dw PickUpItemText
	dw SafariZoneCenterText2
	dw SafariZoneCenterText3

SafariZoneCenterText2:
	fartext _SafariZoneCenterText2
	done

SafariZoneCenterText3:
	fartext _SafariZoneCenterText3
	done
