item: MACRO
    dw \1Description
    db \2 ; filter
ENDM

ItemAttributeTable:
    item MasterBall, QUICK_BATTLE_USE
	item UltraBall, QUICK_BATTLE_USE | SELLABLE
	item GreatBall, QUICK_BATTLE_USE | SELLABLE
	item PokeBall, QUICK_BATTLE_USE | SELLABLE
	item TownMap, QUICK_FIELD_USE
	item Bicycle, QUICK_FIELD_USE | EXIT_MENU
	item Surfboard, 0
	item SafariBall, 0
	item Pokedex, 0
	item MoonStone, STONE_USE
	item Antidote, HEALTH_USE
	item BurnHeal, HEALTH_USE
	item IceHeal, HEALTH_USE
	item Awakening, HEALTH_USE
	item ParlyzHeal, HEALTH_USE
	item FullRestore, HEALTH_USE
	item MaxPotion, HEALTH_USE
	item HyperPotion, HEALTH_USE
	item SuperPotion, HEALTH_USE
	item Potion, HEALTH_USE
	item BoulderBadge, 0
	item CascadeBadge, 0
	item ThunderBadge, 0
	item RainbowBadge, 0
	item SoulBadge, 0
	item Marshbadge, 0
	item VolcanoBadge, 0
	item EarthBadge, 0
	item EscapeRope, QUICK_FIELD_USE | SELLABLE | EXIT_MENU
	item Repel, QUICK_FIELD_USE | SELLABLE
	item OldAmber, 0
	item FireStone, STONE_USE | SELLABLE
	item ThunderStone, STONE_USE | SELLABLE
	item WaterStone, STONE_USE | SELLABLE
	item HPUp, VITAMIN_USE
	item Protein, VITAMIN_USE
	item Iron, VITAMIN_USE
	item Carbos, VITAMIN_USE
	item Calcium, VITAMIN_USE
	item RareCandy, VITAMIN_USE
	item DomeFossil, 0
	item HelixFossil, 0
	item SecretKey, 0
	item UnusedItem, 0
	item BikeVoucher, 0
	item XAccuracy, QUICK_BATTLE_USE | SELLABLE
	item LeafStone, STONE_USE | SELLABLE
	item CardKey, 0
	item Nugget, SELLABLE
	item PPUp2, 0
	item PokeDoll, QUICK_BATTLE_USE | SELLABLE
	item FullHeal, HEALTH_USE
	item Revive, HEALTH_USE
	item MaxRevive, HEALTH_USE
	item GuardSpec, QUICK_BATTLE_USE | SELLABLE
	item SuperRepel, QUICK_FIELD_USE | SELLABLE
	item MaxRepel, QUICK_FIELD_USE | SELLABLE
	item DireHit, QUICK_BATTLE_USE | SELLABLE
	item Coin, 0
	item FreshWater, HEALTH_USE | HOLDABLE
	item SodaPop, HEALTH_USE | HOLDABLE
	item Lemonade, HEALTH_USE | HOLDABLE
	item SSTicket, HOLDABLE
	item GoldTeeth, 0
	item XAttack, QUICK_BATTLE_USE | SELLABLE
	item XDefend, QUICK_BATTLE_USE | SELLABLE
	item XSpeed, QUICK_BATTLE_USE | SELLABLE
	item XSpecial, QUICK_BATTLE_USE | SELLABLE
	item CoinCase, 0
	item OaksParcel, 0
	item ItemFinder, QUICK_FIELD_USE | EXIT_MENU
	item SilphScope, 0
	item PokeFlute, QUICK_FIELD_USE | QUICK_BATTLE_USE | EXIT_MENU
	item LiftKey, 0
	item ExpAll, 0
	item OldRod, QUICK_FIELD_USE | EXIT_MENU
	item GoodRod, QUICK_FIELD_USE | EXIT_MENU
	item SuperRod, QUICK_FIELD_USE | EXIT_MENU
	item PPUp, QUICK_FIELD_USE | APPLY_TO_PK
	item Ether, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxEther, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item Elixer, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
	item MaxElixer, QUICK_FIELD_USE | QUICK_BATTLE_USE | APPLY_TO_PK
ItemAttributeTableEnd:
