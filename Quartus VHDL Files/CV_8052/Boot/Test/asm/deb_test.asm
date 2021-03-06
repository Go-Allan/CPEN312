; Blinky.asm: blinks LEDR0 of the CV-8052 each second.
$MODDE0CV

org 0000H
	ljmp myprogram

;For a 33.33MHz clock takes 30ns
WaitHalfSec:
	mov R2, #90
L3: mov R1, #250
L2: mov R0, #250
L1: djnz R0, L1 ; 3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L2 ; 22.5us*250=5.625ms
	djnz R2, L3 ; 5.625ms*90=0.5s (approximately)
	ret

getbyte:
	mov dptr, #0
getbyte_L0:
	movx a, @dptr
	jz getbyte_L0
	; got something
	inc dpl
	movx a, @dptr ; read it
	push acc
	; clear flag so transmitter can send something else
	dec dpl
	clr a
	movx @dptr, a
	; return value read
	pop acc
	ret
	
myprogram:
	mov SP, #7FH
	mov LEDRA,#0
	mov LEDRB,#0
M0:
	lcall getbyte
	mov LEDRA, a
	sjmp M0
END
