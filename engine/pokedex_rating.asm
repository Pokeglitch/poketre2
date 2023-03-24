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
	text "POKéDEX comp-"
	next "letion is:"

	para ""
	numtext hDexRatingNumMonsSeen, 3, 1
	text " POKéMON seen"
	next ""
	numtext hDexRatingNumMonsOwned, 3, 1
	text " POKéMON owned"

	para "PROF.OAK's"
	next "Rating:"
	prompt

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
	text "You still have"
	next "lots to do."
	cont "Look for POKéMON"
	cont "in grassy areas!"
	done

PokedexRatingText_44206:
	text "You're on the"
	next "right track! "
	cont "Get a FLASH HM"
	cont "from my AIDE!"
	done

PokedexRatingText_4420b:
	text "You still need"
	next "more POKéMON!"
	cont "Try to catch"
	cont "other species!"
	done

PokedexRatingText_44210:
	text "Good, you're"
	next "trying hard!"
	cont "Get an ITEMFINDER"
	cont "from my AIDE!"
	done

PokedexRatingText_44215:
	text "Looking good!"
	next "Go find my AIDE"
	cont "when you get 50!"
	done

PokedexRatingText_4421a:
	text "You finally got at"
	next "least 50 species!"
	cont "Be sure to get"
	cont "EXP.ALL from my"
	cont "AIDE!"
	done

PokedexRatingText_4421f:
	text "Ho! This is geting"
	next "even better!"
	done

PokedexRatingText_44224:
	text "Very good!"
	next "Go fish for some"
	cont "marine POKéMON!"
	done

PokedexRatingText_44229:
	text "Wonderful!"
	next "Do you like to"
	cont "collect things?"
	done

PokedexRatingText_4422e:
	text "I'm impressed!"
	next "It must have been"
	cont "difficult to do!"
	done

PokedexRatingText_44233:
	text "You finally got at"
	next "least 100 species!"
	cont "I can't believe"
	cont "how good you are!"
	done

PokedexRatingText_44238:
	text "You even have the"
	next "evolved forms of"
	cont "POKéMON! Super!"
	done

PokedexRatingText_4423d:
	text "Excellent! Trade"
	next "with friends to"
	cont "get some more!"
	done

PokedexRatingText_44242:
	text "Outstanding!"
	next "You've become a"
	cont "real pro at this!"
	done

PokedexRatingText_44247:
	text "I have nothing"
	next "left to say!"
	cont "You're the"
	cont "authority now!"
	done

PokedexRatingText_4424c:
	text "Your POKéDEX is"
	next "entirely complete!"
	cont "Congratulations!"
	done
