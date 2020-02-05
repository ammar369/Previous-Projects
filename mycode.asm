; ISR_example.asm: a) Increments/decrements a BCD variable every half second using
; an ISR for timer 2; b) Generates a 2kHz square wave at pin P3.7 using
; an ISR for timer 0; and c) in the 'main' loop it displays the variable
; incremented/decremented using the ISR for timer 2 on the LCD.  Also resets it to 
; zero if the 'BOOT' pushbutton connected to P4.5 is pressed.
$NOLIST
$MODLP51
$LIST

; There is a couple of typos in MODLP51 in the definition of the timer 0/1 reload
; special function registers (SFRs), so:

TIMER0_RELOAD_L DATA 0xf2
TIMER1_RELOAD_L DATA 0xf3
TIMER0_RELOAD_H DATA 0xf4
TIMER1_RELOAD_H DATA 0xf5

CLK           EQU 22118400 ; Microcontroller system crystal frequency in Hz
TIMER0_RATE   EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))

BOOT_BUTTON   equ P4.5
SOUND_OUT     equ P3.7
UPDOWN        equ P0.7
SETBUTTON     equ P0.5
CHANGEBUTTON  equ P0.2
ALARM1_SET	  equ P0.1
ALARM2_SET 	  equ P0.0
SNOOZEBUTTON  equ P0.3

; Reset vector
org 0x0000
    ljmp main

; External interrupt 0 vector (not used in this code)
org 0x0003
	reti

; Timer/Counter 0 overflow interrupt vector
org 0x000B
	ljmp Timer0_ISR

; External interrupt 1 vector (not used in this code)
org 0x0013
	reti

; Timer/Counter 1 overflow interrupt vector (not used in this code)
org 0x001B
	reti

; Serial port receive/transmit interrupt vector (not used in this code)
org 0x0023 
	reti
	
; Timer/Counter 2 overflow interrupt vector
org 0x002B
	ljmp Timer2_ISR

; In the 8051 we can define direct access variables starting at location 0x30 up to location 0x7F
dseg at 0x30
Count1ms:     ds 2 ; Used to determine when half second has passed
sec_count:    ds 1 ; The BCD counter incrememted in the ISR and displayed in the main loop
min_count:    ds 1
hour_count:   ds 1
day_count:    ds 1
a1_min:		  ds 1
a1_hour:	  ds 1
a1_day:		  ds 1
a2_min:		  ds 1
a2_hour:	  ds 1
a2_day:		  ds 1

; In the 8051 we have variables that are 1-bit in size.  We can use the setb, clr, jb, and jnb
; instructions with these variables.  This is how you define a 1-bit variable:
bseg
second_flag: dbit 1 ; Set to one in the ISR every time 500 ms had passed
a1_flag:	 dbit 1
a2_flag:	 dbit 1

cseg
; These 'equ' must match the wiring between the microcontroller and the LCD!
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5
$NOLIST
$include(C:\Users\user\Documents\Education\School\2018\ELEC 291\Modules\Module 2\LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

;                     1234567890123456    <- This helps determine the location of the counter
line_1:  	db 'xx:xx:xx', 0
monday:  	db 'MON',0
tuesday:  	db 'TUE',0
wednesday:  db 'WED',0
thursday:  	db 'THU',0
friday:  	db 'FRI',0
saturday:  	db 'SAT',0
sunday:  	db 'SUN',0

;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 0                     ;
;---------------------------------;
Timer0_Init:
	mov a, TMOD
	anl a, #0xf0 ; Clear the bits for timer 0
	orl a, #0x01 ; Configure timer 0 as 16-timer
	mov TMOD, a
	mov TH0, #high(TIMER0_RELOAD)
	mov TL0, #low(TIMER0_RELOAD)
	; Set autoreload value
	mov TIMER0_RELOAD_H, #high(TIMER0_RELOAD)
	mov TIMER0_RELOAD_L, #low(TIMER0_RELOAD)
	; Enable the timer and interrupts
    setb ET0  ; Enable timer 0 interrupt
    setb TR0
	ret

;---------------------------------;
; ISR for timer 0.  Set to execute;
; every 1/4096Hz to generate a    ;
; 2048 Hz square wave at pin P3.7 ;
;---------------------------------;
Timer0_ISR:
	;clr TF0  ; According to the data sheet this is done for us already.
	cpl SOUND_OUT ; Connect speaker to P3.7!
	reti

;---------------------------------;
; Routine to initialize the ISR   ;
; for timer 2                     ;
;---------------------------------;
Timer2_Init:
	mov T2CON, #0 ; Stop timer/counter.  Autoreload mode.
	mov TH2, #high(TIMER2_RELOAD)
	mov TL2, #low(TIMER2_RELOAD)
	; Set the reload value
	mov RCAP2H, #high(TIMER2_RELOAD)
	mov RCAP2L, #low(TIMER2_RELOAD)
	; Init One millisecond interrupt counter.  It is a 16-bit variable made with two 8-bit parts
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	mov sec_count,  a
	mov min_count,  a
	mov hour_count, a
	mov day_count,  a
	mov a1_min, a
	mov a1_hour, a
	mov a1_day, a
	mov a2_min, a
	mov a2_hour, a
	mov a2_day, a
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret

;---------------------------------;
; ISR for timer 2                 ;
;---------------------------------;
Timer2_ISR:
	clr TF2  ; Timer 2 doesn't clear TF2 automatically. Do it in ISR
	cpl P3.6 ; To check the interrupt rate with oscilloscope. It must be precisely a 1 ms pulse.
	
	; The two registers used in the ISR must be saved in the stack
	push acc
	push psw
	
	; Increment the 16-bit one mili second counter
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1

Inc_Done:
	; Check if one second has passed
	mov a, Count1ms+0
	cjne a, #low(1000), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(1000), Timer2_ISR_done
	
	; 1000 milliseconds have passed.  Set a flag so the main program knows
	setb second_flag ; Let the main program know a second had passed
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	lcall count_sec
	lcall count_min
	lcall count_hour
	lcall inc_day
	lcall display_day
	jnb ALARM1_SET, change_a1
	jnb ALARM2_SET, change_a2
snooze_alarms:
	lcall snooze_a1
	lcall snooze_a2
change_time:
	lcall change_loop1
	lcall change_loop2
	lcall change_loop3
	jb ALARM1_SET, Timer2_ISR_done
change_a1:
	lcall change_loop4
	lcall change_loop5
	lcall change_loop6
	jb ALARM2_SET, Timer2_ISR_done
change_a2:
	lcall change_loop7
	lcall change_loop8
	lcall change_loop9
Timer2_ISR_done:
	pop psw
	pop acc
	reti

;---------------------------------;
;   Snooze Button Functionality   ;
;---------------------------------;
snooze_a1:
	jnb a1_flag, snooze_a1end
	jnb SNOOZEBUTTON, a1_inc
snooze_a1end:
	ret
snooze_a2:
	jnb a2_flag, snooze_a2end
	jnb SNOOZEBUTTON, a2_inc
snooze_a2end:
	ret
	
a1_inc:
	mov a, a1_min
	add a, #0x10
	da a
	mov a1_min, a
	reti
a2_inc:
	mov a, a2_min
	add a, #0x10
	da a
	mov a2_min, a
	reti
;---------------------------------;

;---------------------------------;
; To increment min, hour and day  ;
;---------------------------------;
count_sec:
	mov a, sec_count
	add a, #0x01
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov sec_count, a
count_min:
	mov a, sec_count
	cjne a, #0x60, count_min_done
	clr a
	mov sec_count, a
	mov a, min_count
	add a, #0x01
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov min_count, a
count_min_done:
	ret
count_hour:
	mov a, min_count
	cjne a, #0X60, count_hour_done
	clr a
	mov min_count, a
	mov sec_count, a
	mov a, hour_count
	add a, #0x01
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov hour_count, a
count_hour_done:
	ret
inc_day:
	mov a, hour_count
	cjne a, #0x24, count_day_done
	clr a
	mov hour_count, a
	mov min_count, a
	mov sec_count, a
	mov a, day_count
	add a, #0x01
	da a
	mov day_count, a
count_day_done:
	ret
display_day:
	mov a, day_count
display_mon:
	cjne a, #0x00, display_tue
	Set_Cursor(2, 1)
	Send_Constant_String(#monday)
	ret
display_tue:
	cjne a, #0x01, display_wed
	Set_Cursor(2, 1)
	Send_Constant_String(#tuesday)
	ret
display_wed:
	cjne a, #0x02, display_thu
	Set_Cursor(2, 1)
	Send_Constant_String(#wednesday)
	ret
display_thu:
	cjne a, #0x03, display_fri
	Set_Cursor(2, 1)
	Send_Constant_String(#thursday)
	ret
display_fri:
	cjne a, #0x04, display_sat
	Set_Cursor(2, 1)
	Send_Constant_String(#friday)
	ret
display_sat:
	cjne a, #0x05, display_sun
	Set_Cursor(2, 1)
	Send_Constant_String(#saturday)
	ret
display_sun:
	cjne a, #0x06, label_11
	Set_Cursor(2, 1)
	Send_Constant_String(#sunday)
	ret
	
;---------------------------------;
;Label for solving relative offset;
;---------------------------------;
label_1:
	ljmp loop_a
	
label_11:
	mov a, #0x00
	mov day_count, a
	ljmp display_mon

;---------------------------------;
;  To set sec, min, hour and day  ;
;  of the clock and of two alarms ;
;---------------------------------;
change_loop1:
	jnb UPDOWN, change_day
	sjmp change_end
change_loop2:
	jnb SETBUTTON, change_hour
	sjmp change_end
change_loop3:
	jnb CHANGEBUTTON, change_min
	sjmp change_end
change_loop4:
	jnb UPDOWN, change_a1_day
	sjmp change_end
change_loop5:
	jnb SETBUTTON, change_a1_hour
	sjmp change_end
change_loop6:
	jnb CHANGEBUTTON, change_a1_min
	sjmp change_end
change_min:
	mov a, min_count
	add a, #0x01
	mov min_count, a
	reti
change_hour:
	mov a, hour_count
	add a, #0x01
	mov hour_count, a
	reti
change_day:
	mov a, day_count
	add a, #0x01
	mov day_count, a
	reti
change_end:
	ret
;to change time for alarm 1
change_a1_min:
	mov a, a1_min
	add a, #0x01
	mov a1_min, a
	reti
change_a1_hour:
	mov a, a1_hour
	add a, #0x01
	mov a1_hour, a
	reti
change_a1_day:
	mov a, a1_day
	add a, #0x01
	mov a1_day, a
	reti
change_loop7:
	jnb UPDOWN, change_a2_day
	sjmp change_end
change_loop8:
	jnb SETBUTTON, change_a2_hour
	sjmp change_end
change_loop9:
	jnb CHANGEBUTTON, change_a2_min
	sjmp change_end
change_a2_min:
	mov a, a2_min
	add a, #0x01
	mov a2_min, a
	reti
change_a2_hour:
	mov a, a2_hour
	add a, #0x01
	mov a2_hour, a
	reti
change_a2_day:
	mov a, a2_day
	add a, #0x01
	mov a2_day, a
	reti


;---------------------------------;
;     To check Alarm Times        ;
;---------------------------------;
check_alarm1:
	mov a, day_count			;first check day
	cjne a, a1_day, no_alarm
	mov a, hour_count			;then check hour
	cjne a, a1_hour, no_alarm	
	mov a, min_count			;then check min
	cjne a, a1_min, no_alarm	
	setb TR0					;if all conditions satisfied turn on timer 0
	setb a1_flag
	ret
	
check_alarm2:
	mov a, day_count			;first check day
	cjne a, a2_day, no_alarm	
	mov a, hour_count			;then check hour
	cjne a, a2_hour, no_alarm	
	mov a, min_count			;then check min
	cjne a, a2_min, no_alarm	
	setb TR0					;if all conditions satisfied turn on timer 0
	setb a2_flag
	ret
	
no_alarm:
	clr TR0						;this stops T0 and therefore speaker stops
	clr a1_flag
	clr a2_flag
	ret							;if no alarm, we return to loop_a after the function call
;---------------------------------;
; Main program. Includes hardware ;
; initialization and 'forever'    ;
; loop.                           ;
;---------------------------------;
main:
	; Initialization
    mov SP, #0x7F
    lcall Timer0_Init
    lcall Timer2_Init
    ; In case you decide to use the pins of P0, configure the port in bidirectional mode:
    mov P0M0, #0
    mov P0M1, #0
    setb EA   ; Enable Global interrupts
    lcall LCD_4BIT
    clr TR0
    ; For convenience a few handy macros are included in 'LCD_4bit.inc':
	Set_Cursor(1, 1)
    Send_Constant_String(#line_1)
    setb second_flag
	mov sec_count, #0x00
	
	; After initialization the program stays in this 'forever' loop
loop:
	
	jb BOOT_BUTTON, loop_a  ; if the 'BOOT' button is not pressed skip
	Wait_Milli_Seconds(#50)	; Debounce delay.  This macro is also in 'LCD_4bit.inc'
	jb BOOT_BUTTON, loop_a  ; if the 'BOOT' button is not pressed skip
	jnb BOOT_BUTTON, $		; Wait for button release.  The '$' means: jump to same instruction.
	; A valid press of the 'BOOT' button has been detected, reset the BCD counter.
	; But first stop timer 2 and reset the milli-seconds counter, to resync everything.
	clr TR2                 ; Stop timer 2
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Now clear the counters
	mov sec_count, a
	mov min_count,  a
	mov hour_count, a
	mov day_count,  a
	mov a1_min, a
	mov a1_hour, a
	mov a1_day, a
	mov a2_min, a
	mov a2_hour, a
	mov a2_day, a
	setb TR2                ; Start timer 2
	sjmp loop_b             ; Display the new value
loop_a:
	lcall check_alarm1		;first we check alarm times and turn on speaker appropriately
	lcall check_alarm2
	jnb second_flag, loop   ; checking second_flag
loop_b:
    clr second_flag 		; We clear this flag in the main loop, but it is set in the ISR for timer 2
	Set_Cursor(1, 1)     	; the place in the LCD where we want the hour_count
	Display_BCD(hour_count) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(1, 4)
	Display_BCD(min_count)
	Set_Cursor(1, 7)
	Display_BCD(sec_count)
	Set_Cursor(2, 6)
	Display_BCD(day_count)
	Set_Cursor(1, 11)
	Display_BCD(a1_day)
	Set_Cursor(1, 13)
	Display_BCD(a1_hour)
	Set_Cursor(1, 15)
	Display_BCD(a1_min)
	Set_Cursor(2, 11)
	Display_BCD(a2_day)
	Set_Cursor(2, 13)
	Display_BCD(a2_hour)
	Set_Cursor(2, 15)
	Display_BCD(a2_min)
    ljmp loop
END