item: MACRO
    dw \1Description
    db \2 ; price (in hundreds)
    db \3 ; filter
ENDM

; TODO - use the full price and the macro can divie by 100 and set the FIFTY_BUCKS flag if there is a remainder
ItemAttributeTable:
    item MasterBall,    0, QUICK_BATTLE_USE
	item UltraBall,    12, QUICK_BATTLE_USE | SELLABLE
	item GreatBall,     6, QUICK_BATTLE_USE | SELLABLE
	item PokeBall,      2, QUICK_BATTLE_USE | SELLABLE
	item TownMap,       0, QUICK_FIELD_USE
	item Bicycle,       0, QUICK_FIELD_USE | EXIT_MENU
	item Surfboard,     0, 0
	item SafariBall,   10, 0
	item Pokedex,       0, 0
	item MoonStone,     0, STONE_USE
	item Antidote,      1, HEALTH_USE
	item BurnHeal,      2 | FIFTY_BUCKS, HEALTH_USE
	item IceHeal,       2 | FIFTY_BUCKS, HEALTH_USE
	item Awakening,     2, HEALTH_USE
	item ParlyzHeal,    2, HEALTH_USE
	item FullRestore,  30, HEALTH_USE
	item MaxPotion,    25, HEALTH_USE
	item HyperPotion,  15, HEALTH_USE
	item SuperPotion,   7, HEALTH_USE
	item Potion,        3, HEALTH_USE
	item BoulderBadge,  0, 0
	item CascadeBadge,  0, 0
	item ThunderBadge,  0, 0
	item RainbowBadge,  0, 0
	item SoulBadge,     0, 0
	item Marshbadge,    0, 0
	item VolcanoBadge,  0, 0
	item EarthBadge,    0, 0
	item EscapeRope,    5 | FIFTY_BUCKS, QUICK_FIELD_USE | SELLABLE | EXIT_MENU
	item Repel,         3 | FIFTY_BUCKS, QUICK_FIELD_USE | SELLABLE
	item OldAmber,      0, 0
	item FireStone,    21, STONE_USE | SELLABLE
	item ThunderStone, 21, STONE_USE | SELLABLE
	item WaterStone,   21, STONE_USE | SELLABLE
	item HPUp,         98, VITAMIN_USE
	item Protein,      98, VITAMIN_USE
	item Iron,         98, VITAMIN_USE
	item Carbos,       98, VITAMIN_USE
	item Calcium,      98, VITAMIN_USE
	item RareCandy,    48, VITAMIN_USE
	item DomeFossil,    0, 0
	item HelixFossil,   0, 0
	item SecretKey,     0, 0
	item UnusedItem,    0, 0
	item BikeVoucher,   0, 0
	item XAccuracy,     9 | FIFTY_BUCKS, QUICK_BATTLE_USE | SELLABLE
	item LeafStone,    21, STONE_USE | SELLABLE
	item CardKey,       0, 0
	item Nugget,      100, SELLABLE
	item PPUp2,        98, 0
	item PokeDoll,     10, QUICK_BATTLE_USE | SELLABLE
	item FullHeal,      6, HEALTH_USE
	item Revive,       15, HEALTH_USE
	item MaxRevive,    40, HEALTH_USE
	item GuardSpec,     7, QUICK_BATTLE_USE | SELLABLE
	item SuperRepel,    5, QUICK_FIELD_USE | SELLABLE
	item MaxRepel,      7, QUICK_FIELD_USE | SELLABLE
	item DireHit,       6 | FIFTY_BUCKS, QUICK_BATTLE_USE | SELLABLE
	item Coin,          0, 0
	item FreshWater,    2, HEALTH_USE | HOLDABLE
	item SodaPop,       3, HEALTH_USE | HOLDABLE
	item Lemonade,      3 | FIFTY_BUCKS, HEALTH_USE | HOLDABLE
	item SSTicket,      0, HOLDABLE
	item GoldTeeth,     0, 0
	item XAttack,       5, QUICK_BATTLE_USE | SELLABLE
	item XDefend,       5 | FIFTY_BUCKS, QUICK_BATTLE_USE | SELLABLE
	item XSpeed,        3 | FIFTY_BUCKS, QUICK_BATTLE_USE | SELLABLE
	item XSpecial,      3 | FIFTY_BUCKS, QUICK_BATTLE_USE | SELLABLE
	item CoinCase,      0, 0
	item OaksParcel,    0, 0
	item ItemFinder,    0, QUICK_FIELD_USE | EXIT_MENU
	item SilphScope,    0, 0
	item PokeFlute,     0, QUICK_FIELD_USE | QUICK_BATTLE_USE | EXIT_MENU
	item LiftKey,       0, 0
	item ExpAll,        0, 0
	item OldRod,        0, QUICK_FIELD_USE | EXIT_MENU
	item GoodRod,       0, QUICK_FIELD_USE | EXIT_MENU
	item SuperRod,      0, QUICK_FIELD_USE | EXIT_MENU
	item PPUp,          0, QUICK_FIELD_USE | APPLY_TO_PK
	item Ether,         0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxEther,      0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item Elixer,        0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxElixer,     0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
ItemAttributeTableEnd:
