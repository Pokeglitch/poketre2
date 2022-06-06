INCLUDE "charmap.asm"
INCLUDE "constants/text_constants.asm"
TEXT_1  EQU $20
TEXT_2  EQU TEXT_1 + 1
TEXT_3  EQU TEXT_2 + 1
TEXT_4  EQU TEXT_3 + 1
TEXT_5  EQU TEXT_4 + 1
TEXT_6  EQU TEXT_5 + 1
TEXT_7  EQU TEXT_6 + 1
TEXT_8  EQU TEXT_7 + 1
TEXT_9  EQU TEXT_8 + 1
TEXT_10 EQU TEXT_9 + 1
TEXT_11 EQU TEXT_10 + 1

POKEDEX_TEXT EQU TEXT_11 + 1
MOVE_NAMES   EQU POKEDEX_TEXT + 1

INCLUDE "macros.asm"
INCLUDE "hram.asm"


SECTION "Text 1", ROMX, BANK[TEXT_1]

_CardKeySuccessText1::
	text "Bingo!"
	done

_CardKeySuccessText2::
	next "The CARD KEY"
	cont "opened the door!"
	done

_CardKeyFailText::
	text "Darn! It needs a"
	next "CARD KEY!"
	done

_TrainerNameText::
	ramtext wcd6d
	text ": "
	done

_NoNibbleText::
	text "Not even a nibble!"
	prompt

_NothingHereText::
	text "Looks like there's"
	next "nothing here."
	prompt

_ItsABiteText::
	text "Oh!"
	next "It's a bite!"
	prompt

_ExclamationText::
	text "!"
	done

_GroundRoseText::
	text "Ground rose up"
	next "somewhere!"
	done

_BoulderText::
	text "This requires"
	next "STRENGTH to move!"
	done

_MartSignText::
	text "All your item"
	next "needs fulfilled!"
	cont "POKéMON MART"
	done

_PokeCenterSignText::
	text "Heal Your POKéMON!"
	next "POKéMON CENTER"
	done

_FoundItemText::
	text "<PLAYER> found"
	next ""
	ramtext wcf4b
	text "!"
	done

_NoMoreRoomForItemText::
	text "No more room for"
	next "items!"
	done

_OaksAideHiText::
	text "Hi! Remember me?"
	next "I'm PROF.OAK's"
	cont "AIDE!"

	para "If you caught "
	numtext hOaksAideRequirement, 3, 1
	next "kinds of POKéMON,"
	cont "I'm supposed to"
	cont "give you an"
	cont ""
	ramtext wOaksAideRewardItemName
	text "!"

	para "So, <PLAYER>! Have"
	next "you caught at"
	cont "least "
	numtext hOaksAideRequirement, 3, 1
	text " kinds of"
	cont "POKéMON?"
	done

_OaksAideUhOhText::
	text "Let's see..."
	next "Uh-oh! You have"
	cont "caught only "
	numtext hOaksAideNumMonsOwned, 3, 1
	cont "kinds of POKéMON!"

	para "You need "
	numtext hOaksAideRequirement, 3, 1
	text " kinds"
	next "if you want the"
	cont ""
	ramtext wOaksAideRewardItemName
	text "."
	done

_OaksAideComeBackText::
	text "Oh. I see."

	para "When you get "
	numtext hOaksAideRequirement, 3, 1
	next "kinds, come back"
	cont "for "
	ramtext wOaksAideRewardItemName
	text "."
	done

_OaksAideHereYouGoText::
	text "Great! You have"
	next "caught "
	numtext hOaksAideNumMonsOwned, 3, 1
	text " kinds "
	cont "of POKéMON!"
	cont "Congratulations!"

	para "Here you go!"
	prompt

_OaksAideGotItemText::
	text "<PLAYER> got the"
	next ""
	ramtext wOaksAideRewardItemName
	text "!"
	done

_OaksAideNoRoomText::
	text "Oh! I see you"
	next "don't have any"
	cont "room for the"
	cont ""
	ramtext wOaksAideRewardItemName
	text "."
	done

INCLUDE "text/maps/viridian_forest.asm"
INCLUDE "text/maps/mt_moon_1f.asm"
INCLUDE "text/maps/mt_moon_b1f.asm"
INCLUDE "text/maps/mt_moon_b2f.asm"
INCLUDE "text/maps/ss_anne_1.asm"
INCLUDE "text/maps/ss_anne_2.asm"
INCLUDE "text/maps/ss_anne_3.asm"
INCLUDE "text/maps/ss_anne_5.asm"
INCLUDE "text/maps/ss_anne_6.asm"
INCLUDE "text/maps/ss_anne_7.asm"
INCLUDE "text/maps/ss_anne_8.asm"
INCLUDE "text/maps/ss_anne_9.asm"
INCLUDE "text/maps/ss_anne_10.asm"
INCLUDE "text/maps/victory_road_3f.asm"
INCLUDE "text/maps/rocket_hideout_b1f.asm"
INCLUDE "text/maps/rocket_hideout_b2f.asm"
INCLUDE "text/maps/rocket_hideout_b3f.asm"
INCLUDE "text/maps/rocket_hideout_b4f.asm"
INCLUDE "text/maps/rocket_hideout_elevator.asm"
INCLUDE "text/maps/silph_co_2f.asm"
INCLUDE "text/maps/silph_co_3f.asm"
INCLUDE "text/maps/silph_co_4f.asm"
INCLUDE "text/maps/silph_co_5f_1.asm"


SECTION "Text 2", ROMX, BANK[TEXT_2]

INCLUDE "text/maps/silph_co_5f_2.asm"
INCLUDE "text/maps/silph_co_6f.asm"
INCLUDE "text/maps/silph_co_7f.asm"
INCLUDE "text/maps/silph_co_8f.asm"
INCLUDE "text/maps/silph_co_9f.asm"
INCLUDE "text/maps/silph_co_10f.asm"
INCLUDE "text/maps/silph_co_11f.asm"
INCLUDE "text/maps/mansion_2f.asm"
INCLUDE "text/maps/mansion_3f.asm"
INCLUDE "text/maps/mansion_b1f.asm"
INCLUDE "text/maps/safari_zone_east.asm"
INCLUDE "text/maps/safari_zone_north.asm"
INCLUDE "text/maps/safari_zone_west.asm"
INCLUDE "text/maps/safari_zone_center.asm"
INCLUDE "text/maps/safari_zone_rest_house_1.asm"
INCLUDE "text/maps/safari_zone_secret_house.asm"
INCLUDE "text/maps/safari_zone_rest_house_2.asm"
INCLUDE "text/maps/safari_zone_rest_house_3.asm"
INCLUDE "text/maps/safari_zone_rest_house_4.asm"
INCLUDE "text/maps/unknown_dungeon_b1f.asm"
INCLUDE "text/maps/victory_road_1f.asm"
INCLUDE "text/maps/lance.asm"
INCLUDE "text/maps/hall_of_fame.asm"
INCLUDE "text/maps/champion.asm"
INCLUDE "text/maps/lorelei.asm"
INCLUDE "text/maps/bruno.asm"
INCLUDE "text/maps/agatha.asm"
INCLUDE "text/maps/rock_tunnel_b2f_1.asm"


SECTION "Text 3", ROMX, BANK[TEXT_3]

INCLUDE "text/maps/rock_tunnel_b2f_2.asm"
INCLUDE "text/maps/seafoam_islands_b4f.asm"

_AIBattleWithdrawText::
	ramtext wTrainerName
	text " with-"
	next "drew "
	ramtext wEnemyMonNick
	text "!"
	prompt

_AIBattleUseItemText::
	ramtext wTrainerName
	next "used "
	ramtext wcd6d
	cont "on "
	ramtext wEnemyMonNick
	text "!"
	prompt

_TradeWentToText::
	ramtext wcf4b
	text " went"
	next "to "
	ramtext wGrassRate
	text "."
	done

_TradeForText::
	text "For <PLAYER>'s"
	next ""
	ramtext wcf4b
	text ","
	done

_TradeSendsText::
	ramtext wGrassRate
	text " sends"
	next ""
	ramtext wcd6d
	text "."
	done

_TradeWavesFarewellText::
	ramtext wGrassRate
	text " waves"
	next "farewell as"
	done

_TradeTransferredText::
	ramtext wcd6d
	text " is"
	next "transferred."
	done

_TradeTakeCareText::
	text "Take good care of"
	next ""
	ramtext wcd6d
	text "."
	done

_TradeWillTradeText::
	ramtext wGrassRate
	text " will"
	next "trade "
	ramtext wcd6d
	done

_TradeforText::
	text "for <PLAYER>'s"
	next ""
	ramtext wcf4b
	text "."
	done

