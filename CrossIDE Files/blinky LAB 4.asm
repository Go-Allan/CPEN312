$MODDE0CV

seven 	equ 78H
zero 	equ 40H
two 	equ 24H
six 	equ 02H
three 	equ 30H
four 	equ 19H
BLANK 	equ 01111111b

org 0
	ljmp init
	
wait:
    mov R2, #90       ; 90 is 5AH
L3: mov R1, #250      ; 250 is FAH 
L2: mov R0, #250
L1: jnb KEY.3, CHECK0 ; checks if KEY3 is pressed
	djnz R0, L1  	  ; 3 machine cycles-> 3*30ns*250=22.5us
    djnz R1, L2       ; 22.5us*250=5.625ms
    djnz R2, L3  	  ; 5.625ms*90=0.506s (approximately)
	ret
	
waitabit:
    mov R2, #45       ; 90 is 5AH
L9: mov R1, #250      ; 250 is FAH 
L8: mov R0, #250
L7: jnb KEY.3, CHECK0 ; checks if KEY3 is pressed
	djnz R0, L1  	  ; 3 machine cycles-> 3*30ns*250=22.5us
    djnz R1, L2       ; 22.5us*250=5.625ms
    djnz R2, L3  	  ; 5.625ms*45=0.2503s (approximately)
	ret
	
waitshort:		 	  ; custom timing for function111
    mov R2, #90  
L6: mov R1, #50
L5: mov R0, #100
L4: jnb KEY.3, CHECK0 ; checks if KEY3 is pressed
	djnz R0, L4 
    djnz R1, L5 
    djnz R2, L6  
	ret
	
startas:
	mov HEX5, #seven  ; six most sig figs of student #
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	mov R4, #four	  ; sets two extra register values for the shifting functions 
	mov R5, #seven 
	ret
	
cleardisp:
	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #BLANK
	mov HEX0, #BLANK
	ret	

;; initialization	
init: 				 
	mov SP, #0x7f     ; Initialize the stack
	MOV LEDRA, #0
	MOV LEDRB, #0
	
	lcall cleardisp
	lcall wait
	sjmp init
	
;; checking the switches and jumping to the approptiate function
CHECK0:				 
	jb SWA.0, CHECK1 ; checks if sw0 is pushed
	jb SWA.1, CHECK2 ; if not checks if switch 1 is pressed
	jb SWA.2, JMPTO100 ; if both sw1 and 2 are not pressed and sw 2 is pressed jumps to function 100
	ljmp function000 ; if no switches pushed
	
JMPTO100:
	ljmp function100
	
CHECK1:
	jb SWA.1, CHECK3 ; if switch 0 is pushed and switch 1 is too jump to check 3
	jb SWA.2, JMPTO101 ; if switch 0 is pushed and switch 1 is not and switch 2 is jump to function 101
	ljmp function001 ; if switches 1 and 2 are not pushed but switch 0 is jump to function 001
	
JMPTO101:
	ljmp function101
	
CHECK2:
	jb SWA.2, JMPTO110 ; if switch 1 is pushed check combinations...
	lcall startas
	ljmp function010
	
JMPTO110:
    ljmp function110
    
CHECK3:
	jb SWA.2, JMPTO111 ; if switch 0 and 1 are pushed and switch 2 is as well jump to function 111
	lcall startas ; initializes the starting values of the display before entering the loop
	ljmp function011 ; if switches are 011 jump to that function
	
JMPTO111:
	ljmp function111
	
		
;; functionalities based on switch values		
function000:		 ; function for switches when set to 000
	mov HEX5, #seven ; six most sig figs of student #
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	
	lcall wait
	ljmp function000
	
function001: 		; function for switches when set to 001
	mov HEX5, #BLANK
	mov HEX4, #BLANK
	mov HEX3, #BLANK
	mov HEX2, #BLANK
	mov HEX1, #seven
	mov HEX0, #four
	
	lcall wait
	ljmp function001
	
function010: ; function for switches when set to 010
	lcall wait
	mov R3, HEX5
	mov HEX5, HEX4
	mov HEX4, HEX3
	mov HEX3, HEX2
	mov HEX2, HEX1
	mov HEX1, HEX0
	mov HEX0, R5
	mov B, R4
	mov R5, B
	mov B, R3
	mov R4, B
	
	ljmp function010

function011: ; function for switches when set to 010
	lcall wait
	mov R3, HEX0
	mov HEX0, HEX1
	mov HEX1, HEX2
	mov HEX2, HEX3
	mov HEX3, HEX4
	mov HEX4, HEX5
	mov HEX5, R4
	mov B, R5
	mov R4, B
	mov B, R3
	mov R5, B
	
	ljmp function011

function100: ;
	mov HEX5, #two
	mov HEX4, #six
	mov HEX3, #three
	mov HEX2, #zero
	mov HEX1, #seven
	mov HEX0, #four
	lcall waitabit

	lcall cleardisp
	lcall waitabit
	
	ljmp function100

function101:
	lcall cleardisp
	lcall wait
	mov HEX5, #seven
	lcall wait
	mov HEX4, #zero
	lcall wait
	mov HEX3, #two
	lcall wait
	mov HEX2, #six
	lcall wait
	mov HEX1, #three
	lcall wait
	mov HEX0, #zero
	lcall wait

    ljmp function101
    
function110:
	mov HEX5, #BLANK
	mov HEX4, #09H ; H
	mov HEX3, #06H ; E
	mov HEX2, #47H ; L
	mov HEX1, #47H ; L
	mov HEX0, #40H ; O
	lcall wait
	
	mov HEX5, #seven ; six most sig figs of student #
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall wait
	
	mov HEX5, #46H   ; C
	mov HEX4, #0CH   ; P
	mov HEX3, #48H   ; N
	mov HEX2, #three ; 3
	mov HEX1, #79    ; 1
	mov HEX0, #two   ; 2
	lcall wait
	
	ljmp function110
	
;; special custom extra function
function111:
	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	;loop 2
	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	;;loop 3
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	;loop4

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	;loop5
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	;loop6

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	;loop 7---------------------------------------------------------------------------------------------------------------------
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #seven
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	;loop 2
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #zero
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	;loop 3

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #two
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	;loop 4

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #six
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #zero
	lcall waitshort

	;loop 5
	
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #three
	mov HEX0, #blank
	lcall waitshort

	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #zero
	lcall waitshort
	
	;loop 6
	mov HEX5, #blank
	mov HEX4, #blank
	mov HEX3, #blank
	mov HEX2, #blank
	mov HEX1, #blank
	mov HEX0, #blank
	lcall waitshort
	
	;add before this
	ljmp function111
	
END


























