; LCD_test_4bit.asm: Initializes and uses an LCD in 4-bit mode
; using the most common procedure found on the internet.
$NOLIST
$MODLP51
$LIST

org 0000H
    ljmp myprogram
    
dseg at 0x30
a0:       ds 1
a1:	      ds 1
a2:	      ds 1
a3:		  ds 1
a4:		  ds 1
a5:		  ds 1
a6:		  ds 1
a7:	 	  ds 1
a8:		  ds 1
a9:		  ds 1


cseg
; These 'equ' must match the hardware wiring
LCD_RS equ P1.1
LCD_RW equ P1.2 ; Not used in this code
LCD_E  equ P1.3
LCD_D4 equ P3.2
LCD_D5 equ P3.3
LCD_D6 equ P3.4
LCD_D7 equ P3.5





; When using a 22.1184MHz crystal in fast mode
; one cycle takes 1.0/22.1184MHz = 45.21123 ns

;---------------------------------;
; Wait 40 microseconds            ;
;---------------------------------;
Wait40uSec:
    push AR0
    mov R0, #177
L0:
    nop
    nop
    djnz R0, L0 ; 1+1+3 cycles->5*45.21123ns*177=40us
    pop AR0
    ret
;---------------------------------;
; Wait 'R2' milliseconds          ;
;---------------------------------;
WaitmilliSec:
    push AR0
    push AR1
L3: mov R1, #45
L2: mov R0, #166
L1: djnz R0, L1 ; 3 cycles->3*45.21123ns*166=22.51519us
    djnz R1, L2 ; 22.51519us*45=1.013ms
    djnz R2, L3 ; number of millisecons to wait passed in R2
    pop AR1
    pop AR0
    ret

;---------------------------------;
; Toggles the LCD's 'E' pin       ;
;---------------------------------;
LCD_pulse:
    setb LCD_E
    lcall Wait40uSec
    clr LCD_E
    ret

;---------------------------------;
; Writes data to LCD              ;
;---------------------------------;
WriteData:
    setb LCD_RS
    ljmp LCD_byte

;---------------------------------;
; Writes command to LCD           ;
;---------------------------------;
WriteCommand:
    clr LCD_RS
    ljmp LCD_byte

;---------------------------------;
; Writes acc to LCD in 4-bit mode ;
;---------------------------------;
LCD_byte:
    ; Write high 4 bits first
    mov c, ACC.7
    mov LCD_D7, c
    mov c, ACC.6
    mov LCD_D6, c
    mov c, ACC.5
    mov LCD_D5, c
    mov c, ACC.4
    mov LCD_D4, c
    lcall LCD_pulse

    ; Write low 4 bits next
    mov c, ACC.3
    mov LCD_D7, c
    mov c, ACC.2
    mov LCD_D6, c
    mov c, ACC.1
    mov LCD_D5, c
    mov c, ACC.0
    mov LCD_D4, c
    lcall LCD_pulse
    ret

;---------------------------------;
; Configure LCD in 4-bit mode     ;
;---------------------------------;
LCD_4BIT:
    clr LCD_E   ; Resting state of LCD's enable is zero
    clr LCD_RW  ; We are only writing to the LCD in this program
    ; After power on, wait for the LCD start up time before initializing
    ; NOTE: the preprogrammed power-on delay of 16 ms on the AT89LP51RC2
    ; seems to be enough.  That is why these two lines are commented out.
    ; Also, commenting these two lines improves simulation time in Multisim.
    ; mov R2, #40
    ; lcall WaitmilliSec
    ; First make sure the LCD is in 8-bit mode and then change to 4-bit mode
    mov a, #0x33
    lcall WriteCommand
    mov a, #0x33
    lcall WriteCommand
    mov a, #0x32 ; change to 4-bit mode
    lcall WriteCommand
    ; Configure the LCD
    mov a, #0x28
    lcall WriteCommand
    mov a, #0x0c
    lcall WriteCommand
    mov a, #0x01 ;  Clear screen command (takes some time)
    lcall WriteCommand
    ;Wait for clear screen command to finish. Usually takes 1.52ms.
    mov R2, #2
    lcall WaitmilliSec
    ret
    
delay:
	mov R2, #250
	lcall WaitmilliSec
	ret
    
SCROLL:
	mov a, #0x8F
    lcall STRING	;cursor at 15
    lcall delay
    dec a			;cursor at 14
    lcall STRING    
    lcall delay
    dec a			;cursor at 13
    lcall STRING
    lcall delay
    dec a	;cursor at 12
    lcall STRING
    lcall delay
    dec a	;cursor at 11
    lcall STRING
    lcall delay
    dec a	;cursor at 10
    lcall STRING
    lcall delay
    dec a	;cursor at 9
    lcall STRING
    lcall delay
    dec a	;cursor at 8
    lcall STRING
    lcall delay
    dec a	;cursor at 7
    lcall STRING
    lcall delay
    dec a	;cursor at 6
    lcall STRING
    lcall delay
    dec a	;cursor at 5
    lcall STRING
    lcall delay
    dec a	;cursor at 4
    lcall STRING
    lcall delay
    dec a	;cursor at 3
    lcall STRING
    lcall delay
    dec a	;cursor at 2
    lcall STRING
    lcall delay
    dec a	;cursor at 1
    lcall STRING
    lcall delay
    dec a	;cursor at 0
    lcall STRING
    lcall delay
    ljmp SCROLL