_PlaySlotMachineText::
	text "A slot machine!"
	next "Want to play?"
	done

_OutOfCoinsSlotMachineText::
	text "Darn!"
	next "Ran out of coins!"
	done

_BetHowManySlotMachineText::
	text "Bet how many"
	next "coins?"
	done

_StartSlotMachineText::
	text "Start!"
	done

_NotEnoughCoinsSlotMachineText::
	text "Not enough"
	next "coins!"
	prompt

_OneMoreGoSlotMachineText::
	text "One more "
	next "go?"
	done

_LinedUpText::
	text " lined up!"
	next "Scored "
	ramtext wcf4b
	text " coins!"
	done

_NotThisTimeText::
	text "Not this time!"
	prompt

_YeahText::
	text "Yeah!"
	done

_DexSeenOwnedText::
	text "POKéDEX   Seen:"
	numtext wDexRatingNumMonsSeen, 3, 1
	next "         Owned:"
	numtext wDexRatingNumMonsOwned, 3, 1
	db "@"

_DexRatingText::
	text "POKéDEX Rating", $6d
	done

_GymStatueText1::
	ramtext wGymCityName
	next "POKéMON GYM"
	cont "LEADER: "
	ramtext wGymLeaderName

	para "WINNING TRAINERS:"
	next "<RIVAL>"
	done

_GymStatueText2::
	ramtext wGymCityName
	next "POKéMON GYM"
	cont "LEADER: "
	ramtext wGymLeaderName

	para "WINNING TRAINERS:"
	next "<RIVAL>"
	cont "<PLAYER>"
	done

_ViridianCityPokecenterGuyText::
	text "POKéMON CENTERs"
	next "heal your tired,"
	cont "hurt or fainted"
	cont "POKéMON!"
	done

_PewterCityPokecenterGuyText::
	text "Yawn!"

	para "When JIGGLYPUFF"
	next "sings, POKéMON"
	cont "get drowsy..."

	para "...Me too..."
	next "Snore..."
	done

_CeruleanPokecenterGuyText::
	text "BILL has lots of"
	next "POKéMON!"

	para "He collects rare"
	next "ones too!"
	done

_LavenderPokecenterGuyText::
	text "CUBONEs wear"
	next "skulls, right?"

	para "People will pay a"
	next "lot for one!"
	done

_MtMoonPokecenterBenchGuyText::
	text "If you have too"
	next "many POKéMON, you"
	cont "should store them"
	cont "via PC!"
	done

_RockTunnelPokecenterGuyText::
	text "I heard that"
	next "GHOSTs haunt"
	cont "LAVENDER TOWN!"
	done

_UnusedBenchGuyText1::
	text "I wish I could"
	next "catch POKéMON."
	done

_UnusedBenchGuyText2::
	text "I'm tired from"
	next "all the fun..."
	done

_UnusedBenchGuyText3::
	text "SILPH's manager"
	next "is hiding in the"
	cont "SAFARI ZONE."
	done

_VermilionPokecenterGuyText::
	text "It is true that a"
	next "higher level"
	cont "POKéMON will be"
	cont "more powerful..."

	para "But, all POKéMON"
	next "will have weak"
	cont "points against"
	cont "specific types."

	para "So, there is no"
	next "universally"
	cont "strong POKéMON."
	done

_CeladonCityPokecenterGuyText::
	text "If I had a BIKE,"
	next "I would go to"
	cont "CYCLING ROAD!"
	done

_FuchsiaCityPokecenterGuyText::
	text "If you're studying "
	next "POKéMON, visit"
	cont "the SAFARI ZONE."

	para "It has all sorts"
	next "of rare POKéMON."
	done

_CinnabarPokecenterGuyText::
	text "POKéMON can still"
	next "learn techniques"
	cont "after canceling"
	cont "evolution."

	para "Evolution can wait"
	next "until new moves"
	cont "have been learned."
	done

_SaffronCityPokecenterGuyText1::
	text "It would be great"
	next "if the ELITE FOUR"
	cont "came and stomped"
	cont "TEAM ROCKET!"
	done

_SaffronCityPokecenterGuyText2::
	text "TEAM ROCKET took"
	next "off! We can go"
	cont "out safely again!"
	cont "That's great!"
	done

_CeladonCityHotelText::
	text "My sis brought me"
	next "on this vacation!"
	done

_BookcaseText::
	text "Crammed full of"
	next "POKéMON books!"
	done

_NewBicycleText::
	text "A shiny new"
	next "BICYCLE!"
	done

_PushStartText::
	text "Push START to"
	next "open the MENU!"
	done

_SaveOptionText::
	text "The SAVE option is"
	next "on the MENU"
	cont "screen."
	done

_StrengthsAndWeaknessesText::
	text "All POKéMON types"
	next "have strong and"
	cont "weak points"
	cont "against others."
	done

_TimesUpText::
	str "PA: Ding-dong!", par, "Time's up!"

_GameOverText::
	str "PA: Your SAFARI GAME is over!"

_CinnabarGymQuizIntroText::
	text "POKéMON Quiz!"

	para "Get it right and"
	next "the door opens to"
	cont "the next room!"

	para "Get it wrong and"
	next "face a trainer!"

	para "If you want to"
	next "conserve your"
	cont "POKéMON for the"
	cont "GYM LEADER..."

	para "Then get it right!"
	next "Here we go!"
	prompt

_CinnabarQuizQuestionsText1::
	text "CATERPIE evolves"
	next "into BUTTERFREE?"
	done

_CinnabarQuizQuestionsText2::
	text "There are 9"
	next "certified POKéMON"
	cont "LEAGUE BADGEs?"
	done

_CinnabarQuizQuestionsText3::
	text "POLIWAG evolves 3"
	next "times?"
	done

_CinnabarQuizQuestionsText4::
	text "Are thunder moves"
	next "effective against"
	cont "ground element-"
	cont "type POKéMON?"
	done

_CinnabarQuizQuestionsText5::
	text "POKéMON of the"
	next "same kind and"
	cont "level are not"
	cont "identical?"
	done

_CinnabarQuizQuestionsText6::
	text "TM28 contains"
	next "TOMBSTONER?"
	done

_CinnabarGymQuizCorrectText::
	text "You're absolutely"
	next "correct!"

	para "Go on through!"
	done

_CinnabarGymQuizIncorrectText::
	text "Sorry! Bad call!"
	prompt

_MagazinesText::
	text "POKéMON magazines!"

	para "POKéMON notebooks!"

	para "POKéMON graphs!"
	done

_BillsHouseMonitorText::
	text "TELEPORTER is"
	next "displayed on the"
	cont "PC monitor."
	done

_BillsHouseInitiatedText::
	text "<PLAYER> initiated"
	next "TELEPORTER's Cell"
	cont "Separator!"
	done

_BillsHousePokemonListText1::
	text "BILL's favorite"
	next "POKéMON list!"
	prompt

_BillsHousePokemonListText2::
	text "Which POKéMON do"
	next "you want to see?"
	done

_OakLabEmailText::
	text "There's an e-mail"
	next "message here!"

	para "..."

	para "Calling all"
	next "POKéMON trainers!"

	para "The elite trainers"
	next "of POKéMON LEAGUE"
	cont "are ready to take"
	cont "on all comers!"

	para "Bring your best"
	next "POKéMON and see"
	cont "how you rate as a"
	cont "trainer!"

	para "POKéMON LEAGUE HQ"
	next "INDIGO PLATEAU"

	para "PS: PROF.OAK,"
	next "please visit us!"
	cont "..."
	done

_GameCornerCoinCaseText::
	text "A COIN CASE is"
	next "required!"
	done

_GameCornerNoCoinsText::
	text "You don't have"
	next "any coins!"
	done

_GameCornerOutOfOrderText::
	text "OUT OF ORDER"
	next "This is broken."
	done

_GameCornerOutToLunchText::
	text "OUT TO LUNCH"
	next "This is reserved."
	done

_GameCornerSomeonesKeysText::
	text "Someone's keys!"
	next "They'll be back."
	done

_JustAMomentText::
	text "Just a moment."
	done

TMNotebookText::
	text "It's a pamphlet"
	next "on TMs."

	para "..."

	para "There are 50 TMs"
	next "in all."

	para "There are also 5"
	next "HMs that can be"
	cont "used repeatedly."

	para "SILPH CO."
	done

_TurnPageText::
	text "Turn the page?"
	done

_ViridianSchoolNotebookText5::
	text "GIRL: Hey! Don't"
	next "look at my notes!"
	done

