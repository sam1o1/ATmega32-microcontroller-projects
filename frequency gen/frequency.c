  //EFORE USING!!!!!
  //in order to enter three frequencies, you sould do that in the follwing form
  // N (number of frequencies) / division sign to seperate N and the first number - the subtraction sign to sperate the first number and the 2nd onee
  // finally + to seperate the third number and the firdt two ( N/feq_1-feq_2+feq_3
  // to generate feq_1 please press =, to generate feq_2 please enter X and to generate feq_3 please enter ON/Off button

#include <mega32.h>
#include <stdlib.h>
#include <alcd.h>
#include <delay.h>

void main(void)
{
//intialization of some needed varabiles
int key =0;
int Nfreq=0;              // number of fequencies needed
long int feq_1=0;        // frequency one
long int feq_2=0;       // frequency two
long int feq_3=0;      // frequency three
  // please note that the accepted number of requencies should not exceed three
int num_indicator =0; // to differentiate between numbers and operators
int space =0;        // division sign to seperate the entered frequencies
int space_indicator =0;
int generate=0;     // to generate feq_1
char num[16];
int com=0;          // to generate feq_2
int col=0;
DDRC=0b00001111;   // to generate feq_3
PORTC=0b00000000;
DDRD.0=0;
PORTD.0=1;
DDRB.3=1;    // OCR0
DDRD.5=1;    // OCR1A
DDRD.7=1;    // OCR2
lcd_init(16);
lcd_gotoxy(0,0);
lcd_putsf("Enter N of fs as");
lcd_gotoxy(0,1);
lcd_putsf("follows");
delay_ms(1500);
lcd_clear();
lcd_putsf("N/f1-f2+f3");  // to guide the user so that the inputs are correctly entered
delay_ms(2000);
lcd_clear();
while (1)
    {


     PORTC.0=1;
     if (PINC.4==1) {while(PINC.4==1){}  key=7; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=8; num_indicator =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=9; num_indicator =1; }
    else if (PINC.7==1){ while(PINC.7==1){}space=1; space_indicator =1;}      // /
     delay_ms (10);
     PORTC.0=0;
     PORTC.1=1;
    if (PINC.4==1) {while(PINC.4==1){}  key=4; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=5; num_indicator =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=6; num_indicator =1;}
  else if (PINC.7==1){ while(PINC.7==1){}  com=1;}
     delay_ms (10);
     PORTC.1=0;
     PORTC.2=1;
     if (PINC.4==1) {while(PINC.4==1){}  key=1; num_indicator =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=2; num_indicator =1; }
    else if (PINC.6==1){ while(PINC.6==1){} key=3; num_indicator =1;}
       else if (PINC.7==1){ while(PINC.7==1){} space=2;space_indicator =1;}   // -
     delay_ms (10);
     PORTC.2=0;
     PORTC.3=1;
     if (PINC.4==1) {while(PINC.4==1){}  col=1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=0; num_indicator =1;}
    else if (PINC.6==1) {while(PINC.6==1){}  generate=1;}    // when = is pressed the generation process begins
   else if (PINC.7==1){ while(PINC.7==1){} space=3;space_indicator=1;}        // +
    PORTC.3=0;
    delay_ms (10);
     if (PIND.0==0) {while(PIND.0==0){} lcd_clear();  key=0; Nfreq=0; feq_1=0; feq_2=0; feq_3=0;space=0; space_indicator=0; num_indicator =0;
     com=0; col=0; generate=0;OCR0=0;TCCR0=0;TCCR2=0; OCR2=0; TCCR1A=0;TCCR1B=0;OCR1A=0; }
      delay_ms (10);

   if ( space==0 && num_indicator ==1){ Nfreq = Nfreq*10+key;  itoa(key,num);lcd_puts(num);num_indicator=0; }
   if  (Nfreq >3){
    lcd_putsf(" is INVALID");
     delay_ms(1000);
   lcd_clear();
    Nfreq=0;
    }


   if (space==1 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
      if (space==2 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
       if (space==3 && space_indicator==1){lcd_putchar('/'); space_indicator=0; }
if ( (Nfreq==1||Nfreq==2||Nfreq==3)&& space==1 &&num_indicator==1){
   feq_1=feq_1*10+key ;
   itoa (key,num);
   lcd_puts(num);
   num_indicator=0;  }
   if ( generate==1) {
   if(feq_1<=4000000&&feq_1>15625){
   TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0 =(8000000/(2*1*feq_1))-1;
  itoa (OCR0,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}
   else if(feq_1<=500000&&feq_1>=1953){
   TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0 =(8000000/(2*8*feq_1))-1;
  itoa (OCR0,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}
    else if(feq_1<=62500&&feq_1>=244){
   TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0 =(8000000/(2*64*feq_1))-1;
  itoa (OCR0,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}

   else if(feq_1<=15625&&feq_1>=61){
TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0 =(8000000/(2*256*feq_1))-1;
  itoa (OCR0,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}
    else if(feq_1<=3906&&feq_1>=15){
TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0 =(8000000/(2*1024*feq_1))-1;
  itoa (OCR0,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}
        else if(feq_1<15&&feq_1>=1){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
    OCR1A=(8000000/(2*1024*feq_1)-1);
  itoa (OCR1A,num);
  itoa (OCR1A,num);
    feq_1=0;
    lcd_gotoxy(0,1);
   lcd_puts(num);}

    }

  generate=0;

  if ((Nfreq==2||Nfreq==3 )&& space==2 &&num_indicator==1){
   feq_2=feq_2*10+key ;
   itoa (key,num);
   lcd_puts(num);
   num_indicator=0;  }
  if (com==1){
   if(feq_2<=4000000&&feq_2>=15625){
TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2 =(8000000/(2*1*feq_2))-1;
  itoa (OCR2,num);
 lcd_gotoxy(5,1);

   lcd_puts(num);

  feq_2=0;

   }
   if(feq_2<=500000&&feq_2>=1953){

TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2 =(8000000/(2*8*feq_2))-1;
  itoa (OCR2,num);
 lcd_gotoxy(5,1);

   lcd_puts(num);

  feq_2=0;

   }
      if(feq_2<=62500&&feq_2>=244){
TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2 =(8000000/(2*64*feq_2))-1;
  itoa (OCR2,num);
  lcd_gotoxy(5,1);

   lcd_puts(num);

  feq_2=0;

   }
       if(feq_2<=15625&&feq_2>=61){


TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2 =(8000000/(2*256*feq_2))-1;
  itoa (OCR2,num);
 lcd_gotoxy(5,1);

   lcd_puts(num);

  feq_2=0;

   }
       if(feq_2<=3906&&feq_2>=15){

TCCR2=(0<<PWM2) | (0<<COM21) | (1<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2 =(8000000/(2*1024*feq_2))-1;
  itoa (OCR2,num);
 lcd_gotoxy(5,1);

   lcd_puts(num);

  feq_2=0;

   }
           else if(feq_2<15&&feq_2>=1){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
    OCR1A=(8000000/(2*1024*feq_2)-1);

  itoa (OCR1A,num);
  itoa (OCR1A,num);
    feq_2=0;
    lcd_gotoxy(5,1);
   lcd_puts(num);}



      com =0;
}

  if ((Nfreq==3 )&& space==3 &&num_indicator==1){
   feq_3=feq_3*10+key ;
   itoa (key,num);
   lcd_puts(num);
   num_indicator=0;  }
     if (col==1){
   if(feq_3<4000000 && feq_3>=61){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
    OCR1A=(8000000/(2*1*feq_3)-1);
  itoa (OCR1A,num);
 lcd_gotoxy(10,1);

   lcd_puts(num);

  feq_3=0;

   }
   else if(feq_3<500000&&feq_3>=7){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
    OCR1A=(8000000/(2*8*feq_3)-1);
  itoa (OCR1A,num);
 lcd_gotoxy(10,1);

   lcd_puts(num);

  feq_3=0;

   }
      else if(feq_3<62500&&feq_3>=1){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
    OCR1A=(8000000/(2*64*feq_3)-1);
  itoa (OCR1A,num);
 lcd_gotoxy(10,1);

   lcd_puts(num);

  feq_3=0;

   }
        else if(feq_3<15625&&feq_3>=1){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
    OCR1A=(8000000/(2*256*feq_3)-1);
  itoa (OCR1A,num);
 lcd_gotoxy(10,1);

   lcd_puts(num);

  feq_3=0;

   }
         else if(feq_3<=3906&&feq_3>=1){
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
    OCR1A=(8000000/(2*1024*feq_3)-1);
  itoa (OCR1A,num);
 lcd_gotoxy(10,1);

   lcd_puts(num);

  feq_3=0;

   }
  col=0;
        }

 }
}