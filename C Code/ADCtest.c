#include <XC.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/attribs.h>
// Configuration Bits (somehow XC32 takes care of this)
#pragma config FNOSC = FRCPLL       // Internal Fast RC oscillator (8 MHz) w/ PLL
#pragma config FPLLIDIV = DIV_2     // Divide FRC before PLL (now 4 MHz)
#pragma config FPLLMUL = MUL_20     // PLL Multiply (now 80 MHz)
#pragma config FPLLODIV = DIV_2     // Divide After PLL (now 40 MHz)
#pragma config CP=OFF, BWP=OFF
#pragma config POSCMOD=XT 
#pragma config FWDTEN = OFF         // Watchdog Timer Disabled
#pragma config FPBDIV = DIV_1       // PBCLK = SYCLK

// Defines
#define SYSCLK 40000000L
#define Baud2BRG(desired_baud)( (SYSCLK / (16*desired_baud))-1)

#define FCY 72000000L
#define FPB 36000000L
#define DEF_FREQ 16000L




volatile unsigned char pwm_count=0;
unsigned int aa = 0;
unsigned int bb = 0;

unsigned int sigsta[5]={1,0,1,0,1};
unsigned int sigstop[5]={0,0,0,0,0};
unsigned int sigleft[5]={0,0,1,0,0};
unsigned int sigright[5]={0,0,1,1,0};
unsigned int sigforward[5]={1,1,1,1,1};
unsigned int sigbackward[5]={0,0,0,1,0};
unsigned int sigforwardright[5]={0,1,1,1,0};
unsigned int sigforwardleft[5]={0,1,1,0,0};
unsigned int sigbackwardleft[5]={0,1,0,1,0};
unsigned int sigbackwardright[5]={0,1,0,0,0};

unsigned int instruction[5]={};

int start=0;

void __ISR(_TIMER_1_VECTOR, IPL5SOFT) Timer1_Handler(void)
{
	
	pwm_count++;
	if(pwm_count>100)pwm_count=0;
	LATBbits.LATB6 = pwm_count>50?0:1; // Blink led on RB6
	LATBbits.LATB5 = pwm_count>aa?0:1;
	LATBbits.LATB10 = pwm_count>bb?0:1;
	IFS0CLR=_IFS0_T1IF_MASK; // Clear timer 1 interrupt flag, bit 4 of IFS0
}

void __ISR(_TIMER_3_VECTOR, IPL6SOFT) Timer3_Handler(void)
{
	LATBbits.LATB7 = !LATBbits.LATB7; // square wave on RB7
	IFS0CLR=_IFS0_T3IF_MASK; // Clear timer 3 interrupt flag, bit 14 of IFS0
	
}


void SetupTimer1 (void)
{
   
	// Explanation here:
	// https://www.youtube.com/watch?v=bu6TTZHnMPY
	__builtin_disable_interrupts();
	PR1 =(SYSCLK/(DEF_FREQ*2L))-1; // since SYSCLK/FREQ = PS*(PR1+1)
	TMR1 = 0;
	T1CONbits.TCKPS = 0; // Pre-scaler: 1
	T1CONbits.TCS = 0; // Clock source
	T1CONbits.ON = 1;
	IPC1bits.T1IP = 5;
	IPC1bits.T1IS = 0;
	IFS0bits.T1IF = 0;
	IEC0bits.T1IE = 1;
	
	INTCONbits.MVEC = 1; //Int multi-vector
	__builtin_enable_interrupts();
}
void SetupTimer2 (void)
{
   
	// Explanation here:
	// https://www.youtube.com/watch?v=bu6TTZHnMPY
//	__builtin_disable_interrupts();
	PR2 =(SYSCLK/(DEF_FREQ*2L))-1; // since SYSCLK/FREQ = PS*(PR1+1)
	TMR2 = 0;
	T2CONbits.TCKPS = 0; // Pre-scaler: 1
	T2CONbits.TCS = 0; // Clock source
	T2CONbits.ON = 1;
	IPC2bits.T2IP = 5;
	IPC2bits.T2IS = 0;
	IFS0bits.T2IF = 0;
	IEC0bits.T2IE = 1;
	
	INTCONbits.MVEC = 1; //Int multi-vector
//	__builtin_enable_interrupts();
}

void SetupTimer3 (void)
{
   
	// Explanation here:
	// https://www.youtube.com/watch?v=bu6TTZHnMPY
	__builtin_disable_interrupts();
	PR3 =(SYSCLK/(2048*2L))-1; // since SYSCLK/FREQ = PS*(PR1+1)
	TMR3 = 0;
	T3CONbits.TCKPS = 0; // Pre-scaler: 1
	T3CONbits.TCS = 0; // Clock source
	T3CONbits.ON = 1;	//starts timer 3
	IPC3bits.T3IP = 6;
	IPC3bits.T3IS = 0;
	IFS0bits.T3IF = 0;
	IEC0bits.T3IE = 1;
	
	INTCONbits.MVEC = 1; //Int multi-vector
	__builtin_enable_interrupts();
}


void Delayms( unsigned t)
{
    T2CON = 0x8000; 
    while (t--)
    { 
        TMR2 = 0;
        while (TMR2 < FPB/900);
    }
} 

int UART2Configure( int desired_baud)

{  
 

    U2MODE = 0;         // disable autobaud, TX and RX enabled only, 8N1, idle=HIGH
    U2STA = 0x1400;     // enable TX and RX
    U2BRG = Baud2BRG(desired_baud); // U2BRG = (FPb / (16*baud)) - 1
    // Calculate actual baud rate
    int actual_baud = SYSCLK / (16 * (U2BRG+1));
    return actual_baud;
}


