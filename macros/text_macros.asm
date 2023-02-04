; Define the textbox before writing the text
textbox: MACRO
	db TEXTBOX_DEF
	db \1
ENDM

more: MACRO
	REPT _NARG
		db \1   
		SHIFT
	ENDR
ENDM

ramtext: MACRO
	db RAM_TEXT
	dw \1
ENDM

neartext: MACRO
	db NEAR_TEXT
	dw \1
ENDM

Default_asmtext: MACRO
	db TEXT_ASM
ENDM

delaytext: MACRO
	db DELAY_TEXT
ENDM

; Scroll to the next line.
cont: MACRO
	db CONTINUE_TEXT
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Scroll without user interaction
autocont: MACRO
	db AUTO_CONTINUE_TEXT
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Move a line down.
next: MACRO
	db NEXT_TEXT_LINE
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Start a new paragraph.
para: MACRO
	db PARAGRAPH
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

; Start a new paragraph without user interaction
autopara: MACRO
	db AUTO_PARAGRAPH
	REPT _NARG
	db \1
	SHIFT
	ENDR
ENDM

Default_asmdone: MACRO
	jp TextScriptEnd
ENDM

; End a string
Default_done: MACRO
	db TEXT_END
ENDM

; Prompt the player to end a text box (initiating some other event).
Default_prompt: MACRO
	db TEXT_PROMPT
ENDM

; Just wait for a keypress before continuing
wait: MACRO
	db TEXT_WAIT
ENDM

; Exit without waiting for keypress
Default_exit: MACRO
	db TEXT_EXIT
ENDM

str: MACRO
	REPT _NARG
	db \1
	SHIFT
	ENDR
	db TEXT_END
ENDM

; 1 - address
; 2 - num digits
; 3 - num bytes & flags
numtext: MACRO
	db NUM_TEXT
	dw \1
	db (\2 << 3) | \3
ENDM

bcdtext: MACRO
	db BCD_TEXT
	dw \1
	db \2
ENDM

crytext: MACRO
	db CRY_TEXT
	db \1
ENDM

sfxtext: MACRO
	db SFX_TEXT
	db \1
ENDM

two_opt: MACRO
	db TWO_OPTION_TEXT
	dw \1
	dw \2
	dw \3
	dw \4
ENDM

fartext: MACRO
	db FAR_TEXT
	dw \1
	db BANK(\1)
ENDM

gototext: MACRO
	db GOTO_TEXT
	dw \1
ENDM

TX_VENDING_MACHINE         EQUS "db $f5"
TX_CABLE_CLUB_RECEPTIONIST EQUS "db $f6"
TX_PRIZE_VENDOR            EQUS "db $f7"
TX_POKECENTER_PC           EQUS "db $f9"
TX_PLAYERS_PC              EQUS "db $fc"
TX_BILLS_PC                EQUS "db $fd"

TX_MART: MACRO
	db $FE, _NARG
	REPT _NARG
	db \1
	SHIFT
	ENDR
	db $FF
ENDM

TX_POKECENTER_NURSE        EQUS "db $ff"

Default_text: MACRO
	REPT _NARG
		db \1   
		SHIFT
	ENDR
ENDM

REDEF TEXT_AUTO_CLOSE EQUS ""
SetTextAutoClose: MACRO
	REDEF TEXT_AUTO_CLOSE EQUS "\1"
ENDM

Text_asmtext: MACRO
	SetTextAutoClose asmdone
	Default_asmtext
ENDM

Text_done: MACRO
    Default_done
    CloseTextContext
ENDM

Text_asmdone: MACRO
    Default_asmdone
    CloseTextContext
ENDM

Text_prompt: MACRO
    Default_prompt
    CloseTextContext
ENDM

Text_exit: MACRO
    Default_exit
	CloseTextContext
ENDM

CloseTextContext: MACRO
	PurgeTempTextMacros {TEMP_TEXT_CLOSE_MACROS}
	CloseContext
ENDM

; 1 - the auto close macro
; 2+ - other macros which will auto close
REDEF TEMP_TEXT_CLOSE_MACROS EQUS ""
InitTextContext: MACRO
	PushContext Text
	SetTextAutoClose \1
	SHIFT

	ForwardTo DefineTempTextMacros
ENDM

DefineTempTextMacros: MACRO
	; args str was defined before this gets called
	REDEF TEMP_TEXT_CLOSE_MACROS EQUS "{ARGS_STR}"

	REPT _NARG
		REDEF Text_\1 EQUS "TempTextClose \1, "
		SHIFT
	ENDR
ENDM

PurgeTempTextMacros: MACRO
	REDEF TEMP_TEXT_CLOSE_MACROS EQUS ""

	REPT _NARG
		PURGE Text_\1
		SHIFT
	ENDR
ENDM

TempTextClose: MACRO
	REDEF MACRO_NAME EQUS "\1"
	SHIFT
	{TEXT_AUTO_CLOSE}
	ForwardTo {MACRO_NAME}
ENDM