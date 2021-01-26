#include <mega32.h>
#include <alcd.h>
#include <stdlib.h>

void main(void)   {
   char number[16]; 
 int x = 0;
 DDRC=0b00001111;
 PORTC=0b0; 
 lcd_init (16);
 lcd_gotoxy(0,0);
 lcd_putsf("Press any key");

while (1)
    {
   PORTC.0=1;
   if (PINC.4==1) {x=7;}
   else if (PINC.5==1) {x=8;} 
   else if (PINC.6==1) {x=9;}  
   else if (PINC.7==1) {x=10;}      
    PORTC.0=0;  
    PORTC.1=1;
   if (PINC.4==1) {x=4;}
   else if (PINC.5==1) {x=5;} 
   else if (PINC.6==1) {x=6;}  
   else if (PINC.7==1) {x=11;} 
     PORTC.1=0;  
    PORTC.2=1;
   if (PINC.4==1) {x=1;}
   else if (PINC.5==1) {x=2;} 
   else if (PINC.6==1) {x=3;}  
   else if (PINC.7==1) {x=12;} 
      PORTC.2=0;  
    PORTC.3=1;
   if (PINC.4==1) {x=13;}
   else if (PINC.5==1) {x=0;} 
   else if (PINC.6==1) {x=14;}  
   else if (PINC.7==1) {x=15;}
    PORTC.3=0;   
    lcd_gotoxy(0,1);
    itoa (x,number); 
    if ( x==10) {lcd_putchar ('/');}
    else if ( x==11){lcd_putchar ('x');}      
    else if ( x==12){lcd_putchar ('-');}    
    else if ( x==13){lcd_putchar ('c');}    
    else if ( x==14){lcd_putchar ('=');}    
    else if ( x==15){lcd_putchar ('+');}      
    else   { lcd_puts (number);  }
    
    }
}
