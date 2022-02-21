
$MODDE0CV

org 0h
ljmp start

;interrupt dictionary
org 3h ;external interrupt 0
reti
org 0bh ; timer 0 interrupt
ljmp pulse
org 13h ;ex interrupt 1
reti
org 1bh ;t1 interrupt
reti
org 23h ;serial port interrupt
reti
org 2bh ;t2 interrupt
reti
	
;lookup tables
T_7SEG:
	DB 40H, 79H, 24H, 30H, 19H
	DB 12H, 02H, 78H, 00H, 10H 
	
start:
;initalize the registers in bank 1 that will count
mov r2, #0
mov sp, #7fh ;!!!!remember to initalize stack pointer!!
mov dptr, #T_7SEG
mov a, r1
movc a, @dptr+a
mov HEX0, a
mov a, r2
movc a, @dptr+a 
mov HEX1, a

push psw
mov psw, #00001000b
mov R0, #0
mov R1, #0
pop psw

;enable timer 0
mov a, TMOD
anl a, #11110000B ;1111 0000 which clears timer 0 without affecting timer 1
orl a, #00000001b; mode 1
mov TMOD, A
clr TR0;reset timer
mov TH0, #high(9981); THIS IS THE INTERUPT RATE!
mov TL0, #low(9981)
clr TF0;clear timer flag
setb TR0; enable timer0
setb ET0 ;enable timer 0 interrupt
setb EA; enable all interrupts

;enable timer 2
;mov a, TMOD
;anl a, #11110000B ;1111 0000 which clears timer 0 without affecting timer 1
;orl a, #00000001b; mode 1
;mov TMOD, A
;clr TR0;reset timer
;mov TH0, #high(9981); THIS IS THE INTERUPT RATE!
;mov TL0, #low(9981)
;clr TF0;clear timer flag
;setb TR0; enable timer0
;setb ET0 ;enable timer 0 interrupt
;setb EA; enable all interrupts

forever:
jmp forever

;the counting ISR
pulse:
	jnb TF0, pulse
	cpl LEDRA.0
	reti

;if the number in register 1 is 9, then make it zero and increment high
cjne R1, #9, inclow
mov r1, #0
cjne R0, #9, inchigh;check if it is 99, if so make high 0 as well
mov r0, #0
sjmp display
inchigh:
inc r0
sjmp display
inclow:
inc r1

display:
mov dptr, #T_7SEG
mov a, r1
movc a, @dptr+a
mov HEX0, a
mov a, r0
movc a, @dptr+a 
mov HEX1, a

wait:
pop acc
pop psw ;pulls the original psw from the previous push
reti
































































































































