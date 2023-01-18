db DEX_NIDOKING ; pokedex id
db 81 ; base hp
db 92 ; base attack
db 77 ; base defense
db 85 ; base speed
db 75 ; base special
db POISON ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 195 ; base exp yield
db 0, 0, 0 ; Former Front Sprite Dimension & Pointer
db 0, 0 ; Former Back Sprite Pointer
; attacks known at lvl 0
db TACKLE
db HORN_ATTACK
db POISON_STING
db THRASH
db 3 ; growth rate
; learnset
	tmlearn 1,5,6,7,8
	tmlearn 9,10,11,12,13,14,15,16
	tmlearn 17,18,19,20,24
	tmlearn 25,26,27,31,32
	tmlearn 33,34,38,40
	tmlearn 44,48
	tmlearn 50,53,54
db 0 ; padding
