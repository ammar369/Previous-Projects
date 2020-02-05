$NOLIST
$MODLP51
$LIST

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

;pins used
pinmode		  equ p2.5
pins  		  equ P2.6			;uses P0.3
CE_ADC  EQU P2.0
MY_MOSI EQU P2.1
MY_MISO EQU P2.2
MY_SCLK EQU P2.3
SEGA equ P0.3					;also uses P0.3
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
BOOT_BUTTON		equ P4.5
OVEN equ P1.0
FT93C66_CE   EQU P2.0  ; WARNING: shared with MCP3008!
FT93C66_MOSI EQU P2.1 
FT93C66_MISO EQU P2.2
FT93C66_SCLK EQU P2.3 
START_STOP   EQU P3.6
SOUND_OUT    EQU P3.7

; Reset vector
org 0x0000
    ljmp main
; External interrupt 0 vector (not used in this code)
org 0x0003
	reti
	
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

; Variables used
dseg at 0x30	
Count1ms:     ds 2		;for checking when a second has passed
BCD_counter_s:  ds 2 	;translates to second counter
BCD_counter_s1:  ds 2 	;translates to S time
BCD_counter_s2:  ds 2 	;translates to R time
soak_temp: ds 2
reflow_temp: ds 2
pwm:       ds 1
state:     ds 1
temp:      ds 1
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
stage:  ds 1
wiretemp: ds 2
sec:    ds 2

bseg	;flags used
seconds_flag: dbit 1 ; Set to one in the ISR every time 1 s had passed
mode: dbit 2	;flag not being used
mf: dbit 1		;flag not being used
flag: dbit 1	;flag not being used

cseg	; These 'equ' must match the wiring between the microcontroller and the LCD!
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5

$NOLIST
$include(math32.inc)
$include(LCD_4bit.inc)
$include(FT93C66.inc)
$LIST

;Strings used
weekday:  	  db 'S time:',0
weekend:  	  db 'R time:',0
Soak_temp1:   db 'S temp:',0
Reflow_temp1: db 'R temp:',0
coma:    	  db ':',0
space1:  	  db '',0
tempabc: 	  db 'temp:           ',0
time:  	 	  db 'time:',0
Stage_0:  	  db 'Stage0', 0
Stage_1:  	  db 'Stage1', 0
Stage_2:  	  db 'Stage2', 0
Stage_3:  	  db 'Stage3', 0
Stage_4:  	  db 'Stage4', 0
Stage_5:  	  db 'Stage5', 0
stage_6:	  db 'Stage6', 0
;functions used
;----------------------------------------;
putchar:
    jnb TI, putchar
    clr TI
    mov SBUF, a
    ret
;----------------------------------------;
Send_BCD mac
	push ar0
	mov r0, %0
	lcall ?Send_BCD
	pop ar0
endmac
;----------------------------------------;
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
	
Average_ADC_Channel MAC
mov b, #%0
lcall ?Average_ADC_Channel
ENDMAC

?Average_ADC_Channel:
Load_x(0)
mov R5, #100
Sum_loop0:
lcall Read_ADC_Channel
mov y+3, #0
mov y+2, #0
mov y+1, R7
mov y+0, R6
lcall add32
djnz R5, Sum_loop0
load_y(100)
lcall div32
ret

;----------------------------------------;
SendString:
    clr A
    movc A, @A+DPTR
    jz SendStringDone
    lcall putchar
    inc DPTR
    sjmp SendString
SendStringDone:
    ret
;----------------------------------------;
InitSerialPort:
    mov R1, #222	;wait otherwise displays gibberish
    mov R0, #166
    djnz R0, $   ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, $-4 ; 22.51519us*222=4.998ms
	orl	PCON,#0x80    ; Now we can proceed with the configuration
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
;----------------------------------------;
Save_Configuration:
	lcall FT93C66_Write_Enable
	mov DPTR, #0
	; Save variables
	mov a, soak_temp+0
	lcall FT93C66_Write
	inc DPTR
	mov a, soak_temp+1
	lcall FT93C66_Write
	inc DPTR
	mov a, BCD_counter_s1
	lcall FT93C66_Write
	inc DPTR
	mov a, reflow_temp+0
	lcall FT93C66_Write
	inc DPTR
	mov a, reflow_temp+1
	lcall FT93C66_Write
	inc DPTR
	mov a, BCD_counter_s2
	lcall FT93C66_Write
	inc DPTR
	mov a, #0x55 ; First key value
	lcall FT93C66_Write
	inc DPTR
	mov a, #0xaa ; Second key value
	lcall FT93C66_Write
	lcall FT93C66_Write_Disable
	ret
