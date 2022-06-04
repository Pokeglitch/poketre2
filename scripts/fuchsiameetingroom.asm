FuchsiaMeetingRoomScript:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaMeetingRoomTextPointers:
	dw FuchsiaMeetingRoomText1
	dw FuchsiaMeetingRoomText2
	dw FuchsiaMeetingRoomText3

FuchsiaMeetingRoomText1:
	text ""
	fartext _FuchsiaMeetingRoomText1
	done

FuchsiaMeetingRoomText2:
	text ""
	fartext _FuchsiaMeetingRoomText2
	done

FuchsiaMeetingRoomText3:
	text ""
	fartext _FuchsiaMeetingRoomText3
	done
