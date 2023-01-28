MtMoonPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

MtMoonPokecenterTrainerHeader0:
	db TrainerHeaderTerminator

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

MAGIKARP_PURCHASE_PRICE EQU 500 ;$

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
	
	ld hl, hMoney
	ld [hl], 0
	inc hl
	ld [hl], MAGIKARP_PURCHASE_PRICE / $100
	inc hl
	ld [hl], MAGIKARP_PURCHASE_PRICE & $FF
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, .NoMoneyText
	jr .printText
.enoughMoney
	lb bc, MAGIKARP, 5
	call GivePokemon
	jr nc, .done

	ld hl, wPriceTemp
	ld [hl], 0
	inc hl
	ld [hl], MAGIKARP_PURCHASE_PRICE / $100
	inc hl
	ld [hl], MAGIKARP_PURCHASE_PRICE & $FF
	ld de, wPlayerMoney + 2
	ld c, 3
	call SubtractBytes
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
