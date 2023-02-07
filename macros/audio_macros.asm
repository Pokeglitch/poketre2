
MACRO StopAllMusic
	ld a, $ff
	call PlaySound
ENDM

Ch0    EQU 0
Ch1    EQU 1
Ch2    EQU 2
Ch3    EQU 3
Ch4    EQU 4
Ch5    EQU 5
Ch6    EQU 6
Ch7    EQU 7

MACRO audio
	db (_NARG - 2) << 6 | \2
	dw \1_\2
	IF _NARG > 2
		db \3
		dw \1_\3
	ENDC
	IF _NARG > 3
		db \4
		dw \1_\4
	ENDC
	IF _NARG > 4
		db \5
		dw \1_\5
	ENDC
ENDM

;format: length [0, 7], pitch change [-7, 7]
MACRO pitchenvelope
	db $10
	IF \2 > 0
		db (\1 << 4) | \2
	ELSE
		db (\1 << 4) | (%1000 | (\2 * -1))
	ENDC
ENDM

;format: length [0, 15], volume [0, 15], volume change [-7, 7], pitch
MACRO squarenote
	db $20 | \1
	IF \3 < 0
		db (\2 << 4) | (%1000 | (\3 * -1))
	ELSE
		db (\2 << 4) | \3
	ENDC
	dw \4
ENDM

;format: length [0, 15], volume [0, 15], volume change [-7, 7], pitch
MACRO noisenote
	db $20 | \1
	IF \3 < 0
		db (\2 << 4) | (%1000 | (\3 * -1))
	ELSE
		db (\2 << 4) | \3
	ENDC
	db \4
ENDM

;format: pitch length (in 16ths)
MACRO C_
	db $00 | (\1 - 1)
ENDM

MACRO C#
	db $10 | (\1 - 1)
ENDM

MACRO D_
	db $20 | (\1 - 1)
ENDM

MACRO D#
	db $30 | (\1 - 1)
ENDM

MACRO E_
	db $40 | (\1 - 1)
ENDM

MACRO F_
	db $50 | (\1 - 1)
ENDM

MACRO F#
	db $60 | (\1 - 1)
ENDM

MACRO G_
	db $70 | (\1 - 1)
ENDM

MACRO G#
	db $80 | (\1 - 1)
ENDM

MACRO A_
	db $90 | (\1 - 1)
ENDM

MACRO A#
	db $A0 | (\1 - 1)
ENDM

MACRO B_
	db $B0 | (\1 - 1)
ENDM

;format: instrument length (in 16ths)
MACRO snare1
	db $B0 | (\1 - 1)
	db $01
ENDM

MACRO snare2
	db $B0 | (\1 - 1)
	db $02
ENDM

MACRO snare3
	db $B0 | (\1 - 1)
	db $03
ENDM

MACRO snare4
	db $B0 | (\1 - 1)
	db $04
ENDM

MACRO snare5
	db $B0 | (\1 - 1)
	db $05
ENDM

MACRO triangle1
	db $B0 | (\1 - 1)
	db $06
ENDM

MACRO triangle2
	db $B0 | (\1 - 1)
	db $07
ENDM

MACRO snare6
	db $B0 | (\1 - 1)
	db $08
ENDM

MACRO snare7
	db $B0 | (\1 - 1)
	db $09
ENDM

MACRO snare8
	db $B0 | (\1 - 1)
	db $0A
ENDM

MACRO snare9
	db $B0 | (\1 - 1)
	db $0B
ENDM

MACRO cymbal1
	db $B0 | (\1 - 1)
	db $0C
ENDM

MACRO cymbal2
	db $B0 | (\1 - 1)
	db $0D
ENDM

MACRO cymbal3
	db $B0 | (\1 - 1)
	db $0E
ENDM

MACRO mutedsnare1
	db $B0 | (\1 - 1)
	db $0F
ENDM

MACRO triangle3
	db $B0 | (\1 - 1)
	db $10
ENDM

MACRO mutedsnare2
	db $B0 | (\1 - 1)
	db $11
ENDM

MACRO mutedsnare3
	db $B0 | (\1 - 1)
	db $12
ENDM

MACRO mutedsnare4
	db $B0 | (\1 - 1)
	db $13
ENDM

;format: rest length (in 16ths)
MACRO rest
	db $C0 | (\1 - 1)
ENDM

; format: notetype speed, volume, fade
MACRO notetype
	db $D0 | \1
	db (\2 << 4) | \3
ENDM

MACRO dspeed
	db $D0 | \1
ENDM

MACRO octave
	db $E8 - \1
ENDM

MACRO toggleperfectpitch
	db $E8
ENDM

;format: vibrato delay, rate, depth
MACRO vibrato
	db $EA
	db \1
	db (\2 << 4) | \3
ENDM

MACRO pitchbend
	db $EB
	db \1
	db \2
ENDM

MACRO duty
	db $EC
	db \1
ENDM

MACRO tempo
	db $ED
	db \1 / $100
	db \1 % $100
ENDM

MACRO stereopanning
	db $EE
	db \1
ENDM

MACRO volume
	db $F0
	db (\1 << 4) | \2
ENDM

MACRO executemusic
	db $F8
ENDM

MACRO dutycycle
	db $FC
	db \1
ENDM

;format: callchannel address
MACRO callchannel
	db $FD
	dw \1
ENDM

;format: loopchannel count, address
MACRO loopchannel
	db $FE
	db \1
	dw \2
ENDM

MACRO endchannel
	db $FF
ENDM
