
; text macros
text     EQUS "db TEXT_INIT," ; Start writing text.
ramtext  EQUS "dbw RAM_TEXT,"
neartext EQUS "dbw NEAR_TEXT,"
textasm  EQUS "db TEXT_ASM"
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
endtext  EQUS "db TEXT_END"

page   EQUS "db DEX_PAGE,"     ; Start a new Pokedex page.
dex    EQUS "db DEX_END, TEXT_END" ; End a Pokedex entry.

str: MACRO
	REPT _NARG
	db \1
	SHIFT
	ENDR
	db TEXT_END
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

TX_RAM: MACRO
; prints text to screen
; \1: RAM address to read from
	db RAM_TEXT
	dw \1
ENDM

TX_BCD: MACRO
; \1: RAM address to read from
; \2: number of bytes + print flags
	db $2
	dw \1
	db \2
ENDM

TX_LINE    EQUS "db $05"
TX_BLINK   EQUS "db $06"
;TX_SCROLL EQUS "db $07"
TX_ASM     EQUS "db $08"

TX_NUM: MACRO
; print a big-endian decimal number.
; \1: address to read from
; \2: number of bytes to read
; \3: number of digits to display
	db $09
	dw \1
	db \2 << 4 | \3
ENDM

TX_DELAY              EQUS "db $0a"
TX_SFX_ITEM_1         EQUS "db $0b"
TX_SFX_LEVEL_UP       EQUS "db $0b"
;TX_ELLIPSES          EQUS "db $0c"
TX_WAIT               EQUS "db $0d"
;TX_SFX_DEX_RATING    EQUS "db $0e"
TX_SFX_ITEM_2         EQUS "db $10"
TX_SFX_KEY_ITEM       EQUS "db $11"
TX_SFX_CAUGHT_MON     EQUS "db $12"
TX_SFX_DEX_PAGE_ADDED EQUS "db $13"
TX_CRY_NIDORINA       EQUS "db $14"
TX_CRY_PIDGEOT        EQUS "db $15"
;TX_CRY_DEWGONG       EQUS "db $16"

TX_FAR: MACRO
	db $17
	dw \1
	db BANK(\1)
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
