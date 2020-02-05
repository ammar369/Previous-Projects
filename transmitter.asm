;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
; This file was generated Fri Mar 30 15:41:33 2018
;--------------------------------------------------------
$name transmitter
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _InitPinADC_PARM_2
	public _GetSignal
	public _TerminationSignal
	public _InitializationSignal
	public _Volts_at_Pin
	public _ADC_at_Pin
	public _InitPinADC
	public _InitADC
	public _LogicZero
	public _LogicOne
	public _AdjustWaveform
	public _AdjustFrequency
	public _waitms
	public _Timer3us
	public _Timer2_ISR
	public __c51_external_startup
	public _OUTPUT1
	public _OUTPUT0
	public _main
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
_ACC            DATA 0xe0
_ADC0ASAH       DATA 0xb6
_ADC0ASAL       DATA 0xb5
_ADC0ASCF       DATA 0xa1
_ADC0ASCT       DATA 0xc7
_ADC0CF0        DATA 0xbc
_ADC0CF1        DATA 0xb9
_ADC0CF2        DATA 0xdf
_ADC0CN0        DATA 0xe8
_ADC0CN1        DATA 0xb2
_ADC0CN2        DATA 0xb3
_ADC0GTH        DATA 0xc4
_ADC0GTL        DATA 0xc3
_ADC0H          DATA 0xbe
_ADC0L          DATA 0xbd
_ADC0LTH        DATA 0xc6
_ADC0LTL        DATA 0xc5
_ADC0MX         DATA 0xbb
_B              DATA 0xf0
_CKCON0         DATA 0x8e
_CKCON1         DATA 0xa6
_CLEN0          DATA 0xc6
_CLIE0          DATA 0xc7
_CLIF0          DATA 0xe8
_CLKSEL         DATA 0xa9
_CLOUT0         DATA 0xd1
_CLU0CF         DATA 0xb1
_CLU0FN         DATA 0xaf
_CLU0MX         DATA 0x84
_CLU1CF         DATA 0xb3
_CLU1FN         DATA 0xb2
_CLU1MX         DATA 0x85
_CLU2CF         DATA 0xb6
_CLU2FN         DATA 0xb5
_CLU2MX         DATA 0x91
_CLU3CF         DATA 0xbf
_CLU3FN         DATA 0xbe
_CLU3MX         DATA 0xae
_CMP0CN0        DATA 0x9b
_CMP0CN1        DATA 0x99
_CMP0MD         DATA 0x9d
_CMP0MX         DATA 0x9f
_CMP1CN0        DATA 0xbf
_CMP1CN1        DATA 0xac
_CMP1MD         DATA 0xab
_CMP1MX         DATA 0xaa
_CRC0CN0        DATA 0xce
_CRC0CN1        DATA 0x86
_CRC0CNT        DATA 0xd3
_CRC0DAT        DATA 0xcb
_CRC0FLIP       DATA 0xcf
_CRC0IN         DATA 0xca
_CRC0ST         DATA 0xd2
_DAC0CF0        DATA 0x91
_DAC0CF1        DATA 0x92
_DAC0H          DATA 0x85
_DAC0L          DATA 0x84
_DAC1CF0        DATA 0x93
_DAC1CF1        DATA 0x94
_DAC1H          DATA 0x8a
_DAC1L          DATA 0x89
_DAC2CF0        DATA 0x95
_DAC2CF1        DATA 0x96
_DAC2H          DATA 0x8c
_DAC2L          DATA 0x8b
_DAC3CF0        DATA 0x9a
_DAC3CF1        DATA 0x9c
_DAC3H          DATA 0x8e
_DAC3L          DATA 0x8d
_DACGCF0        DATA 0x88
_DACGCF1        DATA 0x98
_DACGCF2        DATA 0xa2
_DERIVID        DATA 0xad
_DEVICEID       DATA 0xb5
_DPH            DATA 0x83
_DPL            DATA 0x82
_EIE1           DATA 0xe6
_EIE2           DATA 0xf3
_EIP1           DATA 0xbb
_EIP1H          DATA 0xee
_EIP2           DATA 0xed
_EIP2H          DATA 0xf6
_EMI0CN         DATA 0xe7
_FLKEY          DATA 0xb7
_HFO0CAL        DATA 0xc7
_HFO1CAL        DATA 0xd6
_HFOCN          DATA 0xef
_I2C0ADM        DATA 0xff
_I2C0CN0        DATA 0xba
_I2C0DIN        DATA 0xbc
_I2C0DOUT       DATA 0xbb
_I2C0FCN0       DATA 0xad
_I2C0FCN1       DATA 0xab
_I2C0FCT        DATA 0xf5
_I2C0SLAD       DATA 0xbd
_I2C0STAT       DATA 0xb9
_IE             DATA 0xa8
_IP             DATA 0xb8
_IPH            DATA 0xf2
_IT01CF         DATA 0xe4
_LFO0CN         DATA 0xb1
_P0             DATA 0x80
_P0MASK         DATA 0xfe
_P0MAT          DATA 0xfd
_P0MDIN         DATA 0xf1
_P0MDOUT        DATA 0xa4
_P0SKIP         DATA 0xd4
_P1             DATA 0x90
_P1MASK         DATA 0xee
_P1MAT          DATA 0xed
_P1MDIN         DATA 0xf2
_P1MDOUT        DATA 0xa5
_P1SKIP         DATA 0xd5
_P2             DATA 0xa0
_P2MASK         DATA 0xfc
_P2MAT          DATA 0xfb
_P2MDIN         DATA 0xf3
_P2MDOUT        DATA 0xa6
_P2SKIP         DATA 0xcc
_P3             DATA 0xb0
_P3MDIN         DATA 0xf4
_P3MDOUT        DATA 0x9c
_PCA0CENT       DATA 0x9e
_PCA0CLR        DATA 0x9c
_PCA0CN0        DATA 0xd8
_PCA0CPH0       DATA 0xfc
_PCA0CPH1       DATA 0xea
_PCA0CPH2       DATA 0xec
_PCA0CPH3       DATA 0xf5
_PCA0CPH4       DATA 0x85
_PCA0CPH5       DATA 0xde
_PCA0CPL0       DATA 0xfb
_PCA0CPL1       DATA 0xe9
_PCA0CPL2       DATA 0xeb
_PCA0CPL3       DATA 0xf4
_PCA0CPL4       DATA 0x84
_PCA0CPL5       DATA 0xdd
_PCA0CPM0       DATA 0xda
_PCA0CPM1       DATA 0xdb
_PCA0CPM2       DATA 0xdc
_PCA0CPM3       DATA 0xae
_PCA0CPM4       DATA 0xaf
_PCA0CPM5       DATA 0xcc
_PCA0H          DATA 0xfa
_PCA0L          DATA 0xf9
_PCA0MD         DATA 0xd9
_PCA0POL        DATA 0x96
_PCA0PWM        DATA 0xf7
_PCON0          DATA 0x87
_PCON1          DATA 0xcd
_PFE0CN         DATA 0xc1
_PRTDRV         DATA 0xf6
_PSCTL          DATA 0x8f
_PSTAT0         DATA 0xaa
_PSW            DATA 0xd0
_REF0CN         DATA 0xd1
_REG0CN         DATA 0xc9
_REVID          DATA 0xb6
_RSTSRC         DATA 0xef
_SBCON1         DATA 0x94
_SBRLH1         DATA 0x96
_SBRLL1         DATA 0x95
_SBUF           DATA 0x99
_SBUF0          DATA 0x99
_SBUF1          DATA 0x92
_SCON           DATA 0x98
_SCON0          DATA 0x98
_SCON1          DATA 0xc8
_SFRPAGE        DATA 0xa7
_SFRPGCN        DATA 0xbc
_SFRSTACK       DATA 0xd7
_SMB0ADM        DATA 0xd6
_SMB0ADR        DATA 0xd7
_SMB0CF         DATA 0xc1
_SMB0CN0        DATA 0xc0
_SMB0DAT        DATA 0xc2
_SMB0FCN0       DATA 0xc3
_SMB0FCN1       DATA 0xc4
_SMB0FCT        DATA 0xef
_SMB0RXLN       DATA 0xc5
_SMB0TC         DATA 0xac
_SMOD1          DATA 0x93
_SP             DATA 0x81
_SPI0CFG        DATA 0xa1
_SPI0CKR        DATA 0xa2
_SPI0CN0        DATA 0xf8
_SPI0DAT        DATA 0xa3
_SPI0FCN0       DATA 0x9a
_SPI0FCN1       DATA 0x9b
_SPI0FCT        DATA 0xf7
_SPI0PCF        DATA 0xdf
_TCON           DATA 0x88
_TH0            DATA 0x8c
_TH1            DATA 0x8d
_TL0            DATA 0x8a
_TL1            DATA 0x8b
_TMOD           DATA 0x89
_TMR2CN0        DATA 0xc8
_TMR2CN1        DATA 0xfd
_TMR2H          DATA 0xcf
_TMR2L          DATA 0xce
_TMR2RLH        DATA 0xcb
_TMR2RLL        DATA 0xca
_TMR3CN0        DATA 0x91
_TMR3CN1        DATA 0xfe
_TMR3H          DATA 0x95
_TMR3L          DATA 0x94
_TMR3RLH        DATA 0x93
_TMR3RLL        DATA 0x92
_TMR4CN0        DATA 0x98
_TMR4CN1        DATA 0xff
_TMR4H          DATA 0xa5
_TMR4L          DATA 0xa4
_TMR4RLH        DATA 0xa3
_TMR4RLL        DATA 0xa2
_TMR5CN0        DATA 0xc0
_TMR5CN1        DATA 0xf1
_TMR5H          DATA 0xd5
_TMR5L          DATA 0xd4
_TMR5RLH        DATA 0xd3
_TMR5RLL        DATA 0xd2
_UART0PCF       DATA 0xd9
_UART1FCN0      DATA 0x9d
_UART1FCN1      DATA 0xd8
_UART1FCT       DATA 0xfa
_UART1LIN       DATA 0x9e
_UART1PCF       DATA 0xda
_VDM0CN         DATA 0xff
_WDTCN          DATA 0x97
_XBR0           DATA 0xe1
_XBR1           DATA 0xe2
_XBR2           DATA 0xe3
_XOSC0CN        DATA 0x86
_DPTR           DATA 0x8382
_TMR2RL         DATA 0xcbca
_TMR3RL         DATA 0x9392
_TMR4RL         DATA 0xa3a2
_TMR5RL         DATA 0xd3d2
_TMR0           DATA 0x8c8a
_TMR1           DATA 0x8d8b
_TMR2           DATA 0xcfce
_TMR3           DATA 0x9594
_TMR4           DATA 0xa5a4
_TMR5           DATA 0xd5d4
_SBRL1          DATA 0x9695
_PCA0           DATA 0xfaf9
_PCA0CP0        DATA 0xfcfb
_PCA0CP1        DATA 0xeae9
_PCA0CP2        DATA 0xeceb
_PCA0CP3        DATA 0xf5f4
_PCA0CP4        DATA 0x8584
_PCA0CP5        DATA 0xdedd
_ADC0ASA        DATA 0xb6b5
_ADC0GT         DATA 0xc4c3
_ADC0           DATA 0xbebd
_ADC0LT         DATA 0xc6c5
_DAC0           DATA 0x8584
_DAC1           DATA 0x8a89
_DAC2           DATA 0x8c8b
_DAC3           DATA 0x8e8d
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
_ACC_0          BIT 0xe0
_ACC_1          BIT 0xe1
_ACC_2          BIT 0xe2
_ACC_3          BIT 0xe3
_ACC_4          BIT 0xe4
_ACC_5          BIT 0xe5
_ACC_6          BIT 0xe6
_ACC_7          BIT 0xe7
_TEMPE          BIT 0xe8
_ADGN0          BIT 0xe9
_ADGN1          BIT 0xea
_ADWINT         BIT 0xeb
_ADBUSY         BIT 0xec
_ADINT          BIT 0xed
_IPOEN          BIT 0xee
_ADEN           BIT 0xef
_B_0            BIT 0xf0
_B_1            BIT 0xf1
_B_2            BIT 0xf2
_B_3            BIT 0xf3
_B_4            BIT 0xf4
_B_5            BIT 0xf5
_B_6            BIT 0xf6
_B_7            BIT 0xf7
_C0FIF          BIT 0xe8
_C0RIF          BIT 0xe9
_C1FIF          BIT 0xea
_C1RIF          BIT 0xeb
_C2FIF          BIT 0xec
_C2RIF          BIT 0xed
_C3FIF          BIT 0xee
_C3RIF          BIT 0xef
_D1SRC0         BIT 0x88
_D1SRC1         BIT 0x89
_D1AMEN         BIT 0x8a
_D01REFSL       BIT 0x8b
_D3SRC0         BIT 0x8c
_D3SRC1         BIT 0x8d
_D3AMEN         BIT 0x8e
_D23REFSL       BIT 0x8f
_D0UDIS         BIT 0x98
_D1UDIS         BIT 0x99
_D2UDIS         BIT 0x9a
_D3UDIS         BIT 0x9b
_EX0            BIT 0xa8
_ET0            BIT 0xa9
_EX1            BIT 0xaa
_ET1            BIT 0xab
_ES0            BIT 0xac
_ET2            BIT 0xad
_ESPI0          BIT 0xae
_EA             BIT 0xaf
_PX0            BIT 0xb8
_PT0            BIT 0xb9
_PX1            BIT 0xba
_PT1            BIT 0xbb
_PS0            BIT 0xbc
_PT2            BIT 0xbd
_PSPI0          BIT 0xbe
_P0_0           BIT 0x80
_P0_1           BIT 0x81
_P0_2           BIT 0x82
_P0_3           BIT 0x83
_P0_4           BIT 0x84
_P0_5           BIT 0x85
_P0_6           BIT 0x86
_P0_7           BIT 0x87
_P1_0           BIT 0x90
_P1_1           BIT 0x91
_P1_2           BIT 0x92
_P1_3           BIT 0x93
_P1_4           BIT 0x94
_P1_5           BIT 0x95
_P1_6           BIT 0x96
_P1_7           BIT 0x97
_P2_0           BIT 0xa0
_P2_1           BIT 0xa1
_P2_2           BIT 0xa2
_P2_3           BIT 0xa3
_P2_4           BIT 0xa4
_P2_5           BIT 0xa5
_P2_6           BIT 0xa6
_P3_0           BIT 0xb0
_P3_1           BIT 0xb1
_P3_2           BIT 0xb2
_P3_3           BIT 0xb3
_P3_4           BIT 0xb4
_P3_7           BIT 0xb7
_CCF0           BIT 0xd8
_CCF1           BIT 0xd9
_CCF2           BIT 0xda
_CCF3           BIT 0xdb
_CCF4           BIT 0xdc
_CCF5           BIT 0xdd
_CR             BIT 0xde
_CF             BIT 0xdf
_PARITY         BIT 0xd0
_F1             BIT 0xd1
_OV             BIT 0xd2
_RS0            BIT 0xd3
_RS1            BIT 0xd4
_F0             BIT 0xd5
_AC             BIT 0xd6
_CY             BIT 0xd7
_RI             BIT 0x98
_TI             BIT 0x99
_RB8            BIT 0x9a
_TB8            BIT 0x9b
_REN            BIT 0x9c
_CE             BIT 0x9d
_SMODE          BIT 0x9e
_RI1            BIT 0xc8
_TI1            BIT 0xc9
_RBX1           BIT 0xca
_TBX1           BIT 0xcb
_REN1           BIT 0xcc
_PERR1          BIT 0xcd
_OVR1           BIT 0xce
_SI             BIT 0xc0
_ACK            BIT 0xc1
_ARBLOST        BIT 0xc2
_ACKRQ          BIT 0xc3
_STO            BIT 0xc4
_STA            BIT 0xc5
_TXMODE         BIT 0xc6
_MASTER         BIT 0xc7
_SPIEN          BIT 0xf8
_TXNF           BIT 0xf9
_NSSMD0         BIT 0xfa
_NSSMD1         BIT 0xfb
_RXOVRN         BIT 0xfc
_MODF           BIT 0xfd
_WCOL           BIT 0xfe
_SPIF           BIT 0xff
_IT0            BIT 0x88
_IE0            BIT 0x89
_IT1            BIT 0x8a
_IE1            BIT 0x8b
_TR0            BIT 0x8c
_TF0            BIT 0x8d
_TR1            BIT 0x8e
_TF1            BIT 0x8f
_T2XCLK0        BIT 0xc8
_T2XCLK1        BIT 0xc9
_TR2            BIT 0xca
_T2SPLIT        BIT 0xcb
_TF2CEN         BIT 0xcc
_TF2LEN         BIT 0xcd
_TF2L           BIT 0xce
_TF2H           BIT 0xcf
_T4XCLK0        BIT 0x98
_T4XCLK1        BIT 0x99
_TR4            BIT 0x9a
_T4SPLIT        BIT 0x9b
_TF4CEN         BIT 0x9c
_TF4LEN         BIT 0x9d
_TF4L           BIT 0x9e
_TF4H           BIT 0x9f
_T5XCLK0        BIT 0xc0
_T5XCLK1        BIT 0xc1
_TR5            BIT 0xc2
_T5SPLIT        BIT 0xc3
_TF5CEN         BIT 0xc4
_TF5LEN         BIT 0xc5
_TF5L           BIT 0xc6
_TF5H           BIT 0xc7
_RIE            BIT 0xd8
_RXTO0          BIT 0xd9
_RXTO1          BIT 0xda
_RFRQ           BIT 0xdb
_TIE            BIT 0xdc
_TXHOLD         BIT 0xdd
_TXNF1          BIT 0xde
_TFRQ           BIT 0xdf
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_OUTPUT0:
	ds 2
