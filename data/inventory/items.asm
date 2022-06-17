item: MACRO
    dw \1Description
	IF \2 % 100
		db ( (\2 - 50) / 100 ) | FIFTY_BUCKS
	ELSE
		db \2 / 100
	ENDC
    db \3 ; filter
ENDM

ItemAttributeTable:
    item MasterBall,      0, QUICK_BATTLE_USE
	item UltraBall,    1200, QUICK_BATTLE_USE | SELLABLE
	item GreatBall,      600, QUICK_BATTLE_USE | SELLABLE
	item PokeBall,       200, QUICK_BATTLE_USE | SELLABLE
	item TownMap,          0, QUICK_FIELD_USE
	item Bicycle,          0, QUICK_FIELD_USE | EXIT_MENU
	item Surfboard,        0, 0
	item SafariBall,    1000, 0
	item Pokedex,          0, 0
	item MoonStone,        0, STONE_USE
	item Antidote,       100, HEALTH_USE
	item BurnHeal,       250, HEALTH_USE
	item IceHeal,        250, HEALTH_USE
	item Awakening,      200, HEALTH_USE
	item ParlyzHeal,     200, HEALTH_USE
	item FullRestore,   3000, HEALTH_USE
	item MaxPotion,     2500, HEALTH_USE
	item HyperPotion,   1500, HEALTH_USE
	item SuperPotion,    700, HEALTH_USE
	item Potion,         300, HEALTH_USE
	item BoulderBadge,     0, 0
	item CascadeBadge,     0, 0
	item ThunderBadge,     0, 0
	item RainbowBadge,     0, 0
	item SoulBadge,        0, 0
	item Marshbadge,       0, 0
	item VolcanoBadge,     0, 0
	item EarthBadge,       0, 0
	item EscapeRope,     550, QUICK_FIELD_USE | SELLABLE | EXIT_MENU
	item Repel,          350, QUICK_FIELD_USE | SELLABLE
	item OldAmber,         0, 0
	item FireStone,     2100, STONE_USE | SELLABLE
	item ThunderStone,  2100, STONE_USE | SELLABLE
	item WaterStone,    2100, STONE_USE | SELLABLE
	item HPUp,          9800, VITAMIN_USE
	item Protein,       9800, VITAMIN_USE
	item Iron,          9800, VITAMIN_USE
	item Carbos,        9800, VITAMIN_USE
	item Calcium,       9800, VITAMIN_USE
	item RareCandy,     4800, VITAMIN_USE
	item DomeFossil,       0, 0
	item HelixFossil,      0, 0
	item SecretKey,        0, 0
	item UnusedItem,       0, 0
	item BikeVoucher,      0, 0
	item XAccuracy,      950, QUICK_BATTLE_USE | SELLABLE
	item LeafStone,     2100, STONE_USE | SELLABLE
	item CardKey,          0, 0
	item Nugget,       10000, SELLABLE
	item PPUp2,         9800, 0
	item PokeDoll,      1000, QUICK_BATTLE_USE | SELLABLE
	item FullHeal,       600, HEALTH_USE
	item Revive,        1500, HEALTH_USE
	item MaxRevive,     4000, HEALTH_USE
	item GuardSpec,      700, QUICK_BATTLE_USE | SELLABLE
	item SuperRepel,     500, QUICK_FIELD_USE | SELLABLE
	item MaxRepel,       700, QUICK_FIELD_USE | SELLABLE
	item DireHit,        650, QUICK_BATTLE_USE | SELLABLE
	item Coin,             0, 0
	item FreshWater,     200, HEALTH_USE | HOLDABLE
	item SodaPop,        300, HEALTH_USE | HOLDABLE
	item Lemonade,       350, HEALTH_USE | HOLDABLE
	item SSTicket,         0, HOLDABLE
	item GoldTeeth,        0, 0
	item XAttack,        500, QUICK_BATTLE_USE | SELLABLE
	item XDefend,        550, QUICK_BATTLE_USE | SELLABLE
	item XSpeed,         350, QUICK_BATTLE_USE | SELLABLE
	item XSpecial,       350, QUICK_BATTLE_USE | SELLABLE
	item CoinCase,         0, 0
	item OaksParcel,       0, 0
	item ItemFinder,       0, QUICK_FIELD_USE | EXIT_MENU
	item SilphScope,       0, 0
	item PokeFlute,        0, QUICK_FIELD_USE | QUICK_BATTLE_USE | EXIT_MENU
	item LiftKey,          0, 0
	item ExpAll,           0, 0
	item OldRod,           0, QUICK_FIELD_USE | EXIT_MENU
	item GoodRod,          0, QUICK_FIELD_USE | EXIT_MENU
	item SuperRod,         0, QUICK_FIELD_USE | EXIT_MENU
	item PPUp,             0, QUICK_FIELD_USE | APPLY_TO_PK
	item Ether,            0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxEther,         0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item Elixer,           0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxElixer,        0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
ItemAttributeTableEnd:
