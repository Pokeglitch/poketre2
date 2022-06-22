_DayCareIntroText::
	text "I run a DAYCARE."
	next "Would you like me"
	cont "to raise one of"
	cont "your POKéMON?"
	done

_DayCareWhichMonText::
	text "Which POKéMON"
	next "should I raise?"
	prompt

_DayCareWillLookAfterMonText::
	text "Fine, I'll look"
	next "after "
	ramtext wcd6d
	cont "for a while."
	prompt

_DayCareComeSeeMeInAWhileText::
	text "Come see me in"
	next "a while."
	done

_DayCareMonHasGrownText::
	text "Your "
	ramtext wcd6d
	next "has grown a lot!"

	para "By level, it's"
	next "grown by "
	numtext wDayCareNumLevelsGrown, 3, 1
	text "!"

	para "Aren't I great?"
	prompt

_DayCareOweMoneyText::
	text "You owe me $"
	numtext wDayCareTotalCost, 5, 2 ; 5 digits, 2 bytes
	next "for the return"
	cont "of this POKéMON."
	done

_DayCareGotMonBackText::
	text "<PLAYER> got"
	next ""
	ramtext wDayCareMonName
	text " back!"
	done

_DayCareMonNeedsMoreTimeText::
	text "Back already?"
	next "Your "
	ramtext wcd6d
	cont "needs some more"
	cont "time with me."
	prompt
