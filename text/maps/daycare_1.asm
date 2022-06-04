_DayCareIntroText::
	text "I run a DAYCARE."
	line "Would you like me"
	cont "to raise one of"
	cont "your POKéMON?"
	done

_DayCareWhichMonText::
	text "Which POKéMON"
	line "should I raise?"
	prompt

_DayCareWillLookAfterMonText::
	text "Fine, I'll look"
	line "after "
	ramtext wcd6d
	cont "for a while."
	prompt

_DayCareComeSeeMeInAWhileText::
	text "Come see me in"
	line "a while."
	done

_DayCareMonHasGrownText::
	text "Your "
	ramtext wcd6d
	line "has grown a lot!"

	para "By level, it's"
	line "grown by "
	numtext wDayCareNumLevelsGrown, 3, 1
	text "!"

	para "Aren't I great?"
	prompt

_DayCareOweMoneyText::
	text "You owe me $"
	bcdtext wDayCareTotalCost, $c2
	line "for the return"
	cont "of this POKéMON."
	done

_DayCareGotMonBackText::
	text "<PLAYER> got"
	line ""
	ramtext wDayCareMonName
	text " back!"
	done

_DayCareMonNeedsMoreTimeText::
	text "Back already?"
	line "Your "
	ramtext wcd6d
	cont "needs some more"
	cont "time with me."
	prompt
