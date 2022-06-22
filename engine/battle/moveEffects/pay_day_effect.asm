PayDayEffect_:
	xor a
	ld hl, wcd6d
	ld [hli], a
	ld a, [H_WHOSETURN]
	and a
	ld a, [wBattleMonLevel]
	jr z, .payDayEffect
	ld a, [wEnemyMonLevel]
.payDayEffect
	add a ; level * 2
	ld [H_DIVIDEND + 2], a
	xor a
	ld hl, H_DIVIDEND
	ld [hli], a
	ld [hli], a
	ld de, wTotalPayDayMoney + 2
	ld c, 3
	call AddBytes
	ld hl, CoinsScatteredText
	jp PrintText

CoinsScatteredText:
	fartext _CoinsScatteredText
	done
