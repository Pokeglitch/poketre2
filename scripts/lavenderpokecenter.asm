LavenderPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

LavenderPokecenterTrainerHeader0:
	db TrainerHeaderTerminator

LavenderPokecenterTextPointers:
	dw LavenderHealNurseText
	dw LavenderPokecenterText2
	dw LavenderPokecenterText3
	dw LavenderTradeNurseText

LavenderTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

LavenderHealNurseText:
	TX_POKECENTER_NURSE

LavenderPokecenterText2:
	fartext _LavenderPokecenterText2
	done

LavenderPokecenterText3:
	fartext _LavenderPokecenterText3
	done
