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

FanClubTrainerHeader0:
	db TrainerHeaderTerminator

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
	fartext PikachuFanText
	done

.bettertext
	fartext PikachuFanBetterText
	done

FanClubText2:
; seel fan
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
	fartext SeelFanText
	done

.bettertext
	fartext SeelFanBetterText
	done

FanClubText3:
; pikachu
	asmtext
	ld hl, .text
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	fartext FanClubPikachuText
	done

FanClubText4:
; seel
	asmtext
	ld hl, .text
	call PrintText
	ld a, SEEL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	fartext FanClubSeelText
	done

FanClubText5:
; chair
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
	fartext FanClubMeetChairText
	done

.storytext
	fartext FanClubChairStoryText
	done

.receivedvouchertext
	fartext ReceivedBikeVoucherText
	sfxtext SFX_GET_KEY_ITEM
	fartext ExplainBikeVoucherText
	done

.nostorytext
	fartext FanClubNoStoryText
	done

.finaltext
	fartext FanClubChairFinalText
	done

.bagfulltext
	fartext FanClubBagFullText
	done

FanClubText6:
	fartext _FanClubText6
	done

FanClubText7:
	fartext _FanClubText7
	done

FanClubText8:
	fartext _FanClubText8
	done
