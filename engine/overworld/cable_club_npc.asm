CableClubNPC:
	ld hl, CableClubNPCWelcomeText
	call PrintText
	CheckEvent EVENT_GOT_POKEDEX
	jp nz, .receivedPokedex
; if the player hasn't received the pokedex
	ld c, 60
	call DelayFrames
	ld hl, CableClubNPCMakingPreparationsText
	call PrintText
	jp .didNotConnect
.receivedPokedex
	ld a, $1
	ld [wMenuJoypadPollCount], a
	ld a, 90
	ld [wLinkTimeoutCounter], a
.establishConnectionLoop
	ld a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .establishedConnection
	cp USING_EXTERNAL_CLOCK
	jr z, .establishedConnection
	ld a, CONNECTION_NOT_ESTABLISHED
	ld [hSerialConnectionStatus], a
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ld [rSB], a
	xor a
	ld [hSerialReceiveData], a
	ld a, START_TRANSFER_EXTERNAL_CLOCK
	ld [rSC], a
	ld a, [wLinkTimeoutCounter]
	dec a
	ld [wLinkTimeoutCounter], a
	jr z, .failedToEstablishConnection
	ld a, ESTABLISH_CONNECTION_WITH_INTERNAL_CLOCK
	ld [rSB], a
	ld a, START_TRANSFER_INTERNAL_CLOCK
	ld [rSC], a
	call DelayFrame
	jr .establishConnectionLoop
.establishedConnection
	call Serial_SendZeroByte
	call DelayFrame
	call Serial_SendZeroByte
	ld c, 50
	call DelayFrames
	ld hl, CableClubNPCPleaseApplyHereHaveToSaveText
	call PrintText
	xor a
	ld [wMenuJoypadPollCount], a
	call YesNoChoice
	ld a, $1
	ld [wMenuJoypadPollCount], a
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .choseNo
	callab SaveSAVtoSRAM
	call WaitForSoundToFinish
	ld a, SFX_SAVE
	call PlaySoundWaitForCurrent
	ld hl, CableClubNPCPleaseWaitText
	call PrintText
	ld hl, wUnknownSerialCounter
	ld a, $3
	ld [hli], a
	xor a
	ld [hl], a
	ld [hSerialReceivedNewData], a
	ld [wSerialExchangeNybbleSendData], a
	call Serial_SyncAndExchangeNybble
	ld hl, wUnknownSerialCounter
	ld a, [hli]
	inc a
	jr nz, .connected
	ld a, [hl]
	inc a
	jr nz, .connected
	ld b, 10
.syncLoop
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .syncLoop
	call CloseLinkConnection
	ld hl, CableClubNPCLinkClosedBecauseOfInactivityText
	call PrintText
	jr .didNotConnect
.failedToEstablishConnection
	ld hl, CableClubNPCAreaReservedFor2FriendsLinkedByCableText
	call PrintText
	jr .didNotConnect
.choseNo
	call CloseLinkConnection
	ld hl, CableClubNPCPleaseComeAgainText
	call PrintText
.didNotConnect
	xor a
	ld hl, wUnknownSerialCounter
	ld [hli], a
	ld [hl], a
	ld hl, wd72e
	res 6, [hl]
	xor a
	ld [wMenuJoypadPollCount], a
	ret
.connected
	xor a
	ld [hld], a
	ld [hl], a
	jpab LinkMenu

CableClubNPCAreaReservedFor2FriendsLinkedByCableText:
	fartext _CableClubNPCAreaReservedFor2FriendsLinkedByCableText
	done

CableClubNPCWelcomeText:
	fartext _CableClubNPCWelcomeText
	done

CableClubNPCPleaseApplyHereHaveToSaveText:
	fartext _CableClubNPCPleaseApplyHereHaveToSaveText
	done

CableClubNPCPleaseWaitText:
	fartext _CableClubNPCPleaseWaitText
	delaytext
	done

CableClubNPCLinkClosedBecauseOfInactivityText:
	fartext _CableClubNPCLinkClosedBecauseOfInactivityText
	done

CableClubNPCPleaseComeAgainText:
	fartext _CableClubNPCPleaseComeAgainText
	done

CableClubNPCMakingPreparationsText:
	fartext _CableClubNPCMakingPreparationsText
	done

CloseLinkConnection:
	call Delay3
	ld a, CONNECTION_NOT_ESTABLISHED
	ld [hSerialConnectionStatus], a
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ld [rSB], a
	xor a
	ld [hSerialReceiveData], a
	ld a, START_TRANSFER_EXTERNAL_CLOCK
	ld [rSC], a
	ret
