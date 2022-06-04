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
	fartext _GetDexRatedText
	done

ClosedOaksPCText:
	fartext _ClosedOaksPCText
	wait
	done

AccessedOaksPCText:
	fartext _AccessedOaksPCText
	done
