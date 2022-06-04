; TODO
; Add in repeat, skip macros 


; text macros
text     EQUS "db TEXT_INIT," ; Start writing text.
ramtext  EQUS "dbw RAM_TEXT,"
neartext EQUS "dbw NEAR_TEXT,"

asmtext  EQUS "db TEXT_ASM"
TX_ASM     EQUS "db TEXT_INIT, TEXT_ASM"

delaytext EQUS "db DELAY_TEXT"
textbox  EQUS "db TEXTBOX_DEF," ; Define the textbox before writing the text
cont     EQUS "db CONTINUE_TEXT," ; Scroll to the next line.
autocont EQUS "db AUTO_CONTINUE_TEXT," ; Scroll without user interaction
next     EQUS "db NEXT_TEXT_LINE," ; Move a line down.
line     EQUS "db NEXT_TEXT_LINE_2," ; Start writing at the bottom line.
para     EQUS "db PARAGRAPH," ; Start a new paragraph.
autopara EQUS "db AUTO_PARAGRAPH," ; Auto start a new paragraph.
done     EQUS "db TEXT_DONE"  ; End a text box.
prompt   EQUS "db TEXT_PROMPT"  ; Prompt the player to end a text box (initiating some other event).
wait     EQUS "db TEXT_WAIT" ; Just wait for a keypress before continuing

page   EQUS "db DEX_PAGE,"     ; Start a new Pokedex page.
dex    EQUS "db DEX_END, TEXT_END" ; End a Pokedex entry.

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