_ViridianSchoolNotebookText1::
	text "Looked at the"
	next "notebook!"

	para "First page..."

	para "POKé BALLs are"
	next "used to catch"
	cont "POKéMON."

	para "Up to 6 POKéMON"
	next "can be carried."

	para "People who raise"
	next "and make POKéMON"
	cont "fight are called"
	cont "POKéMON trainers."
	prompt

_ViridianSchoolNotebookText2::
	text "Second page..."

	para "A healthy POKéMON"
	next "may be hard to"
	cont "catch, so weaken"
	cont "it first!"

	para "Poison, burns and"
	next "other damage are"
	cont "effective!"
	prompt

_ViridianSchoolNotebookText3::
	text "Third page..."

	para "POKéMON trainers"
	next "seek others to"
	cont "engage in POKéMON"
	cont "fights."

	para "Battles are"
	next "constantly fought"
	cont "at POKéMON GYMs."
	prompt

_ViridianSchoolNotebookText4::
	text "Fourth page..."

	para "The goal for"
	next "POKéMON trainers"
	cont "is to beat the "
	cont "top 8 POKéMON"
	cont "GYM LEADERs."

	para "Do so to earn the"
	next "right to face..."

	para "The ELITE FOUR of"
	next "POKéMON LEAGUE!"
	prompt

_EnemiesOnEverySideText::
	text "Enemies on every"
	next "side!"
	done

_WhatGoesAroundComesAroundText::
	text "What goes around"
	next "comes around!"
	done

_FightingDojoText::
	text "FIGHTING DOJO"
	done

_IndigoPlateauHQText::
	text "INDIGO PLATEAU"
	next "POKéMON LEAGUE HQ"
	done

_RedBedroomSNESText::
	text "<PLAYER> is"
	next "playing the SNES!"
	cont "...Okay!"
	cont "It's time to go!"
	done

_Route15UpstairsBinocularsText::
	text "Looked into the"
	next "binoculars..."

	para "A large, shining"
	next "bird is flying"
	cont "toward the sea."
	done

_AerodactylFossilText::
	text "AERODACTYL Fossil"
	next "A primitive and"
	cont "rare POKéMON."
	done

_KabutopsFossilText::
	text "KABUTOPS Fossil"
	next "A primitive and"
	cont "rare POKéMON."
	done

_LinkCableHelpText1::
	text "TRAINER TIPS"

	para "Using a Game Link"
	next "Cable"
	prompt

_LinkCableHelpText2::
	text "Which heading do"
	next "you want to read?"
	done

_LinkCableInfoText1::
	text "When you have"
	next "linked your GAME"
	cont "BOY with another"
	cont "GAME BOY, talk to"
	cont "the attendant on"
	cont "the right in any"
	cont "POKéMON CENTER."
	prompt

_LinkCableInfoText2::
	text "COLOSSEUM lets"
	next "you play against"
	cont "a friend."
	prompt

_LinkCableInfoText3::
	text "TRADE CENTER is"
	next "used for trading"
	cont "POKéMON."
	prompt

_ViridianSchoolBlackboardText1::
	text "The blackboard"
	next "describes POKéMON"
	cont "STATUS changes"
	cont "during battles."
	prompt

_ViridianSchoolBlackboardText2::
	text "Which heading do"
	next "you want to read?"
	done

_ViridianBlackboardSleepText::
	text "A POKéMON can't"
	next "attack if it's"
	cont "asleep!"

	para "POKéMON will stay"
	next "asleep even after"
	cont "battles."

	para "Use AWAKENING to"
	next "wake them up!"
	prompt

_ViridianBlackboardPoisonText::
	text "When poisoned, a"
	next "POKéMON's health"
	cont "steadily drops."

	para "Poison lingers"
	next "after battles."

	para "Use an ANTIDOTE"
	next "to cure poison!"
	prompt

_ViridianBlackboardPrlzText::
	text "Paralysis could"
	next "make POKéMON"
	cont "moves misfire!"

	para "Paralysis remains"
	next "after battles."

	para "Use PARLYZ HEAL"
	next "for treatment!"
	prompt

_ViridianBlackboardBurnText::
	text "A burn reduces"
	next "power and speed."
	cont "It also causes"
	cont "ongoing damage."

	para "Burns remain"
	next "after battles."

	para "Use BURN HEAL to"
	next "cure a burn!"
	prompt

_ViridianBlackboardFrozenText::
	text "If frozen, a"
	next "POKéMON becomes"
	cont "totally immobile!"

	para "It stays frozen"
	next "even after the"
	cont "battle ends."

	para "Use ICE HEAL to"
	next "thaw out POKéMON!"
	prompt

_VermilionGymTrashText::
	text "Nope, there's"
	next "only trash here."
	done

_VermilionGymTrashSuccessText1::
	text "Hey! There's a"
	next "switch under the"
	cont "trash!"
	cont "Turn it on!"

	para "The 1st electric"
	next "lock opened!"
	done

_VermilionGymTrashSuccessText2::
	text "Hey! There's"
	next "another switch"
	cont "under the trash!"
	cont "Turn it on!"
	prompt

_VermilionGymTrashSuccessText3::
	text "The 2nd electric"
	next "lock opened!"

	para "The motorized door"
	next "opened!"
	done

_VermilionGymTrashFailText::
	text "Nope! There's"
	next "only trash here."
	cont "Hey! The electric"
	cont "locks were reset!"
	done

_FoundHiddenItemText::
	text "<PLAYER> found"
	next ""
	ramtext wcd6d
	text "!"
	done

_HiddenItemBagFullText::
	text "But, <PLAYER> has"
	next "no more room for"
	cont "other items!"
	done

_FoundHiddenCoinsText::
	text "<PLAYER> found"
	next ""
	bcdtext hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	db " coins!"
	done

_DroppedHiddenCoinsText::
	para "Oops! Dropped"
	next "some coins!"
	done

_IndigoPlateauStatuesText1::
	text "INDIGO PLATEAU"
	prompt

_IndigoPlateauStatuesText2::
	text "The ultimate goal"
	next "of trainers!"
	cont "POKéMON LEAGUE HQ"
	done

_IndigoPlateauStatuesText3::
	text "The highest"
	next "POKéMON authority"
	cont "POKéMON LEAGUE HQ"
	done

_PokemonBooksText::
	text "Crammed full of"
	next "POKéMON books!"
	done

_DiglettSculptureText::
	text "It's a sculpture"
	next "of DIGLETT."
	done

_ElevatorText::
	text "This is an"
	next "elevator."
	done

_TownMapText::
	text "A TOWN MAP."
	done

_PokemonStuffText::
	text "Wow! Tons of"
	next "POKéMON stuff!"
	done

_OutOfSafariBallsText::
	text "PA: Ding-dong!"

	para "You are out of"
	next "SAFARI BALLs!"
	prompt

_WildRanText::
	text "Wild "
	ramtext wEnemyMonNick
	next "ran!"
	prompt

_EnemyRanText::
	text "Enemy "
	ramtext wEnemyMonNick
	next "ran!"
	prompt

_HurtByPoisonText::
	text "<USER>'s"
	next "hurt by poison!"
	prompt

_HurtByBurnText::
	text "<USER>'s"
	next "hurt by the burn!"
	prompt

_HurtByLeechSeedText::
	text "LEECH SEED saps"
	next "<USER>!"
	prompt

_EnemyMonFaintedText::
	text "Enemy "
	ramtext wEnemyMonNick
	next "fainted!"
	prompt

_MoneyForWinningText::
	text "<PLAYER> got $"
	bcdtext wAmountMoneyWon, 3 | LEADING_ZEROES | LEFT_ALIGN
	next "for winning!"
	prompt

_TrainerDefeatedText::
	text "<PLAYER> defeated"
	next ""
	ramtext wTrainerName
	text "!"
	prompt

_PlayerMonFaintedText::
	ramtext wBattleMonNick
	next "fainted!"
	prompt

_UseNextMonText::
	text "Use next POKéMON?"
	done

_Sony1WinText::
	text "<RIVAL>: Yeah! Am"
	next "I great or what?"
	prompt

_PlayerBlackedOutText2::
	text "<PLAYER> is out of"
	next "useable POKéMON!"

	para "<PLAYER> blacked"
	next "out!"
	prompt

_LinkBattleLostText::
	text "<PLAYER> lost to"
	next ""
	ramtext wTrainerName
	text "!"
	prompt

_TrainerAboutToUseText::
	ramtext wTrainerName
	text " is"
	next "about to use"
	cont ""
	ramtext wEnemyMonNick
	text "!"

	para "Will <PLAYER>"
	next "change POKéMON?"
	done

