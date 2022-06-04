CeruleanPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CeruleanPokecenterTextPointers:
	dw CeruleanHealNurseText
	dw CeruleanPokecenterText2
	dw CeruleanPokecenterText3
	dw CeruleanTradeNurseText

CeruleanTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

CeruleanHealNurseText:
	TX_POKECENTER_NURSE

CeruleanPokecenterText2:
	text ""
	fartext _CeruleanPokecenterText2
	done

CeruleanPokecenterText3:
	text ""
	fartext _CeruleanPokecenterText3
	done
