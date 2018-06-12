#include "Tecla12INT.h"
 // Lcd pinout settings
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;
// Pin direction
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

char x,key;
char aux = 0;
char txt[3];
char cont = 0;
char interrupcion = 0;

void interrupt() {
     if(interrupcion == 0){
      Lcd_Out(1,1,"Turno: ");
      interrupcion++;
     }else{cont++;}
     //cont++;
     if((cont%2) != 0)  {
           aux++;
           if(aux>99) {aux = 0;}
     }else{
      cont = 0;
     }
     ByteToStr(aux, txt);
     Lcd_Out(1,8,txt);
    x = PORTB;
    INTCON.RBIF=0;
}
void main() {
        //Configuracion de entradas
    TRISB = 0xF0;
         
    Lcd_Init ();
    ADCON1 = 0x07;

    INTCON2.RBPU = 0; //Habilitacmos resistencia pullup
    x=PORTB; //para poder borrar el RBIF
    INTCON.RBIF = 0; //flag a 0
    INTCON.RBIE = 1;
    INTCON.GIE = 1;

    x=PORTB; //para poder borrar el RBIF
    INTCON.RBIF = 1; //flag a 1

    while(1);

}