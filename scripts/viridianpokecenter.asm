ViridianPokeCenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

ViridianPokecenterTextPointers:
	dw ViridianHealNurseText
	dw ViridianPokeCenterText2
	dw ViridianPokeCenterText3
	dw ViridianTradeNurseText

ViridianHealNurseText:
	TX_POKECENTER_NURSE

ViridianPokeCenterText2:
	fartext _ViridianPokeCenterText2
	done

ViridianPokeCenterText3:
	fartext _ViridianPokeCenterText3
	done

ViridianTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST
