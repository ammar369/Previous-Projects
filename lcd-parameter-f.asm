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
BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))

SOUND_OUT     equ P3.7
pinmode		  equ p2.4
pins  		  equ P0.3 
stop           equ P2.5
CE_ADC  EQU P2.0
MY_MOSI EQU P2.1
MY_MISO EQU P2.2
MY_SCLK EQU P2.3
SEGA equ P0.3
SEGB equ P0.5
SEGC equ P0.7
SEGD equ P4.4
SEGE equ P4.5
SEGF equ P0.4
SEGG equ P0.6
SEGP equ P2.7
CA1  equ P0.0
CA2  equ P0.1
CA3  equ P0.2
;BOOT_BUTTON		equ P4.5
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
ljmp main
; In the 8051 we can define direct access variables starting at location 0x30 up to location 0x7F
dseg at 0x30
Count1ms:     ds 2 ; Used to determine when half second has passed
BCD_counter_s:  ds 2 ; The BCD counter incrememted in the ISR and displayed in the main loop
BCD_counter_s1:  ds 2 
BCD_counter_s2:  ds 2 
soak_temp: ds 2
reflow_temp: ds 2
x:   ds 4
y:   ds 4
bcd: ds 5
Result: Ds 2
Room_temperature: ds 2
Room: ds 4
temperature_001: ds 2
temperature_010: ds 2
temperature_100: ds 2

BCD_counter:  ds 1 ; The BCD counter incrememted in the ISR and displayed in the main loop
Disp1:  ds 1 
Disp2:  ds 1
Disp3:  ds 1
state:  ds 1
temp: ds 1
; In the 8051 we have variables that are 1-bit in size.  We can use the setb, clr, jb, and jnb
; instructions with these variables.  This is how you define a 1-bit variable:
bseg
half_seconds_flag: dbit 1 ; Set to one in the ISR every time 500 ms had passed
setwk:   dbit 1
setwn:	dbit 1
mode: dbit 2
mf: dbit 1
flag: dbit 1
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
$include(math32.inc)
$include(LCD_4bit.inc) ; A library of LCD related functions and utility macros
$LIST

;                     1234567890123456    <- This helps determine the location of the counter

weekday:  db 'S time:',0
weekend:  db 'R time:',0
Soak_temp1: db 'S temp:',0
Reflow_temp1: db 'R temp:',0
coma:   db ':',0
space1:  db '',0
tempabc:   db 'temp:           ',0
time:  db 'time:',0

putchar:
    jnb TI, putchar
    clr TI
    mov SBUF, a
    ret

Send_BCD mac
	push ar0
	mov r0, %0
	lcall ?Send_BCD
	pop ar0
endmac

?Send_BCD:
	push acc
	; Write most significant digit
	mov a, r0
	swap a
	anl a, #0fh
	orl a, #30h
	lcall putchar
	; write least significant digit
	mov a, r0
	anl a, #0fh
	orl a, #30h
	lcall putchar
	pop acc
	ret
	
SendString:
    clr A
    movc A, @A+DPTR
    jz SendStringDone
    lcall putchar
    inc DPTR
    sjmp SendString
SendStringDone:
    ret
InitSerialPort:
    ; Since the reset button bounces, we need to wait a bit before
    ; sending messages, otherwise we risk displaying gibberish!
    mov R1, #222
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
    ; Now we can proceed with the configuration
	orl	PCON,#0x80
	mov	SCON,#0x52
	mov	BDRCON,#0x00
	mov	BRL,#BRG_VAL
	mov	BDRCON,#0x1E ; BDRCON=BRR|TBCK|RBCK|SPD;
    ret
INIT_SPI:
 setb MY_MISO ; Make MISO an input pin
 clr MY_SCLK ; For mode (0,0) SCLK is zero
 ret

DO_SPI_G:
 push acc
 mov R1, #0 ; Received byte stored in R1
 mov R2, #8 ; Loop counter (8-bits)