;----------------------------------------;
Load_Configuration:
	mov dptr, #0x0006 ;First key value location. Must be 0x55
	lcall FT93C66_Read
	cjne a, #0x55, Load_Defaults
	inc dptr ; Second key value location. Must be 0xaa
	lcall FT93C66_Read
	cjne a, #0xaa, Load_Defaults
	; Keys are good. Load saved values.
	mov dptr, #0x0000
	lcall FT93C66_Read
	mov soak_temp+0, a
	inc dptr
	lcall FT93C66_Read
	mov soak_temp+1, a
	inc dptr
	lcall FT93C66_Read
	mov BCD_counter_s1, a
	inc dptr
	lcall FT93C66_Read
	mov reflow_temp+0, a
	inc dptr  
	lcall FT93C66_Read
	mov reflow_temp+1, a
	inc dptr
	lcall FT93C66_Read
	mov BCD_counter_s2, a
	mov BCD_counter_s1+1, #0x00
	mov BCD_counter_s2+1, #0x00
	ret
;----------------------------------------;	
Load_Defaults: ; Load defaults if keys are incorrect
	mov soak_temp+0, #0x40
     mov soak_temp+1, #0x01
     mov BCD_counter_s1+0, #0x50
     mov BCD_counter_s1+1, #0x00
     mov reflow_temp+0, #0x20
	mov reflow_temp+1, #0x02
     mov BCD_counter_s2+0, #0x20
     mov BCD_counter_s2+1, #0x00
	ret
;----------------------------------------;
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
;----------------------------------------;
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
;----------------------------------------;
Display_wire_temperature:
   mov x+0,Result+0
   mov x+1,Result+1
   mov x+2,#0
   mov x+3,#0
   LOAD_Y(189163)
   LCALL MUL32
   LOAD_Y(426146)
   LCALL DIV32
   lcall add320
   lcall HEX2bcd
   mov wiretemp, BCD
   mov wiretemp+1, BCD+1
   Send_BCD(BCD+1)
   Send_BCD(BCD+0)   
   MOV a,#'\n'
   lcall putchar
   MOV a,#'\r'
   lcall putchar
   Set_Cursor(2, 6)
   Display_BCD(BCD+1) 
   Display_BCD(BCD+0) 
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
;----------------------------------------;
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
;	Send_BCD(BCD+0)
;	mov a, #'\n'
;	lcall putchar
;	mov a, #'\r'
;	lcall putchar
    clr a
	Set_Cursor(2,11)
	Display_BCD(BCD+0)
	ret
;----------------------------------------;
load_segments:	;to set acc to display number to led
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
	mov RCAP2H, #high(TIMER2_RELOAD)	; Set the reload value
	mov RCAP2L, #low(TIMER2_RELOAD)
	clr a		; Init One millisecond interrupt counter
	mov Count1ms+0, a
	mov Count1ms+1, a
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret
;---------------------------------;
; ISR for timer 2                 ;
;---------------------------------;
Timer2_ISR:
	clr TF2  	; Timer 2 doesn't clear TF2 automatically. Do it in ISR
	push acc	; The two registers used in the ISR must be saved in the stack
	push psw
;------------STATEMACHINE(LED)--------------;
	setb CA1	;turns all displays off
	setb CA2
	setb CA3
	mov a, state
state0:
	cjne a, #0, state1
	mov a, disp1	;disp1 holds the value we are to send to be displayed in 1
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
	; Increment the 16-bit one milli second counter
	inc Count1ms+0    ; Increment the low 8-bits first
	mov a, Count1ms+0 ; If the low 8-bits overflow, then increment high 8-bits
	jnz Inc_Done
	inc Count1ms+1
