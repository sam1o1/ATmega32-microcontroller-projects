#include <mega32.h>
#include <delay.h>
#include <alcd.h>
#include <stdlib.h>
void main(){
  int x=0;   
  char arr[5];
 DDRC.0=0;
 DDRC.3=0;
 PORTC.0=1;
 PORTC.3=1;
  lcd_init(16);
   while(1){
   if ( PINC.0==0){
  while ( PINC.0==0){}  
  x++; 
   lcd_gotoxy (0,0);
   lcd_putsf("The number is : ");
     
 itoa(x,arr); 
   lcd_puts(arr);
}
 if ( PINC.3==0){
  while ( PINC.3==0){}   
  x =0;
  lcd_clear ();
  lcd_putsf(" Reset done! ");
  delay_ms (1000);
  lcd_clear();
}
}
}