// Good information about ADC in PIC32 found here:
// http://umassamherstm5.org/tech-tutorials/pic32-tutorials/pic32mx220-tutorials/adc
void ADCConf(void)
{
    
    AD1CON1CLR = 0x8000;    // disable ADC before configuration
    AD1CON1 = 0x00E0;       // internal counter ends sampling and starts conversion (auto-convert), manual sample
    AD1CON2 = 0;            // AD1CON2<15:13> set voltage reference to pins AVSS/AVDD
    AD1CON3 = 0x0f01;       // TAD = 4*TPB, acquisition time = 15*TAD 
    AD1CON1SET=0x8000;      // Enable ADC
}
///////////////////////////////////////////////////////////waitms

//Checks for same string
int stringequ(unsigned int instruction[], unsigned int stringabc[]) {
	int num=0;
	int count1=0;
	int same = 0;
	for (num = 0; num < 5; num++) {
		if (instruction[num] == stringabc[num]) {
			count1 ++;
		}
	}
	if (count1 == 5) same = 1;
	else same = 0;
	return same;
}

////////////////////////////// /////////////////////////////////////////////copied for waitms
int ADCRead(char analogPIN)
{
    AD1CHS = analogPIN << 16;    // AD1CHS<16:19> controls which analog pin goes to the ADC
 
    AD1CON1bits.SAMP = 1;        // Begin sampling
    while(AD1CON1bits.SAMP);     // wait until acquisition is done
    while(!AD1CON1bits.DONE);    // wait until conversion done
 
    return ADC1BUF0;             // result stored in ADC1BUF0
}

char readvoltage(void){
	float voltage;
	char recieve;
	 int adcval;
	adcval = ADCRead(5); // note that we call pin AN5 (RB3) by it's analog number
    voltage=adcval*3.3/1023.0;
        	
        	if (voltage>0){
        	recieve=1;
       		}
        	else recieve=0;
        	printf(" %.3fV,%d,\r\n", voltage,recieve);
	return recieve;

}
void main(void)
{
 
    //char buf[128]; // declare receive buffer with max size 128
    unsigned int rx_size;
	int newF;
	unsigned long reload;
   
    float voltage;
    char recieve=0;
    int size=0;
    int j=0;
    int sum=0;
   start=0;

    
    ////////////////
 //    size=4;
 //    start=1;
 //   unsigned int instruction[5]={0,1,0,0,1};
    //////////////////
    CFGCON = 0;
  	DDPCON = 0;
  
    // Configure pins as analog inputs
    ANSELBbits.ANSB3 = 1;   // set RB3 (AN5, pin 7 of DIP28) as analog pin
    TRISBbits.TRISB3 = 1;   // set RB3 as an input
	TRISBbits.TRISB6 = 0;
	LATBbits.LATB6 = 0;	
	TRISBbits.TRISB5 = 0;
	LATBbits.LATB5 = 0;
	LATBbits.LATB7 = 0;	//initialize as 0	
	TRISBbits.TRISB10 = 0;
	LATBbits.LATB10 = 0;	
	INTCONbits.MVEC = 1;
	SetupTimer1();
	SetupTimer3();

    // Peripheral Pin Select
    U2RXRbits.U2RXR = 4; //SET RX to RB8
    RPB9Rbits.RPB9R = 2; //SET RB9 to TX
 
    UART2Configure(115200); // Configure UART2 for a baud rate of 115200
    U2MODESET = 0x8000; // enable UART2
 

    ADCConf(); // Configure ADC
    
    //printf("*** PIC32 ADC test ***\n");
	while(1)
	{       
	    Delayms(500);

        	
        if(start==0){
        	instruction[size]=readvoltage();
        	if(instruction[size]!= sigsta[size]){
           	size=0;
           	start=0;
           	printf(" no ins\r\n");
        	}
        	else size++;
        	
        	if(size==4){
        	start=1;
        	size=0;
        	for(j=0;j<5;j++){
        	printf("ins sucess %d\r\n", instruction[j]);
        	}
        	}
        }//start=0
        
        if (start==1){
        	start=0;
        	size=0;
        		for(j=0;j<5;j++){
        		Delayms(500);
        		instruction[size]=readvoltage();
        		}
        		if (stringequ(instruction, sigleft) == 1) {
				aa = 15;
				bb = 85;
				printf("sigleft\r\n");
				
				}
				else if (stringequ(instruction, sigright) == 1) {
				aa = 85;
				bb = 15;
				printf("sigright\r\n");
				}
		
				else if (stringequ(instruction, sigforward) == 1) {
				aa = 15;
				bb = 15;
				printf("sigforward\r\n");
				}
				else if (stringequ(instruction, sigbackward) == 1) {
				aa = 85;
				bb = 85;
				printf("sigbackward\r\n");
				}
				
				else if (stringequ(instruction, sigforwardright) == 1) {
				aa = 5;
				bb = 25;
				printf("sigbackwardright\r\n");
				}
				
				else if (stringequ(instruction, sigforwardleft) == 1) {
				aa = 25;
				bb = 5;
				printf("sigforwardleft\r\n");
				}
				else if (stringequ(instruction, sigbackwardleft) == 1) {
				aa = 95;
				bb = 75;
				printf("sigbackwardleft\r\n");
				}
				else if (stringequ(instruction, sigbackwardright) == 1) {
				aa = 75;
				bb = 95;
				printf("sigbackwardright\r\n");
				}
        		else if (stringequ(instruction, sigstop)==1){
        		aa=50;
        		bb=50;
          		printf("sigstop\r\n");	
        		}
			
	      	}//start=1 
  	}//while
        //	fflush(stdout);
}//end
