db DEX_DUGTRIO ; pokedex id
db 35 ; base hp
db 80 ; base attack
db 50 ; base defense
db 120 ; base speed
db 70 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 50 ; catch rate
db 153 ; base exp yield
db 0, 0, 0, ; Former Front Sprite Dimension & Pointer
dw DugtrioPicBack
; attacks known at lvl 0
db SCRATCH
db GROWL
db DIG
db 0
db 0 ; growth rate
; learnset
	tmlearn 6,8
	tmlearn 9,10,15
	tmlearn 20
	tmlearn 26,27,28,31,32
	tmlearn 34
	tmlearn 44,48
	tmlearn 50
db 0 ; padding
