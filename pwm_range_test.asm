$MODLP51
org 0000H
   ljmp MainProgram

FT93C66_CE   EQU P2.4  ; WARNING: shared with MCP3008!
FT93C66_MOSI EQU P2.1 
FT93C66_MISO EQU P2.2
FT93C66_SCLK EQU P2.3 
START_STOP   EQU P3.6
INC_STATE	 EQU P3.0
$include(FT93C66.inc)

CLK  EQU 22118400
BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))

Stage0:  db 'Stage0', 0
Stage1:  db 'Stage1', 0
Stage2:  db 'Stage2', 0
Stage3:  db 'Stage3', 0
Stage4:  db 'Stage4', 0
Stage5:  db 'Stage5', 0

dseg at 0x30
Count1ms:    	 ds 2 ; Used to determine when half second has passed
sec_count:   	 ds 1 ; The BCD counter incrememted in the ISR and displayed in the main loop

temp_soak_input: ds 1
time_soak_input: ds 1
temp_refl_input: ds 1
time_refl_input: ds 1


temp_soak: ds 1
time_soak: ds 1
temp_refl: ds 1
time_refl: ds 1

temp_refl_h: ds 1
temp_refl_l: ds 1

pwm:       ds 1
state:     ds 1
temp:      ds 1


bseg
cooldown_flag: dbit 1


cseg
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5

OVEN equ P2.5
$NOLIST
$include(LCD_4bit.inc) 
$LIST

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
	; Enable the timer and interrupts
    setb ET2  ; Enable timer 2 interrupt
    setb TR2  ; Enable timer 2
	ret

;---------------------------------;
; ISR for timer 2 (counts seconds);
;---------------------------------;
Timer2_ISR:
	clr TF2  ; Timer 2 doesn't clear TF2 automatically. Do it in ISR
	
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
	clr a
	mov Count1ms+0, a
	mov Count1ms+1, a
	lcall count_sec
Timer2_ISR_done:
	pop psw
	pop acc
	reti
count_sec:
	mov a, sec_count
	add a, #0x01
	da a ; Decimal adjust instruction.  Check datasheet for more details!
	mov sec_count, a
count_sec_done:
	ret
	
	
; this keeps temp in range of +/- 20 within temp_refl
Init_temp_refl_range:
	mov a, temp_refl
	clr c
	subb a, #20	
	da a
	mov temp_refl_l, a
	add a, #40
	da a
	mov temp_refl_h, a
	ret	

; Configure the serial port and baud rate
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

Save_Configuration:
lcall FT93C66_Write_Enable
mov DPTR, #0
; Save variables
mov a, temp_soak_input
lcall FT93C66_Write
inc DPTR
mov a, time_soak_input
lcall FT93C66_Write
inc DPTR
mov a, temp_refl_input
lcall FT93C66_Write
inc DPTR
mov a, time_refl_input
lcall FT93C66_Write
inc DPTR
mov a, #0x55 ; First key value
lcall FT93C66_Write
inc DPTR
mov a, #0xaa ; Second key value
lcall FT93C66_Write
lcall FT93C66_Write_Disable
ret

Load_Configuration:
mov dptr, #0x0004 ;First key value location. Must be 0x55
lcall FT93C66_Read
cjne a, #0x55, Load_Defaults
inc dptr ; Second key value location. Must be 0xaa
lcall FT93C66_Read
cjne a, #0xaa, Load_Defaults
; Keys are good. Load saved values.
mov dptr, #0x0000
lcall FT93C66_Read
mov temp_soak, a
inc dptr
lcall FT93C66_Read
mov time_soak, a
inc dptr
lcall FT93C66_Read
mov temp_refl, a
inc dptr
lcall FT93C66_Read
mov time_refl, a
ret

Load_Defaults: ; Load defaults if keys are incorrect
mov temp_soak, #150
mov time_soak, #45
mov temp_refl, #225
mov time_refl, #30
ret

