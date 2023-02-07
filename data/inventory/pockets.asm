MACRO pocket
	dw Inventory\1PocketGFX
    dw w\1PocketPosition
    dw \1PocketItems
    db \1PocketItemsEnd - \1PocketItems
ENDM

; Pocket Attributes Table
PocketAttributesTable:
    pocket Battle
    pocket Field
    pocket Health
    pocket Moves
PocketAttributesTableEnd::

BattlePocketItems:
    db GREAT_BALL
	db MASTER_BALL
	db POKE_BALL
	db ULTRA_BALL
BattlePocketItemsEnd:

HealthPocketItems:
    db ANTIDOTE
	db AWAKENING
	db BURN_HEAL
	db CALCIUM
	db CARBOS
    db DIRE_HIT
	db ELIXER
	db ETHER
	db FRESH_WATER
	db FULL_HEAL
    db FULL_RESTORE
	db GUARD_SPEC
	db HP_UP
	db HYPER_POTION
	db ICE_HEAL
    db IRON
	db LEMONADE
	db MAX_ELIXER
	db MAX_ETHER
	db MAX_POTION
    db MAX_REVIVE
	db PARLYZ_HEAL
	db POTION
	db PP_UP
    db PROTEIN
	db RARE_CANDY
	db REVIVE
	db SODA_POP
	db SUPER_POTION
    db X_ACCURACY
	db X_ATTACK
	db X_DEFEND
	db X_SPECIAL
	db X_SPEED
HealthPocketItemsEnd:

FieldPocketItems:
    db BICYCLE
	db BIKE_VOUCHER
	db CARD_KEY
	db COIN_CASE
    db DOME_FOSSIL
	db ESCAPE_ROPE
	db EXP_ALL
	db FIRE_STONE
    db GOLD_TEETH
	db GOOD_ROD
	db HELIX_FOSSIL
	db ITEMFINDER
    db LEAF_STONE
	db LIFT_KEY
	db MAX_REPEL
	db MOON_STONE
    db NUGGET
	db OAKS_PARCEL
	db OLD_AMBER
	db OLD_ROD
    db POKE_DOLL
	db POKE_FLUTE
	db REPEL
	db S_S_TICKET
    db SECRET_KEY
	db SILPH_SCOPE
	db SUPER_REPEL
	db SUPER_ROD
	db THUNDER_STONE
	db TOWN_MAP
	db WATER_STONE
FieldPocketItemsEnd:

MovesPocketItems:
    db TM_34
    db TM_14
    db TM_08
    db TM_11
    db TM_18
    db HM_01
    db TM_28
    db TM_10
    db TM_32
    db TM_23
    db TM_42
    db TM_26
    db TM_37
    db TM_47
    db TM_38
    db TM_27
    db HM_05
    db HM_02
    db TM_07
    db TM_15
    db TM_13
    db TM_21
    db TM_05
    db TM_01
    db TM_35
    db TM_31
    db TM_16
    db TM_29
    db TM_46
    db TM_20
    db TM_02
    db TM_33
    db TM_44
    db TM_48
    db TM_19
    db TM_36
    db TM_40
    db TM_43
    db TM_41
    db TM_22
    db HM_04
    db TM_17
    db TM_50
    db HM_03
    db TM_39
    db TM_03
    db TM_09
    db TM_30
    db TM_25
    db TM_45
    db TM_24
    db TM_06
    db TM_49
    db TM_12
    db TM_04
MovesPocketItemsEnd:
