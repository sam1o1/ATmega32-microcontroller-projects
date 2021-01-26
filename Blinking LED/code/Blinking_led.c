#include <mega32.h>
#include <delay.h>
void main(){
DDRD=0b11111111;
PORTD=0b0;


while(1){
PORTD.0=1;
delay_ms(1000);
PORTD.0=0;
delay_ms(1000);





}
}