DO_SPI_G_LOOP:
 mov a, R0 ; Byte to write is in R0
 rlc a ; Carry flag has bit to write
 mov R0, a
 mov MY_MOSI, c
 setb MY_SCLK ; Transmit
 mov c, MY_MISO ; Read received bit
 mov a, R1 ; Save received bit in R1
 rlc a
 mov R1, a
 clr MY_SCLK
 djnz R2, DO_SPI_G_LOOP
 pop acc
 ret
 ;///////////////////////////////////////////////////display
 Delay:
    push AR0
    push AR1
    lcall WaitmilliSec
    lcall WaitmilliSec
    lcall WaitmilliSec
    lcall WaitmilliSec
    lcall WaitmilliSec
    lcall WaitmilliSec
    lcall WaitmilliSec
 

    pop AR1
    pop AR0
    ret    

WaitmilliSec:
    push AR0
    push AR1
L15: mov R4, #45
L14: mov R3, #166
L16: djnz R3, L16 ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R4, L14 ; 22.51519us*45=1.013ms
    djnz R2, L15 ; number of millisecons to wait passed in R2
    pop AR1
    pop AR0
    ret    


Display_wire_temperature:
   mov x+0,Result+0
   mov x+1,Result+1
   mov x+2,#0
   mov x+3,#0
   LOAD_Y(36)
   LCALL MUL32
   LOAD_Y(100)
   LCALL DIV32
   
   lcall add320
   
   lcall HEX2bcd
   Send_BCD(BCD+1)
   Send_BCD(BCD+0)   
   MOV a,#'\n'
   lcall putchar
   MOV a,#'\r'
   lcall putchar
   Set_Cursor(2, 6)     ; the place in the LCD where we want the BCD counter value
   Display_BCD(BCD+1) ; This macro is also in 'LCD_4bit.inc'
   Display_BCD(BCD+0) ; This macro is also in 'LCD_4bit.inc'
   mov a, BCD+0
   mov b,#0X10
   DIV ab
   mov Temperature_001,b
   mov Temperature_010,a
   clr a

   mov a, BCD+1
   mov b,#0X10
   DIV ab
   mov TEMPERATURE_100,b
   clr a

   
   
  ret

Display_room_temperature:
   mov x+0,Room_temperature+0
   mov x+1,Room_temperature+1
   mov x+2,#0
   mov x+3,#0
   Load_y(410)
	lcall mul32
	Load_y(1023)
	lcall div32
	Load_y(273)
	lcall sub32

    mov Room+0, x+0
    mov Room+1, x+1
    mov Room+2,#0
    mov Room+3,#0
    
    lcall hex2bcd   
	Send_BCD(BCD+0)
	mov a, #'\n'
	lcall putchar
	mov a, #'\r'
	lcall putchar
    clr a
    
   Set_Cursor(2,11)
   Display_BCD(BCD+0)
   
   ret
   
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
    clr ET0  ; Enable timer 0 interrupt
    setb TR0  ; Start timer 0
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
	
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret

load_segments:
	mov c, acc.0
	mov SEGA, c
	mov c, acc.1
	mov SEGB, c
	mov c, acc.2
	mov SEGC, c
	mov c, acc.3
	mov SEGD, c
	mov c, acc.4
	mov SEGE, c
	mov c, acc.5
	mov SEGF, c
	mov c, acc.6
	mov SEGG, c
	mov c, acc.7
	mov SEGP, c
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
	setb CA1
	setb CA2
	setb CA3

	mov a, state
state0:
	cjne a, #0, state1
	mov a, disp1
	lcall load_segments
	clr CA1
	inc state
	sjmp state_done
state1:
	cjne a, #1, state2
	mov a, disp2
	lcall load_segments
	clr CA2
	inc state
	sjmp state_done
