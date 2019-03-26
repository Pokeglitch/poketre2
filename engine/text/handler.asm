; To most the printing to the next line
MoveToNextLine:
	call ResetColumnTilesRemaining

	; decrease the number of rows remaining
	ld a, [wTextboxRowParams]
	dec a
	ld [wTextboxRowParams], a

	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, [hFlags_0xFFF6]
	bit 2, a
	ret nz ; return if single space
	add hl, bc
	ret

; try to reveal the textbox when a user prompt is encountered
CheckRevealTextbox::
    ld a, [wTextboxSettings]
    bit BIT_DONT_REVEAL, a
    ret z ; return if the textbox is not set to be hidden

	ld a, [hWY]
	cp SCREEN_HEIGHT_PIXELS
	ret c ; return if its already revealed

	push de
	push hl
	farcall RevealTextbox
	
	ld a, [wTextboxSettings]
	bit BIT_NO_DELAY, a
	jr nz, .dontEnableDelay

	ld hl, wLetterPrintingDelayFlags
	set 1, [hl] ; enable letter delay

.dontEnableDelay
	pop hl
	pop de
	ret

; To handle the next character in the string
HandleNextChar:
    ld a, [wNextChar]
    ld b, a
    push hl
    ld hl, StringCommandTable

.checkCommandTableLoop
    ld a, [hli]
    cp b
    jp z, JumpToTablePointer
    inc hl
    inc hl
    and a
    jr nz, .checkCommandTableLoop

    ld hl, NestedStringsTable

.checkNestedTableLoop
    ld a, [hli]
    cp b
    jr z, UseNestedTextFromTable
    inc hl
    inc hl
    and a
    jr nz, .checkNestedTableLoop

    pop hl
    ld a, b
    ; fall through

    ; End of table
PlaceNextCharacter:
	ld [hli], a
	ld a, [wTextboxColsRemaining]
	dec a
	ld [wTextboxColsRemaining], a
	call PrintLetterDelay
    jp ReturnAndPlaceNextChar

UseNestedTextFromTable:
    ld c, [hl]
    inc hl
    ld b, [hl]
    pop hl
    push de
    ld d, b
    ld e, c

PlaceNestedString:
	call PlaceTextboxString
	ld h, b
	ld l, c
	pop de
	jp ReturnAndPlaceNextChar

StringCommandTable:
    dbw " ", SpaceCommand ; space
    dbw NEXT_TEXT_LINE, NextLineCommand ; next
    dbw NEXT_TEXT_LINE+1, NextLineCommand ; line
	dbw AUTO_CONTINUE_TEXT, AutoContinueTextCommand ; autocont
	dbw CONTINUE_TEXT, ContinueTextCommand ; cont
	dbw PARAGRAPH, ParagraphCommand ; para
	dbw TEXT_DONE, TextDoneCommand ; done
	dbw TEXT_PROMPT, TextPromptCommand ; prompt
	dbw DEX_PAGE, DexPageCommand ; page
	dbw DEX_END, DexEndCommand ; dex
	dbw MOVE_TARGET_TEXT, MoveTargetTextCommand ; TARGET
	dbw MOVE_USER_TEXT, MoveUserTextCommand ; USER
    db 00

NextLineCommand:
    pop hl
	pop hl
	call MoveToNextLine
	push hl
	jp ReturnAndPlaceNextChar

SpaceCommand:
    pop hl
	inc de
    ld a, [wTextboxSettings]
    bit BIT_NO_WORD_WRAP, a
    jp z, CheckWordWrap
	; fall through

CheckWordWrapReturn:
	dec de
	jr c, .handleWordWrap

	ld a, " "
    jp PlaceNextCharacter

.handleWordWrap
	; if there are rows remaining, move to the next line
	ld a, [wTextboxRowParams]
	and TEXTBOX_ROWS_REMAINING_MASK
	jr nz, .rowsRemaining 

	; if there is auto scroll remaining, then auto scroll
	ld a, [wTextboxRowParams]
	and TEXTBOX_AUTOSCROLL_REMAINING_MASK
	jp nz, AutoContinueText ; auto scroll

	;otherwise, reset autoscroll count and prompt for a scroll
	ld a, [wTextboxSettings]
	and TEXT_LINES_MASK
	swap a
	ld [wTextboxRowParams], a

	jp ContinueText