_TrainerSentOutText::
	ramtext wTrainerName
	text " sent"
	next "out "
	ramtext wEnemyMonNick
	text "!"
	done

_NoWillText::
	text "There's no will"
	next "to fight!"
	prompt

_CantEscapeText::
	text "Can't escape!"
	prompt

_NoRunningText::
	text "No! There's no"
	next "running from a"
	cont "trainer battle!"
	prompt

_GotAwayText::
	text "Got away safely!"
	prompt

_ItemsCantBeUsedHereText::
	text "Items can't be"
	next "used here."
	prompt

_AlreadyOutText::
	ramtext wBattleMonNick
	text " is"
	next "already out!"
	prompt

_MoveNoPPText::
	text "No PP left for"
	next "this move!"
	prompt

_MoveDisabledText::
	text "The move is"
	next "disabled!"
	prompt

_NoMovesLeftText::
	ramtext wBattleMonNick
	text " has no"
	next "moves left!"
	done

_MultiHitText::
	text "Hit the enemy"
	next ""
	numtext wPlayerNumHits, 1, 1
	text " times!"
	prompt

_ScaredText::
	ramtext wBattleMonNick
	text " is too"
	next "scared to move!"
	prompt

_GetOutText::
	text "GHOST: Get out..."
	next "Get out..."
	prompt

_FastAsleepText::
	text "<USER>"
	next "is fast asleep!"
	prompt

_WokeUpText::
	text "<USER>"
	next "woke up!"
	prompt

_IsFrozenText::
	text "<USER>"
	next "is frozen solid!"
	prompt

_FullyParalyzedText::
	text "<USER>'s"
	next "fully paralyzed!"
	prompt

_FlinchedText::
	text "<USER>"
	next "flinched!"
	prompt

_MustRechargeText::
	text "<USER>"
	next "must recharge!"
	prompt

_DisabledNoMoreText::
	text "<USER>'s"
	next "disabled no more!"
	prompt

_IsConfusedText::
	text "<USER>"
	next "is confused!"
	prompt

_HurtItselfText::
	text "It hurt itself in"
	next "its confusion!"
	prompt

_ConfusedNoMoreText::
	text "<USER>'s"
	next "confused no more!"
	prompt

_SavingEnergyText::
	text "<USER>"
	next "is saving energy!"
	prompt

_UnleashedEnergyText::
	text "<USER>"
	next "unleashed energy!"
	prompt

_ThrashingAboutText::
	text "<USER>'s"
	next "thrashing about!"
	done

_AttackContinuesText::
	text "<USER>'s"
	next "attack continues!"
	done

_CantMoveText::
	text "<USER>"
	next "can't move!"
	prompt

_MoveIsDisabledText::
	text "<USER>'s"
	next ""
	ramtext wcd6d
	text " is"
	cont "disabled!"
	prompt

_MonName1Text::
	text "<USER>"
	done

_UsedText::
	next "used "
	done

_InsteadText::
	text "instead,"
	cont ""
	done

_CF4BText::
	ramtext wcf4b
	text "!"
	done

_AttackMissedText::
	text "<USER>'s"
	next "attack missed!"
	prompt

_KeptGoingAndCrashedText::
	text "<USER>"
	next "kept going and"
	cont "crashed!"
	prompt

_UnaffectedText::
	text "<TARGET>'s"
	next "unaffected!"
	prompt

_DoesntAffectMonText::
	text "It doesn't affect"
	next "<TARGET>!"
	prompt

_CriticalHitText::
	text "Critical hit!"
	prompt

_OHKOText::
	text "One-hit KO!"
	prompt

_LoafingAroundText::
	ramtext wBattleMonNick
	text " is"
	next "loafing around."
	prompt

_BeganToNapText::
	ramtext wBattleMonNick
	text " began"
	next "to nap!"
	prompt

_WontObeyText::
	ramtext wBattleMonNick
	text " won't"
	next "obey!"
	prompt

_TurnedAwayText::
	ramtext wBattleMonNick
	text " turned"
	next "away!"
	prompt

_IgnoredOrdersText::
	ramtext wBattleMonNick
	next "ignored orders!"
	prompt

_SubstituteTookDamageText::
	text "The SUBSTITUTE"
	next "took damage for"
	cont "<TARGET>!"
	prompt

_SubstituteBrokeText::
	text "<TARGET>'s"
	next "SUBSTITUTE broke!"
	prompt

_BuildingRageText::
	text "<USER>'s"
	next "RAGE is building!"
	prompt

_MirrorMoveFailedText::
	text "The MIRROR MOVE"
	next "failed!"
	prompt

_HitXTimesText::
	text "Hit "
	numtext wEnemyNumHits, 1, 1
	text " times!"
	prompt

_GainedText::
	ramtext wcd6d
	text " gained"
	next ""
	done

_WithExpAllText::
	text "with EXP.ALL,"
	cont ""
	done

_BoostedText::
	text "a boosted"
	cont ""
	done

_ExpPointsText::
	numtext wExpAmountGained, 4, 2
	text " EXP. Points!"
	prompt

_GrewLevelText::
	ramtext wcd6d
	text " grew"
	next "to level "
	numtext wCurEnemyLVL, 3, 1 ; 3 digits, 1 byte
	text "!"
	done

_WildMonAppearedText::
	text "Wild "
	ramtext wEnemyMonNick
	next "appeared!"
	prompt

_HookedMonAttackedText::
	text "The hooked"
	next ""
	ramtext wEnemyMonNick
	cont "attacked!"
	prompt

_EnemyAppearedText::
	ramtext wEnemyMonNick
	next "appeared!"
	prompt

_TrainerWantsToFightText::
	ramtext wTrainerName
	text " wants"
	next "to fight!"
	prompt

_UnveiledGhostText::
	text "SILPH SCOPE"
	next "unveiled the"
	cont "GHOST's identity!"
	prompt

_GhostCantBeIDdText::
	text "Darn! The GHOST"
	next "can't be ID'd!"
	prompt

_GoText::
	text "Go! "
	done

_DoItText::
	text "Do it! "
	done

_GetmText::
	text "Get'm! "
	done

_EnemysWeakText::
	text "The enemy's weak!"
	next "Get'm! "
	done

_PlayerMon1Text::
	ramtext wBattleMonNick
	text "!"
	done

_PlayerMon2Text::
	ramtext wBattleMonNick
	text " "
	done

_EnoughText::
	text "enough!"
	done

_OKExclamationText::
	text "OK!"
	done

_GoodText::
	text "good!"
	done

_ComeBackText::
	next "Come back!"
	done

_SuperEffectiveText::
	text "It's super"
	next "effective!"
	prompt

_NotVeryEffectiveText::
	text "It's not very"
	next "effective..."
	prompt

_SafariZoneEatingText::
	text "Wild "
	ramtext wEnemyMonNick
	next "is eating!"
	prompt

_SafariZoneAngryText::
	text "Wild "
	ramtext wEnemyMonNick
	next "is angry!"
	prompt

; money related
_PickUpPayDayMoneyText::
	text "<PLAYER> picked up"
	next "$"
	bcdtext wTotalPayDayMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text "!"
	prompt

_ClearSaveDataText::
	text "Clear all saved"
	next "data?"
	done

_WhichFloorText::
	text "Which floor do"
	next "you want? "
	done

_PartyMenuNormalText::
	text "Choose a POKéMON."
	done

_PartyMenuItemUseText::
	text "Use item on which"
	next "POKéMON?"
	done

_PartyMenuBattleText::
	text "Bring out which"
	next "POKéMON?"
	done

_PartyMenuUseTMText::
	text "Use TM on which"
	next "POKéMON?"
	done

_PartyMenuSwapMonText::
	text "Move POKéMON"
	next "where?"
	done

_PotionText::
	ramtext wcd6d
	next "recovered by "
	numtext wHPBarHPDifference, 3, 2
	text "!"
	done

_AntidoteText::
	ramtext wcd6d
	text " was"
	next "cured of poison!"
	done

_ParlyzHealText::
	ramtext wcd6d
	text "'s"
	next "rid of paralysis!"
	done

_BurnHealText::
	ramtext wcd6d
	text "'s"
	next "burn was healed!"
	done

_IceHealText::
	ramtext wcd6d
	text " was"
	next "defrosted!"
	done

_AwakeningText::
	ramtext wcd6d
	next "woke up!"
	done

_FullHealText::
	ramtext wcd6d
	text "'s"
	next "health returned!"
	done

_ReviveText::
	ramtext wcd6d
	next "is revitalized!"
	done

_RareCandyText::
	ramtext wcd6d
	text " grew"
	next "to level "
	numtext wCurEnemyLVL, 3, 1 ; 3 digits, 1 byte
	text "!"
	done

