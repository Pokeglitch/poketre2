SilphCo1Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret z
	CheckAndSetEvent EVENT_SILPH_CO_RECEPTIONIST_AT_DESK
	ret nz
	ld a, HS_SILPH_CO_1F_RECEPTIONIST
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

SilphCo1TrainerHeader0:
	db TrainerHeaderTerminator

SilphCo1TextPointers:
	dw SilphCo1Text1

SilphCo1Text1:
	fartext _SilphCo1Text1
	done
