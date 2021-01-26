#include <mega32.h>
#include <stdlib.h>
#include <alcd.h>
#include <delay.h>

void main(void)
{
//intialization of some needed varabiles
int key =0;
int Nfreq=0;   // number of fequencies needed 
long int feq_1=0;   // frequency one
long int feq_2=0;   // frequency two
long int feq_3=0;   // frequency three
int num_indicator =0; // to differentiate between numbers and operations
int space =0;  // division sign to seperate the entered frequencies 
int space_indicator =0;
int generate=0;
char num[16];
DDRC=0b00001111;
PORTC=0b0;
DDRB.3=1;
DDRD.5=1;
DDRD.7=1;
lcd_init(16);
lcd_gotoxy(0,0);
lcd_putsf("Enter N of fs as");
lcd_gotoxy(0,1);
lcd_putsf("follows");
delay_ms(2000);
lcd_clear();
lcd_putsf("N/f1-f2+f3=");  // to guide the user so that the inputs are correctly entered
delay_ms(2000);
lcd_clear();
while (1)
    { 
    

     PORTC.0=1;
     if (PINC.4==1) {while(PINC.4==1){}  key=7; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=8; num_indicator =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=9; num_indicator =1; }  
    else if (PINC.7==1){ while(PINC.7==1){}space=1; space_indicator =1;}   
     delay_ms (10);
     PORTC.0=0;
     PORTC.1=1; 
    if (PINC.4==1) {while(PINC.4==1){}  key=4; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=5; num_indicator =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=6; num_indicator =1;}  
  // I did not map the multiplication button as it is not needed
     delay_ms (10);
     PORTC.1=0;
     PORTC.2=1;   
     if (PINC.4==1) {while(PINC.4==1){}  key=1; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=2; num_indicator =1; }
    else if (PINC.6==1){ while(PINC.6==1){} key=3; num_indicator =1;}     
       else if (PINC.7==1){ while(PINC.7==1){} space=2;space_indicator =1;} 
     delay_ms (10);
     PORTC.2=0;
     PORTC.3=1;   
     //if (PINC.4==1) {while(PINC.4==1){} { key=0;}
 if (PINC.5==1) {while(PINC.5==1){}  key=0; num_indicator =1;}
 else if (PINC.6==1) {while(PINC.6==1){}  generate=1;}    // when = is pressed the generation process begins
      else if (PINC.7==1){ while(PINC.7==1){} space=3;space_indicator =1;}        // +
    PORTC.3=0; 
    delay_ms (10);
   if ( space==0 && num_indicator==1) { 
     Nfreq = Nfreq*10+ key;
     itoa(key,num);
     Nfreq=0;
     lcd_puts(num);  }
     num_indicator=0;    
   if ((Nfreq >3) && space==0 && num_indicator==1) {
     lcd_clear();
     lcd_putsf ("INVALID");  
     delay_ms(1000); }   
     Nfreq=0;
     num_indicator=0;    
     lcd_clear();        
 }
}