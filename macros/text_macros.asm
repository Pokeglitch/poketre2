; Define the textbox before writing the text
MACRO _textbox
	if \1 == NO_TEXTBOX
		db \1
	else
		db TEXTBOX_DEF, \1
	endc
ENDM

MACRO _more
	foreach db, \#
ENDM

MACRO _ramtext
	db RAM_TEXT
	dw \1
ENDM

MACRO _neartext
	db NEAR_TEXT
	dw \1
ENDM

MACRO _asmtext
	db TEXT_ASM
ENDM

MACRO _delaytext
	db DELAY_TEXT
ENDM

; Scroll to the next line.
MACRO _cont
	foreach db, CONTINUE_TEXT, \#
ENDM

; Scroll without user interaction
MACRO _autocont
	foreach db, AUTO_CONTINUE_TEXT, \#
ENDM

; Move a line down.
MACRO _next
	foreach db, NEXT_TEXT_LINE, \#
ENDM

; Start a new paragraph.
MACRO _para
	foreach db, PARAGRAPH, \#
ENDM

; Start a new paragraph without user interaction
MACRO _autopara
	foreach db, AUTO_PARAGRAPH, \#
ENDM

MACRO _asmdone
	jp TextScriptEnd
ENDM

; End a string
MACRO _done
	db TEXT_END
ENDM

; Prompt the player to end a text box (initiating some other event).
MACRO _prompt
	db TEXT_PROMPT
ENDM

; Just wait for a keypress before continuing
MACRO _wait
	db TEXT_WAIT
ENDM

; Exit without waiting for keypress
MACRO _close
	db TEXT_EXIT
ENDM

macro str
	foreach db, \#, TEXT_END
endm

; 1 - address
; 2 - num digits
; 3 - num bytes & flags
MACRO _numtext
	db NUM_TEXT
	dw \1
	db (\2 << 3) | \3
ENDM

MACRO _bcdtext
	db BCD_TEXT
	dw \1
	db \2
ENDM

MACRO _crytext
	db CRY_TEXT
	db \1
ENDM

MACRO _sfxtext
	db SFX_TEXT
	db \1
ENDM

MACRO _two_opt
	db TWO_OPTION_TEXT
	foreach dw, \#
ENDM

MACRO _fartext
	db FAR_TEXT
	dw \1
	db BANK(\1)
ENDM

MACRO _gototext
	db GOTO_TEXT
	dw \1
ENDM

TX_VENDING_MACHINE         EQUS "db $f5"
TX_CABLE_CLUB_RECEPTIONIST EQUS "db $f6"
TX_PRIZE_VENDOR            EQUS "db $f7"
TX_POKECENTER_PC           EQUS "db $f9"
TX_PLAYERS_PC              EQUS "db $fc"
TX_BILLS_PC                EQUS "db $fd"

MACRO TX_MART
	db $FE, _NARG
	REPT _NARG
		db \1
		SHIFT
	ENDR
	db $FF
ENDM

TX_POKECENTER_NURSE        EQUS "db $ff"

MACRO _text
	foreach db, \#
ENDM