state0:			;initial/off state
mov a, state
cjne a, #0, state1
clr TR2
mov pwm, #0
mov sec_count, #0	
Set_Cursor(2, 1)
Send_Constant_String(#Stage0)
Wait_Milli_Seconds(#250)	; if start_stop is pressed for less than 250ms it will stay in state0, otherwise restart and jump back to state1
jb START_STOP, state0_done  ;if the start button is not pressed, it stays in state0
jnb START_STOP, $ ; Wait for key release
mov state, #1
state0_done:
ljmp forever

abort:
mov state, #0
clr TR2
ljmp forever

increment_state:
mov a, state
cjne a, #5, abort
add a, #1
da a
mov state, a
increment_state_done:
ret

state1:			;full power state
cjne a, #1, state2
mov pwm, #100
Set_Cursor(2, 1)
Send_Constant_String(#Stage1)
jnb START_STOP, abort  ;if the start_stop is pressed in any other state, it will return to state0
jnb INC_STATE, increment_state		;if the INC_STATE button is pressed we jump to the next state
state1_done:
ljmp forever

state2:			;zero power state
cjne a, #2, state3
mov pwm, #0
Set_Cursor(2, 1)
Send_Constant_String(#Stage2)
jnb START_STOP, abort  ;if the start_stop is pressed in any other state, it will return to state0
jnb INC_STATE, increment_state		;if the INC_STATE button is pressed we jump to the next state
state2_done:
ljmp forever

state3:			;20% power state
cjne a, #3, state4
mov pwm, #20
Set_Cursor(2, 1)
Send_Constant_String(#Stage3)
jnb START_STOP, stop  ;if the start_stop is pressed in any other state, it will return to state0
jnb INC_STATE, increment_state_redirect		;if the INC_STATE button is pressed we jump to the next state
state3_done:
ljmp forever

increment_state_redirect:
	ljmp increment_state

stop:
	ljmp abort

state4:			;timed off state
cjne a, #4, state5
mov pwm, #0
setb TR2
Set_Cursor(2, 1)
Send_Constant_String(#Stage4)
jnb START_STOP, stop
jnb INC_STATE, increment_state_redirect		;if the INC_STATE button is pressed we jump to the next state
mov a, time_refl
clr c
subb a, sec_count		;time_refl and sec are compared, if time_refl>=sec, it will remain in state4, else go to state5
jnc state4_done
mov state, #5
state4_done:
ljmp forever

state5:			;temperature state
cjne a, #5, state5_done ;go back to forever loop
mov pwm, #0
mov a, #60
Set_Cursor(2, 1)
Send_Constant_String(#Stage5)
jnb START_STOP, stop
jnb INC_STATE, increment_state_redirect	;if the INC_STATE button is pressed we jump to the next state, in this case to state0
clr c
subb a, temp
jc state5_done
mov state, #0
state5_done:
ljmp forever

MainProgram:
	mov state, #0  ;initialize the state to state0
    mov SP, #7FH ; Set the stack pointer to the beginning of idata
    clr FT93C66_CE  ;the EEPROM is activated when the respective functions are called
    lcall FT93C66_INIT_SPI
    
    lcall InitSerialPort
	lcall Init_temp_refl_range
    lcall LCD_4BIT
	lcall Timer2_Init
	setb EA   ; Enable Global interrupts
    
forever:    
    lcall Save_Configuration
    lcall Load_Configuration
    mov a, pwm
check_pwm100:
    cjne a, #100, check_pwm20
	setb OVEN
	ljmp done
check_pwm20:
    cjne a, #20, check_pwm0
	jb cooldown_flag, cooldown
heatup:		;this checks for upper range of temp_refl
	setb OVEN
	clr cooldown_flag
	mov a, temp_refl_h
	clr c
	subb a, temp		
	jnc done		;if temp_refl_h is more than or equal to temp, it will restart, if not it will continue
cooldown:	;this checks for lower range of temp_refl
	clr OVEN
	setb cooldown_flag
	mov a, temp
	clr c
	subb a, temp_refl_l
	jnc done		;if temp is more than or equal to temp_refl_l, it will restart, if not it will continue
	sjmp heatup
check_pwm0:
    cjne a,#0, done
	clr OVEN
	ljmp done
done:
	ljmp state0
    ;ljmp forever 	;there is no need to include this as at completion of any state, pc jumps to start of forever loop
END