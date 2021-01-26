#include <mega32.h>
#include <delay.h>
void main(){
DDRC=0b11111111;
PORTC=0b0;


while(1){
PORTC.1=1;
delay_ms(1000);
PORTC.1=0;
PORTC.2=1;
delay_ms(1000);
PORTC.2=0;
 PORTC.3=1;
delay_ms(1000);
   PORTC.3=0;
}
}