_TurnedOnPC1Text::
	text "<PLAYER> turned on"
	next "the PC."
	prompt

_AccessedBillsPCText::
	text "Accessed BILL's"
	next "PC."

	para "Accessed POKéMON"
	next "Storage System."
	prompt

_AccessedSomeonesPCText::
	text "Accessed someone's"
	next "PC."

	para "Accessed POKéMON"
	next "Storage System."
	prompt

_TurnedOnPC2Text::
	text "<PLAYER> turned on"
	next "the PC."
	prompt

_WhatDoYouWantText::
	text "What do you want"
	next "to do?"
	done

_WhatToDepositText::
	text "What do you want"
	next "to deposit?"
	done

_DepositHowManyText::
	text "How many?"
	done

_ItemWasStoredText::
	ramtext wcd6d
	text " was"
	next "stored via PC."
	prompt

_NothingToDepositText::
	text "You have nothing"
	next "to deposit."
	prompt

_NoRoomToStoreText::
	text "No room left to"
	next "store items."
	prompt

_WhatToWithdrawText::
	text "What do you want"
	next "to withdraw?"
	done

_WithdrawHowManyText::
	text "How many?"
	done

_WithdrewItemText::
	text "Withdrew"
	next ""
	ramtext wcd6d
	text "."
	prompt

_NothingStoredText::
	text "There is nothing"
	next "stored."
	prompt

_CantCarryMoreText::
	text "You can't carry"
	next "any more items."
	prompt

_WhatToTossText::
	text "What do you want"
	next "to toss away?"
	done

_TossHowManyText::
	text "How many?"
	done

_AccessedHoFPCText::
	text "Accessed POKéMON"
	next "LEAGUE's site."

	para "Accessed the HALL"
	next "OF FAME List."
	prompt

_SwitchOnText::
	text "Switch on!"
	prompt

_WhatText::
	text "What?"
	done

_DepositWhichMonText::
	text "Deposit which"
	next "POKéMON?"
	done

_MonWasStoredText::
	ramtext wcf4b
	text " was"
	next "stored in Box "
	ramtext wBoxNumString
	text "."
	prompt

_CantDepositLastMonText::
	text "You can't deposit"
	next "the last POKéMON!"
	prompt

_BoxFullText::
	text "Oops! This Box is"
	next "full of POKéMON."
	prompt

_MonIsTakenOutText::
	ramtext wcf4b
	text " is"
	next "taken out."
	cont "Got "
	ramtext wcf4b
	text "."
	prompt

_NoMonText::
	text "What? There are"
	next "no POKéMON here!"
	prompt

_CantTakeMonText::
	text "You can't take"
	next "any more POKéMON."

	para "Deposit POKéMON"
	next "first."
	prompt

_ReleaseWhichMonText::
	text "Release which"
	next "POKéMON?"
	done

_OnceReleasedText::
	text "Once released,"
	next ""
	ramtext wcf4b
	text " is"
	cont "gone forever. OK?"
	done

_MonWasReleasedText::
	ramtext wcf4b
	text " was"
	next "released outside."
	cont "Bye @"

_CF4BExclamationText::
	ramtext wcf4b
	text "!"
	prompt

_RequireCoinCaseText::
	text "A COIN CASE is"
	next "required!"
	done

_ExchangeCoinsForPrizesText::
	text "We exchange your"
	next "coins for prizes."
	prompt

_WhichPrizeText::
	text "Which prize do"
	next "you want?"
	done

_HereYouGoText::
	text "Here you go!"
	done

_SoYouWantPrizeText::
	text "So, you want"
	next ""
	ramtext wcd6d
	text "?"
	done

_SorryNeedMoreCoinsText::
	text "Sorry, you need"
	next "more coins."
	done

_OopsYouDontHaveEnoughRoomText::
	text "Oops! You don't"
	next "have enough room."
	done

_OhFineThenText::
	text "Oh, fine then."
	done

_GetDexRatedText::
	text "Want to get your"
	next "POKéDEX rated?"
	done

_ClosedOaksPCText::
	text "Closed link to"
	next "PROF.OAK's PC."
	done

_AccessedOaksPCText::
	text "Accessed PROF."
	next "OAK's PC."

	para "Accessed POKéDEX"
	next "Rating System."
	prompt

_WhereWouldYouLikeText::
	text "Where would you"
	next "like to go?"
	done

_PleaseWaitText::
	text "OK, please wait"
	next "just a moment."
	done

_LinkCanceledText::
	text "The link was"
	next "canceled."
	done

INCLUDE "text/oakspeech.asm"

_DoYouWantToNicknameText::
	text "Do you want to"
	next "give a nickname"
	cont "to "
	ramtext wcd6d
	text "?"
	done

_YourNameIsText::
	text "Right! So your"
	next "name is <PLAYER>!"
	prompt

_HisNameIsText::
	text "That's right! I"
	next "remember now! His"
	cont "name is <RIVAL>!"
	prompt

_WillBeTradedText::
	ramtext wNameOfPlayerMonToBeTraded
	text " and"
	next ""
	ramtext wcd6d
	text " will"
	cont "be traded."
	done

INCLUDE "text/maps/digletts_cave_route_2_entrance.asm"
INCLUDE "text/maps/viridian_forest_exit.asm"
INCLUDE "text/maps/route_2_house.asm"
INCLUDE "text/maps/route_2_gate.asm"
INCLUDE "text/maps/viridian_forest_entrance.asm"
INCLUDE "text/maps/mt_moon_pokecenter.asm"
INCLUDE "text/maps/saffron_gates.asm"
INCLUDE "text/maps/daycare_1.asm"


SECTION "Text 4", ROMX, BANK[TEXT_4]

INCLUDE "text/maps/daycare_2.asm"
INCLUDE "text/maps/underground_path_route_6_entrance.asm"
INCLUDE "text/maps/underground_path_route_7_entrance.asm"
INCLUDE "text/maps/underground_path_route_7_entrance_unused.asm"
INCLUDE "text/maps/underground_path_route_8_entrance.asm"
INCLUDE "text/maps/rock_tunnel_pokecenter.asm"
INCLUDE "text/maps/rock_tunnel_b1f.asm"
INCLUDE "text/maps/power_plant.asm"
INCLUDE "text/maps/route_11_gate.asm"
INCLUDE "text/maps/route_11_gate_upstairs.asm"
INCLUDE "text/maps/digletts_cave_route_11_entrance.asm"
INCLUDE "text/maps/route_12_gate.asm"
INCLUDE "text/maps/route_12_gate_upstairs.asm"
INCLUDE "text/maps/route_12_house.asm"
INCLUDE "text/maps/route_15_gate.asm"
INCLUDE "text/maps/route_15_gate_upstairs.asm"
INCLUDE "text/maps/route_16_gate.asm"
INCLUDE "text/maps/route_16_gate_upstairs.asm"
INCLUDE "text/maps/route_16_house.asm"
INCLUDE "text/maps/route_18_gate.asm"
INCLUDE "text/maps/route_18_gate_upstairs.asm"
INCLUDE "text/maps/pokemon_league_gate.asm"
INCLUDE "text/maps/victory_road_2f.asm"
INCLUDE "text/maps/bills_house.asm"
INCLUDE "text/maps/route_1.asm"
INCLUDE "text/maps/route_2.asm"
INCLUDE "text/maps/route_3.asm"
INCLUDE "text/maps/route_4.asm"
INCLUDE "text/maps/route_5.asm"
INCLUDE "text/maps/route_6.asm"
INCLUDE "text/maps/route_7.asm"
INCLUDE "text/maps/route_8.asm"
INCLUDE "text/maps/route_9.asm"
INCLUDE "text/maps/route_10.asm"
INCLUDE "text/maps/route_11_1.asm"


SECTION "Text 5", ROMX, BANK[TEXT_5]

INCLUDE "text/maps/route_11_2.asm"
INCLUDE "text/maps/route_12.asm"
INCLUDE "text/maps/route_13.asm"
INCLUDE "text/maps/route_14.asm"
INCLUDE "text/maps/route_15.asm"
INCLUDE "text/maps/route_16.asm"
INCLUDE "text/maps/route_17.asm"
INCLUDE "text/maps/route_18.asm"
INCLUDE "text/maps/route_19.asm"
INCLUDE "text/maps/route_20.asm"
INCLUDE "text/maps/route_21.asm"
INCLUDE "text/maps/route_22.asm"
INCLUDE "text/maps/route_23.asm"
INCLUDE "text/maps/route_24_1.asm"


SECTION "Text 6", ROMX, BANK[TEXT_6]

