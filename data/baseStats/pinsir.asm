db 0 ; Former Pokedex ID (was never used anyway)
db 65 ; base hp
db 125 ; base attack
db 100 ; base defense
db 85 ; base speed
db 55 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 45 ; catch rate
db 200 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db VICEGRIP
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn 3,6,8
	tmlearn 9,10,15
	tmlearn 17,19,20
	tmlearn 31,32
	tmlearn 34
	tmlearn 44
	tmlearn 50,51,54
db 0 ; padding
