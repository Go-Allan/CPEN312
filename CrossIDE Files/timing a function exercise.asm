$MODDE0CV

org 0 
ljmp cycles

;initializing the timer
mov a, TMOD
anl a, #11110000b ; clr timer 0 leave timer 1
orl a, #00000001b ; mode one, 16-bit timer
mov TMOD, a
mov TH0, #0
mov TL0, #0

time_start: ; assuming the cycles of is less than 23.59 ms
	clr TF0 ; reset timer flag
	clr TR0 ; reset timer
	ret

time_end:
	mov R0, TH0
	mov R1, TL0
	ret
	
cycles:
	lcall time_start
	setb TR0 ; start the timer
	; ... function to be timed goes here
	clr TR0 ; stop the timer
	lcall time_end
	
END