;----------------------------------------------;
Inc_Done:
	mov a, Count1ms+0
	cjne a, #low(1000), Timer2_ISR_done
	mov a, Count1ms+1
	cjne a, #high(1000), Timer2_ISR_done
	setb seconds_flag
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	mov a, BCD_counter_s	; Increment the BCD_counter_s, this happens every 1s
	cjne a, #0x99, abc
	mov a,#0x00
	mov  BCD_counter_s,a
	mov a,BCD_counter_s+1	
	add a, #0x01
	da a
	mov BCD_counter_s+1, a
	ljmp runningtime
	abc:
		add a, #0x01
		da a
		mov BCD_counter_s, a
	
runningtime:	
	mov a, sec
	cjne a, #0x99,abcd
	mov a,#0x00
	mov sec,a
	mov a,sec+1
	add a, #0x01
	da a
	mov sec+1,a
	ljmp  Timer2_ISR_done
	
	abcd:
	add a, #0x01
	da a
	mov sec, a		
Timer2_ISR_done:
	pop psw
	pop acc
	reti
;------------------------------------;
HEX_7SEG: DB 0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
;---------------------------------;
;          Main program           ;
;---------------------------------;
main:
	; Initialization
    mov SP, #0x7F
    lcall Timer0_Init
    lcall Timer2_Init
    lcall LCD_4BIT
	lcall InitSerialPort
    lcall INIT_SPI
	clr mode	;how is this flag used?
	clr FT93C66_CE  ;the EEPROM is activated when the respective functions are called
	lcall FT93C66_INIT_SPI
    mov P0M0, #0
    mov P0M1, #0
    mov P1M0, #0
    mov P1M1, #0
    mov AUXR, #00010001B  ;see page 19 of data sheet
    setb EA   ; Enable Global interrupts
    setb P2.6 ;pins
    setb P3.6 ;stop
    setb P2.2 ;MY_MISO
    setb P2.0 ;CE_ADC
    setb P2.5 ;pinmode
    setb seconds_flag
	mov stage, #0x00  ;initialize the state to stage0
    mov BCD_counter_s, #0x00
     mov BCD_counter_s+1, #0x00
	mov temp, #0x20		;temp initialized to 20
	mov state, #0
	mov sec, #0x00
	mov sec+1,#0x00
