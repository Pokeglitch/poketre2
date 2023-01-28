CinnabarPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CinnabarPokecenterTrainerHeader0:
	db TrainerHeaderTerminator

CinnabarPokecenterTextPointers:
	dw CinnabarHealNurseText
	dw CinnabarPokecenterText2
	dw CinnabarPokecenterText3
	dw CinnabarTradeNurseText

CinnabarHealNurseText:
	TX_POKECENTER_NURSE

CinnabarPokecenterText2:
	fartext _CinnabarPokecenterText2
	done

CinnabarPokecenterText3:
	fartext _CinnabarPokecenterText3
	done

CinnabarTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST
