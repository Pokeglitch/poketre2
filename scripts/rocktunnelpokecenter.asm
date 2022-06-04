RockTunnelPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

RockTunnelPokecenterTextPointers:
	dw RockTunnelHealNurseText
	dw RockTunnelPokecenterText2
	dw RockTunnelPokecenterText3
	dw RockTunnelTradeNurseText

RockTunnelHealNurseText:
	db $ff

RockTunnelPokecenterText2:
	text ""
	fartext _RockTunnelPokecenterText2
	done

RockTunnelPokecenterText3:
	text ""
	fartext _RockTunnelPokecenterText3
	done

RockTunnelTradeNurseText:
	db $f6
