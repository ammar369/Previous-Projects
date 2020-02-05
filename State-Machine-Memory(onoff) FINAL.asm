$MODLP51
org 0000H
   ljmp MainProgram

FT93C66_CE   EQU P2.4  ; WARNING: shared with MCP3008!
FT93C66_MOSI EQU P2.1 
FT93C66_MISO EQU P2.2
FT93C66_SCLK EQU P2.3 
START_STOP   EQU P3.6
$include(FT93C66.inc)

CLK  EQU 22118400
BAUD equ 115200
BRG_VAL equ (0x100-(CLK/(16*BAUD)))

Stage0:  db 'Stage0', 0
Stage1:  db 'Stage1', 0
Stage2:  db 'Stage2', 0
Stage3:  db 'Stage3', 0
Stage4:  db 'Stage4', 0
Stage5:  db 'Stage5', 0

dseg at 0x30
temp_soak_input: ds 1
time_soak_input: ds 1
temp_refl_input: ds 1
time_refl_input: ds 1


temp_soak: ds 1
time_soak: ds 1
temp_refl: ds 1
time_refl: ds 1

pwm:       ds 1
state:     ds 1
sec:       ds 1
temp:      ds 1

bseg
LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5
$NOLIST
$include(LCD_4bit.inc) 
$LIST

CSEG

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

state0:
mov a, state
cjne a, #0, state1
mov pwm, #0
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
ljmp forever

state1:
cjne a, #1, state2
mov pwm, #100
mov sec, #0
Set_Cursor(2, 1)
Send_Constant_String(#Stage1)
jnb START_STOP, abort  ;if the start_stop is pressed in any other state, it will return to state0
mov a, temp_soak
clr c
subb a, temp
jnc state1_done
mov state, #2
state1_done:
ljmp forever

state2:
cjne a, #2, state3
mov pwm, #20
Set_Cursor(2, 1)
Send_Constant_String(#Stage2)
jnb START_STOP, jum
mov a, time_soak
clr c
subb a, sec
jnc state2_done
mov state, #3
state2_done:
ljmp forever

state3:
cjne a, #3, state4
mov pwm, #100
mov sec, #0
Set_Cursor(2, 1)
Send_Constant_String(#Stage3)
jnb START_STOP, jum
mov a, temp_refl
clr c
subb a, temp
jnc state3_done
mov state, #4
state3_done:
ljmp forever

jum:
	ljmp abort

state4:
cjne a, #4, state5
mov pwm, #20
Set_Cursor(2, 1)
Send_Constant_String(#Stage4)
jnb START_STOP, jum
mov a, time_refl
clr c
subb a, sec
jnc state4_done
mov state, #5
state4_done:
ljmp forever

state5:
cjne a, #5, state5_done ;go back to forever loop
mov pwm, #0
mov a, #60
Set_Cursor(2, 1)
Send_Constant_String(#Stage5)
jnb START_STOP, jum
clr c
subb a, temp
jc state5_done
mov state, #0
state5_done:
ljmp forever

MainProgram:
	mov state, #0

    mov SP, #7FH ; Set the stack pointer to the begining of idata
    clr FT93C66_CE
    lcall FT93C66_INIT_SPI
    
    lcall InitSerialPort
    lcall LCD_4BIT
    
forever:    
    lcall Save_Configuration
    lcall Load_Configuration
	ljmp state0
	
    ljmp done  

done:    
    sjmp $ ; This is equivalent to 'forever: sjmp forever'
    
END