state2:
	cjne a, #2, state_reset
	mov a, disp3
	lcall load_segments
	clr CA3
	mov state, #0
	sjmp state_done
state_reset:
	mov state, #0
state_done:
	; Increment the 16-bit one mili second counter
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1
	

Inc_Done:
	; Check if half second has passed
	mov a, Count1ms+0
	cjne a, #low(200), Timer2_ISR_done ; Warning: this instruction changes the carry flag!
	mov a, Count1ms+1
	cjne a, #high(200), Timer2_ISR_done
	
	; 500 milliseconds have passed.  Set a flag so the main program knows
	setb half_seconds_flag ; Let the main program know half second had passed
	;cpl TR0 ; Enable/disable timer/counter 0. This line creates a beep-silence-beep-silence sound.
	; Reset to zero the milli-seconds counter, it is a 16-bit variable
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Increment the BCD counter
	
	mov a, BCD_counter_s
;	jnb UPDOWN, Timer2_ISR_decrement
	sjmp Timer2_ISR_da
Timer2_ISR_decrement:
	add a, #0x99 ; Adding the 10-complement of -1 is like subtracting 1.
Timer2_ISR_da:
	cjne a, #0x99, abc
	mov a,#0x00
	mov  BCD_counter_s,a
	mov a,BCD_counter_s+1	
	add a, #0x01
	da a
	mov BCD_counter_s+1, a
	ljmp Timer2_ISR_done
abc:
	add a, #0x01
	da a
	mov BCD_counter_s, a
	  

Timer2_ISR_done:

	pop psw
	pop acc
	reti

HEX_7SEG: DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
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
    mov AUXR, #00010001B
    setb EA   ; Enable Global interrupts
    setb P0.3 
    setb P0.6 
    setb P2.5 
    setb P2.2 
    setb P2.0
    setb P0.1
    setb P2.4
    clr mode
    lcall LCD_4BIT
   lcall InitSerialPort
    lcall INIT_SPI
    
    setb half_seconds_flag
    mov BCD_counter_s, #0x00
     mov BCD_counter_s+1, #0x00
    mov BCD_counter_s1, #0x00
     mov BCD_counter_s1+1, #0x00
     mov BCD_counter_s2, #0x00
     mov BCD_counter_s2+1, #0x00
    mov soak_temp, #0x00
     mov soak_temp+1, #0x00
	mov reflow_temp, #0x00
	mov reflow_temp+1, #0x00
	mov temp, #0x17
	mov state, #0
	; After initialization the program stays in this 'forever' loop
loop:
	jnb pinmode,n1
	ljmp mode0
