UndergroundPathEntranceRoute8Script:
	ld a, ROUTE_8
	ld [wLastMap], a
	jp EnableAutoTextBoxDrawing

UndergroundPathEntranceRoute8TextPointers:
	dw UndergroundPathEntranceRoute8Text1

UndergroundPathEntranceRoute8Text1:
	fartext _UndergroundPathEntRoute8Text1
	done
