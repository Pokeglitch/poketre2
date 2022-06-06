_TM29PreReceiveText::
	text "...Wait! Don't"
	next "say a word!"

	para "You wanted this!"
	prompt

_ReceivedTM29Text::
	text "<PLAYER> received"
	next ""
	ramtext wcf4b
	text "!"
	done

_TM29ExplanationText::
	text "TM29 is PSYCHIC!"

	para "It can lower the"
	next "target's SPECIAL"
	cont "abilities."
	done

_TM29NoRoomText::
	text "Where do you plan"
	next "to put this?"
	done
