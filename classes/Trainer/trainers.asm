    Class_ Trainer
    
    ; Traits
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

    ; MoveSelection
    Flag Ailment,		Ignore,		Check
    Flag SideEffects,	Ignore,		Favor
    Flag TypeAdvantage,	Ignore,		Consider

    Entry Youngster,	15,		Male,		Good,	{Standard},		0,	Ignore,	Ignore,	Ignore
    Entry Bug Catcher,	10,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Lass,			15,		Female,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Sailor,		30,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Jr.Trainer♂,	20,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Jr.Trainer♀,	20,		Female,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry PokéManiac,	50,		Male,		Good,	{Standard},		0,	Check,	Favor,	Consider
    Entry Super Nerd,	25,		Male,		Good,	{Standard},		0,	Check,	Favor,	Ignore
    Entry Hiker,		35,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Biker,		20,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Burglar,		90,		Male,		Evil,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Engineer,		50,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Fisherman,	35,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Swimmer,		5,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Cue Ball,		25,		Male,		Evil,	{Standard},		0,	Ignore,	Ignore,	Ignore
    Entry Gambler,		70,		Male,		Evil,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Beauty,		70,		Female,		Good,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Psychic,		10,		Male,		Good,	{Standard},		0,	Check,	Favor,	Ignore
    Entry Rocker,		25,		Male,		Evil,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Juggler,		35,		Male,		Evil,	{Standard},		3,	Check,	Ignore,	Ignore
    Entry Tamer,		40,		Male,		Evil,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Bird Keeper,	25,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Blackbelt,	25,		Male,		Good,	{Standard},		2,	Check,	Ignore,	Ignore
    Entry Rival1,		35,		Male,		Good,	{Rival},		0,	Check,	Ignore,	Ignore
    Entry Prof. Oak,	99,		Male,		Good,	{Standard},		0,	Check,	Ignore,	Consider
    Entry Scientist,	50,		Male,		Good,	{Standard},		0,	Check,	Favor,	Ignore
    Entry Giovanni,		99,		Male,		Evil,	{GymLeader},	1,	Check,	Ignore,	Consider
    Entry Rocket,		30,		Male,		Evil,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Cooltrainer♂,	35,		Male,		Good,	{Standard},		2,	Check,	Ignore,	Consider
    Entry Cooltrainer♀,	35,		Female,		Good,	{Standard},		1,	Check,	Ignore,	Consider
    Entry Bruno,		99,		Male,		Good,	{Elite4},		2,	Check,	Ignore,	Ignore
    Entry Brock,		99,		Male,		Good,	{GymLeader},	5,	Check,	Ignore,	Ignore
    Entry Misty,		99,		Female,		Good,	{GymLeader},	1,	Check,	Ignore,	Consider
    Entry Lt. Surge,	99,		Male,		Good,	{GymLeader},	1,	Check,	Ignore,	Consider
    Entry Erika,		99,		Female,		Good,	{GymLeader},	1,	Check,	Ignore,	Consider
    Entry Koga,			99,		Male,		Good,	{GymLeader},	2,	Check,	Ignore,	Consider
    Entry Blaine,		99,		Male,		Good,	{GymLeader},	2,	Check,	Ignore,	Consider
    Entry Sabrina,		99,		Female,		Good,	{GymLeader},	1,	Check,	Ignore,	Consider
    Entry Gentleman,	70,		Male,		Good,	{Standard},		0,	Check,	Favor,	Ignore
    Entry Rival2,		65,		Male,		Good,	{Rival},		1,	Check,	Ignore,	Consider
    Entry Rival3,		99,		Male,		Good,	{RivalChamp},	1,	Check,	Ignore,	Consider
    Entry Lorelei,		99,		Female,		Good,	{Elite4},		2,	Check,	Favor,	Consider
    Entry Channeler,	30,		Female,		Good,	{Standard},		0,	Check,	Ignore,	Ignore
    Entry Agatha,		99,		Female,		Good,	{Elite4},		2,	Check,	Ignore,	Ignore
    Entry Lance,		99,		Male,		Good,	{Elite4Champ},	1,	Check,	Ignore,	Consider
