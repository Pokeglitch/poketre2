SafariZoneRestHouse4Script:
	call EnableAutoTextBoxDrawing
	ret

SafariZoneRestHouse4TrainerHeader0:
	db TrainerHeaderTerminator

SafariZoneRestHouse4TextPointers:
	dw SafariZoneRestHouse4Text1
	dw SafariZoneRestHouse4Text2
	dw SafariZoneRestHouse4Text3

SafariZoneRestHouse4Text1:
	fartext _SafariZoneRestHouse4Text1
	done

SafariZoneRestHouse4Text2:
	fartext _SafariZoneRestHouse4Text2
	done

SafariZoneRestHouse4Text3:
	fartext _SafariZoneRestHouse4Text3
	done
