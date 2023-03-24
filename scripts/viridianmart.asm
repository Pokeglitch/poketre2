ViridianMartScript:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_GOT_OAKS_PARCEL
	ret nz

	call UpdateSprites

		text "Hey! You came from"
		next "PALLET TOWN?"
		done
		
	; todo - can be an inline macro
	ld hl, wSimulatedJoypadStatesEnd
	ld de, OaksParcelMovementScript
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	call WaitForScriptedPlayerMovement

	Delay 3

		text "You know PROF."
		next "OAK, right?"

		para "His order came in."
		next "Will you take it"
		cont "to him?"

		para "<PLAYER> got"
		next "OAK's PARCEL!"

		sfxtext SFX_GET_KEY_ITEM

	give_item OAKS_PARCEL
	SetEvent EVENT_GOT_OAKS_PARCEL
	ret

OaksParcelMovementScript:
	db D_LEFT, 1
	db D_UP, 2
	db -1