_OUTPUT1:
	ds 2
_AdjustFrequency_f_1_53:
	ds 4
_GetSignal_x_1_80:
	ds 4
_main_n_1_93:
	ds 4
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
	rseg	R_OSEG
_InitPinADC_PARM_2:
	ds 1
	rseg	R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
	CSEG at 0x002b
	ljmp	_Timer2_ISR
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:27: char _c51_external_startup (void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:30: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:31: WDTCN = 0xDE; //First key
	mov	_WDTCN,#0xDE
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:32: WDTCN = 0xAD; //Second key
	mov	_WDTCN,#0xAD
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:34: VDM0CN |= 0x80;
	orl	_VDM0CN,#0x80
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:35: RSTSRC = 0x02;
	mov	_RSTSRC,#0x02
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:42: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:43: PFE0CN  = 0x20; // SYSCLK < 75 MHz.
	mov	_PFE0CN,#0x20
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:44: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:65: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:66: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:67: while ((CLKSEL & 0x80) == 0);
L002001?:
	mov	a,_CLKSEL
	jnb	acc.7,L002001?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:68: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:69: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:70: while ((CLKSEL & 0x80) == 0);
L002004?:
	mov	a,_CLKSEL
	jnb	acc.7,L002004?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:76: P2MDOUT|=0b_0000_0011;
	orl	_P2MDOUT,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:77: P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	orl	_P0MDOUT,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:78: XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	mov	_XBR0,#0x01
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:79: XBR1     = 0X10; // Enable T0 on P0.0
	mov	_XBR1,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:80: XBR2     = 0x40; // Enable crossbar and weak pull-ups
	mov	_XBR2,#0x40
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:86: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:87: CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	mov	_CKCON0,_CKCON0
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:88: TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	mov	_TH1,#0xE6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:89: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:90: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:91: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:92: TR1 = 1; // START Timer1
	setb	_TR1
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:93: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:96: TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	mov	_TMR2CN0,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:97: CKCON0|=0b_0001_0000;
	orl	_CKCON0,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:98: TMR2RL=(-(SYSCLK/(2*DEFAULT_F))); // Initialize reload value
	mov	_TMR2RL,#0xEE
	mov	(_TMR2RL >> 8),#0xF6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:99: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:100: ET2=1;         // Enable Timer2 interrupts
	setb	_ET2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:101: TR2=1;         // Start Timer2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:102: EA=1; // Global interrupt enable
	setb	_EA
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:104: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:109: void Timer2_ISR (void) interrupt INTERRUPT_TIMER2
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
	push	acc
	push	ar2
	push	psw
	mov	psw,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:111: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:112: OUTPUT0=!OUTPUT0;
	mov	a,_OUTPUT0
	orl	a,(_OUTPUT0 + 1)
	cjne	a,#0x01,L003003?
L003003?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:113: OUTPUT1=!OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L003004?
L003004?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT1,r2
	mov	(_OUTPUT1 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:115: OUT0=OUTPUT0;
	mov	a,_OUTPUT0
	orl	a,(_OUTPUT0 + 1)
	add	a,#0xff
	mov	_P2_0,c
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:116: OUT1=OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	add	a,#0xff
	mov	_P2_1,c
	pop	psw
	pop	ar2
	pop	acc
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer3us'
;------------------------------------------------------------
;us                        Allocated to registers r2 
;i                         Allocated to registers r3 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:120: void Timer3us(unsigned char us)
;	-----------------------------------------
;	 function Timer3us
;	-----------------------------------------
_Timer3us:
	mov	r2,dpl
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:125: CKCON0|=0b_0100_0000;
	orl	_CKCON0,#0x40
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:127: TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	mov	_TMR3RL,#0xB8
	mov	(_TMR3RL >> 8),#0xFF
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:128: TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	mov	_TMR3,_TMR3RL
	mov	(_TMR3 >> 8),(_TMR3RL >> 8)
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:130: TMR3CN0 = 0x04;                 // Start Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x04
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:131: for (i = 0; i < us; i++)       // Count <us> overflows
	mov	r3,#0x00
L004004?:
	clr	c
	mov	a,r3
	subb	a,r2
	jnc	L004007?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:133: while (!(TMR3CN0 & 0x80));  // Wait for overflow
L004001?:
	mov	a,_TMR3CN0
	jnb	acc.7,L004001?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:134: TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	anl	_TMR3CN0,#0x7F
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:131: for (i = 0; i < us; i++)       // Count <us> overflows
	inc	r3
	sjmp	L004004?
L004007?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:136: TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r4 r5 
;k                         Allocated to registers r6 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:139: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:143: for(j=0; j<ms; j++)
	mov	r4,#0x00
	mov	r5,#0x00
L005005?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	L005009?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:144: for (k=0; k<4; k++) Timer3us(250);
	mov	r6,#0x00
L005001?:
	cjne	r6,#0x04,L005018?
L005018?:
	jnc	L005007?
	mov	dpl,#0xFA
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_Timer3us
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r6
	sjmp	L005001?
L005007?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:143: for(j=0; j<ms; j++)
	inc	r4
	cjne	r4,#0x00,L005005?
	inc	r5
	sjmp	L005005?
L005009?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'AdjustFrequency'
;------------------------------------------------------------
;x                         Allocated to registers r2 r3 r4 r5 
;f                         Allocated with name '_AdjustFrequency_f_1_53'
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:148: void AdjustFrequency (void)
;	-----------------------------------------
;	 function AdjustFrequency
;	-----------------------------------------
_AdjustFrequency:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:151: while(1){
L006005?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:152: printf("New frequency=");
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:153: scanf("%lu", &f);
	mov	a,#_AdjustFrequency_f_1_53
	push	acc
	mov	a,#(_AdjustFrequency_f_1_53 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_scanf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:154: x=(SYSCLK/(2L*f));
	mov	a,_AdjustFrequency_f_1_53
	add	a,_AdjustFrequency_f_1_53
	mov	__divulong_PARM_2,a
	mov	a,(_AdjustFrequency_f_1_53 + 1)
	rlc	a
	mov	(__divulong_PARM_2 + 1),a
	mov	a,(_AdjustFrequency_f_1_53 + 2)
	rlc	a
	mov	(__divulong_PARM_2 + 2),a
	mov	a,(_AdjustFrequency_f_1_53 + 3)
	rlc	a
	mov	(__divulong_PARM_2 + 3),a
	mov	dptr,#0xA200
	mov	b,#0x4A
	mov	a,#0x04
	lcall	__divulong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:155: if(x>0xffff)
	clr	c
	mov	a,#0xFF
	subb	a,r2
	mov	a,#0xFF
	subb	a,r3
	clr	a
	subb	a,r4
	clr	a
	subb	a,r5
	jnc	L006002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:157: printf("Sorry %lu Hz is out of range.\n", f);
	push	_AdjustFrequency_f_1_53
	push	(_AdjustFrequency_f_1_53 + 1)
	push	(_AdjustFrequency_f_1_53 + 2)
	push	(_AdjustFrequency_f_1_53 + 3)
	mov	a,#__str_2
	push	acc
	mov	a,#(__str_2 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
	ljmp	L006005?
L006002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:161: TR2=0; // Stop timer 2
	clr	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:162: TMR2RL=0x10000L-x; // Change reload value for new frequency
	clr	a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	clr	a
	subb	a,r5
	mov	_TMR2RL,r2
	mov	(_TMR2RL >> 8),r3
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:163: TR2=1; // Start timer 2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:164: f=SYSCLK/(2L*(0x10000L-TMR2RL));
	mov	r2,_TMR2RL
	mov	r3,(_TMR2RL >> 8)
	mov	r4,#0x00
	clr	a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r5
	mov	r5,a
	mov	a,r2
	add	a,r2
	mov	__divslong_PARM_2,a
	mov	a,r3
	rlc	a
	mov	(__divslong_PARM_2 + 1),a
	mov	a,r4
	rlc	a
	mov	(__divslong_PARM_2 + 2),a
	mov	a,r5
	rlc	a
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0xA200
	mov	b,#0x4A
	mov	a,#0x04
	lcall	__divslong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	_AdjustFrequency_f_1_53,r2
	mov	(_AdjustFrequency_f_1_53 + 1),r3
	mov	(_AdjustFrequency_f_1_53 + 2),r4
	mov	(_AdjustFrequency_f_1_53 + 3),r5
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:165: printf("\nActual frequency: %lu\n", f);
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
	ljmp	L006005?
;------------------------------------------------------------
;Allocation info for local variables in function 'AdjustWaveform'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:169: void AdjustWaveform (void)
;	-----------------------------------------
;	 function AdjustWaveform
;	-----------------------------------------
_AdjustWaveform:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:171: while(1){
L007005?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:172: if(Button==0){//pressed
	jb	_P2_6,L007002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:173: OUTPUT0=1;
	mov	_OUTPUT0,#0x01
	clr	a
	mov	(_OUTPUT0 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:174: OUTPUT1=1;
	mov	_OUTPUT1,#0x01
	clr	a
	mov	(_OUTPUT1 + 1),a
	sjmp	L007005?
L007002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:178: OUTPUT0=!OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L007012?
L007012?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
	sjmp	L007005?
;------------------------------------------------------------
;Allocation info for local variables in function 'LogicOne'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:183: void LogicOne (void)
;	-----------------------------------------
;	 function LogicOne
;	-----------------------------------------
_LogicOne:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:185: OUTPUT0=!OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L008003?
L008003?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:186: waitms(9);//1
	mov	dptr,#0x0009
	lcall	_waitms
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:187: printf("1");
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'LogicZero'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:190: void LogicZero (void)
;	-----------------------------------------
;	 function LogicZero
;	-----------------------------------------
_LogicZero:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:192: OUTPUT0=1;
	mov	_OUTPUT0,#0x01
	clr	a
	mov	(_OUTPUT0 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:193: OUTPUT1=1;
	mov	_OUTPUT1,#0x01
	clr	a
	mov	(_OUTPUT1 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:194: waitms(9);//0
	mov	dptr,#0x0009
	lcall	_waitms
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:195: printf("0");	
	mov	a,#__str_5
	push	acc
	mov	a,#(__str_5 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'InitADC'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:198: void InitADC (void)
;	-----------------------------------------
;	 function InitADC
;	-----------------------------------------
_InitADC:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:200: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:201: ADC0CN1 = 0b_10_000_000; //14-bit,  Right justified no shifting applied, perform and Accumulate 1 conversion.
	mov	_ADC0CN1,#0x80
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:202: ADC0CF0 = 0b_11111_0_00; // SYSCLK/32
	mov	_ADC0CF0,#0xF8
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:203: ADC0CF1 = 0b_0_0_011110; // Same as default for now
	mov	_ADC0CF1,#0x1E
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:204: ADC0CN0 = 0b_0_0_0_0_0_00_0; // Same as default for now
	mov	_ADC0CN0,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:205: ADC0CF2 = 0b_0_01_11111 ; // GND pin, Vref=VDD
	mov	_ADC0CF2,#0x3F
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:206: ADC0CN2 = 0b_0_000_0000;  // Same as default for now. ADC0 conversion initiated on write of 1 to ADBUSY.
	mov	_ADC0CN2,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:207: ADEN=1; // Enable ADC
	setb	_ADEN
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'InitPinADC'
;------------------------------------------------------------
;pinno                     Allocated with name '_InitPinADC_PARM_2'
;portno                    Allocated to registers r2 
;mask                      Allocated to registers r3 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:210: void InitPinADC (unsigned char portno, unsigned char pinno)
;	-----------------------------------------
;	 function InitPinADC
;	-----------------------------------------
_InitPinADC:
	mov	r2,dpl
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:214: mask=1<<pinno;
	mov	b,_InitPinADC_PARM_2
	inc	b
	mov	a,#0x01
	sjmp	L011013?
L011011?:
	add	a,acc
L011013?:
	djnz	b,L011011?
	mov	r3,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:216: SFRPAGE = 0x20;
	mov	_SFRPAGE,#0x20
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:217: switch (portno)
	cjne	r2,#0x00,L011014?
	sjmp	L011001?
L011014?:
	cjne	r2,#0x01,L011015?
	sjmp	L011002?
L011015?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:219: case 0:
	cjne	r2,#0x02,L011005?
	sjmp	L011003?
L011001?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:220: P0MDIN &= (~mask); // Set pin as analog input
	mov	a,r3
	cpl	a
	mov	r2,a
	anl	_P0MDIN,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:221: P0SKIP |= mask; // Skip Crossbar decoding for this pin
	mov	a,r3
	orl	_P0SKIP,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:222: break;
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:223: case 1:
	sjmp	L011005?
L011002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:224: P1MDIN &= (~mask); // Set pin as analog input
	mov	a,r3
	cpl	a
	mov	r2,a
	anl	_P1MDIN,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:225: P1SKIP |= mask; // Skip Crossbar decoding for this pin
	mov	a,r3
	orl	_P1SKIP,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:226: break;
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:227: case 2:
	sjmp	L011005?
L011003?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:228: P2MDIN &= (~mask); // Set pin as analog input
	mov	a,r3
	cpl	a
	mov	r2,a
	anl	_P2MDIN,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:229: P2SKIP |= mask; // Skip Crossbar decoding for this pin
	mov	a,r3
	orl	_P2SKIP,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:233: }
L011005?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:234: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'ADC_at_Pin'
;------------------------------------------------------------
;pin                       Allocated to registers 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:237: unsigned int ADC_at_Pin(unsigned char pin)
;	-----------------------------------------
;	 function ADC_at_Pin
;	-----------------------------------------
_ADC_at_Pin:
	mov	_ADC0MX,dpl
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:240: ADBUSY=1;       // Dummy conversion first to select new pin
	setb	_ADBUSY
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:241: while (ADBUSY); // Wait for dummy conversion to finish
L012001?:
	jb	_ADBUSY,L012001?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:242: ADBUSY = 1;     // Convert voltage at the pin
	setb	_ADBUSY
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:243: while (ADBUSY); // Wait for conversion to complete
L012004?:
	jb	_ADBUSY,L012004?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:244: return (ADC0);
	mov	dpl,_ADC0
	mov	dph,(_ADC0 >> 8)
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Volts_at_Pin'
;------------------------------------------------------------
;pin                       Allocated to registers r2 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:247: float Volts_at_Pin(unsigned char pin)
;	-----------------------------------------
;	 function Volts_at_Pin
;	-----------------------------------------
_Volts_at_Pin:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:249: return ((ADC_at_Pin(pin)*VDD)/0b_0011_1111_1111_1111);
	lcall	_ADC_at_Pin
	lcall	___uint2fs
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0x999A
	mov	b,#0x99
	mov	a,#0x40
	lcall	___fsmul
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	clr	a
	push	acc
	mov	a,#0xFC
	push	acc
	mov	a,#0x7F
	push	acc
	mov	a,#0x46
	push	acc
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fsdiv
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'InitializationSignal'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:252: void InitializationSignal (void)
;	-----------------------------------------
;	 function InitializationSignal
;	-----------------------------------------
_InitializationSignal:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:255: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:256: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:257: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:258: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:259: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:260: printf("----------");
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'TerminationSignal'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:263: void TerminationSignal (void)
;	-----------------------------------------
;	 function TerminationSignal
;	-----------------------------------------
_TerminationSignal:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:266: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:267: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:268: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:269: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:270: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:271: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'GetSignal'
;------------------------------------------------------------
;x                         Allocated with name '_GetSignal_x_1_80'
;y                         Allocated to registers r6 r7 r0 r1 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:274: void GetSignal (void)
;	-----------------------------------------
;	 function GetSignal
;	-----------------------------------------
_GetSignal:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:279: while(1){
L016037?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:281: x = Volts_at_Pin(QFP32_MUX_P2_2);
	mov	dpl,#0x0F
	lcall	_Volts_at_Pin
	mov	_GetSignal_x_1_80,dpl
	mov	(_GetSignal_x_1_80 + 1),dph
	mov	(_GetSignal_x_1_80 + 2),b
	mov	(_GetSignal_x_1_80 + 3),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:282: y = Volts_at_Pin(QFP32_MUX_P2_3);
	mov	dpl,#0x10
	lcall	_Volts_at_Pin
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:286: if((x>2.0) && (x<4.5) && (y>2.0) && (y<4.5))  {
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fsgt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	mov	a,r2
	jnz	L016067?
	ljmp	L016002?
L016067?:
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fslt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jnz	L016068?
	ljmp	L016002?
L016068?:
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jnz	L016069?
	ljmp	L016002?
L016069?:
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jz	L016002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:287: printf("PAUSED           --- \r");
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_8
	push	acc
	mov	a,#(__str_8 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:288: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:289: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:290: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:291: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:292: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:293: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:294: printf("\r");	}	
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
L016002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:299: if((x>2.0) && (x<4.5) && (y<2.0)) {
	mov	a,r2
	jnz	L016071?
	ljmp	L016007?
L016071?:
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fslt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jnz	L016072?
	ljmp	L016007?
L016072?:
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jz	L016007?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:300: printf("BACKWARD         180 \r");
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_10
	push	acc
	mov	a,#(__str_10 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:301: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:302: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:303: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:304: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:305: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:306: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:307: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:308: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
L016007?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:313: if((x<2.0) && (y>2.0) && (y<4.5)) {
	push	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fslt
	mov	r3,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar2
	mov	a,r3
	jnz	L016074?
	ljmp	L016011?
L016074?:
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r4,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar3
	pop	ar2
	mov	a,r4
	jnz	L016075?
	ljmp	L016011?
L016075?:
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r4,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar3
	pop	ar2
	mov	a,r4
	jz	L016011?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:314: printf("LEFT             270 \r");
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_11
	push	acc
	mov	a,#(__str_11 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:315: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:316: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:317: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:318: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:319: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:320: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:321: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:322: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar3
	pop	ar2
L016011?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:327: if((x>4.5) && (y>2.0) && (y<4.5)){
	push	ar2
	push	ar3
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fsgt
	mov	r4,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar3
	pop	ar2
	mov	a,r4
	jnz	L016077?
	ljmp	L016015?
L016077?:
	push	ar2
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r5,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	pop	ar2
	mov	a,r5
	jnz	L016078?
	ljmp	L016015?
L016078?:
	push	ar2
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r5,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	pop	ar2
	mov	a,r5
	jz	L016015?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:328: printf("RIGHT            090 \r");
	push	ar2
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_12
	push	acc
	mov	a,#(__str_12 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:329: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:330: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:331: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:332: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:333: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:334: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:335: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:336: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	pop	ar2
L016015?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:341: if((x>2.0) && (x<4.5) && (y>4.5)){
	mov	a,r2
	jnz	L016080?
	ljmp	L016019?
L016080?:
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,_GetSignal_x_1_80
	mov	dph,(_GetSignal_x_1_80 + 1)
	mov	b,(_GetSignal_x_1_80 + 2)
	mov	a,(_GetSignal_x_1_80 + 3)
	lcall	___fslt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	mov	a,r2
	jnz	L016081?
	ljmp	L016019?
L016081?:
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	mov	a,r2
	jz	L016019?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:342: printf("FORWARD          000 \r");
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_13
	push	acc
	mov	a,#(__str_13 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:343: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:344: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:345: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:346: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:347: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:348: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:349: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:350: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
L016019?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:355: if((x<2.0) && (y>4.5)){
	mov	a,r3
	jnz	L016083?
	ljmp	L016023?
L016083?:
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	mov	a,r2
	jz	L016023?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:356: printf("FORWARD LEFT     315 \r");
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_14
	push	acc
	mov	a,#(__str_14 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:357: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:358: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:359: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:360: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:361: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:362: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:363: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:364: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
L016023?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:369: if((x>4.5) && (y>4.5)){
	mov	a,r4
	jnz	L016085?
	ljmp	L016026?
L016085?:
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	mov	a,#0x90
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fsgt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
	mov	a,r2
	jz	L016026?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:370: printf("FORWARD RIGHT    045 \n");
	push	ar3
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_15
	push	acc
	mov	a,#(__str_15 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:371: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:372: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:373: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:374: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:375: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:376: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:377: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:378: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	pop	ar3
L016026?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:383: if((x<2.0) && (y<2.0)){
	mov	a,r3
	jnz	L016087?
	ljmp	L016029?
L016087?:
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
	mov	a,r2
	jz	L016029?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:384: printf("BACKWARD LEFT    225 \n");
	push	ar4
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	a,#__str_16
	push	acc
	mov	a,#(__str_16 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:385: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:386: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:387: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:388: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:389: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:390: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:391: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:392: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	pop	ar1
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar4
L016029?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:397: if((x>4.5) && (y<2.0)){
	mov	a,r4
	jz	L016032?
	clr	a
	push	acc
	push	acc
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	mov	a,r1
	lcall	___fslt
	mov	r2,dpl
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	a,r2
	jz	L016032?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:398: printf("BACKWARD RIGHT   135 \n");
	mov	a,#__str_17
	push	acc
	mov	a,#(__str_17 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:399: printf("\n");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:400: InitializationSignal();
	lcall	_InitializationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:401: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:402: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:403: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:404: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:405: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:406: printf("\r");	}
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
L016032?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:409: if(STOP==0){	//pressed
	jnb	_P2_4,L016091?
	ljmp	L016037?
L016091?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:410: printf("Signal Transmission Stopped-----");
	mov	a,#__str_18
	push	acc
	mov	a,#(__str_18 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:411: TerminationSignal();
	lcall	_TerminationSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:412: main();}//to jump back to main
	lcall	_main
	ljmp	L016037?
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;n                         Allocated with name '_main_n_1_93'
;j                         Allocated to registers 
;f                         Allocated to registers r2 r3 r4 r5 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:418: void main (void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:423: waitms(500); // Give PuTTy a chance to start before sending
	mov	dptr,#0x01F4
	lcall	_waitms
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:424: printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
	mov	a,#__str_19
	push	acc
	mov	a,#(__str_19 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:426: "Check pins P2.0 and P2.1 with the oscilloscope.\r\n");
	mov	a,#__str_20
	push	acc
	mov	a,#(__str_20 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:429: InitPinADC(2, 2); // Configure P2.2 as analog input
	mov	_InitPinADC_PARM_2,#0x02
	mov	dpl,#0x02
	lcall	_InitPinADC
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:430: InitPinADC(2, 3); // Configure P2.3 as analog input
	mov	_InitPinADC_PARM_2,#0x03
	mov	dpl,#0x02
	lcall	_InitPinADC
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:431: InitADC();
	lcall	_InitADC
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:433: while(1)
L017008?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:438: TR2=0; // Stop timer 2
	clr	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:439: TMR2RL=0x10000L-j; // Change reload value for new frequency
	mov	_TMR2RL,#0xCF
	mov	(_TMR2RL >> 8),#0xF6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:440: TR2=1; // Start timer 2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:441: f=SYSCLK/(2L*(0x10000L-TMR2RL));
	mov	r2,_TMR2RL
	mov	r3,(_TMR2RL >> 8)
	mov	r4,#0x00
	clr	a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r5
	mov	r5,a
	mov	a,r2
	add	a,r2
	mov	__divslong_PARM_2,a
	mov	a,r3
	rlc	a
	mov	(__divslong_PARM_2 + 1),a
	mov	a,r4
	rlc	a
	mov	(__divslong_PARM_2 + 2),a
	mov	a,r5
	rlc	a
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0xA200
	mov	b,#0x4A
	mov	a,#0x04
	lcall	__divslong
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:442: printf("\nActual frequency: %lu\n", f);
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xf9
	mov	sp,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:448: "Press STOP button to stop signal transmission \n");
	mov	a,#__str_21
	push	acc
	mov	a,#(__str_21 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:449: scanf("%d", &n);
	mov	a,#_main_n_1_93
	push	acc
	mov	a,#(_main_n_1_93 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_22
	push	acc
	mov	a,#(__str_22 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_scanf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:450: if(n==1){	AdjustFrequency();		}
	mov	a,#0x01
	cjne	a,_main_n_1_93,L017016?
	clr	a
	cjne	a,(_main_n_1_93 + 1),L017016?
	clr	a
	cjne	a,(_main_n_1_93 + 2),L017016?
	clr	a
	cjne	a,(_main_n_1_93 + 3),L017016?
	sjmp	L017017?
L017016?:
	sjmp	L017002?
L017017?:
	lcall	_AdjustFrequency
L017002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:451: if(n==2){	AdjustWaveform();		}
	mov	a,#0x02
	cjne	a,_main_n_1_93,L017018?
	clr	a
	cjne	a,(_main_n_1_93 + 1),L017018?
	clr	a
	cjne	a,(_main_n_1_93 + 2),L017018?
	clr	a
	cjne	a,(_main_n_1_93 + 3),L017018?
	sjmp	L017019?
L017018?:
	sjmp	L017004?
L017019?:
	lcall	_AdjustWaveform
L017004?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\transmitter.c:452: if(n==3){	GetSignal();			}
	mov	a,#0x03
	cjne	a,_main_n_1_93,L017020?
	clr	a
	cjne	a,(_main_n_1_93 + 1),L017020?
	clr	a
	cjne	a,(_main_n_1_93 + 2),L017020?
	clr	a
	cjne	a,(_main_n_1_93 + 3),L017020?
	sjmp	L017021?
L017020?:
	ljmp	L017008?
L017021?:
	lcall	_GetSignal
	ljmp	L017008?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 'New frequency='
	db 0x00
__str_1:
	db '%lu'
	db 0x00
__str_2:
	db 'Sorry %lu Hz is out of range.'
	db 0x0A
	db 0x00
__str_3:
	db 0x0A
	db 'Actual frequency: %lu'
	db 0x0A
	db 0x00
__str_4:
	db '1'
	db 0x00
__str_5:
	db '0'
	db 0x00
__str_6:
	db '----------'
	db 0x00
__str_7:
	db 0x0A
	db 0x00
__str_8:
	db 'PAUSED           --- '
	db 0x0D
	db 0x00
__str_9:
	db 0x0D
	db 0x00
__str_10:
	db 'BACKWARD         180 '
	db 0x0D
	db 0x00
__str_11:
	db 'LEFT             270 '
	db 0x0D
	db 0x00
__str_12:
	db 'RIGHT            090 '
	db 0x0D
	db 0x00
__str_13:
	db 'FORWARD          000 '
	db 0x0D
	db 0x00
__str_14:
	db 'FORWARD LEFT     315 '
	db 0x0D
	db 0x00
__str_15:
	db 'FORWARD RIGHT    045 '
	db 0x0A
	db 0x00
__str_16:
	db 'BACKWARD LEFT    225 '
	db 0x0A
	db 0x00
__str_17:
	db 'BACKWARD RIGHT   135 '
	db 0x0A
	db 0x00
__str_18:
	db 'Signal Transmission Stopped-----'
	db 0x00
__str_19:
	db 0x1B
	db '[2J'
	db 0x00
__str_20:
	db 'Variable frequency generator for the EFM8LB1.'
	db 0x0D
	db 0x0A
	db 'Check pins P2'
	db '.0 and P2.1 with the oscilloscope.'
	db 0x0D
	db 0x0A
	db 0x00
__str_21:
	db 'Menu: '
	db 0x0A
	db '1:Adjust Frequency '
	db 0x0A
	db '2:Adjust Waveform '
	db 0x0A
	db '3:Start Signal'
	db ' Transmission '
	db 0x0A
	db 'Press STOP button to stop signal transmission'
	db ' '
	db 0x0A
	db 0x00
__str_22:
	db '%d'
	db 0x00

	CSEG

end