.rowsRemaining
	pop hl
	call MoveToNextLine
	push hl 
	jp ReturnAndPlaceNextChar

ContinueTextCommand::
    pop hl

ContinueText::
	push de
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll
	pop de
	jr ScrollCommon

AutoContinueTextCommand::
    pop hl

AutoContinueText::
	; decrease the auto scroll count
	ld a, [wTextboxRowParams]
	swap a
	dec a
	swap a
	ld [wTextboxRowParams], a
	;fall through

ScrollCommon:
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	call ResetColumnTilesRemaining
	call GetStartOfBottomRow
	pop de
	jp ReturnAndPlaceNextChar


; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually emtpy
; second time, copy the bottom row of text into the top row of text
ScrollTextUpOneLine::
	coord hl, 0, 2 ; top row of text
	coord de, 0, 1 ; empty line above text
	call GetTextboxSize
	dec a
	jr z, .eraseLastRow
	ld b, a
	xor a

.sizeLoop
	add SCREEN_WIDTH
	dec b
	jr nz, .sizeLoop
	ld b, a

.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText

.eraseLastRow
	call GetStartOfBottomRow
	ld a, " "
	ld b, SCREEN_WIDTH - 2
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText

	; wait five frames
	ld b, 5
.WaitFrame
	call DelayFrame
	dec b
	jr nz, .WaitFrame
	ret

ParagraphCommand:: ; para
    pop hl
	push de
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll
	coord hl, 1, 1
	call GetTextboxSize
	ld b, a
	ld c, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	call ResetRowsRemaining
	call ResetColumnTilesRemaining
	coord hl, 1, 1
	push hl
	jp ReturnAndPlaceNextChar

TextPromptCommand:: ; prompt
    pop hl
	call Delay3
	call CheckRevealTextbox
	call ManualTextScroll
	jr TextFinishCommon

TextDoneCommand:: ; done
    pop hl

TextFinishCommon::
	ld de, TextEndCharText-1
	pop hl
	jp HomeBankswitchReturn

; Pokedex Page
DexPageCommand::
    pop hl
	push de
	ld a, "▼"
	Coorda 18, 16
	call Delay3
	call ManualTextScroll
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp ReturnAndPlaceNextChar

DexEndCommand::
; ends a Pokédex entry
    pop hl
	ld [hl], "."
	pop hl
	jp HomeBankswitchReturn

MoveTargetTextCommand::
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
	ld a, [H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

MoveUserTextCommand::
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a, [H_WHOSETURN]
MonsterNameCharsCommon::
    pop hl
	push de
	ld de, wBattleMonNick ; player active monster name
	and a
	jr nz, .notEnemy

	ld de, EnemyMonText ; enemy monster name

.notEnemy
	jp PlaceNestedString

EnemyMonText::
	db "Enemy "
	TX_RAM wEnemyMonNick
	db "@"

NestedStringsTable:
	dbw PLAYER_NAME_TEXT, wPlayerName ; player
	dbw RIVAL_NAME_TEXT, wRivalName ; rival
	dbw POKE_TEXT, PokeText ; POKé
	dbw PC_TEXT, PCText ; PC
	dbw ROCKET_TEXT, RocketText ; ROCKET
	dbw TM_TEXT, TMText ; TM
	dbw TRAINER_TEXT, TrainerText ; TRAINER
	dbw DOTS_TEXT, DotsText ; 6 dots
	dbw PKMN_TEXT, PKMNText ; PKMN
    db 00

PokeText::
	db "Poké@"

PCText::
	db "PC@"

RocketText::
	db "ROCKET@"

TMText::
	db "TM@"

TrainerText::
	db "TRAINER@"

DotsText::
	db "……@"

PKMNText::
	db $E1,$E2,"@" ; PKMN
