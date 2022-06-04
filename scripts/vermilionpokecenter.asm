VermilionPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

VermilionPokecenterTextPointers:
	dw VermilionHealNurseText
	dw VermilionPokecenterText2
	dw VermilionPokecenterText3
	dw VermilionTradeNurseText

VermilionHealNurseText:
	TX_POKECENTER_NURSE

VermilionPokecenterText2:
	text ""
	fartext _VermilionPokecenterText2
	done

VermilionPokecenterText3:
	text ""
	fartext _VermilionPokecenterText3
	done

VermilionTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST
