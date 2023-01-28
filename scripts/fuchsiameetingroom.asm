FuchsiaMeetingRoomScript:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaMeetingRoomTrainerHeader0:
	db TrainerHeaderTerminator

FuchsiaMeetingRoomTextPointers:
	dw FuchsiaMeetingRoomText1
	dw FuchsiaMeetingRoomText2
	dw FuchsiaMeetingRoomText3

FuchsiaMeetingRoomText1:
	fartext _FuchsiaMeetingRoomText1
	done

FuchsiaMeetingRoomText2:
	fartext _FuchsiaMeetingRoomText2
	done

FuchsiaMeetingRoomText3:
	fartext _FuchsiaMeetingRoomText3
	done