n1:	Wait_Milli_Seconds(#100)
	jnb pinmode,n2
	ljmp mode0	; Wait for the button to be released
n2:
lm1: jnb pinmode, lm1

   
mode1:
 	setb setwk
    clr setwn
	jb pins, not_pressed11
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed11	; Wait for the button to be released
lb11: jnb pins, lb11
	lcall presseds1

not_pressed11:
	Set_Cursor(2, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(BCD_counter_s1) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(2, 12)  
	Display_BCD(BCD_counter_s1+1)
	Set_Cursor(2, 1)    
    Send_Constant_String(#weekday)  	
	 	jnb pinmode,nm1
	ljmp mode1
nm1:	Wait_Milli_Seconds(#100)
	jnb pinmode,nm2
	ljmp mode1	; Wait for the button to be released
nm2:
lm2: jnb pinmode, lm2

	
	
	
mode2:
 	setb setwn
    clr setwk
	jb pins, not_pressed12
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed12	; Wait for the button to be released
lb12: jnb pins, lb12
	lcall presseds2
	
not_pressed12:
	Set_Cursor(2, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(BCD_counter_s2) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(2, 12)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(BCD_counter_s2+1) 
Set_Cursor(2, 1)    
    Send_Constant_String(#weekend)

	jnb pinmode,nm4
	ljmp mode2
nm4:	Wait_Milli_Seconds(#100)
	jnb pinmode,nm3
	ljmp mode2	; Wait for the button to be released
nm3:
lm3: jnb pinmode, lm3
		
	
mode3:
 	setb setwn
    clr setwk
	jb pins, not_pressed112
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed112	; Wait for the button to be released
lb112: jnb pins, lb112
	lcall soaktemp

	
not_pressed112:
	Set_Cursor(2, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(soak_temp) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(2, 12)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(soak_temp+1) 
	Set_Cursor(2, 1)    
    Send_Constant_String(#Soak_temp1)

	jnb pinmode,nm14
	ljmp mode3
nm14:	Wait_Milli_Seconds(#100)
	jnb pinmode,nm13
	ljmp mode3	; Wait for the button to be released
nm13:
lm13: jnb pinmode, lm13	

mode4:

 	setb setwn
    clr setwk
	jb pins, not_pressed1112
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed1112	; Wait for the button to be released
lb1112: jnb pins, lb1112
	lcall reflowtemp

	
not_pressed1112:
	Set_Cursor(2, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(reflow_temp) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(2, 12)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(reflow_temp+1) 
	Set_Cursor(2, 1)    
    Send_Constant_String(#Reflow_temp1)

	jnb pinmode,nm114
	ljmp mode4
nm114:	Wait_Milli_Seconds(#100)
	jnb pinmode,nm113
	ljmp mode4	; Wait for the button to be released
nm113:
lm113: jnb pinmode, lm113	

mode0:

alarm:
	mov a, BCD_counter_s
	cjne a, #0x20, next
	clr a
buffer:
	setb ET0
	mov r3, #2
La4: mov R2, #89
La3: mov R1, #250
La2: mov R0, #166
La1: djnz R0, La1 ; 3 cycles->3*45.21123ns*166=22.51519us
   djnz R1, La2 ; 22.51519us*250=5.629ms
   djnz R2, La3 ; 5.629ms*89=0.5s (approximately)
   djnz R3, La4 ; 3S
	clr ET0

next:
;	jb BOOT_BUTTON, loop_a  ; if the 'BOOT' button is not pressed skip
;	Wait_Milli_Seconds(#100)	; Debounce delay.  This macro is also in 'LCD_4bit.inc'
;	jb BOOT_BUTTON, loop_a  ; if the 'BOOT' button is not pressed skip
;	jnb BOOT_BUTTON, $		; Wait for button release.  The '$' means: jump to same instruction.
	; A valid press of the 'BOOT' button has been detected, reset the BCD counter.
	; But first stop timer 2 and reset the milli-seconds counter, to resync everything.

;	clr TR2                 ; Stop timer 2
;	clr a
;	mov Count1ms+0, a
;	mov Count1ms+1, a

	; Now clear the BCD counter
;	mov BCD_counter_s, a
;		mov BCD_counter_s+1, a
;	mov BCD_counter_min, a
 ;   mov BCD_counter_hour,a
  ;  mov BCD_counter_day,a   
	;mov BCD_counter_s1, a
	;mov BCD_counter_s1+1, a
	;mov BCD_counter_min1, a
    ;mov BCD_counter_hour1,a    
;    mov BCD_counter_day1,a  
 ;  	mov BCD_counter_s2,a
  ; 	mov BCD_counter_s2+1,a
  	;mov	soak_temp,a
;  	mov soak_temp+1,a
;	mov reflow_temp,a
;	mov reflow_temp+1,a
;	setb TR2                ; Start timer 2
;		sjmp loop_b             ; Display the new value
loop_a:
	jb half_seconds_flag, loop_b
	ljmp loop
loop_b:
    clr half_seconds_flag ; We clear this flag in the main loop, but it is set in the ISR for timer 2

 ;Display_BCD(BCD+0) ; This macro is also in 'LCD_4bit.inc'
    clr CE_ADC
    mov R0, #00000001B ; Start bit:1
    lcall DO_SPI_G
    mov R0, #10010000B ; Single ended, read channel 0
    lcall DO_SPI_G
    mov a, R1 ; R1 contains bits 8 and 9
    anl a, #00000011B ; We need only the two least significant bits
    mov Result+1, a ; Save result high.
    mov R0, #55H ; It doesn't matter what we transmit...
    lcall DO_SPI_G
    mov Result, R1 ; R1 contains bits 0 to 7. Save result low.
    setb CE_ADC
    lcall Display_wire_temperature

clr CE_ADC
    mov R0, #00000001B ; Start bit:1
    lcall DO_SPI_G
    mov R0, #10000000B ; Single ended, read channel 0
    lcall DO_SPI_G
    mov a, R1 ; R1 contains bits 8 and 9
    anl a, #00000011B ; We need only the two least significant bits
    mov Room_temperature+1, a ; Save result high.
    mov R0, #55H ; It doesn't matter what we transmit...
    lcall DO_SPI_G
    mov Room_temperature, R1 ; R1 contains bits 0 to 7. Save result low.
    setb CE_ADC
    lcall Display_room_temperature
    ;Set_Cursor(2, 10)     ; the place in the LCD where we want the BCD counter value
   
  
    Set_Cursor(2, 1)
	Send_Constant_String(#tempabc)
	mov dptr, #HEX_7SEG
	
	
	mov a, temperature_001

	anl a, #0x0f
	movc a, @a+dptr
	mov disp1, a

	swap a
	mov a,temperature_010
	anl a, #0x0f
	movc a, @a+dptr
	mov disp2, a
	
	mov a, temperature_100
	anl a, #0x0f
	movc a, @a+dptr
	mov disp3, a
	Set_Cursor(1, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(BCD_counter_s) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(1, 12) 
	Display_BCD(BCD_counter_s+1)
	;mov a,BCD_counter_s
	Set_Cursor(1, 1)
	Send_Constant_String(#time)
	
	Set_Cursor(2, 6)  
    Display_BCD(BCD+1) ; This macro is also in 'LCD_4bit.inc'
    Display_BCD(BCD+0) ; This macro is also in 'LCD_4bit.inc'
	
	jb stop, bloop
	Wait_Milli_Seconds(#100)
	jb stop, bloop	; Wait for the button to be released
lbw1: jnb stop, lbw1
	lcall stoppp

stoppp:  
	mov BCD_counter_s, a
	jb stop, stoppp
	Wait_Milli_Seconds(#100)
	jb stop, stoppp	; Wait for the button to be released
lbw11: jnb stop, lbw11
	lcall bloop

bloop:	
    ljmp loop
  
presseds1:
    mov a, BCD_counter_s1
	cjne a, #0x95, aft1 
	mov a, #0x00
	mov BCD_counter_s1,a
	mov a,BCD_counter_s1+1
	add a, #0x01
   	da a
	mov BCD_counter_s1+1, a
	ret
aft1:	
	
	cjne a, #0x96, aft2 
	mov a, #0x01
	mov BCD_counter_s1,a
	mov a,BCD_counter_s1+1
	add a, #0x01
   	da a
	mov BCD_counter_s1+1, a
	ret

aft2:
	cjne a, #0x97, aft3 
	mov a, #0x02
	mov BCD_counter_s1,a
	mov a,BCD_counter_s1+1
	add a, #0x01
   	da a
	mov BCD_counter_s1+1, a
	ret
	
aft3:
	cjne a, #0x98, aft4 
	mov a, #0x03
	mov BCD_counter_s1,a
	mov a,BCD_counter_s1+1
	add a, #0x01
   	da a
	mov BCD_counter_s1+1, a
	ret

aft4:
	cjne a, #0x99, aft5 
	mov a, #0x04
	mov BCD_counter_s1,a
	mov a,BCD_counter_s1+1
	add a, #0x01
   	da a
	mov BCD_counter_s1+1, a
	ret

aft5:
	add a, #0x05
	da a
	mov BCD_counter_s1, a
	ret	



		    
presseds2:
       mov a, BCD_counter_s2
	;add a, #0x05
	cjne a, #0x95, aft11 
	mov a, #0x00
	mov BCD_counter_s2,a
	mov a,BCD_counter_s2+1
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a
	ret
aft11:	
	
	cjne a, #0x96, aft12 
	mov a, #0x01
	mov BCD_counter_s2,a
	mov a,BCD_counter_s2+1
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a
	ret

aft12:
	cjne a, #0x97, aft13 
	mov a, #0x02
	mov BCD_counter_s2,a
	mov a,BCD_counter_s2+1
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a
	ret
	
aft13:
	cjne a, #0x98, aft14 
	mov a, #0x03
	mov BCD_counter_s2,a
	mov a,BCD_counter_s2+1
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a
	ret

aft14:
	cjne a, #0x99, aft15 
	mov a, #0x04
	mov BCD_counter_s2,a
	mov a,BCD_counter_s2+1
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a
	ret

aft15:
	add a, #0x05
	da a
	mov BCD_counter_s2, a
	ret	
	
soaktemp:
       mov a, soak_temp
	;add a, #0x05
	cjne a, #0x95, aft111 
	mov a, #0x00
	mov soak_temp,a
	mov a,soak_temp+1
	add a, #0x01
   	da a
	mov soak_temp+1, a
	ret
aft111:	
	
	cjne a, #0x96, aft112 
	mov a, #0x01
	mov soak_temp,a
	mov a,soak_temp+1
	add a, #0x01
   	da a
	mov soak_temp+1, a
	ret

aft112:
	cjne a, #0x97, aft113 
	mov a, #0x02
	mov soak_temp,a
	mov a,soak_temp+1
	add a, #0x01
   	da a
	mov soak_temp+1, a
	ret
	
aft113:
	cjne a, #0x98, aft114 
	mov a, #0x03
	mov soak_temp,a
	mov a,soak_temp+1
	add a, #0x01
   	da a
	mov soak_temp+1, a
	ret

aft114:
	cjne a, #0x99, aft115 
	mov a, #0x04
	mov soak_temp,a
	mov a,soak_temp+1
	add a, #0x01
   	da a
	mov soak_temp+1, a
	ret

aft115:
	add a, #0x05
	da a
	mov soak_temp, a
	ret	
	
	
reflowtemp:	
	       mov a, reflow_temp
	;add a, #0x05
	cjne a, #0x95, aft1111 
	mov a, #0x00
	mov reflow_temp,a
	mov a,reflow_temp+1
	add a, #0x01
   	da a
	mov reflow_temp+1, a
	ret
aft1111:	
	
	cjne a, #0x96, aft1112 
	mov a, #0x01
	mov reflow_temp,a
	mov a,reflow_temp+1
	add a, #0x01
   	da a
	mov reflow_temp+1, a
	ret

aft1112:
	cjne a, #0x97, aft1113 
	mov a, #0x02
	mov reflow_temp,a
	mov a,reflow_temp+1
	add a, #0x01
   	da a
	mov reflow_temp+1, a
	ret
	
aft1113:
	cjne a, #0x98, aft1114 
	mov a, #0x03
	mov reflow_temp,a
	mov a,reflow_temp+1
	add a, #0x01
   	da a
	mov reflow_temp+1, a
	ret

aft1114:
	cjne a, #0x99, aft1115 
	mov a, #0x04
	mov reflow_temp,a
	mov a,reflow_temp+1
	add a, #0x01
   	da a
	mov reflow_temp+1, a
	ret

aft1115:
	add a, #0x05
	da a
	mov reflow_temp, a
	ret	
	
END
	