;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
; This file was generated Thu Mar 29 15:06:39 2018
;--------------------------------------------------------
$name Baud_Rate
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
	public _main
	public _SendSignal
	public _IniSignal
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
_AdjustFrequency_f_1_52:
	ds 4
_main_n_1_75:
	ds 4
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:34: char _c51_external_startup (void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:37: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:38: WDTCN = 0xDE; //First key
	mov	_WDTCN,#0xDE
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:39: WDTCN = 0xAD; //Second key
	mov	_WDTCN,#0xAD
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:41: VDM0CN |= 0x80;
	orl	_VDM0CN,#0x80
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:42: RSTSRC = 0x02;
	mov	_RSTSRC,#0x02
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:49: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:50: PFE0CN  = 0x20; // SYSCLK < 75 MHz.
	mov	_PFE0CN,#0x20
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:51: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:72: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:73: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:74: while ((CLKSEL & 0x80) == 0);
L002001?:
	mov	a,_CLKSEL
	jnb	acc.7,L002001?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:75: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:76: CLKSEL = 0x03;
	mov	_CLKSEL,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:77: while ((CLKSEL & 0x80) == 0);
L002004?:
	mov	a,_CLKSEL
	jnb	acc.7,L002004?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:83: P2MDOUT|=0b_0000_0011;
	orl	_P2MDOUT,#0x03
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:84: P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	orl	_P0MDOUT,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:85: XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	mov	_XBR0,#0x01
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:86: XBR1     = 0X10; // Enable T0 on P0.0
	mov	_XBR1,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:87: XBR2     = 0x40; // Enable crossbar and weak pull-ups
	mov	_XBR2,#0x40
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:93: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:94: CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	mov	_CKCON0,_CKCON0
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:95: TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	mov	_TH1,#0xE6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:96: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:97: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:98: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:99: TR1 = 1; // START Timer1
	setb	_TR1
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:100: TI = 1;  // Indicate TX0 ready
	setb	_TI
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:103: TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	mov	_TMR2CN0,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:104: CKCON0|=0b_0001_0000;
	orl	_CKCON0,#0x10
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:105: TMR2RL=(-(SYSCLK/(2*DEFAULT_F))); // Initialize reload value
	mov	_TMR2RL,#0xEE
	mov	(_TMR2RL >> 8),#0xF6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:106: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:107: ET2=1;         // Enable Timer2 interrupts
	setb	_ET2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:108: TR2=1;         // Start Timer2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:109: EA=1; // Global interrupt enable
	setb	_EA
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:111: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:114: void Timer2_ISR (void) interrupt INTERRUPT_TIMER2
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
	push	acc
	push	ar2
	push	psw
	mov	psw,#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:116: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:117: OUTPUT0=!OUTPUT0;
	mov	a,_OUTPUT0
	orl	a,(_OUTPUT0 + 1)
	cjne	a,#0x01,L003003?
L003003?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:118: OUTPUT1=!OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L003004?
L003004?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT1,r2
	mov	(_OUTPUT1 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:122: OUT0=OUTPUT0;
	mov	a,_OUTPUT0
	orl	a,(_OUTPUT0 + 1)
	add	a,#0xff
	mov	_P2_0,c
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:123: OUT1=OUTPUT1;
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:127: void Timer3us(unsigned char us)
;	-----------------------------------------
;	 function Timer3us
;	-----------------------------------------
_Timer3us:
	mov	r2,dpl
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:132: CKCON0|=0b_0100_0000;
	orl	_CKCON0,#0x40
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:134: TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	mov	_TMR3RL,#0xB8
	mov	(_TMR3RL >> 8),#0xFF
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:135: TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	mov	_TMR3,_TMR3RL
	mov	(_TMR3 >> 8),(_TMR3RL >> 8)
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:137: TMR3CN0 = 0x04;                 // Sart Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x04
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:138: for (i = 0; i < us; i++)       // Count <us> overflows
	mov	r3,#0x00
L004004?:
	clr	c
	mov	a,r3
	subb	a,r2
	jnc	L004007?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:140: while (!(TMR3CN0 & 0x80));  // Wait for overflow
L004001?:
	mov	a,_TMR3CN0
	jnb	acc.7,L004001?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:141: TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	anl	_TMR3CN0,#0x7F
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:138: for (i = 0; i < us; i++)       // Count <us> overflows
	inc	r3
	sjmp	L004004?
L004007?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:143: TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r4 r5 
;k                         Allocated to registers r6 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:146: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:150: for(j=0; j<ms; j++)
	mov	r4,#0x00
	mov	r5,#0x00
L005005?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	L005009?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:151: for (k=0; k<4; k++) Timer3us(250);
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:150: for(j=0; j<ms; j++)
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
;f                         Allocated with name '_AdjustFrequency_f_1_52'
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:155: void AdjustFrequency (void)
;	-----------------------------------------
;	 function AdjustFrequency
;	-----------------------------------------
_AdjustFrequency:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:158: while(1){
L006005?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:159: printf("New frequency=");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:160: scanf("%lu", &f);
	mov	a,#_AdjustFrequency_f_1_52
	push	acc
	mov	a,#(_AdjustFrequency_f_1_52 >> 8)
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:161: x=(SYSCLK/(2L*f));
	mov	a,_AdjustFrequency_f_1_52
	add	a,_AdjustFrequency_f_1_52
	mov	__divulong_PARM_2,a
	mov	a,(_AdjustFrequency_f_1_52 + 1)
	rlc	a
	mov	(__divulong_PARM_2 + 1),a
	mov	a,(_AdjustFrequency_f_1_52 + 2)
	rlc	a
	mov	(__divulong_PARM_2 + 2),a
	mov	a,(_AdjustFrequency_f_1_52 + 3)
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:162: if(x>0xffff)
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:164: printf("Sorry %lu Hz is out of range.\n", f);
	push	_AdjustFrequency_f_1_52
	push	(_AdjustFrequency_f_1_52 + 1)
	push	(_AdjustFrequency_f_1_52 + 2)
	push	(_AdjustFrequency_f_1_52 + 3)
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:168: TR2=0; // Stop timer 2
	clr	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:169: TMR2RL=0x10000L-x; // Change reload value for new frequency
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:170: TR2=1; // Start timer 2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:171: f=SYSCLK/(2L*(0x10000L-TMR2RL));
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
	mov	_AdjustFrequency_f_1_52,r2
	mov	(_AdjustFrequency_f_1_52 + 1),r3
	mov	(_AdjustFrequency_f_1_52 + 2),r4
	mov	(_AdjustFrequency_f_1_52 + 3),r5
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:172: printf("\nActual frequency: %lu\n", f);
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:176: void AdjustWaveform (void)
;	-----------------------------------------
;	 function AdjustWaveform
;	-----------------------------------------
_AdjustWaveform:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:178: while(1){
L007005?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:179: if(Button==0){//pressed
	jb	_P2_2,L007002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:180: OUTPUT0=1;
	mov	_OUTPUT0,#0x01
	clr	a
	mov	(_OUTPUT0 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:181: OUTPUT1=1;
	mov	_OUTPUT1,#0x01
	clr	a
	mov	(_OUTPUT1 + 1),a
	sjmp	L007005?
L007002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:185: OUTPUT0=!OUTPUT1;
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:190: void LogicOne (void)
;	-----------------------------------------
;	 function LogicOne
;	-----------------------------------------
_LogicOne:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:192: OUTPUT0=!OUTPUT1;
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L008003?
L008003?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:193: waitms(500);//1
	mov	dptr,#0x01F4
	lcall	_waitms
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:194: printf("1");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:197: void LogicZero (void)
;	-----------------------------------------
;	 function LogicZero
;	-----------------------------------------
_LogicZero:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:199: OUTPUT0=1;
	mov	_OUTPUT0,#0x01
	clr	a
	mov	(_OUTPUT0 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:200: OUTPUT1=1;
	mov	_OUTPUT1,#0x01
	clr	a
	mov	(_OUTPUT1 + 1),a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:201: waitms(500);//0
	mov	dptr,#0x01F4
	lcall	_waitms
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:202: printf("0");	
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
;Allocation info for local variables in function 'IniSignal'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:205: void IniSignal (void)
;	-----------------------------------------
;	 function IniSignal
;	-----------------------------------------
_IniSignal:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:208: printf("initialize signal: 01110 \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:209: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:210: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:211: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:212: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:213: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:214: printf("\n");
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
;Allocation info for local variables in function 'SendSignal'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:217: void SendSignal (void)
;	-----------------------------------------
;	 function SendSignal
;	-----------------------------------------
_SendSignal:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:220: while(1){
L011010?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:222: if(FORWARD==0){
	jb	_P2_6,L011002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:223: printf("forward \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:224: IniSignal();
	lcall	_IniSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:226: printf("Signal: 11001 \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:227: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:228: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:229: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:230: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:231: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:232: printf("\n\n");
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
L011002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:235: if(BACKWARD==0){
	jb	_P2_4,L011004?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:236: printf("backward \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:237: IniSignal();
	lcall	_IniSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:239: printf("Signal: 10011 \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:240: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:241: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:242: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:243: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:244: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:245: printf("\n\n");
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
L011004?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:248: if(LEFT==0){
	jb	_P1_6,L011006?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:249: printf("left \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:250: IniSignal();
	lcall	_IniSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:252: printf("Signal: 01001 \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:253: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:254: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:255: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:256: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:257: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:258: printf("\n\n");
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
L011006?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:261: if(RIGHT==0){
	jnb	_P1_4,L011022?
	ljmp	L011010?
L011022?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:262: printf("right \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:263: IniSignal();
	lcall	_IniSignal
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:265: printf("Signal: 01010 \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:266: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:267: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:268: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:269: LogicOne();
	lcall	_LogicOne
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:270: LogicZero();
	lcall	_LogicZero
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:271: printf("\n\n");
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
	ljmp	L011010?
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;n                         Allocated with name '_main_n_1_75'
;x                         Allocated to registers 
;f                         Allocated to registers r2 r3 r4 r5 
;------------------------------------------------------------
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:276: void main (void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:280: OUTPUT0=!OUTPUT1;	
	mov	a,_OUTPUT1
	orl	a,(_OUTPUT1 + 1)
	cjne	a,#0x01,L012012?
L012012?:
	clr	a
	rlc	a
	mov	r2,a
	mov	_OUTPUT0,r2
	mov	(_OUTPUT0 + 1),#0x00
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:281: printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:283: "Check pins P2.0 and P2.1 with the oscilloscope.\r\n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:288: TR2=0; // Stop timer 2
	clr	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:289: TMR2RL=0x10000L-x; // Change reload value for new frequency
	mov	_TMR2RL,#0xCF
	mov	(_TMR2RL >> 8),#0xF6
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:290: TR2=1; // Start timer 2
	setb	_TR2
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:291: f=SYSCLK/(2L*(0x10000L-TMR2RL));
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:292: printf("\nActual frequency: %lu\n", f);
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:300: "2:Send Signal \n");
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
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:302: scanf("%d", &n);
	mov	a,#_main_n_1_75
	push	acc
	mov	a,#(_main_n_1_75 >> 8)
	push	acc
	mov	a,#0x40
	push	acc
	mov	a,#__str_20
	push	acc
	mov	a,#(__str_20 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_scanf
	mov	a,sp
	add	a,#0xfa
	mov	sp,a
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:304: if(n==0){
	mov	a,_main_n_1_75
	orl	a,(_main_n_1_75 + 1)
	orl	a,(_main_n_1_75 + 2)
	orl	a,(_main_n_1_75 + 3)
	jnz	L012002?
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:305: AdjustFrequency();
	lcall	_AdjustFrequency
L012002?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:308: if(n==1){
	mov	a,#0x01
	cjne	a,_main_n_1_75,L012014?
	clr	a
	cjne	a,(_main_n_1_75 + 1),L012014?
	clr	a
	cjne	a,(_main_n_1_75 + 2),L012014?
	clr	a
	cjne	a,(_main_n_1_75 + 3),L012014?
	sjmp	L012015?
L012014?:
	sjmp	L012004?
L012015?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:309: AdjustWaveform();
	lcall	_AdjustWaveform
L012004?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:311: if(n==2){
	mov	a,#0x02
	cjne	a,_main_n_1_75,L012016?
	clr	a
	cjne	a,(_main_n_1_75 + 1),L012016?
	clr	a
	cjne	a,(_main_n_1_75 + 2),L012016?
	clr	a
	cjne	a,(_main_n_1_75 + 3),L012016?
	sjmp	L012017?
L012016?:
	ret
L012017?:
;	C:\Users\user\Documents\Education\School\2018\ELEC 291\Project 2\Baud-Rate.c:312: SendSignal();
	ljmp	_SendSignal
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
	db 'initialize signal: 01110 '
	db 0x0A
	db 0x00
__str_7:
	db 0x0A
	db 0x00
__str_8:
	db 'forward '
	db 0x0A
	db 0x00
__str_9:
	db 'Signal: 11001 '
	db 0x0A
	db 0x00
__str_10:
	db 0x0A
	db 0x0A
	db 0x00
__str_11:
	db 'backward '
	db 0x0A
	db 0x00
__str_12:
	db 'Signal: 10011 '
	db 0x0A
	db 0x00
__str_13:
	db 'left '
	db 0x0A
	db 0x00
__str_14:
	db 'Signal: 01001 '
	db 0x0A
	db 0x00
__str_15:
	db 'right '
	db 0x0A
	db 0x00
__str_16:
	db 'Signal: 01010 '
	db 0x0A
	db 0x00
__str_17:
	db 0x1B
	db '[2J'
	db 0x00
__str_18:
	db 'Variable frequency generator for the EFM8LB1.'
	db 0x0D
	db 0x0A
	db 'Check pins P2'
	db '.0 and P2.1 with the oscilloscope.'
	db 0x0D
	db 0x0A
	db 0x00
__str_19:
	db 'Menu: '
	db 0x0A
	db '0:Adjust Frequency '
	db 0x0A
	db '1:Adjust Waveform '
	db 0x0A
	db '2:Send Signal '
	db 0x0A
	db 0x00
__str_20:
	db '%d'
	db 0x00

	CSEG

end