INCLUDE "text/maps/route_24_2.asm"
INCLUDE "text/maps/route_25.asm"

_WouldYouLikeToSaveText::
	text "Would you like to"
	next "SAVE the game?"
	done

_GameSavedText::
	text "<PLAYER> saved"
	next "the game!"
	done

_OlderFileWillBeErasedText::
	text "The older file"
	next "will be erased to"
	cont "save. Okay?"
	done

_WhenYouChangeBoxText::
	text "When you change a"
	next "POKéMON BOX, data"
	cont "will be saved."

	para "Is that okay?"
	done

_ChooseABoxText::
	text "Choose a"
	next "<pkmn> BOX."
	done

_EvolvedText::
	ramtext wcf4b
	text " evolved"
	done

_IntoText::
	next "into "
	ramtext wcd6d
	text "!"
	done

_StoppedEvolvingText::
	text "Huh? "
	ramtext wcf4b
	next "stopped evolving!"
	prompt

_IsEvolvingText::
	text "What? "
	ramtext wcf4b
	next "is evolving!"
	done

_FellAsleepText::
	text "<TARGET>"
	next "fell asleep!"
	prompt

_AlreadyAsleepText::
	text "<TARGET>'s"
	next "already asleep!"
	prompt

_PoisonedText::
	text "<TARGET>"
	next "was poisoned!"
	prompt

_BadlyPoisonedText::
	text "<TARGET>'s"
	next "badly poisoned!"
	prompt

_BurnedText::
	text "<TARGET>"
	next "was burned!"
	prompt

_FrozenText::
	text "<TARGET>"
	next "was frozen solid!"
	prompt

_FireDefrostedText::
	text "Fire defrosted"
	next "<TARGET>!"
	prompt

_MonsStatsRoseText::
	text "<USER>'s"
	next ""
	ramtext wcf4b
	done

_GreatlyRoseText::
	autocont "greatly"
	done

_RoseText::
	text " rose!"
	prompt

_MonsStatsFellText::
	text "<TARGET>'s"
	next ""
	ramtext wcf4b
	done

_GreatlyFellText::
	autocont "greatly"
	done

_FellText::
	text " fell!"
	prompt

_RanFromBattleText::
	text "<USER>"
	next "ran from battle!"
	prompt

_RanAwayScaredText::
	text "<TARGET>"
	next "ran away scared!"
	prompt

_WasBlownAwayText::
	text "<TARGET>"
	next "was blown away!"
	prompt

_ChargeMoveEffectText::
	text "<USER>"
	done

_MadeWhirlwindText::
	next "made a whirlwind!"
	prompt

_TookInSunlightText::
	next "took in sunlight!"
	prompt

_LoweredItsHeadText::
	next "lowered its head!"
	prompt

_SkyAttackGlowingText::
	next "is glowing!"
	prompt

_FlewUpHighText::
	next "flew up high!"
	prompt

_DugAHoleText::
	next "dug a hole!"
	prompt

_BecameConfusedText::
	text "<TARGET>"
	next "became confused!"
	prompt

_MimicLearnedMoveText::
	text "<USER>"
	next "learned"
	cont ""
	ramtext wcd6d
	text "!"
	prompt

_MoveWasDisabledText::
	text "<TARGET>'s"
	next ""
	ramtext wcd6d
	text " was"
	cont "disabled!"
	prompt

_NothingHappenedText::
	text "Nothing happened!"
	prompt

_NoEffectText::
	text "No effect!"
	prompt

_ButItFailedText::
	text "But, it failed! "
	prompt

_DidntAffectText::
	text "It didn't affect"
	next "<TARGET>!"
	prompt

_IsUnaffectedText::
	text "<TARGET>"
	next "is unaffected!"
	prompt

_ParalyzedMayNotAttackText::
	text "<TARGET>'s"
	next "paralyzed! It may"
	cont "not attack!"
	prompt

_SubstituteText::
	text "It created a"
	next "SUBSTITUTE!"
	prompt

_HasSubstituteText::
	text "<USER>"
	next "has a SUBSTITUTE!"
	prompt

_TooWeakSubstituteText::
	text "Too weak to make"
	next "a SUBSTITUTE!"
	prompt

_CoinsScatteredText::
	text "Coins scattered"
	next "everywhere!"
	prompt

_GettingPumpedText::
	text "<USER>'s"
	next "getting pumped!"
	prompt

_WasSeededText::
	text "<TARGET>"
	next "was seeded!"
	prompt

_EvadedAttackText::
	text "<TARGET>"
	next "evaded attack!"
	prompt

_HitWithRecoilText::
	text "<USER>'s"
	next "hit with recoil!"
	prompt

_ConvertedTypeText::
	text "Converted type to"
	next "<TARGET>'s!"
	prompt

_StatusChangesEliminatedText::
	text "All STATUS changes"
	next "are eliminated!"
	prompt

_StartedSleepingEffect::
	text "<USER>"
	next "started sleeping!"
	done

_FellAsleepBecameHealthyText::
	text "<USER>"
	next "fell asleep and"
	cont "became healthy!"
	done

_RegainedHealthText::
	text "<USER>"
	next "regained health!"
	prompt

_TransformedText::
	text "<USER>"
	next "transformed into"
	cont ""
	ramtext wcd6d
	text "!"
	prompt

_LightScreenProtectedText::
	text "<USER>'s"
	next "protected against"
	cont "special attacks!"
	prompt

_ReflectGainedArmorText::
	text "<USER>"
	next "gained armor!"
	prompt

_ShroudedInMistText::
	text "<USER>'s"
	next "shrouded in mist!"
	prompt

_SuckedHealthText::
	text "Sucked health from"
	next "<TARGET>!"
	prompt

_DreamWasEatenText::
	text "<TARGET>'s"
	next "dream was eaten!"
	prompt

_TradeCenterText1::
	text "!"
	done

_ColosseumText1::
	text "!"
	done

INCLUDE "text/maps/reds_house_1f.asm"
INCLUDE "text/maps/blues_house.asm"
INCLUDE "text/maps/oaks_lab.asm"
INCLUDE "text/maps/viridian_pokecenter.asm"
INCLUDE "text/maps/viridian_mart.asm"
INCLUDE "text/maps/school.asm"
INCLUDE "text/maps/viridian_house.asm"
INCLUDE "text/maps/viridian_gym.asm"
INCLUDE "text/maps/museum_1f.asm"
INCLUDE "text/maps/museum_2f.asm"
INCLUDE "text/maps/pewter_gym_1.asm"


SECTION "Text 7", ROMX, BANK[TEXT_7]

INCLUDE "text/maps/pewter_gym_2.asm"
INCLUDE "text/maps/pewter_house_1.asm"
INCLUDE "text/maps/pewter_mart.asm"
INCLUDE "text/maps/pewter_house_2.asm"
INCLUDE "text/maps/pewter_pokecenter.asm"
INCLUDE "text/maps/cerulean_trashed_house.asm"
INCLUDE "text/maps/cerulean_trade_house.asm"
INCLUDE "text/maps/cerulean_pokecenter.asm"
INCLUDE "text/maps/cerulean_gym.asm"
INCLUDE "text/maps/bike_shop.asm"
INCLUDE "text/maps/cerulean_mart.asm"
INCLUDE "text/maps/cerulean_badge_house.asm"
INCLUDE "text/maps/lavender_pokecenter.asm"
INCLUDE "text/maps/pokemon_tower_1f.asm"
INCLUDE "text/maps/pokemon_tower_2f.asm"
INCLUDE "text/maps/pokemon_tower_3f.asm"
INCLUDE "text/maps/pokemon_tower_4f.asm"
INCLUDE "text/maps/pokemon_tower_5f.asm"
INCLUDE "text/maps/pokemon_tower_6f.asm"
INCLUDE "text/maps/pokemon_tower_7f.asm"
INCLUDE "text/maps/fujis_house.asm"
INCLUDE "text/maps/lavender_mart.asm"
INCLUDE "text/maps/lavender_house.asm"
INCLUDE "text/maps/name_rater.asm"
INCLUDE "text/maps/vermilion_pokecenter.asm"
INCLUDE "text/maps/fan_club.asm"
INCLUDE "text/maps/vermilion_mart.asm"
INCLUDE "text/maps/vermilion_gym_1.asm"


SECTION "Text 8", ROMX, BANK[TEXT_8]

