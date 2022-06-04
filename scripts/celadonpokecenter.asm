CeladonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeladonPokecenterTextPointers:
	dw CeladonHealNurseText
	dw CeladonPokecenterText2
	dw CeladonPokecenterText3
	dw CeladonTradeNurseText

CeladonTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

CeladonHealNurseText:
	TX_POKECENTER_NURSE

CeladonPokecenterText2:
	fartext _CeladonPokecenterText2
	done

CeladonPokecenterText3:
	fartext _CeladonPokecenterText3
	done
