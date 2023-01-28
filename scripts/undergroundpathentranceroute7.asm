UndergroundPathEntranceRoute7Script:
	ld a, ROUTE_7
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathEntranceRoute7TrainerHeader0:
	db TrainerHeaderTerminator

UndergroundPathEntranceRoute7TextPointers:
	dw UndergroundPathEntranceRoute7Text1

UndergroundPathEntranceRoute7Text1:
	fartext _UndergroundPathEntRoute7Text1
	done
