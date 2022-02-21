$MODDE0CV

org 0
	mov SP, #7FH
	ljmp clockprogram
	
Hex_Table:
	DB 0C0H, 0F9H, 0A4H, 0B0H, 099H
	DB 092H, 082H, 0F8H, 080H, 090H
	
DSEG at 30H
S: DS 1
M: DS 1
H: DS 1

CSEG
	
Wait250ms:
	mov R5, #45
	sjmp L3
Wait50ms:
	mov R5, #9 ; change to 90 for 0.5 seconds or 180 for 1 second
L3: mov R4, #250
L2: mov R3, #250
L1: djnz R3, L1
	djnz R4, L2
	djnz R5, L3
	ret

clockprogram:
	MOV LEDRA, #0 ; turn off all leds
	MOV LEDRB, #0
	
	;initialize time and pointers
	mov S, #00H ;seconds
	mov M, #00H ;minutes
	mov H, #12H ;hours
	
	mov dptr, #Hex_Table 
	
forever:
	lcall Display
	;sjmp forever
	
	mov B, #20 ;counter
W0: 
	jnb KEY.1, Spressed
	jnb KEY.2, Mpressed
	jnb KEY.3, Hpressed
	;nothing pressed
	lcall Wait50ms
	djnz B, W0
	ljmp Next

Spressed:
	lcall Wait50ms ;Debouncing
	jnb KEY.1, Spressed2
	djnz B, W0 ;not pressed
	ljmp Next
Spressed2: ;set seconds
	lcall IncrementS
	lcall Display
	lcall Wait250ms
	jnb KEY.1, Spressed2 ;wait for release
	ljmp forever ;released
	
Mpressed:
	lcall Wait50ms ;Debouncing
	jnb KEY.2, Mpressed2
	djnz B, W0 ;not pressed
	ljmp Next
Mpressed2: ;set minutes
	lcall IncrementM
	lcall Display
	lcall Wait250ms
	jnb KEY.2, Mpressed2 ;wait for release
	ljmp forever ;released
	
Hpressed:
	lcall Wait50ms ;Debouncing
	jnb KEY.3, Hpressed2
	djnz B, W0 ;not pressed
	ljmp Next
Hpressed2: ;set hours
	lcall IncrementH
	lcall Display
	lcall Wait250ms
	jnb KEY.3, Hpressed2 ;wait for release
	ljmp forever ;released
	
Next:
	lcall IncrementS
	ljmp forever
	
Display:
	push Acc ;save accumulator

	;display seconds MSDigit
	mov A, S
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX1, A
	;display seconds LSDigit
	mov A, S
	anl A, #0FH
	movc A, @A+dptr
	mov HEX0, A
	
	;display minutes MSDigit	
	mov A, M
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX3, A
	;display minutes LSDigit
	mov A, M
	anl A, #0FH
	movc A, @A+dptr
	mov HEX2, A
	
	;display hours MSDigit	
	mov A, H
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX5, A
	;display hours LSDigit
	mov A, H
	anl A, #0FH
	movc A, @A+dptr
	mov HEX4, A	
	
	pop Acc
	
	ret ;done displaying
	
IncrementH:
	mov A, H
	add A, #1
	da A
	mov H, A
	cjne A, #13H, Not13
	mov H, #01H
Not13:
	ret
	
IncrementM:
	mov A, M
	add A, #1
	da A
	mov M, A
	cjne A, #60H, MNot60
	mov M, #00H
	lcall IncrementH
MNot60:
	ret
	
IncrementS:
	mov A, S
	add A, #1
	da A
	mov S, A
	cjne A, #60H, SNot60
	mov S, #00H
	lcall IncrementM
SNot60:
	ret
	
END