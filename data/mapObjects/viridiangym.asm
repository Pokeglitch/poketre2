	Warp 16, 17, 4
	Warp 17, 17, 4

	Battle SPRITE_GIOVANNI, 2, 1, STAY, DOWN, 0, Giovanni
		asm
				text "Fwahahaha! This is"
				next "my hideout!"
			
				para "I planned to"
				next "resurrect TEAM"
				cont "ROCKET here!"
			
				para "But, you have"
				next "caught me again!"
				cont "So be it! This"
				cont "time, I'm not"
				cont "holding back!"
			
				para "Once more, you"
				next "shall face"
				cont "GIOVANNI, the"
				cont "greatest trainer!"
			printtext
			ld hl, wd72d
			set 6, [hl]
			set 7, [hl]
			ld a, 8
			ld [wGymLeaderNo], a
			ld a, 2
			ld [wViridianGymCurScript], a
		end

		asm
			CheckEvent EVENT_GOT_TM27
			jr nz, .GotTM27
			call AfterDefeatGiovanniText
			call DisableWaitingAfterTextDisplay
			jr .end

		.GotTM27
			ld a, 1
			ld [wDoNotWaitForButtonPressAfterDisplayingText], a
				text "Having lost, I"
				next "cannot face my"
				cont "underlings!"
				cont "TEAM ROCKET is"
				cont "finished forever!"
			
				para "I will dedicate my"
				next "life to the study"
				cont "of POKéMON!"
			
				para "Let us meet again"
				next "some day!"
				cont "Farewell!"
				prompt
			printtext
			call GBFadeOutToBlack
			ld a, HS_VIRIDIAN_GYM_GIOVANNI
			ld [wMissableObjectIndex], a
			predef HideObject
			call UpdateSprites
			call Delay3
			call GBFadeInFromBlack
		.end
		end

		text "Ha!"
		next "That was a truly"
		cont "intense fight!"
		cont "You have won!"
		cont "As proof, here is"
		cont "the EARTHBADGE!"
		sfxtext SFX_GET_ITEM_1 ; plays SFX_LEVEL_UP instead since the wrong music bank is loaded

    	Team 45, Rhyhorn, 42, Dugtrio, 44, Nidoqueen, 45, Nidoking, 50, Rhydon, 2, FISSURE

	Battle SPRITE_BLACK_HAIR_BOY_1, 12, 7, STAY, DOWN, 4, CooltrainerM
		text "Heh! You must be"
		next "running out of"
		cont "steam by now!"
		done

		text "You need power to"
		next "keep up with our"
		cont "GYM LEADER!"
		done
		
		text "I"
		next "ran out of gas!"
		
		Team 39, Sandslash, Dugtrio

	Battle SPRITE_HIKER, 11, 11, STAY, UP, 4, Blackbelt
		text "Rrrroar! I'm"
		next "working myself"
		cont "into a rage!"
		done
		
		text "I'm still not"
		next "worthy!"
		done

		text "Wargh!"

		Team 40, Machop, Machoke

	Battle SPRITE_ROCKER, 10, 7, STAY, DOWN, 4, Tamer
		text "POKéMON and I, we"
		next "make wonderful"
		cont "music together!"
		done
	
		text "Do you know the"
		next "identity of our"
		cont "GYM LEADER?"
		done
			
		text "You are in"
		next "perfect harmony!"

		Team 43, Rhyhorn

	Battle SPRITE_HIKER, 3, 7, STAY, LEFT, 2, Blackbelt
		text "Karate is the"
		next "ultimate form of"
		cont "martial arts!"
		done
		
		text "If my POKéMON"
		next "were as good at"
		cont "Karate as I..."
		done
		
		text "Atcho!"

		Team 43, Machoke

	Battle SPRITE_BLACK_HAIR_BOY_1, 13, 5, STAY, RIGHT, 3, CooltrainerM	
		text "The truly talented"
		next "win with style!"
		done
		
		text "The LEADER will"
		next "scold me!"
		done
		
		text "I"
		next "lost my grip!"
		
		Team 43, Rhyhorn

	Battle SPRITE_HIKER, 10, 1, STAY, DOWN, 4, Blackbelt
		text "I'm the KARATE"
		next "KING! Your fate"
		cont "rests with me!"
		done
		
		text "POKéMON LEAGUE?"
		next "You? Don't get"
		cont "cocky!"
		done
		
		text "Ayah!"

		Team 38, Machoke, Machop, Machoke

	Battle SPRITE_ROCKER, 2, 16, STAY, RIGHT, 3, Tamer
		text "Your POKéMON will"
		next "cower at the"
		cont "crack of my whip!"
		done
		
		text "Wait! I was just"
		next "careless!"
		done

		text "Yowch!"
		next "Whiplash!"
		
		Team 39, Arbok, Tauros

	Battle SPRITE_BLACK_HAIR_BOY_1, 6, 5, STAY, DOWN, 4, CooltrainerM
		text "VIRIDIAN GYM was"
		next "closed for a long"
		cont "time, but now our"
		cont "LEADER is back!"
		done

		text "You can go onto"
		next "POKéMON LEAGUE"
		cont "only by defeating"
		cont "our GYM LEADER!"
		done
	
		text "I"
		next "was beaten?"

		Team 39, Nidorino, Nidoking

	NPC SPRITE_GYM_HELPER, 16, 15, STAY, DOWN
		asmtext
			CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
			jr nz, .BeatGym
			
				text "Yo! Champ in"
				next "making!"

				para "Even I don't know"
				next "VIRIDIAN LEADER's"
				cont "identity!"

				para "This will be the"
				next "toughest of all"
				cont "the GYM LEADERs!"

				para "I heard that the"
				next "trainers here"
				cont "like ground-type"
				cont "POKéMON!"
				done
			jr .finish

		.BeatGym
			text "Blow me away!"
			next "GIOVANNI was the"
			cont "GYM LEADER here?"
		finish

	Pickup 16, 9, REVIVE

	WarpTo 16, 17
	WarpTo 17, 17
