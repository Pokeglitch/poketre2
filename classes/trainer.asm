Trainer: MACRO
	ConvertName \1
	Prop Name, String, {NAME_STRING}
	Prop Front, Sprite
	Prop Money, BCD2, \2
	Prop Parties, Pointer, {NAME_VALUE}Parties
	Prop Traits, Flags, Gender, \3, Morality, \4, Boss, \5, Rival, \6

	; Default AI Values
	DEF AI_USES = 3
	REDEF AI_ROUTINE EQUS "GenericAI"
	
	IF \7 != 0
		DEF AI_USES = \7
		REDEF AI_ROUTINE EQUS "{NAME_VALUE}AI"
	ENDC
	
	Prop AIUses, Byte, AI_USES
	Prop AIRoutine, Pointer, AI_ROUTINE

	PUSHS
	SECTION "{NAME_VALUE} Parties", ROMX, BANK[$E]
		{NAME_VALUE}Parties:
			INCLUDE "classes/Trainer/Parties/{NAME_VALUE}.asm"
	POPS
ENDM

	Class Trainer
	
	Flag Gender, 	Male,		Female
	Flag Morality, 	Good,		Evil
	Flag Boss, 		No,			Yes
	Flag Rival, 	No,			Yes

	DEF Standard	EQUS "No,	No"
	DEF Rival		EQUS "No,	Yes"
	DEF GymLeader	EQUS "Yes,	No"
	DEF Elite4		EQUS "Yes,	No"
	DEF Elite4Champ	EQUS "Yes,	No"
	DEF RivalChamp	EQUS "Yes,	Yes"

	Entry Youngster,	15,		Male,		Good,	{Standard},		0
	Entry Bug Catcher,	10,		Male,		Good,	{Standard},		0
	Entry Lass,			15,		Female,		Good,	{Standard},		0
	Entry Sailor,		30,		Male,		Good,	{Standard},		0
	Entry Jr.Trainer♂,	20,		Male,		Good,	{Standard},		0
	Entry Jr.Trainer♀,	20,		Female,		Good,	{Standard},		0
	Entry PokéManiac,	50,		Male,		Good,	{Standard},		0
	Entry Super Nerd,	25,		Male,		Good,	{Standard},		0
	Entry Hiker,		35,		Male,		Good,	{Standard},		0
	Entry Biker,		20,		Male,		Good,	{Standard},		0
	Entry Burglar,		90,		Male,		Evil,	{Standard},		0
	Entry Engineer,		50,		Male,		Good,	{Standard},		0
	Entry Fisherman,	35,		Male,		Good,	{Standard},		0
	Entry Swimmer,		5,		Male,		Good,	{Standard},		0
	Entry Cue Ball,		25,		Male,		Evil,	{Standard},		0
	Entry Gambler,		70,		Male,		Evil,	{Standard},		0
	Entry Beauty,		70,		Female,		Good,	{Standard},		0
	Entry Psychic,		10,		Male,		Good,	{Standard},		0
	Entry Rocker,		25,		Male,		Evil,	{Standard},		0
	Entry Juggler,		35,		Male,		Evil,	{Standard},		3
	Entry Tamer,		40,		Male,		Evil,	{Standard},		0
	Entry Bird Keeper,	25,		Male,		Good,	{Standard},		0
	Entry Blackbelt,	25,		Male,		Good,	{Standard},		2
	Entry Rival1,		35,		Male,		Good,	{Rival},		0
	Entry Prof. Oak,	99,		Male,		Good,	{Standard},		0
	Entry Scientist,	50,		Male,		Good,	{Standard},		0
	Entry Giovanni,		99,		Male,		Evil,	{GymLeader},	1
	Entry Rocket,		30,		Male,		Evil,	{Standard},		0
	Entry Cooltrainer♂,	35,		Male,		Good,	{Standard},		2
	Entry Cooltrainer♀,	35,		Female,		Good,	{Standard},		1
	Entry Bruno,		99,		Male,		Good,	{Elite4},		2
	Entry Brock,		99,		Male,		Good,	{GymLeader},	5
	Entry Misty,		99,		Female,		Good,	{GymLeader},	1
	Entry Lt. Surge,	99,		Male,		Good,	{GymLeader},	1
	Entry Erika,		99,		Female,		Good,	{GymLeader},	1
	Entry Koga,			99,		Male,		Good,	{GymLeader},	2
	Entry Blaine,		99,		Male,		Good,	{GymLeader},	2
	Entry Sabrina,		99,		Female,		Good,	{GymLeader},	1
	Entry Gentleman,	70,		Male,		Good,	{Standard},		0
	Entry Rival2,		65,		Male,		Good,	{Rival},		1
	Entry Rival3,		99,		Male,		Good,	{RivalChamp},	1
	Entry Lorelei,		99,		Female,		Good,	{Elite4},		2
	Entry Channeler,	30,		Female,		Good,	{Standard},		0
	Entry Agatha,		99,		Female,		Good,	{Elite4},		2
	Entry Lance,		99,		Male,		Good,	{Elite4Champ},	1
