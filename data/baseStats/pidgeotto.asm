db DEX_PIDGEOTTO ; pokedex id
db 63 ; base hp
db 60 ; base attack
db 55 ; base defense
db 71 ; base speed
db 50 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 120 ; catch rate
db 113 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db GUST
db SAND_ATTACK
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 2,4,6
	tmlearn 9,10
	tmlearn 20
	tmlearn 31,32
	tmlearn 33,34,39
	tmlearn 43,44
	tmlearn 50,52
db 0 ; padding
