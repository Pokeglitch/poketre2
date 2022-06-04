OaksAideScript:
	ld hl, OaksAideHiText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .choseNo
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hOaksAideNumMonsOwned], a
	ld b, a
	ld a, [hOaksAideRequirement]
	cp b
	jr z, .giveItem
	jr nc, .notEnoughOwnedMons
.giveItem
	ld hl, OaksAideHereYouGoText
	call PrintText
	ld a, [hOaksAideRewardItem]
	ld b, a
	ld c, 1
	call GiveItem
	jr nc, .bagFull
	ld hl, OaksAideGotItemText
	call PrintText
	ld a, $1
	jr .done
.bagFull
	ld hl, OaksAideNoRoomText
	call PrintText
	xor a
	jr .done
.notEnoughOwnedMons
	ld hl, OaksAideUhOhText
	call PrintText
	ld a, $80
	jr .done
.choseNo
	ld hl, OaksAideComeBackText
	call PrintText
	ld a, $ff
.done
	ld [hOaksAideResult], a
	ret

OaksAideHiText:
	fartext _OaksAideHiText
	done

OaksAideUhOhText:
	fartext _OaksAideUhOhText
	done

OaksAideComeBackText:
	fartext _OaksAideComeBackText
	done

OaksAideHereYouGoText:
	fartext _OaksAideHereYouGoText
	done

OaksAideGotItemText:
	fartext _OaksAideGotItemText
	sfxtext SFX_GET_ITEM_1
	done

OaksAideNoRoomText:
	fartext _OaksAideNoRoomText
	done
