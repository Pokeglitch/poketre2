CeladonDinerScript:
	call EnableAutoTextBoxDrawing
	ret

CeladonDinerTextPointers:
	dw CeladonDinerText1
	dw CeladonDinerText2
	dw CeladonDinerText3
	dw CeladonDinerText4
	dw CeladonDinerText5

CeladonDinerText1:
	fartext _CeladonDinerText1
	done

CeladonDinerText2:
	fartext _CeladonDinerText2
	done

CeladonDinerText3:
	fartext _CeladonDinerText3
	done

CeladonDinerText4:
	fartext _CeladonDinerText4
	done

CeladonDinerText5:
	asmtext
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, .asm_eb14d
	ld hl, CeladonDinerText_491a7
	call PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, ReceivedCoinCaseText
	call PrintText
	jr .asm_68b61
.BagFull
	ld hl, CoinCaseNoRoomText
	call PrintText
	jr .asm_68b61
.asm_eb14d
	ld hl, CeladonDinerText_491b7
	call PrintText
.asm_68b61
	jp TextScriptEnd

CeladonDinerText_491a7:
	fartext _CeladonDinerText_491a7
	done

ReceivedCoinCaseText:
	fartext _ReceivedCoinCaseText
	sfxtext SFX_GET_KEY_ITEM
	done

CoinCaseNoRoomText:
	fartext _CoinCaseNoRoomText
	done

CeladonDinerText_491b7:
	fartext _CeladonDinerText_491b7
	done
