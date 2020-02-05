$NOLIST
$MODLP51
$LIST

org 0
   ljmp main

TIMER0_RELOAD_L DATA 0xf2
TIMER1_RELOAD_L DATA 0xf3
TIMER0_RELOAD_H DATA 0xf4
TIMER1_RELOAD_H DATA 0xf5

CLK           EQU 22118400 ; Microcontroller system crystal frequency in Hz
TIMER0_RATE   EQU 4096     ; 2048Hz squarewave (peak amplitude of CEM-1203 speaker)
TIMER0_RELOAD EQU ((65536-(CLK/TIMER0_RATE)))
TIMER2_RATE   EQU 1000     ; 1000Hz, for a timer tick of 1ms
TIMER2_RELOAD EQU ((65536-(CLK/TIMER2_RATE)))

$include(LCD_4bit.inc)

LCD_RS equ P1.1
LCD_RW equ P1.2
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5


ON_OFF_OVEN equ P1.0


main:
mov SP, #0x7F
mov P0M0, #0
mov P0M1, #0
mov P1M0, #0
mov P1M1, #0
;loop:
;clr ON_OFF_OVEN
;Wait_Milli_Seconds(#250)
;Wait_Milli_Seconds(#250)
clr ON_OFF_OVEN
;Wait_Milli_Seconds(#250)
;Wait_Milli_Seconds(#250)
loop:
ljmp loop



END