INCLUDE "text/maps/vermilion_gym_2.asm"
INCLUDE "text/maps/vermilion_house.asm"
INCLUDE "text/maps/vermilion_dock.asm"
INCLUDE "text/maps/vermilion_fishing_house.asm"
INCLUDE "text/maps/celadon_dept_store_1f.asm"
INCLUDE "text/maps/celadon_dept_store_2f.asm"
INCLUDE "text/maps/celadon_dept_store_3f.asm"
INCLUDE "text/maps/celadon_dept_store_4f.asm"
INCLUDE "text/maps/celadon_dept_store_roof.asm"
INCLUDE "text/maps/celadon_mansion_1f.asm"
INCLUDE "text/maps/celadon_mansion_2f.asm"
INCLUDE "text/maps/celadon_mansion_3f.asm"
INCLUDE "text/maps/celadon_mansion_4f_outside.asm"
INCLUDE "text/maps/celadon_mansion_4f_inside.asm"
INCLUDE "text/maps/celadon_pokecenter.asm"
INCLUDE "text/maps/celadon_gym.asm"
INCLUDE "text/maps/celadon_game_corner.asm"
INCLUDE "text/maps/celadon_dept_store_5f.asm"
INCLUDE "text/maps/celadon_prize_room.asm"
INCLUDE "text/maps/celadon_diner.asm"
INCLUDE "text/maps/celadon_house.asm"
INCLUDE "text/maps/celadon_hotel.asm"
INCLUDE "text/maps/fuchsia_mart.asm"
INCLUDE "text/maps/fuchsia_house.asm"
INCLUDE "text/maps/fuchsia_pokecenter.asm"
INCLUDE "text/maps/wardens_house.asm"
INCLUDE "text/maps/safari_zone_entrance.asm"
INCLUDE "text/maps/fuchsia_gym_1.asm"


SECTION "Text 9", ROMX, BANK[TEXT_9]

INCLUDE "text/maps/fuchsia_gym_2.asm"
INCLUDE "text/maps/fuchsia_meeting_room.asm"
INCLUDE "text/maps/fuchsia_fishing_house.asm"
INCLUDE "text/maps/mansion_1f.asm"
INCLUDE "text/maps/cinnabar_gym.asm"
INCLUDE "text/maps/cinnabar_lab.asm"
INCLUDE "text/maps/cinnabar_lab_trade_room.asm"
INCLUDE "text/maps/cinnabar_lab_metronome_room.asm"
INCLUDE "text/maps/cinnabar_lab_fossil_room.asm"
INCLUDE "text/maps/cinnabar_pokecenter.asm"
INCLUDE "text/maps/cinnabar_mart.asm"
INCLUDE "text/maps/indigo_plateau_lobby.asm"
INCLUDE "text/maps/copycats_house_1f.asm"
INCLUDE "text/maps/copycats_house_2f.asm"
INCLUDE "text/maps/fighting_dojo.asm"
INCLUDE "text/maps/saffron_gym.asm"
INCLUDE "text/maps/saffron_house.asm"
INCLUDE "text/maps/saffron_mart.asm"
INCLUDE "text/maps/silph_co_1f.asm"
INCLUDE "text/maps/saffron_pokecenter.asm"
INCLUDE "text/maps/mr_psychics_house.asm"

_PokemartGreetingText::
	text "Hi there!"
	next "May I help you?"
	; fall through

PokemartBuySellMenu:
	two_opt .buyText, .sellText, .buy, .done
	autopara "Thank you!"
.done
	done
.buy
	autopara "Take your time."
	done

.buyText
	str "Buy"
.sellText
	str "Sell"

_PokemartAnythingElseText::
	text "Is there anything"
	next "else I can do?"
	gototext PokemartBuySellMenu

_PokemonFaintedText::
	text
	ramtext wcd6d
	str " fainted!"
	done

_PlayerBlackedOutText::
	text "<PLAYER> is out of"
	next "useable POKéMON!"

	para "<PLAYER> blacked"
	next "out!"
	prompt

_RepelWoreOffText::
	text "REPEL's effect"
	next "wore off."
	done

_PokemartTellBuyPriceText::
	ramtext wcf4b
	text "?"
	next "That will be"
	cont "$"
	bcdtext hMoney, 3 | LEADING_ZEROES | LEFT_ALIGN
	text ". OK?"
	done

_PokemartBoughtItemText::
	text "Here you are!"
	next "Thank you!"
	prompt

_PokemartNotEnoughMoneyText::
	text "You don't have"
	next "enough money."
	prompt

_PokemartItemBagFullText::
	text "You can't carry"
	next "any more items."
	prompt

_LearnedMove1Text::
	ramtext wLearnMoveMonName
	text " learned"
	next ""
	ramtext wcf4b
	text "!"
	done

_WhichMoveToForgetText::
	text "Which move should"
	next "be forgotten?"
	done

_AbandonLearningText::
	text "Abandon learning"
	next ""
	ramtext wcf4b
	text "?"
	done

_DidNotLearnText::
	ramtext wLearnMoveMonName
	next "did not learn"
	cont ""
	ramtext wcf4b
	text "!"
	prompt

_TryingToLearnText::
	ramtext wLearnMoveMonName
	text " is"
	next "trying to learn"
	cont ""
	ramtext wcf4b
	text "!"

	para "But, "
	ramtext wLearnMoveMonName
	next "can't learn more"
	cont "than 4 moves!"

	para "Delete an older"
	next "move to make room"
	cont "for "
	ramtext wcf4b
	text "?"
	done

_OneTwoAndText::
	text "1, 2 and..."
	done

_PoofText::
	text " Poof!"
	done

_ForgotAndText::
	para ""
	ramtext wLearnMoveMonName
	text " forgot"
	next ""
	ramtext wcd6d
	text "!"

	para "And..."
	prompt

_HMCantDeleteText::
	text "HM techniques"
	next "can't be deleted!"
	prompt

_PokemonCenterWelcomeText::
	text "Welcome to our"
	next "POKéMON CENTER!"

	para "We heal your"
	next "POKéMON back to"
	cont "perfect health!"
	prompt

_ShallWeHealYourPokemonText::
	text "Shall we heal your"
	next "POKéMON?"
	done

_NeedYourPokemonText::
	text "OK. We'll need"
	next "your POKéMON."
	done

_PokemonFightingFitText::
	text "Thank you!"
	next "Your POKéMON are"
	cont "fighting fit!"
	prompt

_PokemonCenterFarewellText::
	text "We hope to see"
	next "you again!"
	done

_CableClubNPCAreaReservedFor2FriendsLinkedByCableText::
	text "This area is"
	next "reserved for 2"
	cont "friends who are"
	cont "linked by cable."
	done

_CableClubNPCWelcomeText::
	text "Welcome to the"
	next "Cable Club!"
	done

_CableClubNPCPleaseApplyHereHaveToSaveText::
	text "Please apply here."

	para "Before opening"
	next "the link, we have"
	cont "to save the game."
	done

_CableClubNPCPleaseWaitText::
	text "Please wait."
	done

_CableClubNPCLinkClosedBecauseOfInactivityText::
	text "The link has been"
	next "closed because of"
	cont "inactivity."

	para "Please contact"
	next "your friend and"
	cont "come again!"
	done


SECTION "Text 10", ROMX, BANK[TEXT_10]

_CableClubNPCPleaseComeAgainText::
	text "Please come again!"
	done

_CableClubNPCMakingPreparationsText::
	text "We're making"
	next "preparations."
	cont "Please wait."
	done

_UsedStrengthText::
	ramtext wcd6d
	text " used"
	next "STRENGTH."
	done

_CanMoveBouldersText::
	ramtext wcd6d
	text " can"
	next "move boulders."
	prompt

_CurrentTooFastText::
	text "The current is"
	next "much too fast!"
	prompt

_CyclingIsFunText::
	text "Cycling is fun!"
	next "Forget SURFing!"
	prompt

_FlashLightsAreaText::
	text "A blinding FLASH"
	next "lights the area!"
	prompt

_WarpToLastPokemonCenterText::
	text "Warp to the last"
	next "POKéMON CENTER."
	done

_CannotUseTeleportNowText::
	ramtext wcd6d
	text " can't"
	next "use TELEPORT now."
	prompt

_CannotFlyHereText::
	ramtext wcd6d
	text " can't"
	next "FLY here."
	prompt

_NotHealthyEnoughText::
	text "Not healthy"
	next "enough."
	prompt

_NewBadgeRequiredText::
	text "No! A new BADGE"
	next "is required."
	prompt

_CannotUseItemsHereText::
	text "You can't use items"
	next "here."
	prompt

_CannotGetOffHereText::
	text "You can't get off"
	next "here."
	prompt

_GotMonText::
	text "<PLAYER> got"
	next ""
	ramtext wcd6d
	text "!"
	done

_SetToBoxText::
	text "There's no more"
	next "room for POKéMON!"
	cont ""
	ramtext wBoxMonNicks
	text " was"
	cont "sent to POKéMON"
	cont "BOX "
	ramtext wcf4b
	text " on PC!"
	done

