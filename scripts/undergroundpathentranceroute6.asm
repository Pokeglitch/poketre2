UndergroundPathEntranceRoute6Script:
	ld a, ROUTE_6
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathEntranceRoute6TrainerHeader0:
	db TrainerHeaderTerminator

UndergroundPathEntranceRoute6TextPointers:
	dw UndergroundPathEntranceRoute6Text1

UndergroundPathEntranceRoute6Text1:
	fartext _UndergrdTunnelEntRoute6Text1
	done
