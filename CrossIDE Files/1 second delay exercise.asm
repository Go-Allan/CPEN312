$MODDE0CV

org 0H
ljmp setup

org 0BH ; interrupt for timer 0
ljmp pulse

setup:
mov R7, #100
MOV LEDRA, #0 ; turn off all other LEDS
MOV LEDRB, #0

start:

	;initialize the registers in bank 1 that will count 
	push psw
	mov psw, #00001000B
	mov R0, #0
	mov R1, #0
	pop psw
	
	;enable timer
	mov A, TMOD
	anl A, #11110000B ; clears timer 0, leaves timer 1
	orl A, #00000001B ; mode 1
	mov TMOD, A
	clr TR0 ; reset timer
	mov TH0, #high(37759); interrupt rate from calculations
	mov TL0, #low(37759)
	clr TF0 ; clear timer flag
	setb TR0 ; enable timer 0
	setb ET0 ; enable timer interrupt
	setb EA ; enable all interrupts
	
pulse:
	jnb TF0, pulse
	djnz R7, start 
	cpl LEDRA.0 
	mov R7, #100
	reti
	
END

