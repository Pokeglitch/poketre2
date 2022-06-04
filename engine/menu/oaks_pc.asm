OpenOaksPC:
	call SaveScreenTilesToBuffer2
	ld hl, AccessedOaksPCText
	call PrintText
	ld hl, GetDexRatedText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .closePC
	predef DisplayDexRating
.closePC
	ld hl, ClosedOaksPCText
	call PrintText
	jp LoadScreenTilesFromBuffer2

GetDexRatedText:
	text ""
	fartext _GetDexRatedText
	done

ClosedOaksPCText:
	text ""
	fartext _ClosedOaksPCText
	wait
	done

AccessedOaksPCText:
	text ""
	fartext _AccessedOaksPCText
	done
