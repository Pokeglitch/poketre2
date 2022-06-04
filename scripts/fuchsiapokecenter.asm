FuchsiaPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

FuchsiaPokecenterTextPointers:
	dw FuchsiaHealNurseText
	dw FuchsiaPokecenterText2
	dw FuchsiaPokecenterText3
	dw FuchsiaTradeNurseText

FuchsiaHealNurseText:
	TX_POKECENTER_NURSE

FuchsiaPokecenterText2:
	text ""
	fartext _FuchsiaPokecenterText1
	done

FuchsiaPokecenterText3:
	text ""
	fartext _FuchsiaPokecenterText3
	done

FuchsiaTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST
