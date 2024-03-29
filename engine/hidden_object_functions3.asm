; prints text for bookshelves in buildings without sign events
PrintBookshelfText:
	ld a, [wSpriteStateData1 + 9] ; player's sprite facing direction
	cp SPRITE_FACING_UP
	jr nz, .noMatch
; facing up
	ld a, [wCurMapTileset]
	ld b, a
	aCoord 8, 7
	ld c, a
	ld hl, BookshelfTileIDs
.loop
	ld a, [hli]
	cp $ff
	jr z, .noMatch
	cp b
	jr nz, .nextBookshelfEntry1
	ld a, [hli]
	cp c
	jr nz, .nextBookshelfEntry2
	ld a, [hl]
	push af
	call EnableAutoTextBoxDrawing
	pop af
	call PrintPredefTextID
	xor a
	ld [$ffdb], a
	ret
.nextBookshelfEntry1
	inc hl
.nextBookshelfEntry2
	inc hl
	jr .loop
.noMatch
	ld a, $ff
	ld [$ffdb], a
	jpba PrintCardKeyText

; format: db tileset id, bookshelf tile id, text id
BookshelfTileIDs:
	db PLATEAU,      $30
	db_tx_pre IndigoPlateauStatues
	db HOUSE,        $3D
	db_tx_pre TownMapText
	db HOUSE,        $1E
	db_tx_pre BookOrSculptureText
	db MANSION,      $32
	db_tx_pre BookOrSculptureText
	db REDS_HOUSE, $32
	db_tx_pre BookOrSculptureText
	db LAB,          $28
	db_tx_pre BookOrSculptureText
	db LOBBY,        $16
	db_tx_pre ElevatorText
	db GYM,          $1D
	db_tx_pre BookOrSculptureText
	db GATE,         $22
	db_tx_pre BookOrSculptureText
	db POKECENTER,   $54
	db_tx_pre PokemonStuffText
	db POKECENTER,   $55
	db_tx_pre PokemonStuffText
	db LOBBY,        $50
	db_tx_pre PokemonStuffText
	db LOBBY,        $52
	db_tx_pre PokemonStuffText
	db SHIP,         $36
	db_tx_pre BookOrSculptureText
	db $FF

IndigoPlateauStatues:
	asmtext
	ld hl, IndigoPlateauStatuesText1
	call PrintText
	ld a, [wXCoord]
	bit 0, a
	ld hl, IndigoPlateauStatuesText2
	jr nz, .ok
	ld hl, IndigoPlateauStatuesText3
.ok
	call PrintText
	jp TextScriptEnd

IndigoPlateauStatuesText1:
	fartext _IndigoPlateauStatuesText1
	done

IndigoPlateauStatuesText2:
	fartext _IndigoPlateauStatuesText2
	done

IndigoPlateauStatuesText3:
	fartext _IndigoPlateauStatuesText3
	done

BookOrSculptureText:
	asmtext
	ld hl, PokemonBooksText
	ld a, [wCurMapTileset]
	cp MANSION ; Celadon Mansion tileset
	jr nz, .ok
	aCoord 8, 6
	cp $38
	jr nz, .ok
	ld hl, DiglettSculptureText
.ok
	call PrintText
	jp TextScriptEnd

PokemonBooksText:
	fartext _PokemonBooksText
	done

DiglettSculptureText:
	fartext _DiglettSculptureText
	done

ElevatorText:
	fartext _ElevatorText
	done

TownMapText:
	fartext _TownMapText
	wait
	asmtext
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wd730
	set 6, [hl]
	call GBPalWhiteOutWithDelay3
	xor a
	ld [hWY], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call LoadFontTilePatterns
	callba DisplayTownMap
	ld hl, wd730
	res 6, [hl]
	ld de, TextScriptEnd
	push de
	jp CloseTextDisplay_StoreBank

PokemonStuffText:
	fartext _PokemonStuffText
	done
