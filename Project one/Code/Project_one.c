#include <mega32.h>
#include <alcd.h>
#include <stdlib.h>
#include <delay.h>
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}
unsigned long int x=0;
unsigned long int y=0;
unsigned long int f=0;
int P_S=0;
char num[50];
void main(void)  {
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
DDRB.0=0;
DDRB.1=0;
PORTB.0=1;
PORTB.1=1;
DDRB.3=1;
PORTB.3=0;
DDRD= 0b11111111;
PORTD=0b00000000;
lcd_init(16);
lcd_clear();
while (1){
x = read_adc(0);
lcd_gotoxy(0,0);
itoa (x,num);
lcd_puts(num);
if ( PINB.0==0) { while (PINB.0==0){ lcd_clear(); f=0;}y++;}
else if ( PINB.1==0) { while (PINB.1==0){lcd_clear(); f=0;} y--;}
     lcd_gotoxy(5,0);
     itoa (y,num);
    lcd_puts(num);
    if ( y>5 || y<0 ){ lcd_clear();x=0; f=0; y=0; TCCR0=0; TCNT0=0; OCR0=0;}

            if ( y==1 ){
              P_S=1;
            lcd_gotoxy(8,0);
            itoa(P_S,num);
            lcd_puts(num);

    TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
    f =8000000/(2*P_S*(x+1));
     lcd_gotoxy(0,1);
          itoa (f,num);
          lcd_puts(num);
                 }

              else  if ( y==2){
               P_S=8;
            lcd_gotoxy(8,0);
            itoa(P_S,num);
            lcd_puts(num);
   TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
     f =8000000/(2*P_S*(x+1));
       lcd_gotoxy(0,1);
        itoa (f,num);
        lcd_puts(num);
             }
                else if ( y==3){
              P_S=64;
            lcd_gotoxy(8,0);
            itoa(P_S,num);
            lcd_puts(num);
 TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
     f =8000000/(2*64*(x+1));
       lcd_gotoxy(0,1);
        itoa (f,num);
        lcd_puts(num);
             }
                 else  if ( y==4){
                P_S=256;
            lcd_gotoxy(8,0);
            itoa(P_S,num);
            lcd_puts(num);
   TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
     f =8000000/(2*256*(x+1));
       lcd_gotoxy(0,1);
        itoa (f,num);
        lcd_puts(num);
             }
                   else  if ( y==5){
              P_S=1024;
            lcd_gotoxy(8,0);
            itoa(P_S,num);
            lcd_puts(num);

  TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
     f = 8000000/(2*1024*(x+1));
       lcd_gotoxy(0,1);
        itoa (f,num);
        lcd_puts(num);
             }
              OCR0=x;
             PORTD= TCNT0;

  }
   }
