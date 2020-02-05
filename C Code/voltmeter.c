// ADC.c:  Shows how to use the 14-bit ADC.  This program
// measures the voltage from some pins of the EFM8LB1 using the ADC.
//
// (c) 2008-2018, Jesus Calvino-Fraga
//

#include <stdio.h>
#include <stdlib.h>
#include <EFM8LB1.h>

// ~C51~  

#define SYSCLK 72000000L
#define BAUDRATE 115200L

#define LCD_RS P2_6
// #define LCD_RW Px_x // Not used in this code.  Connect to GND
#define LCD_E  P2_5
#define LCD_D4 P2_4
#define LCD_D5 P2_3
#define LCD_D6 P2_2
#define LCD_D7 P2_1
#define CHARS_PER_LINE 16

unsigned char overflow_count;

char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	SFRPAGE = 0x00;
	WDTCN = 0xDE; //First key
	WDTCN = 0xAD; //Second key
  
	VDM0CN=0x80;       // enable VDD monitor
	RSTSRC=0x02|0x04;  // Enable reset on missing clock detector and VDD

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
	
	P0MDOUT |= 0x10; // Enable UART0 TX as push-pull output
	XBR0     = 0x01; // Enable UART0 on P0.4(TX) and P0.5(RX)                     
	XBR1     = 0X00;
	XBR2     = 0x40; // Enable crossbar and weak pull-ups

	// Configure Uart 0
	#if (((SYSCLK/BAUDRATE)/(2L*12L))>0xFFL)
		#error Timer 0 reload value is incorrect because (SYSCLK/BAUDRATE)/(2L*12L) > 0xFF
	#endif
	SCON0 = 0x10;
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(2L*12L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; // START Timer1
	TI = 1;  // Indicate TX0 ready
  	
	return 0;
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

#define VDD 3.3035 // The measured value of VDD in volts

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

void TIMER0_Init(void)
{
	TMOD&=0b_1111_0000; // Set the bits of Timer/Counter 0 to zero
	TMOD|=0b_0000_0101; // Timer/Counter 0 used as a 16-bit counter
	TR0=0; // Stop Timer/Counter 0
}

void LCD_pulse (void)
{
	LCD_E=1;
	Timer3us(40);
	LCD_E=0;
}

void LCD_byte (unsigned char x)
{
	// The accumulator in the C8051Fxxx is bit addressable!
	ACC=x; //Send high nible
	LCD_D7=ACC_7;
	LCD_D6=ACC_6;
	LCD_D5=ACC_5;
	LCD_D4=ACC_4;
	LCD_pulse();
	Timer3us(40);
	ACC=x; //Send low nible
	LCD_D7=ACC_3;
	LCD_D6=ACC_2;
	LCD_D5=ACC_1;
	LCD_D4=ACC_0;
	LCD_pulse();
}

void WriteData (unsigned char x)
{
	LCD_RS=1;
	LCD_byte(x);
	waitms(2);
}

void WriteCommand (unsigned char x)
{
	LCD_RS=0;
	LCD_byte(x);
	waitms(5);
}

void LCDprint(char * string, unsigned char line, bit clear)
{
	int j;

	WriteCommand(line==2?0xc0:0x80);
	waitms(5);
	for(j=0; string[j]!=0; j++)	WriteData(string[j]);// Write the message
	if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); // Clear the rest of the line
}

void LCD_4BIT (void)
{
	LCD_E=0; // Resting state of LCD's enable is zero
	// LCD_RW=0; // We are only writing to the LCD in this program
	waitms(20);
	// First make sure the LCD is in 8-bit mode and then change to 4-bit mode
	WriteCommand(0x33);
	WriteCommand(0x33);
	WriteCommand(0x32); // Change to 4-bit mode

	// Configure the LCD
	WriteCommand(0x28);
	WriteCommand(0x0c);
	WriteCommand(0x01); // Clear screen command (takes some time)
	waitms(20); // Wait for clear screen command to finsih.
}


