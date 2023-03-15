MACRO item2
    dw \1Description
	; price
	IF \2 % 100
		db ( (\2 - 50) / 100 ) | FIFTY_BUCKS
	ELSE
		db \2 / 100
	ENDC
	; filter
    db \3
ENDM

ItemAttributeTable:
    item2 MasterBall,      0, QUICK_BATTLE_USE
	item2 UltraBall,    1200, QUICK_BATTLE_USE | SELLABLE
	item2 GreatBall,      600, QUICK_BATTLE_USE | SELLABLE
	item2 PokeBall,       200, QUICK_BATTLE_USE | SELLABLE
	item2 TownMap,          0, QUICK_FIELD_USE
	item2 Bicycle,          0, QUICK_FIELD_USE | EXIT_MENU
	item2 Surfboard,        0, 0
	item2 SafariBall,    1000, 0
	item2 Pokedex,          0, 0
	item2 MoonStone,        0, STONE_USE
	item2 Antidote,       100, HEALTH_USE
	item2 BurnHeal,       250, HEALTH_USE
	item2 IceHeal,        250, HEALTH_USE
	item2 Awakening,      200, HEALTH_USE
	item2 ParlyzHeal,     200, HEALTH_USE
	item2 FullRestore,   3000, HEALTH_USE
	item2 MaxPotion,     2500, HEALTH_USE
	item2 HyperPotion,   1500, HEALTH_USE
	item2 SuperPotion,    700, HEALTH_USE
	item2 Potion,         300, HEALTH_USE
	item2 BoulderBadge,     0, 0
	item2 CascadeBadge,     0, 0
	item2 ThunderBadge,     0, 0
	item2 RainbowBadge,     0, 0
	item2 SoulBadge,        0, 0
	item2 Marshbadge,       0, 0
	item2 VolcanoBadge,     0, 0
	item2 EarthBadge,       0, 0
	item2 EscapeRope,     550, QUICK_FIELD_USE | SELLABLE | EXIT_MENU
	item2 Repel,          350, QUICK_FIELD_USE | SELLABLE
	item2 OldAmber,         0, 0
	item2 FireStone,     2100, STONE_USE | SELLABLE
	item2 ThunderStone,  2100, STONE_USE | SELLABLE
	item2 WaterStone,    2100, STONE_USE | SELLABLE
	item2 HPUp,          9800, VITAMIN_USE
	item2 Protein,       9800, VITAMIN_USE
	item2 Iron,          9800, VITAMIN_USE
	item2 Carbos,        9800, VITAMIN_USE
	item2 Calcium,       9800, VITAMIN_USE
	item2 RareCandy,     4800, VITAMIN_USE
	item2 DomeFossil,       0, 0
	item2 HelixFossil,      0, 0
	item2 SecretKey,        0, 0
	item2 UnusedItem,       0, 0
	item2 BikeVoucher,      0, 0
	item2 XAccuracy,      950, QUICK_BATTLE_USE | SELLABLE
	item2 LeafStone,     2100, STONE_USE | SELLABLE
	item2 CardKey,          0, 0
	item2 Nugget,       10000, SELLABLE
	item2 PPUp2,         9800, 0
	item2 PokeDoll,      1000, QUICK_BATTLE_USE | SELLABLE
	item2 FullHeal,       600, HEALTH_USE
	item2 Revive,        1500, HEALTH_USE
	item2 MaxRevive,     4000, HEALTH_USE
	item2 GuardSpec,      700, QUICK_BATTLE_USE | SELLABLE
	item2 SuperRepel,     500, QUICK_FIELD_USE | SELLABLE
	item2 MaxRepel,       700, QUICK_FIELD_USE | SELLABLE
	item2 DireHit,        650, QUICK_BATTLE_USE | SELLABLE
	item2 Coin,             0, 0
	item2 FreshWater,     200, HEALTH_USE | HOLDABLE
	item2 SodaPop,        300, HEALTH_USE | HOLDABLE
	item2 Lemonade,       350, HEALTH_USE | HOLDABLE
	item2 SSTicket,         0, HOLDABLE
	item2 GoldTeeth,        0, 0
	item2 XAttack,        500, QUICK_BATTLE_USE | SELLABLE
	item2 XDefend,        550, QUICK_BATTLE_USE | SELLABLE
	item2 XSpeed,         350, QUICK_BATTLE_USE | SELLABLE
	item2 XSpecial,       350, QUICK_BATTLE_USE | SELLABLE
	item2 CoinCase,         0, 0
	item2 OaksParcel,       0, 0
	item2 ItemFinder,       0, QUICK_FIELD_USE | EXIT_MENU
	item2 SilphScope,       0, 0
	item2 PokeFlute,        0, QUICK_FIELD_USE | QUICK_BATTLE_USE | EXIT_MENU
	item2 LiftKey,          0, 0
	item2 ExpAll,           0, 0
	item2 OldRod,           0, QUICK_FIELD_USE | EXIT_MENU
	item2 GoodRod,          0, QUICK_FIELD_USE | EXIT_MENU
	item2 SuperRod,         0, QUICK_FIELD_USE | EXIT_MENU
	item2 PPUp,             0, QUICK_FIELD_USE | APPLY_TO_PK
	item2 Ether,            0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item2 MaxEther,         0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item2 Elixer,           0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item2 MaxElixer,        0, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
ItemAttributeTableEnd:
