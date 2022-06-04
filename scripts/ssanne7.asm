SSAnne7Script:
	call SSAnne7Script_6189b
	jp EnableAutoTextBoxDrawing

SSAnne7Script_6189b:
	CheckEvent EVENT_RUBBED_CAPTAINS_BACK
	ret nz
	ld hl, wd72d
	set 5, [hl]
	ret

SSAnne7TextPointers:
	dw SSAnne7Text1
	dw SSAnne7Text2
	dw SSAnne7Text3

SSAnne7Text1:
	TX_ASM
	CheckEvent EVENT_GOT_HM01
	jr nz, .asm_797c4
	ld hl, SSAnne7RubText
	call PrintText
	ld hl, ReceivingHM01Text
	call PrintText
	lb bc, HM_01, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedHM01Text
	call PrintText
	SetEvent EVENT_GOT_HM01
	jr .asm_0faf5
.BagFull
	ld hl, HM01NoRoomText
	call PrintText
	ld hl, wd72d
	set 5, [hl]
	jr .asm_0faf5
.asm_797c4
	ld hl, SSAnne7Text_61932
	call PrintText
.asm_0faf5
	jp TextScriptEnd

SSAnne7RubText:
	text ""
	fartext _SSAnne7RubText
	asmtext
	ld a, [wAudioROMBank]
	cp BANK(Audio3_UpdateMusic)
	ld [wAudioSavedROMBank], a
	jr nz, .asm_61908
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	ld a, Bank(Music_PkmnHealed)
	ld [wAudioROMBank], a
.asm_61908
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.asm_61910
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .asm_61910
	call PlayDefaultMusic
	SetEvent EVENT_RUBBED_CAPTAINS_BACK
	ld hl, wd72d
	res 5, [hl]
	jp TextScriptEnd

ReceivingHM01Text:
	text ""
	fartext _ReceivingHM01Text
	done

ReceivedHM01Text:
	text ""
	fartext _ReceivedHM01Text
	sfxtext SFX_GET_KEY_ITEM
	done

SSAnne7Text_61932:
	text ""
	fartext _SSAnne7Text_61932
	done

HM01NoRoomText:
	text ""
	fartext _HM01NoRoomText
	done

SSAnne7Text2:
	text ""
	fartext _SSAnne7Text2
	done

SSAnne7Text3:
	text ""
	fartext _SSAnne7Text3
	done
