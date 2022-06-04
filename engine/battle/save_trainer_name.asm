SaveTrainerName:
	ld hl, TrainerNamePointers
	ld a, [wTrainerClass]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wcd6d
.CopyCharacter
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .CopyCharacter
	ret

TrainerNamePointers:
; what is the point of these?
	dw YoungsterName
	dw BugCatcherName
	dw LassName
	dw wTrainerName
	dw JrTrainerMName
	dw JrTrainerFName
	dw PokemaniacName
	dw SuperNerdName
	dw wTrainerName
	dw wTrainerName
	dw BurglarName
	dw EngineerName
	dw JugglerXName
	dw wTrainerName
	dw SwimmerName
	dw wTrainerName
	dw wTrainerName
	dw BeautyName
	dw wTrainerName
	dw RockerName
	dw JugglerName
	dw wTrainerName
	dw wTrainerName
	dw BlackbeltName
	dw wTrainerName
	dw ProfOakName
	dw ChiefName
	dw ScientistName
	dw wTrainerName
	dw RocketName
	dw CooltrainerMName
	dw CooltrainerFName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName

YoungsterName:
	str "YOUNGSTER"
BugCatcherName:
	str "BUG CATCHER"
LassName:
	str "LASS"
JrTrainerMName:
	str "JR.TRAINER♂"
JrTrainerFName:
	str "JR.TRAINER♀"
PokemaniacName:
	str "POKéMANIAC"
SuperNerdName:
	str "SUPER NERD"
BurglarName:
	str "BURGLAR"
EngineerName:
	str "ENGINEER"
JugglerXName:
	str "JUGGLER"
SwimmerName:
	str "SWIMMER"
BeautyName:
	str "BEAUTY"
RockerName:
	str "ROCKER"
JugglerName:
	str "JUGGLER"
BlackbeltName:
	str "BLACKBELT"
ProfOakName:
	str "PROF.OAK"
ChiefName:
	str "CHIEF"
ScientistName:
	str "SCIENTIST"
RocketName:
	str "ROCKET"
CooltrainerMName:
	str "COOLTRAINER♂"
CooltrainerFName:
	str "COOLTRAINER♀"
