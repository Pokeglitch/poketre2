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
	text ""
	fartext _CeladonPokecenterText2
	done

CeladonPokecenterText3:
	text ""
	fartext _CeladonPokecenterText3
	done
