$MODDE0CV

L_J equ 01100001b
L_E equ 06H
L_S equ 12H
L_U equ 41h
BLANK equ 01111111b
DASH equ 00111111b

org 0
	ljmp init

wait:
    mov R2, #90  ; 90 is 5AH
L3: mov R1, #250 ; 250 is FAH 
L2: mov R0, #250
L1: djnz R0, L1  ; 3 machine cycles-> 3*30ns*250=22.5us
    djnz R1, L2  ; 22.5us*250=5.625ms
    djnz R2, L3  ; 5.625ms*90=0.506s (approximately)
	ret

init:
	mov SP, #0x7f ; Initialize the stack
	MOV LEDRA, #0
	MOV LEDRB, #0
	
	mov HEX4, #L_J
	mov HEX3, #L_E
	mov HEX2, #L_S
	mov HEX1, #L_U
	mov HEX0, #L_S
	
main_loop:
	mov HEX4, #L_J
	mov HEX3, #L_E
	mov HEX2, #L_S
	mov HEX1, #L_U
	mov HEX0, #L_S
	setb LEDRA.0
	lcall wait

	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #BLANK
	mov HEX0, #BLANK
	clr LEDRA.0
	lcall wait
	
	jb SWA.0, dont_do_this
	
	mov HEX4, #L_J
	lcall wait
	mov HEX3, #L_E
	lcall wait
	mov HEX2, #L_S
	lcall wait
	mov HEX1, #L_U
	lcall wait
	mov HEX0, #L_S
	lcall wait

dont_do_this:

	; Check if SWA is 01010100.  If so display "------"
	mov a, swa
	cjne a, #01010100b, not_01010100
	; Display "------"		
	mov HEX4, #DASH
	mov HEX3, #DASH
	mov HEX2, #DASH
	mov HEX1, #DASH
	mov HEX0, #DASH
	lcall wait
not_01010100:
	
    sjmp main_loop

END


























