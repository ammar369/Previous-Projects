
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
#define Button P2_6
#define SENSOR P2_5
#define STOP P2_4
//x and y inputs from the joystick will be pins 2.2 and 2.3 respectively(x is yellow, y is green)
#define VDD 4.8 // The measured value of VDD in volts


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
	
	TMR3CN0 = 0x04;                 // Start Timer3 and clear overflow flag
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
	waitms(100);//1
	printf("1");
}

void LogicZero (void)
{
	OUTPUT0=0;
	OUTPUT1=0;
	waitms(100);//0
	printf("0");	
}

void InitADC (void)
{
	SFRPAGE = 0x00;
	ADC0CN1 = 0b_10_000_000; //14-bit,  Right justified no shifting applied, perform and Accumulate 1 conversion.
	ADC0CF0 = 0b_11111_0_00; // SYSCLK/32
	ADC0CF1 = 0b_0_0_011110; // Same as default for now
	ADC0CN0 = 0b_0_0_0_0_0_00_0; // Same as default for now
	ADC0CF2 = 0b_0_01_11111 ; // GND pin, Vref=VDD
	ADC0CN2 = 0b_0_000_0000;  // Same as default for now. ADC0 conversion initiated on write of 1 to ADBUSY.
	ADEN=1; // Enable ADC
}

void InitPinADC (unsigned char portno, unsigned char pinno)
{
	unsigned char mask;
	
	mask=1<<pinno;

	SFRPAGE = 0x20;
	switch (portno)
	{
		case 0:
			P0MDIN &= (~mask); // Set pin as analog input
			P0SKIP |= mask; // Skip Crossbar decoding for this pin
		break;
		case 1:
			P1MDIN &= (~mask); // Set pin as analog input
			P1SKIP |= mask; // Skip Crossbar decoding for this pin
		break;
		case 2:
			P2MDIN &= (~mask); // Set pin as analog input
			P2SKIP |= mask; // Skip Crossbar decoding for this pin
		break;
		default:
		break;
	}
	SFRPAGE = 0x00;
}

unsigned int ADC_at_Pin(unsigned char pin)
{
	ADC0MX = pin;   // Select input from pin
	ADBUSY=1;       // Dummy conversion first to select new pin
	while (ADBUSY); // Wait for dummy conversion to finish
	ADBUSY = 1;     // Convert voltage at the pin
	while (ADBUSY); // Wait for conversion to complete
	return (ADC0);
}

float Volts_at_Pin(unsigned char pin)
{
	 return ((ADC_at_Pin(pin)*VDD)/0b_0011_1111_1111_1111);
}

void InitializationSignal (void)
{
	//initialize signal: 10101
	LogicOne();
	LogicZero();
	LogicOne();
	LogicZero();
	LogicOne();
	printf("-----");
}

void TerminationSignal (void)
{
	//terminate signal: 10001
	LogicOne();
	LogicZero();
	LogicZero();
	LogicZero();
	LogicOne();
	printf("\n");
}

void GetSignal (void)
{
	float x;
	float y;
	
	while(1){
	// Read 14-bit value from the pins configured as analog inputs
	x = Volts_at_Pin(QFP32_MUX_P2_2);
	y = Volts_at_Pin(QFP32_MUX_P2_3);

/*****************************************************************************/
//PAUSED, 00000
	if((x>2.0) && (x<4.5) && (y>2.0) && (y<4.5))  {
							printf("PAUSED     --- \r\n");
							LogicZero();
							LogicZero();
							LogicZero();
							LogicZero();
							LogicZero();	}	
/*****************************************************************************/
							
/*****************************************************************************/
//BACKWARD, 10010 
	if((x>2.0) && (x<4.5) && (y<2.0)) {
							printf("BACKWARD     180 \r\n");
							InitializationSignal();
							LogicOne();
							LogicZero();
							LogicZero();
							LogicOne();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/

/*****************************************************************************/
//LEFT, 00100
	if((x<2.0) && (y>2.0) && (y<4.5)) {
							printf("LEFT     270 \r\n");
							InitializationSignal();
							LogicZero();
							LogicZero();
							LogicOne();
							LogicZero();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/
//RIGHT, 00110
	if((x>4.5) && (y>2.0) && (y<4.5)){
							printf("RIGHT     090 \r\n");
							InitializationSignal();
							LogicZero();
							LogicZero();
							LogicOne();
							LogicOne();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/							
//FORWARD, 11111
	if((x>2.0) && (x<4.5) && (y>4.5)){
							printf("FORWARD     000 \r\n");
							InitializationSignal();
							LogicOne();
							LogicOne();
							LogicOne();
							LogicOne();
							LogicOne();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/							
//FORWARD LEFT, 01000
	if((x<2.0) && (y>4.5)){
							printf("FORWARD LEFT     315 \r\n");
							InitializationSignal();
							LogicZero();
							LogicOne();
							LogicZero();
							LogicZero();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/							
//FORWARD RIGHT, 01110
	if((x>4.5) && (y>4.5)){
							printf("FORWARD RIGHT     045 \r\n");
							InitializationSignal();
							LogicZero();
							LogicOne();
							LogicOne();
							LogicOne();
							LogicZero();
							printf("\r");	}
/*****************************************************************************/	

/*****************************************************************************/							
//BACKWARD LEFT, 01100
	if((x<2.0) && (y<2.0)){
							printf("BACKWARD LEFT     225 \r\n");
							InitializationSignal();
							LogicZero();
							LogicOne();
							LogicOne();
							LogicZero();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/							
//BACKWARD RIGHT, 01010
	if((x>4.5) && (y<2.0)){
							printf("BACKWARD RIGHT     135 \r\n");
							InitializationSignal();
							LogicZero();
							LogicOne();
							LogicZero();
							LogicOne();
							LogicZero();
							printf("\n");	}
/*****************************************************************************/	

/*****************************************************************************/							
//DISTANCE SENSOR TOGGLE BUTTON, 11011
	if(SENSOR==0){
							printf("DISTANCE SENSOR TOGGLED\r\n");
							printf("\n\r");
							InitializationSignal();
							LogicOne();
							LogicOne();
							LogicZero();
							LogicOne();
							LogicOne();
							printf("\r");	}
/*****************************************************************************/
		
	if(STOP==0){	//pressed
			printf("Signal Transmission Stopped \r\n");
			TerminationSignal();
			}//to jump back to main
}
}



void main (void)
{
	unsigned long int n;
	unsigned long int j, f;
	
	waitms(500); // Give PuTTy a chance to start before sending
			
	//configuring ADC pins
	InitPinADC(2, 2); // Configure P2.2 as analog input
	InitPinADC(2, 3); // Configure P2.3 as analog input
    InitADC();
 	
	while(1)
	{
		//Set Frequency
		f=15295;
		j=(SYSCLK/(2L*f));
		TR2=0; // Stop timer 2
		TMR2RL=0x10000L-j; // Change reload value for new frequency
		TR2=1; // Start timer 2
		f=SYSCLK/(2L*(0x10000L-TMR2RL));
		printf("\nActual frequency: %lu\n", f);
		
		printf("Menu: \n"
		"1:Adjust Frequency \n" 
		"2:Adjust Waveform \n"
		"3:Start Signal Transmission \n"
		"Press STOP button to stop signal transmission \n");
		scanf("%d", &n);
		if(n==1){	AdjustFrequency();		}
		if(n==2){	AdjustWaveform();		}
		if(n==3){	GetSignal();			}
		
	 }  
}

