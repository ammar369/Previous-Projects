//  freq_gen.c: Uses timer 2 interrupt to generate a square wave at pins
//  P2.0 and P2.1.  The program allows the user to enter a frequency.
//  Copyright (c) 2010-2018 Jesus Calvino-Fraga
//  ~C51~

#include <EFM8LB1.h>
#include <stdlib.h>
#include <stdio.h>


#define SYSCLK    72000000L // SYSCLK frequency in Hz
#define BAUDRATE  115200L   // Baud rate of UART in bps
#define DEFAULT_F 15500L

#define OUT0 P2_0
#define OUT1 P2_1
#define Button P2_2
#define FORWARD P2_6
#define BACKWARD P2_4
#define LEFT P1_6
#define RIGHT P1_4

#define SIGSTA 01110
#define SIGFORWARD 11001
#define SIGBACKWARD 10011
#define SIGLEFT 01001
#define SIGRIGHT 01010


volatile unsigned int OUTPUT0;
volatile unsigned int OUTPUT1;


char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	SFRPAGE = 0x00;
	WDTCN = 0xDE; //First key
	WDTCN = 0xAD; //Second key
  
	VDM0CN |= 0x80;
	RSTSRC = 0x02;

	#if (SYSCLK == 48000000L)	
		SFRPAGE = 0x10;
		PFE0CN  = 0x10; // SYSCLK < 50 MHz.
		SFRPAGE = 0x00;
	#elif (SYSCLK == 72000000L)
		SFRPAGE = 0x10;
		PFE0CN  = 0x20; // SYSCLK < 75 MHz.
		SFRPAGE = 0x00;
	#endif
	
	#if (SYSCLK == 12250000L)
		CLKSEL = 0x10;
		CLKSEL = 0x10;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 24500000L)
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 48000000L)	
		// Before setting clock to 48 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x07;
		CLKSEL = 0x07;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 72000000L)
		// Before setting clock to 72 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x03;
		CLKSEL = 0x03;
		while ((CLKSEL & 0x80) == 0);
	#else
		#error SYSCLK must be either 12250000L, 24500000L, 48000000L, or 72000000L
	#endif
	
	// Configure the pins used for square output
	P2MDOUT|=0b_0000_0011;
	P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0X10; // Enable T0 on P0.0
	XBR2     = 0x40; // Enable crossbar and weak pull-ups

	#if (((SYSCLK/BAUDRATE)/(2L*12L))>0xFFL)
		#error Timer 0 reload value is incorrect because (SYSCLK/BAUDRATE)/(2L*12L) > 0xFF
	#endif
	// Configure Uart 0
	SCON0 = 0x10;
	CKCON0 |= 0b_0000_0000 ; // Timer 1 uses the system clock divided by 12.
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready

	// Initialize timer 2 for periodic interrupts
	TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	CKCON0|=0b_0001_0000;
	TMR2RL=(-(SYSCLK/(2*DEFAULT_F))); // Initialize reload value
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2
	EA=1; // Global interrupt enable
	
	return 0;
}

void Timer2_ISR (void) interrupt INTERRUPT_TIMER2
{
	TF2H = 0; // Clear Timer2 interrupt flag
	OUTPUT0=!OUTPUT0;
	OUTPUT1=!OUTPUT1;
	
	
	
	OUT0=OUTPUT0;
	OUT1=OUTPUT1;
}

// Uses Timer3 to delay <us> micro-seconds. 
void Timer3us(unsigned char us)
{
	unsigned char i;               // usec counter
	
	// The input for Timer 3 is selected as SYSCLK by setting T3ML (bit 6) of CKCON0:
	CKCON0|=0b_0100_0000;
	
	TMR3RL = (-(SYSCLK)/1000000L); // Set Timer3 to overflow in 1us.
	TMR3 = TMR3RL;                 // Initialize Timer3 for first overflow
	
	TMR3CN0 = 0x04;                 // Sart Timer3 and clear overflow flag
	for (i = 0; i < us; i++)       // Count <us> overflows
	{
		while (!(TMR3CN0 & 0x80));  // Wait for overflow
		TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	}
	TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
}

