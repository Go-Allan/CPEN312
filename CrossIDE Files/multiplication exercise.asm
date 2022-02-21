$MODDE0CV

org 0000b ; origin at 0

mov dpl, #low(16900)
mov dph, #high(16900)
mov R0, #128
ljmp check
    
highbigger:
mov a, r0
add a, #1
mov r0, a
ljmp check
highlower:
clr c
mov a, r0
subb a, #1
mov r0, a
ljmp check

lowbigger:
mov a, r0
add a, #1
mov r0, a
ljmp check
lowlower: 
mov a, r0
add a, #1
mov r0, a
ljmp check


check:
mov b, R0
mov a, R0
mul ab
mov r1, a
mov r2, b
clr c
mov a, r2
subb a, dph 
jc highbigger
mov a, dph
subb a, r2
jc highlower
mov a, r1
subb a, dpl 
jc lowbigger
mov a, dpl
subb a, r1
jc lowlower
			;or they're equal
mov a, r0
mov r7, a
END



























































































