DisplayDexRating:
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsOwned], a
	ld hl, DexRatingsTable
.findRating
	ld a, [hli]
	ld b, a
	ld a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc hl
	inc hl
	jr .findRating
.foundRating
	ld a, [hli]
	ld h, [hl]
	ld l, a ; load text pointer into hl
	CheckAndResetEventA EVENT_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, PokedexRatingText_441cc
	call PrintText
	pop hl
	call PrintText
	callba PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ld a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ld a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
.copyRatingTextLoop
	ld a, [hli]
	cp "@"
	jr z, .doneCopying
	ld [de], a
	inc de
	jr .copyRatingTextLoop
.doneCopying
	ld [de], a
	ret

PokedexRatingText_441cc:
	fartext _OaksLabText_441cc
	done

DexRatingsTable:
	db 10
	dw PokedexRatingText_44201
	db 20
	dw PokedexRatingText_44206
	db 30
	dw PokedexRatingText_4420b
	db 40
	dw PokedexRatingText_44210
	db 50
	dw PokedexRatingText_44215
	db 60
	dw PokedexRatingText_4421a
	db 70
	dw PokedexRatingText_4421f
	db 80
	dw PokedexRatingText_44224
	db 90
	dw PokedexRatingText_44229
	db 100
	dw PokedexRatingText_4422e
	db 110
	dw PokedexRatingText_44233
	db 120
	dw PokedexRatingText_44238
	db 130
	dw PokedexRatingText_4423d
	db 140
	dw PokedexRatingText_44242
	db 150
	dw PokedexRatingText_44247
	db 152
	dw PokedexRatingText_4424c

PokedexRatingText_44201:
	fartext _OaksLabText_44201
	done

PokedexRatingText_44206:
	fartext _OaksLabText_44206
	done

PokedexRatingText_4420b:
	fartext _OaksLabText_4420b
	done

PokedexRatingText_44210:
	fartext _OaksLabText_44210
	done

PokedexRatingText_44215:
	fartext _OaksLabText_44215
	done

PokedexRatingText_4421a:
	fartext _OaksLabText_4421a
	done

PokedexRatingText_4421f:
	fartext _OaksLabText_4421f
	done

PokedexRatingText_44224:
	fartext _OaksLabText_44224
	done

PokedexRatingText_44229:
	fartext _OaksLabText_44229
	done

PokedexRatingText_4422e:
	fartext _OaksLabText_4422e
	done

PokedexRatingText_44233:
	fartext _OaksLabText_44233
	done

PokedexRatingText_44238:
	fartext _OaksLabText_44238
	done

PokedexRatingText_4423d:
	fartext _OaksLabText_4423d
	done

PokedexRatingText_44242:
	fartext _OaksLabText_44242
	done

PokedexRatingText_44247:
	fartext _OaksLabText_44247
	done

PokedexRatingText_4424c:
	fartext _OaksLabText_4424c
	done
