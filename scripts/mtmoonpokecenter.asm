MtMoonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenterTextPointers:
	dw MtMoonHealNurseText
	dw MtMoonPokecenterText2
	dw MtMoonPokecenterText3
	dw MagikarpSalesmanText
	dw MtMoonPokecenterText5
	dw MtMoonTradeNurseText

MtMoonHealNurseText:
	db $ff

MtMoonPokecenterText2:
	fartext _MtMoonPokecenterText1
	done

MtMoonPokecenterText3:
	fartext _MtMoonPokecenterText3
	done

MagikarpSalesmanText:
	asmtext
	CheckEvent EVENT_BOUGHT_MAGIKARP, 1
	jp c, .alreadyBoughtMagikarp
	ld hl, .Text1
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .choseNo
	ld [hMoney], a
	ld [hMoney + 2], a
	ld a, $5
	ld [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, .NoMoneyText
	jr .printText
.enoughMoney
	lb bc, MAGIKARP, 5
	call GivePokemon
	jr nc, .done
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	SetEvent EVENT_BOUGHT_MAGIKARP
	jr .done
.choseNo
	ld hl, .RefuseText
	jr .printText
.alreadyBoughtMagikarp
	ld hl, .Text2
.printText
	call PrintText
.done
	jp TextScriptEnd

.Text1
	fartext _MagikarpSalesmanText1
	done

.RefuseText
	fartext _MagikarpSalesmanNoText
	done

.NoMoneyText
	fartext _MagikarpSalesmanNoMoneyText
	done

.Text2
	fartext _MagikarpSalesmanText2
	done

MtMoonPokecenterText5:
	fartext _MtMoonPokecenterText5
	done

MtMoonTradeNurseText:
	db $f6