_BoxIsFullText::
	text "There's no more"
	next "room for POKéMON!"

	para "The POKéMON BOX"
	next "is full and can't"
	cont "accept any more!"

	para "Change the BOX at"
	next "a POKéMON CENTER!"
	done

INCLUDE "text/maps/pallet_town.asm"
INCLUDE "text/maps/viridian_city.asm"
INCLUDE "text/maps/pewter_city.asm"
INCLUDE "text/maps/cerulean_city.asm"
INCLUDE "text/maps/lavender_town.asm"
INCLUDE "text/maps/vermilion_city.asm"
INCLUDE "text/maps/celadon_city.asm"
INCLUDE "text/maps/fuchsia_city.asm"
INCLUDE "text/maps/cinnabar_island.asm"
INCLUDE "text/maps/saffron_city.asm"

_ItemUseBallText00::
	text "It dodged the"
	next "thrown BALL!"

	para "This POKéMON"
	next "can't be caught!"
	prompt

_ItemUseBallText01::
	text "You missed the"
	next "POKéMON!"
	prompt

_ItemUseBallText02::
	text "Darn! The POKéMON"
	next "broke free!"
	prompt

_ItemUseBallText03::
	text "Aww! It appeared"
	next "to be caught! "
	prompt

_ItemUseBallText04::
	text "Shoot! It was so"
	next "close too!"
	prompt

_ItemUseBallText05::
	text "All right!"
	next ""
	ramtext wEnemyMonNick
	db " was"
	cont "caught!"
	done

_ItemUseBallText07::
	ramtext wBoxMonNicks
	text " was"
	next "transferred to"
	cont "BILL's PC!"
	prompt

_ItemUseBallText08::
	ramtext wBoxMonNicks
	text " was"
	next "transferred to"
	cont "someone's PC!"
	prompt

_ItemUseBallText06::
	text "New POKéDEX data"
	next "will be added for"
	cont ""
	ramtext wEnemyMonNick
	db "!"
	done

_SurfingGotOnText::
	text "<PLAYER> got on"
	next ""
	ramtext wcd6d
	text "!"
	prompt

_SurfingNoPlaceToGetOffText::
	text "There's no place"
	next "to get off!"
	prompt

_VitaminStatRoseText::
	ramtext wcd6d
	text "'s"
	next ""
	ramtext wcf4b
	text " rose."
	prompt

_VitaminNoEffectText::
	text "It won't have any"
	next "effect."
	prompt

_ThrewBaitText::
	text "<PLAYER> threw"
	next "some BAIT."
	done

_ThrewRockText::
	text "<PLAYER> threw a"
	next "ROCK."
	done

_PlayedFluteNoEffectText::
	text "Played the #"
	next "FLUTE."

	para "Now, that's a"
	next "catchy tune!"
	prompt

_FluteWokeUpText::
	text "All sleeping"
	next "POKéMON woke up."
	prompt

_PlayedFluteHadEffectText::
	text "<PLAYER> played the"
	next "# FLUTE."
	done

_CoinCaseNumCoinsText::
	text "Coins"
	next ""
	bcdtext wPlayerCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " "
	prompt

_ItemfinderFoundItemText::
	text "Yes! ITEMFINDER"
	next "indicates there's"
	cont "an item nearby."
	prompt

_ItemfinderFoundNothingText::
	text "Nope! ITEMFINDER"
	next "isn't responding."
	prompt

_RaisePPWhichTechniqueText::
	text "Raise PP of which"
	next "technique?"
	done

_RestorePPWhichTechniqueText::
	text "Restore PP of"
	next "which technique?"
	done

_PPMaxedOutText::
	ramtext wcf4b
	text "'s PP"
	next "is maxed out."
	prompt

_PPIncreasedText::
	ramtext wcf4b
	text "'s PP"
	next "increased."
	prompt

_PPRestoredText::
	text "PP was restored."
	prompt

_MonCannotLearnMachineMoveText::
	ramtext wcd6d
	text " is not"
	next "compatible with"
	cont ""
	ramtext wcf4b
	text "."

	para "It can't learn"
	next ""
	ramtext wcf4b
	text "."
	prompt

_ItemUseNotTimeText::
	text "OAK: <PLAYER>!"
	next "This isn't the"
	cont "time to use that! "
	prompt

_ItemUseNotYoursToUseText::
	text "This isn't yours"
	next "to use!"
	prompt

_ItemUseNoEffectText::
	text "It won't have any"
	next "effect."
	prompt

_ThrowBallAtTrainerMonText1::
	text "The trainer"
	next "blocked the BALL!"
	prompt

_ThrowBallAtTrainerMonText2::
	text "Don't be a thief!"
	prompt

_NoCyclingAllowedHereText::
	text "No cycling"
	next "allowed here."
	prompt

_NoSurfingHereText::
	text "No SURFing on"
	next ""
	ramtext wcd6d
	text " here!"
	prompt

_BoxFullCannotThrowBallText::
	text "The POKéMON BOX"
	next "is full! Can't"
	cont "use that item!"
	prompt


SECTION "Text 11", ROMX, BANK[TEXT_11]

_ItemUseText001::
	text "<PLAYER> used"
	next ""
	ramtext wcf4b
	db "!"
	done

_GotOnBicycleText1::
	text "<PLAYER> got on the"
	next ""
	ramtext wcf4b
	db "!"
	prompt

_GotOffBicycleText1::
	text "<PLAYER> got off"
	next ""
	db "the "
	ramtext wcf4b
	db "."
	prompt

_AlreadyKnowsText::
	ramtext wcd6d
	text " knows"
	next ""
	ramtext wcf4b
	text "!"
	prompt

_ConnectCableText::
	text "Okay, connect the"
	next "cable like so!"
	prompt

_TradedForText::
	text "<PLAYER> traded"
	next ""
	ramtext wInGameTradeGiveMonName
	text " for"
	cont ""
	ramtext wInGameTradeReceiveMonName
	text "!"
	done

_WannaTrade1Text::
	text "I'm looking for"
	next ""
	ramtext wInGameTradeGiveMonName
	text "! Wanna"

	para "trade one for"
	next ""
	ramtext wInGameTradeReceiveMonName
	text "? "
	done

_NoTrade1Text::
	text "Awww!"
	next "Oh well..."
	done

_WrongMon1Text::
	text "What? That's not"
	next ""
	ramtext wInGameTradeGiveMonName
	text "!"

	para "If you get one,"
	next "come back here!"
	done

_Thanks1Text::
	text "Hey thanks!"
	done

_AfterTrade1Text::
	text "Isn't my old"
	next ""
	ramtext wInGameTradeReceiveMonName
	text " great?"
	done

_WannaTrade2Text::
	text "Hello there! Do"
	next "you want to trade"

	para "your "
	ramtext wInGameTradeGiveMonName
	next "for "
	ramtext wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade2Text::
	text "Well, if you"
	next "don't want to..."
	done

_WrongMon2Text::
	text "Hmmm? This isn't"
	next ""
	ramtext wInGameTradeGiveMonName
	text "."

	para "Think of me when"
	next "you get one."
	done

_Thanks2Text::
	text "Thanks!"
	done

_AfterTrade2Text::
	text "The "
	ramtext wInGameTradeGiveMonName
	text " you"
	next "traded to me"

	para "went and evolved!"
	done

_WannaTrade3Text::
	text "Hi! Do you have"
	next ""
	ramtext wInGameTradeGiveMonName
	text "?"

	para "Want to trade it"
	next "for "
	ramtext wInGameTradeReceiveMonName
	text "?"
	done

_NoTrade3Text::
	text "That's too bad."
	done

_WrongMon3Text::
	text "...This is no"
	next ""
	ramtext wInGameTradeGiveMonName
	text "."

	para "If you get one,"
	next "trade it with me!"
	done

_Thanks3Text::
	text "Thanks pal!"
	done

_AfterTrade3Text::
	text "How is my old"
	next ""
	ramtext wInGameTradeReceiveMonName
	text "?"

	para "My "
	ramtext wInGameTradeGiveMonName
	text " is"
	next "doing great!"
	done

_NothingToCutText::
	text "There isn't"
	next "anything to CUT!"
	prompt

_UsedCutText::
	ramtext wcd6d
	text " hacked"
	next "away with CUT!"
	prompt


SECTION "Pokedex Text", ROMX, BANK[POKEDEX_TEXT]

INCLUDE "text/pokedex.asm"


SECTION "Move Names", ROMX, BANK[MOVE_NAMES]

INCLUDE "text/move_names.asm"
