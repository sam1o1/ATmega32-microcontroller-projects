#include <mega32.h>
void main(){
 DDRB=0b11111111;
 PORTB=0b0;
 DDRC.3=0;
 PORTC.3=1;
 while(1){
 if (PINC.3==1){
 while (PINC.3==1){}
   PORTB= PORTB + 1;
}
}
}