STRING:	
    mov a0, a
    cjne a, #0x8F, str0
    ljmp NAME
str0:
    mov a, a0	;a=80
    inc a	;a=81
    mov a1, a	;a1=81
    cjne a, #0x8F, str1
    ljmp NAME
str1:
    add a, #0x1
    mov a2, a	;a2=82
    cjne a, #0x8F, str2
    ljmp NAME
str2:
    add a, #0x1
    mov a3, a	;a3=83
    cjne a, #0x8F, str3
    ljmp NAME
str3:
    add a, #0x1
    mov a4, a	;a4=84
    cjne a, #0x8F, str4
    ljmp NAME
str4:
    add a, #0x2	;a=86
    mov a5, a	;a5=86
    cjne a, #0x8F, str5
    ljmp NAME
str5:
    add a, #0x1
    mov a6, a	;a6=87
    cjne a, #0x8F, str6
    ljmp NAME
str6:
    add a, #0x1
    mov a7, a	;a7=88
    cjne a, #0x8F, str7
    ljmp NAME
str7:
    add a, #0x1
    mov a8, a	;a8=89
    cjne a, #0x8F, str8
    ljmp NAME
str8:
    add a, #0x1
    mov a9, a	;a9=8A
    ljmp NAME
NAME:
    mov a, a0 ; Move cursor to line 1 column 5
    lcall WriteCommand
    mov a, #'A'
    lcall WriteData
    mov a, a0
    cjne a, #0x8F, n0 
    ljmp NUMBER
n0:
    mov a, a1 ; Move cursor to line 1 column 5
    lcall WriteCommand
    mov a, #'M'
    lcall WriteData
    mov a, a1
    cjne a, #0x8F, n1 
    ljmp NUMBER
n1:
    mov a, a2 ; Move cursor to line 1 column 4
    lcall WriteCommand
    mov a, #'M'
    lcall WriteData
    mov a, a2
    cjne a, #0x8F, n2 
    ljmp NUMBER
n2:
    mov a, a3 ; Move cursor to line 1 column 2
    lcall WriteCommand
    mov a, #'A'
    lcall WriteData
    mov a, a3
    cjne a, #0x8F, n3 
    ljmp NUMBER
n3:
    mov a, a4 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'R'
    lcall WriteData
    mov a, a4
    cjne a, #0x8F, n4 
    ljmp NUMBER
n4:
    mov a, a5 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'R'
    lcall WriteData
    mov a, a5
    cjne a, #0x8F, n5 
    ljmp NUMBER
n5:
    mov a, a6 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'E'
    lcall WriteData
    mov a, a6
    cjne a, #0x8F, n6 
    ljmp NUMBER
n6:
    mov a, a7 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'H'
    lcall WriteData
    mov a, a7
    cjne a, #0x8F, n7 
    ljmp NUMBER
n7:
	mov a, a8 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'A'
    lcall WriteData
    mov a, a8
    cjne a, #0x8F, n8 
    ljmp NUMBER
n8:
    mov a, a9 ; Move cursor to line 1 column 3
    lcall WriteCommand
    mov a, #'N'
    lcall WriteData
    ljmp NUMBER
NUMBER:
    mov a, #0xC0 ; Move cursor to line 2 column 1
    lcall WriteCommand
    mov a, #'1'
    lcall WriteData
    mov a, #0xC1 ; Move cursor to line 2 column 2
    lcall WriteCommand
    mov a, #'0'
    lcall WriteData
	mov a, #0xC2 ; Move cursor to line 2 column 3
    lcall WriteCommand
    mov a, #'6'
    lcall WriteData
    mov a, #0xC3 ; Move cursor to line 2 column 4
    lcall WriteCommand
    mov a, #'4'
    lcall WriteData
	mov a, #0xC4 ; Move cursor to line 2 column 5
    lcall WriteCommand
    mov a, #'9'
    lcall WriteData
    mov a, #0xC5 ; Move cursor to line 2 column 6
    lcall WriteCommand
    mov a, #'1'
    lcall WriteData
    mov a, #0xC6 ; Move cursor to line 2 column 7
    lcall WriteCommand
    mov a, #'5'
    lcall WriteData
	mov a, #0xC7 ; Move cursor to line 2 column 8
    lcall WriteCommand
    mov a, #'1'
    lcall WriteData
    ret
;---------------------------------;
; Main loop.  Initialize stack,   ;
; ports, LCD, and displays        ;
; letters on the LCD              ;
;---------------------------------;
myprogram:
    mov SP, #7FH
    lcall LCD_4BIT
    mov a0, #0
    mov a1, #0
    mov a2, #0
    mov a3, #0
    mov a4, #0
    mov a5, #0
    mov a6, #0
    mov a7, #0
    mov a8, #0
    mov a9, #0
    lcall SCROLL
    
    
forever:
    sjmp forever
END