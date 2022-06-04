FanClubScript:
	jp EnableAutoTextBoxDrawing

FanClubBikeInBag:
; check if any bike paraphernalia in bag
	CheckEvent EVENT_GOT_BIKE_VOUCHER
	ret nz
	ld b, BICYCLE
	call IsItemInBag
	ret nz
	ld b, BIKE_VOUCHER
	jp IsItemInBag

FanClubTextPointers:
	dw FanClubText1
	dw FanClubText2
	dw FanClubText3
	dw FanClubText4
	dw FanClubText5
	dw FanClubText6
	dw FanClubText7
	dw FanClubText8

FanClubText1:
; pikachu fan
	text ""
	asmtext
	CheckEvent EVENT_PIKACHU_FAN_BOAST
	jr nz, .mineisbetter
	ld hl, .normaltext
	call PrintText
	SetEvent EVENT_SEEL_FAN_BOAST
	jr .done
.mineisbetter
	ld hl, .bettertext
	call PrintText
	ResetEvent EVENT_PIKACHU_FAN_BOAST
.done
	jp TextScriptEnd

.normaltext
	text ""
	fartext PikachuFanText
	done

.bettertext
	text ""
	fartext PikachuFanBetterText
	done

FanClubText2:
; seel fan
	text ""
	asmtext
	CheckEvent EVENT_SEEL_FAN_BOAST
	jr nz, .mineisbetter
	ld hl, .normaltext
	call PrintText
	SetEvent EVENT_PIKACHU_FAN_BOAST
	jr .done
.mineisbetter
	ld hl, .bettertext
	call PrintText
	ResetEvent EVENT_SEEL_FAN_BOAST
.done
	jp TextScriptEnd

.normaltext
	text ""
	fartext SeelFanText
	done

.bettertext
	text ""
	fartext SeelFanBetterText
	done

FanClubText3:
; pikachu
	text ""
	asmtext
	ld hl, .text
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	text ""
	fartext FanClubPikachuText
	done

FanClubText4:
; seel
	text ""
	asmtext
	ld hl, .text
	call PrintText
	ld a, SEEL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	text ""
	fartext FanClubSeelText
	done

FanClubText5:
; chair
	text ""
	asmtext
	call FanClubBikeInBag
	jr nz, .nothingleft

	ld hl, .meetchairtext
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .nothanks

	; tell the story
	ld hl, .storytext
	call PrintText
	lb bc, BIKE_VOUCHER, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, .receivedvouchertext
	call PrintText
	SetEvent EVENT_GOT_BIKE_VOUCHER
	jr .done
.BagFull
	ld hl, .bagfulltext
	call PrintText
	jr .done
.nothanks
	ld hl, .nostorytext
	call PrintText
	jr .done
.nothingleft
	ld hl, .finaltext
	call PrintText
.done
	jp TextScriptEnd

.meetchairtext
	text ""
	fartext FanClubMeetChairText
	done

.storytext
	text ""
	fartext FanClubChairStoryText
	done

.receivedvouchertext
	text ""
	fartext ReceivedBikeVoucherText
	sfxtext SFX_GET_KEY_ITEM
	fartext ExplainBikeVoucherText
	done

.nostorytext
	text ""
	fartext FanClubNoStoryText
	done

.finaltext
	text ""
	fartext FanClubChairFinalText
	done

.bagfulltext
	text ""
	fartext FanClubBagFullText
	done

FanClubText6:
	text ""
	fartext _FanClubText6
	done

FanClubText7:
	text ""
	fartext _FanClubText7
	done

FanClubText8:
	text ""
	fartext _FanClubText8
	done
