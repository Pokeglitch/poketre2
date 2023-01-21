Trainer: MACRO
	ConvertName \1
	Prop Name, String, {NAME_STRING}
	Prop Front, Sprite
	Prop Money, BCD2, \2

	Prop Traits, Flags, Gender, \3, Morality, \4, Boss, \5, Rival, \6
ENDM

	Table Trainer
	
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

	Entry Youngster,	15,		Male,		Good,	{Standard}
	Entry Bug Catcher,	10,		Male,		Good,	{Standard}
	Entry Lass,			15,		Female,		Good,	{Standard}
	Entry Sailor,		30,		Male,		Good,	{Standard}
	Entry Jr.Trainer♂,	20,		Male,		Good,	{Standard}
	Entry Jr.Trainer♀,	20,		Female,		Good,	{Standard}
	Entry PokéManiac,	50,		Male,		Good,	{Standard}
	Entry Super Nerd,	25,		Male,		Good,	{Standard}
	Entry Hiker,		35,		Male,		Good,	{Standard}
	Entry Biker,		20,		Male,		Good,	{Standard}
	Entry Burglar,		90,		Male,		Evil,	{Standard}
	Entry Engineer,		50,		Male,		Good,	{Standard}
	Entry Fisherman,	35,		Male,		Good,	{Standard}
	Entry Swimmer,		5,		Male,		Good,	{Standard}
	Entry Cue Ball,		25,		Male,		Evil,	{Standard}
	Entry Gambler,		70,		Male,		Evil,	{Standard}
	Entry Beauty,		70,		Female,		Good,	{Standard}
	Entry Psychic,		10,		Male,		Good,	{Standard}
	Entry Rocker,		25,		Male,		Evil,	{Standard}
	Entry Juggler,		35,		Male,		Evil,	{Standard}
	Entry Tamer,		40,		Male,		Evil,	{Standard}
	Entry Bird Keeper,	25,		Male,		Good,	{Standard}
	Entry Blackbelt,	25,		Male,		Good,	{Standard}
	Entry Rival1,		35,		Male,		Good,	{Rival}
	Entry Prof. Oak,	99,		Male,		Good,	{Standard}
	Entry Scientist,	50,		Male,		Good,	{Standard}
	Entry Giovanni,		99,		Male,		Evil,	{GymLeader}
	Entry Rocket,		30,		Male,		Evil,	{Standard}
	Entry Cooltrainer♂,	35,		Male,		Good,	{Standard}
	Entry Cooltrainer♀,	35,		Female,		Good,	{Standard}
	Entry Bruno,		99,		Male,		Good,	{Elite4}
	Entry Brock,		99,		Male,		Good,	{GymLeader}
	Entry Misty,		99,		Female,		Good,	{GymLeader}
	Entry Lt. Surge,	99,		Male,		Good,	{GymLeader}
	Entry Erika,		99,		Female,		Good,	{GymLeader}
	Entry Koga,			99,		Male,		Good,	{GymLeader}
	Entry Blaine,		99,		Male,		Good,	{GymLeader}
	Entry Sabrina,		99,		Female,		Good,	{GymLeader}
	Entry Gentleman,	70,		Male,		Good,	{Standard}
	Entry Rival2,		65,		Male,		Good,	{Rival}
	Entry Rival3,		99,		Male,		Good,	{RivalChamp}
	Entry Lorelei,		99,		Female,		Good,	{Elite4}
	Entry Channeler,	30,		Female,		Good,	{Standard}
	Entry Agatha,		99,		Female,		Good,	{Elite4}
	Entry Lance,		99,		Male,		Good,	{Elite4Champ}
