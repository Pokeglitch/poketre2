SaffronPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

SaffronPokecenterTextPointers:
	dw SaffronHealNurseText
	dw SaffronPokecenterText2
	dw SaffronPokecenterText3
	dw SaffronTradeNurseText

SaffronHealNurseText:
	TX_POKECENTER_NURSE

SaffronPokecenterText2:
	fartext _SaffronPokecenterText2
	done

SaffronPokecenterText3:
	fartext _SaffronPokecenterText3
	done

SaffronTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST
