db 0 ; Former Pokedex ID (was never used anyway)
db 250 ; base hp
db 5 ; base attack
db 5 ; base defense
db 50 ; base speed
db 105 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 30 ; catch rate
db 255 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db POUND
db DOUBLESLAP
db 0
db 0
db 4 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14,15
	tmlearn 17,18,19,20,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,34,35,37,38,40
	tmlearn 41,44,45,46
	tmlearn 49,50,54,55
db 0 ; padding