void main (void)
{

//------Initializations----------------------------//	
	unsigned long diff, i, perdiv4, Period;
	float freq, phase, VTEST, VREF, sqrttwo, tdiff, period;
	char buff1[17];
	char buff2[17];
	InitPinADC(1, 5); // Configure P2.2 as analog input
	InitPinADC(1, 4); // Configure P2.3 as analog input
    InitADC();  //initailize ADC
	TIMER0_Init();  //initialize the Timer0
	LCD_4BIT();  // Configure the LCD
//-------------------------------------------------//
	
	
	
	while(1)
	{
	sqrttwo = 1.414213562;
//-----------------------------------------------//	 
// Measure half period at pin P1.7 using timer 0
TR0=0; // Stop timer 0
TMOD=0B_0000_0001; // Set timer 0 as 16-bit timer
TH0=0; TL0=0; // Reset the timer
while (P1_7==1); // Wait for the signal to be zero
while (P1_7==0); // Wait for the signal to be one
TR0=1; // Start timing
while (P1_7==1); // Wait for the signal to be zero
TR0=0; // Stop timer 0
// [TH0,TL0] is half the period in multiples of 12/CLK, so:
Period=(TH0*0x100+TL0)*2; // Assume Period is unsigned int
//-----------------------------------------------//
//standardize units of period to seconds
period = (Period * 12)/ SYSCLK; //period has to be float, it is in seconds
perdiv4= (period * 1000000) / 4;  //this gives one fourth of the period in micro-seconds
	 

//-------getting reference peak-------------------//
//get zero cross(high) of VREF (P1.5)
while (P1_5==1); // Wait for the signal to be zero
while (P1_5==0); // Wait for the signal to be one, going high
//wait for period/4 time
i = perdiv4;
while (i>0) {
	Timer3us (1); //this gives wait time of one microsecond
	i= i-1; }
//get peak voltage of reference at pin 1.5
VREF = Volts_at_Pin(QFP32_MUX_P1_5); 
//------------------------------------------------//


//-----getting test peak----------------------------//
//get zero cross(high) of VTEST (P1.4)
while (P1_4==1); // Wait for the signal to be zero
while (P1_4==0); // Wait for the signal to be one, going high
//wait for period/4 time
i = perdiv4;
while (i>0) {
	Timer3us (1); //this gives wait time of one microsecond
	i= i-1; }
//get peak voltage of test at pin 1.4
VTEST = Volts_at_Pin(QFP32_MUX_P1_4); 
//--------------------------------------------------//

//--------get time difference between reference and test-----//
//reset timer 0
TH0=0; TL0=0;
//zero cross of reference (P1.7)
while (P1_7==1); // Wait for the signal to be zero
while (P1_7==0); // Wait for the signal to be one, going high
TR0=1; // Start timing
//zero cross of test (P1.6)
while (P1_6==1); // Wait for the signal to be zero
while (P1_6==0); // Wait for the signal to be one, going high
TR0=0; // Stop timing
diff = (TH0*0x100+TL0); // this shows time difference between the zero crosses for both
tdiff = (diff * 12)/ SYSCLK; //tdiff has to be float, it is in seconds 
//-----------------------------------------------------------//

//----convert VREF and VTEST to RMS voltages----//
VREF = VREF / sqrttwo;
VTEST = VTEST / sqrttwo;
//----------------------------------------------//

//---convert time difference to phase-----------//
phase = (tdiff * 0x168) / period; //phase has to be float
//----------------------------------------------//

//--------convert period to frequency------------//
freq = 1 / period; //freq has to be a float
//-----------------------------------------------//

//-------display everything----------------------//
sprintf(buff1, "Vr=%.4g Vt=%.4gV", VREF, VTEST);	//This gets value of VREF and VTEST into a srting
sprintf(buff2, "P=%.4gD F=%.4gHz", phase,freq);	//This gets value of phase and freq into a srting

LCDprint(buff1, 1, 1);		//This prints that string to LCD
LCDprint(buff2, 2, 1);		//This prints that string to LCD
//----------------------------------------------//

	}

}	
