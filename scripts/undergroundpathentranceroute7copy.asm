UndergroundPathEntranceRoute7CopyScript:
	ld a, ROUTE_7
	ld [wLastMap], a
	ret

UndergroundPathEntranceRoute7CopyTrainerHeader0:
	db TrainerHeaderTerminator

UndergroundPathEntranceRoute7CopyTextPointers:
	dw UGPathRoute7EntranceUnusedText_5d773
	dw UGPathRoute7EntranceUnusedText_5d77d

UGPathRoute7EntranceUnusedText_5d773:
	fartext _UGPathRoute7EntranceUnusedText_5d773
	done

UGPathRoute7EntranceUnusedText_5d778:
	fartext _UGPathRoute7EntranceUnusedText_5d778
	done

UGPathRoute7EntranceUnusedText_5d77d:
	fartext _UGPathRoute7EntranceUnusedText_5d77d
	done

UGPathRoute7EntranceUnusedText_5d782:
	fartext _UGPathRoute7EntranceUnusedText_5d782
	done
