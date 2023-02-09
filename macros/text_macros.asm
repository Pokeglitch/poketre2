; Define the textbox before writing the text
MACRO textbox
	db TEXTBOX_DEF
	db \1
ENDM

MACRO more
	foreach db, \#
ENDM

MACRO ramtext
	db RAM_TEXT
	dw \1
ENDM

MACRO neartext
	db NEAR_TEXT
	dw \1
ENDM

MACRO Default_asmtext
	db TEXT_ASM
ENDM

MACRO delaytext
	db DELAY_TEXT
ENDM

; Scroll to the next line.
MACRO cont
	db CONTINUE_TEXT
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Scroll without user interaction
MACRO autocont
	db AUTO_CONTINUE_TEXT
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Move a line down.
MACRO Default_next
	db NEXT_TEXT_LINE
	REPT _NARG
		db \1
		SHIFT
	ENDR
ENDM

; Start a new paragraph.
MACRO para
	db PARAGRAPH
	REPT _NARG
		db \1
		SHIFT
	ENDR
ENDM

; Start a new paragraph without user interaction
MACRO autopara
	db AUTO_PARAGRAPH
	REPT _NARG
		db \1
		SHIFT
	ENDR
ENDM

MACRO Default_asmdone
	jp TextScriptEnd
ENDM

; End a string
MACRO Default_done
	db TEXT_END
ENDM

; Prompt the player to end a text box (initiating some other event).
MACRO Default_prompt
	db TEXT_PROMPT
ENDM

; Just wait for a keypress before continuing
MACRO wait
	db TEXT_WAIT
ENDM

; Exit without waiting for keypress
MACRO Default_exit
	db TEXT_EXIT
ENDM

MACRO str
	REPT _NARG
		db \1
		SHIFT
	ENDR
	db TEXT_END
ENDM

; 1 - address
; 2 - num digits
; 3 - num bytes & flags
MACRO numtext
	db NUM_TEXT
	dw \1
	db (\2 << 3) | \3
ENDM

MACRO bcdtext
	db BCD_TEXT
	dw \1
	db \2
ENDM

MACRO crytext
	db CRY_TEXT
	db \1
ENDM

MACRO sfxtext
	db SFX_TEXT
	db \1
ENDM

MACRO two_opt
	db TWO_OPTION_TEXT
	dw \1
	dw \2
	dw \3
	dw \4
ENDM

MACRO fartext
	db FAR_TEXT
	dw \1
	db BANK(\1)
ENDM

MACRO gototext
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

MACRO Default_text
	foreach db, \#
ENDM

REDEF TEXT_AUTO_CLOSE EQUS ""
MACRO SetTextAutoClose
	REDEF TEXT_AUTO_CLOSE EQUS "\1"
ENDM

MACRO Text_asmtext
	SetTextAutoClose asmdone
	Default_asmtext
ENDM

MACRO Text_done
    Default_done
    CloseTextContext
ENDM

MACRO Text_asmdone
    Default_asmdone
    CloseTextContext
ENDM

MACRO Text_prompt
    Default_prompt
    CloseTextContext
ENDM

MACRO Text_exit
    Default_exit
	CloseTextContext
ENDM

MACRO CloseTextContext
	PurgeTempTextMacros {TEMP_TEXT_CLOSE_MACROS}
	CloseContext
ENDM

; 1 - the auto close macro
; 2+ - other macros which will auto close
REDEF TEMP_TEXT_CLOSE_MACROS EQUS ""
MACRO InitTextContext
	PushContext Text
	SetTextAutoClose \1
	SHIFT

	REDEF TEMP_TEXT_CLOSE_MACROS EQUS "\#"

	REPT _NARG
		REDEF Text_\1 EQUS "TempTextClose \1, "
		SHIFT
	ENDR
ENDM

MACRO PurgeTempTextMacros
	REDEF TEMP_TEXT_CLOSE_MACROS EQUS ""

	REPT _NARG
		PURGE Text_\1
		SHIFT
	ENDR
ENDM

MACRO TempTextClose
	REDEF MACRO_NAME EQUS "\1"
	SHIFT
	{TEXT_AUTO_CLOSE}
	{MACRO_NAME} \#
ENDM

	DefineDefaultMacros Text, next