void waitms (unsigned int ms)
{
	unsigned int j;
	unsigned char k;
	for(j=0; j<ms; j++)
		for (k=0; k<4; k++) Timer3us(250);
}


void AdjustFrequency (void)
{
	unsigned long int x, f;
	while(1){
		printf("New frequency=");
		scanf("%lu", &f);
		x=(SYSCLK/(2L*f));
		if(x>0xffff)
		{
			printf("Sorry %lu Hz is out of range.\n", f);
		}
		else
		{
			TR2=0; // Stop timer 2
			TMR2RL=0x10000L-x; // Change reload value for new frequency
			TR2=1; // Start timer 2
			f=SYSCLK/(2L*(0x10000L-TMR2RL));
			printf("\nActual frequency: %lu\n", f);
 		}
	}
}
void AdjustWaveform (void)
{
	while(1){
		if(Button==0){//pressed
			OUTPUT0=1;
			OUTPUT1=1;
		}
		else{
		
			OUTPUT0=!OUTPUT1;
		}
	}
}

void LogicOne (void)
{
	OUTPUT0=!OUTPUT1;
	waitms(500);//1
	printf("1");
}

void LogicZero (void)
{
	OUTPUT0=1;
	OUTPUT1=1;
	waitms(500);//0
	printf("0");	
}

void IniSignal (void)
{
	//start signal: 01110
	printf("initialize signal: 01110 \n");
	LogicZero();
	LogicOne();
	LogicOne();
	LogicOne();
	LogicZero();
	printf("\n");
}

void SendSignal (void)
{

	while(1){
		
		if(FORWARD==0){
			printf("forward \n");
			IniSignal();
			//forward signal 11001
			printf("Signal: 11001 \n");
			LogicOne();
			LogicOne();
			LogicZero();
			LogicZero();
			LogicOne();
			printf("\n\n");
		}
	
		if(BACKWARD==0){
			printf("backward \n");
			IniSignal();
			//backward signal 10011
			printf("Signal: 10011 \n");
			LogicOne();
			LogicZero();
			LogicZero();
			LogicOne();
			LogicOne();
			printf("\n\n");
		}
		
		if(LEFT==0){
			printf("left \n");
			IniSignal();
			//left signal 01001
			printf("Signal: 01001 \n");
			LogicZero();
			LogicOne();
			LogicZero();
			LogicZero();
			LogicOne();
			printf("\n\n");
		}
		
		if(RIGHT==0){
			printf("right \n");
			IniSignal();
			//right signal 01010
			printf("Signal: 01010 \n");
			LogicZero();
			LogicOne();
			LogicZero();
			LogicOne();
			LogicZero();
			printf("\n\n");
		}	
	}
}

void main (void)
{
	unsigned long int n;
	unsigned long int x, f;
	OUTPUT0=!OUTPUT1;	
	printf("\x1b[2J"); // Clear screen using ANSI escape sequence.
	printf("Variable frequency generator for the EFM8LB1.\r\n"
	       "Check pins P2.0 and P2.1 with the oscilloscope.\r\n");
	
	f=15295;
		x=(SYSCLK/(2L*f));
		
			TR2=0; // Stop timer 2
			TMR2RL=0x10000L-x; // Change reload value for new frequency
			TR2=1; // Start timer 2
			f=SYSCLK/(2L*(0x10000L-TMR2RL));
			printf("\nActual frequency: %lu\n", f);
 	



	printf("Menu: \n"
	       "0:Adjust Frequency \n" 
	       "1:Adjust Waveform \n"
	       "2:Send Signal \n");
	
	scanf("%d", &n);

	if(n==0){
		AdjustFrequency();
	}
	
	if(n==1){
		AdjustWaveform();
	}
	if(n==2){
		SendSignal();
	}
}

