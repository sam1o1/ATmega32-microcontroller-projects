
#include <mega32.h>

#include <delay.h>

#include <alcd.h>

#include <stdlib.h>
int key=0;
int num_1 =0;
int num_2 =0;
int flag_1 =0;
int flag_2 =0;
int op =0;
int result=0;
int final_result=0;
char number[16];
void main(void)
{

DDRC = 0b00001111;
PORTC=0b0;
lcd_init(16);
lcd_gotoxy(0,0);
lcd_clear();
while (1)
    {
     PORTC.0=1;
     if (PINC.4==1) {while(PINC.4==1){} key=7; flag_1 =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=8; flag_1 =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=9; flag_1 =1;}
    else if (PINC.7==1){ while(PINC.7==1){}  op=1; flag_2 =1;}   //op =1>> /
     delay_ms (10);
     PORTC.0=0;
     PORTC.1=1;
    if (PINC.4==1) {while(PINC.4==1){}  key=4; flag_1 =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=5; flag_1 =1;}
    else if (PINC.6==1){ while(PINC.6==1){}  key=6; flag_1 =1;}
    else if (PINC.7==1) {while(PINC.7==1){}  op=2; flag_2 =1;}  // op =2>>x
     delay_ms (10);
     PORTC.1=0;
     PORTC.2=1;
     if (PINC.4==1) {while(PINC.4==1){}  key=1; flag_1 =1;}
    else if (PINC.5==1) {while(PINC.5==1){}  key=2; flag_1 =1;}
    else if (PINC.6==1){ while(PINC.6==1){} key=3; flag_1 =1;}
    else if (PINC.7==1) {while(PINC.7==1){}  op=3; flag_2 =1;}  // op=3>>-
     delay_ms (10);
     PORTC.2=0;
     PORTC.3=1;
     if (PINC.4==1) {while(PINC.4==1){} { key=0;num_1 =0; num_2 =0;flag_1 =0;flag_2 =0; op =0; result=0; final_result=0; lcd_clear();}}
    else if (PINC.5==1) {while(PINC.5==1){}  key=0; flag_1 =1;}
    else if (PINC.6==1) {while(PINC.6==1){}  result=1;}
    else if (PINC.7==1) {while(PINC.7==1){}  op=4; flag_2 =1;}  // op=3>>-
    PORTC.3=0;
    delay_ms (10);

    if ((op==0) && (flag_1==1)){
      num_1= (10*num_1) +key;
      itoa (key,number);
      lcd_puts(number);
      flag_1=0;
      }
      if ((op ==1) && (flag_2==1)) {lcd_putchar ('/');}
      else if (op ==2 && flag_2==1) {lcd_putchar ('x');}
      else if (op ==3 && flag_2==1) {lcd_putchar ('-');}
      else if (op ==4 && flag_2==1) {lcd_putchar ('+');}
       flag_2=0;
       if (( op ==1 || op ==2 || op==3 || op==4)&& (flag_1 ==1)){
          num_2=num_2*10+key;
      itoa (key,number);
      lcd_puts(number);
      flag_1=0;
      }
      if(result==1){
      lcd_putchar('=');
      if (op ==1) {
      final_result=(num_1)/(num_2);
      }
      else if (op ==1 && num_2==0){ lcd_putsf ("infinity");}
      else if (op ==2) {final_result=num_1*num_2;}
      else if (op ==3) {final_result=num_1-num_2;}
      else if (op ==4) {final_result=num_1+num_2;}
     itoa (final_result,number);
     lcd_puts(number);
     if (op==1&&num_2==0){
     lcd_clear();
     lcd_putsf(" result=infinity");}
   result =0;
     }
    }

}
