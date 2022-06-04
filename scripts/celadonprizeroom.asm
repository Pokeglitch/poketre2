CeladonPrizeRoomScript:
	jp EnableAutoTextBoxDrawing

CeladonPrizeRoomTextPointers:
	dw CeladonPrizeRoomText1
	dw CeladonPrizeRoomText2
	dw CeladonPrizeRoomText3
	dw CeladonPrizeRoomText3
	dw CeladonPrizeRoomText3

CeladonPrizeRoomText1:
	fartext _CeladonPrizeRoomText1
	done

CeladonPrizeRoomText2:
	fartext _CeladonPrizeRoomText2
	done

CeladonPrizeRoomText3:
	TX_PRIZE_VENDOR
