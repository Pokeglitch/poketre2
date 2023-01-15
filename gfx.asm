SECTION "CustomGFX", ROMX, BANK[$3D]
    ResetPreviousTile
    IncludeTiles GUI, Cursor, 1, SliderLeftLight, 2, SliderRightLight, 2, SliderLeftDark, 2, SliderRightDark, 2
    IncludeTiles Palette, White, Light, Dark, Black, Alpha
	IncludeTiles Buttons, A, Select, 3

TitleScreenSharedGFX: INCBIN "gfx/titlescreen/shared.2bpp"
TitleScreenShareGFXEnd:

TitleScreenPokemonBGGFX: INCBIN "gfx/titlescreen/pokemon_bg.2bpp"
TitleScreenPokemonBGGFXEnd:

TitleScreenTeamRocketEditionBGGFX: INCBIN "gfx/titlescreen/team_rocket_edition_bg.2bpp"
TitleScreenTeamRocketEditionBGGFXEnd:

TitleScreenMenuBoxBottomGFX: INCBIN "gfx/titlescreen/menu_box_bottom.2bpp"
TitleScreenMenuBoxBottomGFXEnd:

TitleScreenSolidGFX: INCBIN "gfx/titlescreen/solid.2bpp"
TitleScreenSolidGFXEnd:

TitleScreenExpendableGFX: INCBIN "gfx/titlescreen/expendable.2bpp"
TitleScreenExpendableGFXEnd:

TitleScreenMenuBoxTopSmallGFX: INCBIN "gfx/titlescreen/menu_box_top_small.2bpp"
TitleScreenMenuBoxTopSmallGFXEnd:

TitleScreenTREBGGFX: INCBIN "gfx/titlescreen/tre_bg.2bpp"
TitleScreenTREBGGFXEnd:

TitleScreenPressStartGFX: INCBIN "gfx/titlescreen/press_start.2bpp"
TitleScreenPressStartGFXEnd:

TitleScreenPokemonTextGFX: INCBIN "gfx/titlescreen/pokemon_text.2bpp"
TitleScreenPokemonTextGFXEnd:

TitleScreenTeamRocketEditionTextGFX: INCBIN "gfx/titlescreen/team_rocket_edition_text.2bpp"
TitleScreenTeamRocketEditionTextGFXEnd:

TitleScreenTRETextGFX: INCBIN "gfx/titlescreen/tre_text.2bpp"
TitleScreenTRETextGFXEnd:

TitleScreenMenuBoxTopLargeGFX: INCBIN "gfx/titlescreen/menu_box_top_large.2bpp"
TitleScreenMenuBoxTopLargeGFXEnd:

TitleScreenTextBoxTopGFX: INCBIN "gfx/titlescreen/text_box_top.2bpp"
TitleScreenTextBoxTopGFXEnd:

TitleScreenTextBoxBottomGFX: INCBIN "gfx/titlescreen/text_box_bottom.2bpp"
TitleScreenTextBoxBottomGFXEnd:

TitleScreenMenuLettersGFX: INCBIN "gfx/titlescreen/menu_letters.2bpp"
TitleScreenMenuLettersGFXEnd:

InventoryScreenGFX:
	INCBIN "gfx/inventory/battle_tab.2bpp"
	INCBIN "gfx/inventory/field_tab.2bpp"
	INCBIN "gfx/inventory/health_tab.2bpp"
	INCBIN "gfx/inventory/moves_tab.2bpp"
	INCBIN "gfx/inventory/tab_bottom_border.2bpp"
SelectButtonGFX:
	INCBIN "gfx/inventory/select.2bpp"
SelectButtonGFXEnd:
	INCBIN "gfx/inventory/tab_bottom_border_hidden.2bpp"
	INCBIN "gfx/inventory/cursor.2bpp"
	INCBIN "gfx/inventory/up_down.2bpp"
InventoryScreenGFXEnd:

InventoryScreen2GFX:
	INCBIN "gfx/inventory/filter_text.2bpp"
SliderLeftDarkGFX:
	INCBIN "gfx/inventory/filter_off.2bpp"
SliderLeftDarkGFXEnd:
SliderRightLightGFX:
	INCBIN "gfx/inventory/filter_on.2bpp"
SliderRightLightGFXEnd:
	INCBIN "gfx/inventory/text_box_border_top.2bpp"
	INCBIN "gfx/inventory/arrows.2bpp"
	INCBIN "gfx/inventory/dpad.2bpp"
	INCBIN "gfx/inventory/text_box_border.2bpp"
InventoryScreen2GFXEnd:

InventoryBattlePocketGFX: INCBIN "gfx/inventory/battle_pocket.2bpp"
InventoryFieldPocketGFX: INCBIN "gfx/inventory/field_pocket.2bpp"
InventoryHealthPocketGFX: INCBIN "gfx/inventory/health_pocket.2bpp"
InventoryMovesPocketGFX: INCBIN "gfx/inventory/moves_pocket.2bpp"

INCLUDE "text/item_descriptions.asm"