;--------------------------------------------------------------------------;
loop:		; After initialization the program stays in this 'forever' loop
	lcall Load_Configuration
	debounce_pinmode0: ;debouncing pinmode, if pressed go to mode1, else stay in mode0
	jnb pinmode,n1 ;if pinmode is pressed it goes to n1
	ljmp mode0 ;else goes to mode 0
	n1: Wait_Milli_Seconds(#100)
		jnb pinmode,n2  ;if pinmode is pressed, go to n2
		ljmp mode0		;stay in same mode if pinmode not pressed, else go to mode1
	n2:
	lm1: jnb pinmode, lm1 ;if pinmode is pressed, go to lm1, waiting for button to be released

;------MODE1------;
mode1:
debounce_pins1:		;debounce pins, if pressed go to presseds1(743)
	jb pins, not_pressed11		
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed11	
	lb11: jnb pins, lb11		
		lcall presseds1
not_pressed11:		;displays BCD_counter_s1 and S time
	Set_Cursor(2, 14)     
	Display_BCD(BCD_counter_s1) 
	Set_Cursor(2, 12)  
	Display_BCD(BCD_counter_s1+1)
	Set_Cursor(2, 1)    
    Send_Constant_String(#weekday)  	;displays 'S time'
debounce_pinmode1: ;debouncing pinmode, if pressed go to mode2, else stay in mode1
	jnb pinmode,nm1
	ljmp mode1
	nm1:Wait_Milli_Seconds(#100)
		jnb pinmode,nm2
		ljmp mode1
	nm2:
	lm2: jnb pinmode, lm2
	lcall Save_Configuration
;------MODE2------;
mode2:
debounce_pins2:		;debounce pins, if pressed go to presseds2(743)
	jb pins, not_pressed12
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed12
	lb12: jnb pins, lb12
		lcall presseds2
not_pressed12:	;displays BCD_counter_s2 and R time
	Set_Cursor(2, 14)     
	Display_BCD(BCD_counter_s2)
	Set_Cursor(2, 12)     
	Display_BCD(BCD_counter_s2+1) 
	Set_Cursor(2, 1)    
    Send_Constant_String(#weekend)	;displays 'R time'
debounce_pinmode2: ;debouncing pinmode, if pressed go to mode3, else stay in mode2
	jnb pinmode,nm4
	ljmp mode2
	nm4:Wait_Milli_Seconds(#100)
		jnb pinmode,nm3
		ljmp mode2
	nm3:
	lm3: jnb pinmode, lm3
	lcall Save_Configuration		
;------MODE3------;
mode3:
debounce_pins3:		;debounce pins, if pressed go to soaktemp(743)
	jb pins, not_pressed112
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed112	
	lb112: jnb pins, lb112 
		lcall soaktemp
not_pressed112:		;displays soak_temp and S temp
	Set_Cursor(2, 14)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(soak_temp) ; This macro is also in 'LCD_4bit.inc'
	Set_Cursor(2, 12)     ; the place in the LCD where we want the BCD counter value
	Display_BCD(soak_temp+1) 
	Set_Cursor(2, 1)    
    Send_Constant_String(#Soak_temp1) ; displays 'S temp'
debounce_pinmode3: ;debouncing pinmode, if pressed go to mode4, else stay in mode3
	jnb pinmode,nm14
	ljmp mode3
	nm14:	Wait_Milli_Seconds(#100)
		jnb pinmode,nm13
		ljmp mode3	;stay in same mode if pinmode not pressed, else go to next mode
	nm13:
	lm13: jnb pinmode, lm13	
	lcall Save_Configuration
;------MODE4------;
mode4:
debounce_pins4:		;debounce pins, if pressed go to reflowtemp to increment
	jb pins, not_pressed1112
	Wait_Milli_Seconds(#100)
	jb pins, not_pressed1112	
	lb1112: jnb pins, lb1112	
		lcall reflowtemp		
not_pressed1112:		;displays reflow_temp and R temp
	Set_Cursor(2, 14)  
	Display_BCD(reflow_temp)
	Set_Cursor(2, 12)     
	Display_BCD(reflow_temp+1) 
	Set_Cursor(2, 1)    
    Send_Constant_String(#Reflow_temp1)	;displays 'R temp'
debounce_pinmode4: ;debouncing pinmode, if pressed go to mode0, else stay in mode4
	jnb pinmode,nm114
	ljmp mode4
	nm114:	Wait_Milli_Seconds(#100)
		jnb pinmode,nm113
		ljmp mode4	; Wait for the button to be released
	nm113:
	lm113: jnb pinmode, lm113	
	lcall Save_Configuration
;------MODE0------;
mode0:
	lcall Load_Configuration
;-------------------------------------------------------------------;
next:
loop_a:
	jb seconds_flag, loop_b
	ljmp loop
loop_b:		;process done after every 1s
    clr seconds_flag
;SPI bitbang for Display_wire_temperature
	Average_ADC_Channel(0)
    lcall Display_wire_temperature	;reads ADC channel and displays wire temp

;SPI bitbang for Display_room_temperature
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
    lcall Display_room_temperature	;reads ADC channel and displays room temp
	
;code for LED Display of temp
	mov dptr, #HEX_7SEG
	mov a, temperature_001
	anl a, #0x0f		
	movc a, @a+dptr		
	mov disp1, a
	;mov a, temperature_001
	swap a	;unnecessary
	mov a,temperature_010
	anl a, #0x0f
	movc a, @a+dptr
	mov disp2, a
	mov a, temperature_100
	anl a, #0x0f
	movc a, @a+dptr
	mov disp3, a

    Set_Cursor(2, 1)				;displays temp: template
	Send_Constant_String(#tempabc)
	Set_Cursor(1, 7)
	Display_BCD(sec+1)
	Set_Cursor(1, 9)
	Display_BCD(sec) 
	Set_Cursor(1, 14)  				;displays BCD_counter_s  
	Display_BCD(BCD_counter_s) 
	Set_Cursor(1, 12) 
	Display_BCD(BCD_counter_s+1)
	Set_Cursor(1, 1)
	Send_Constant_String(#time)		;displays 'time:'
	Set_Cursor(2, 14)				;displays BCD  
    Display_BCD(BCD+0)

    

check_pwm100:
	mov a, pwm
    cjne a, #100, check_pwm20
	setb OVEN
	ljmp done
check_pwm20:
    cjne a, #20, check_pwm0
	setb OVEN
	Wait_Milli_Seconds(#1)
	clr OVEN
	Wait_Milli_Seconds(#4)
	ljmp done
check_pwm0:
    cjne a,#0, done
	clr OVEN
	ljmp done
done:
	ljmp stage0
;---------------STATEMACHINE(PWM)------------------;
stage0:
	mov a, stage
	cjne a, #0, stage1
	mov a,#0x00
	mov BCD_counter_s, a
	mov sec, a
	mov sec+1,a
	mov pwm, #0
	Set_Cursor(2, 10)
	Send_Constant_String(#Stage_0)
	Wait_Milli_Seconds(#250)	; if start_stop is pressed for less than 250ms it will stay in state0, otherwise restart and jump back to state1
	jb START_STOP, stage0_done  ;if the start button is not pressed, it stays in state0
	jnb START_STOP, $ ; Wait for key release
	mov stage, #1
	setb ET0
	lcall waitsec
	clr ET0
	ljmp loop
	stage0_done:
	ljmp loop
abort:
	mov stage, #0
	ljmp loop
stage1:
	mov a, stage
	cjne a, #1, stage2
	mov pwm, #100
		;the sec_count is set to 0 and timer is off in state 1. The timer will start as soon as we move to state 2
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_1)
	mov a,  BCD_counter_s
	cjne a,#0x60, stage11
	mov a, wiretemp+1
	cjne a, #0x00, stage11
	mov a, wiretemp
	clr c
	subb a, #0x50
	jc termination
stage11:	
	jnb START_STOP, abort  ;if the start_stop is pressed in any other state, it will return to state0
	mov a, wiretemp+1
	cjne a, #01, stage1_done
	mov a, soak_temp
	clr c
	subb a, wiretemp
	jnc stage1_done
	mov a, #0x02
	mov stage, a
	mov a,#0x00
	mov BCD_counter_s, a
	mov BCD_counter_s+1, a
	setb ET0
	lcall waitsec
	clr ET0
	stage1_done:
	ljmp loop
termination:
	mov stage, #0x00
	setb ET0
	lcall waitsec
	clr ET0
	ljmp loop
stage2:
	mov a, stage
	cjne a, #2, stage3
	mov pwm, #20
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_2)
	jnb START_STOP, stop1		;checking if stop button is pressed
	mov a, BCD_counter_s1
	clr c
	subb a, BCD_counter_s		;time_soak and sec are compared, if time_soak>=sec, it will remain in state2, else go to state3
	jnc stage2_done
	mov a,#0x00
	mov BCD_counter_s, a
	mov BCD_counter_s+1, a
	mov stage, #3
	setb ET0
	lcall waitsec
	clr ET0
	stage2_done:
	ljmp loop
stage3:
	mov a,stage
	cjne a, #3, stage4
	mov pwm, #100
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_3)
	jnb START_STOP, stop1
	mov a, wiretemp+1
	cjne a, #02, stage3_done
	mov a, reflow_temp
	clr c
	subb a, wiretemp
	jnc stage3_done
	mov a,#0x00
	mov BCD_counter_s, a
	mov BCD_counter_s+1, a
	mov a, #0x04
	mov stage, a
	setb ET0
	lcall waitsec
	clr ET0
stage3_done:
	ljmp loop
stop1:
	ljmp abort
stage4:
	mov a, stage
	cjne a, #4, stage5
	mov pwm, #20
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_4)
	jnb START_STOP, stop1
	mov a, BCD_counter_s2
	clr c
	subb a, BCD_counter_s		;time_refl and sec are compared, if time_refl>=sec, it will remain in state4, else go to state5
	jnc stage4_done
	mov a,#0x00
	mov BCD_counter_s, a
	mov BCD_counter_s+1, a
	mov stage, #5
	setb ET0
	lcall waitsec
	lcall waitsec
	lcall waitsec
	clr ET0
	stage4_done:
	ljmp loop
stage5:
	mov a, stage
	cjne a, #5, stage6 ;go back to forever loop
	mov pwm, #0
	mov a, wiretemp
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_5)
	jnb START_STOP, stop1
	clr c
	mov a, wiretemp+1
	cjne a, #0x00, stage5_done
	mov a, wiretemp
	subb  a, #0x80
	jnc stage5_done
	mov a, #0x06
	mov stage, a
	setb ET0
	lcall waitsec
	clr ET0
	lcall waitsec
	
	setb ET0
	lcall waitsec
	clr ET0
	lcall waitsec
	setb ET0
	lcall waitsec
	clr ET0
	lcall waitsec
	setb ET0
	lcall waitsec
	clr ET0
	lcall waitsec
	setb ET0
	lcall waitsec
	clr ET0
	lcall waitsec
	setb ET0
	lcall waitsec
	clr ET0
	
	stage5_done:
	ljmp loop
stage6:
	mov a,stage
	cjne a, #6, stage6_done
	Set_Cursor(2, 1)
	Send_Constant_String(#Stage_6)
	jnb START_STOP, stop11
	setb ET0
	mov a, wiretemp
	subb  a, #0x40
	jnc stage6_done
	mov a,#0x00
	mov stage, a
	clr ET0
stage6_done:
	ljmp loop
stop11:
	ljmp abort
;-------------------------------------------;
;------------------------------------------------------------------------------;
;----------------------------------END OF LOOP---------------------------------;
;------------------------------------------------------------------------------;


Read_ADC_Channel:
    clr CE_ADC
    mov R0, #00000001B ; Start bit:1
    lcall DO_SPI_G
    mov R0, #10010000B ; Single ended, read channel 0
    lcall DO_SPI_G
    mov a, R1 ; R1 contains bits 8 and 9
    anl a, #00000011B ; We need only the two least significant bits
    mov Result+1, a ; Save result high.
    mov R0, #55H ;It doesn't matter what we transmit...
    lcall DO_SPI_G
    mov Result, R1 ; R1 contains bits 0 to 7. Save result low.
    setb CE_ADC
    ret
  
presseds1:		;adds 5 to BCD_counter_s1 (S time)
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
		
presseds2:		;adds 5 to BCD_counter_s2 (R time)
	mov a, BCD_counter_s2
	cjne a, #0x95, aft11 		;check if  BCD_counter_s2 is 95
	mov a, #0x00
	mov BCD_counter_s2,a		;moves 0 to BCD_counter_s2
	mov a,BCD_counter_s2+1		
	add a, #0x01
   	da a
	mov BCD_counter_s2+1, a		;adds 1 to BCD_counter_s2(high)
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

soaktemp:		;adds 5 to soaktemp
	mov a, soak_temp
	cjne a, #0x95, aft111 		;checks is soak_temp is 95
	mov a, #0x00				;move 0 to a
	mov soak_temp,a				;move 0 to soak_temp
	mov a,soak_temp+1			
	add a, #0x01
   	da a
	mov soak_temp+1, a			;add 1 to soak_temp(high)
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
		mov soak_temp, a			;add 5 to soak_temp
		ret	
		
reflowtemp:		;adds 5 to reflow_temp
	mov a, reflow_temp
	cjne a, #0x95, aft1111		;checks if reflow_temp is 95
	mov a, #0x00				;puts 0 in a
	mov reflow_temp,a			;puts 0 in reflow_temp(low)
	mov a,reflow_temp+1			;puts reflow_temp(high) in a
	add a, #0x01				;adds 1 to a
   	da a
	mov reflow_temp+1, a		;adds 1 to reflow_temp(high)
	ret
	aft1111:	
		cjne a, #0x96, aft1112 		;checks if reflow_temp is 96
		mov a, #0x01				
		mov reflow_temp,a			;puts 1 in reflow_temp
		mov a,reflow_temp+1
		add a, #0x01
		da a
		mov reflow_temp+1, a		;adds 1 to reflow_temp(high)
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
		mov reflow_temp, a			;adds 5 to reflow_temp
		ret	
	waitsec:
	mov r3, #2
La4: mov R2, #89
La3: mov R1, #250
La2: mov R0, #166
La1: djnz R0, La1 ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, La2 ; 22.51519us*250=5.629ms
    djnz R2, La3 ; 5.629ms*89=0.5s (approximately)
    djnz R3, La4 ; 3S
	ret
END

	