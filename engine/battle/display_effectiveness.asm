DisplayEffectiveness:
	ld a, [wDamageMultipliers]
	and $7F
	cp $0A
	ret z
	ld hl, SuperEffectiveText
	jr nc, .done
	ld hl, NotVeryEffectiveText
.done
	jp PrintText

SuperEffectiveText:
	fartext _SuperEffectiveText
	done

NotVeryEffectiveText:
	fartext _NotVeryEffectiveText
	done
