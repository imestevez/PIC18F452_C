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

float resolucion = (500.0/1023.0);
float vi;
char txt[14];
int x, aux, auxAnterior;

void interrupt(){

     if(INTCON.TMR0IF){
        ADCON0.B2 = 1;
        TMR0H = (18661>>8);
        TMR0L = 18661;
     }
      if(PIR1.ADIF){
         aux =(ADRESH<<8);
         aux =ADRESL + aux;
         if(auxAnterior != aux){
            vi = aux*resolucion;
            FloatToStr(vi, txt);
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_out(1,1,txt);
         }
        auxAnterior = aux;
     }
     INTCON.TMR0IF = 0;
     PIR1.ADIF = 0;
}

void main() {

     Lcd_init();
     ADCON0 = 0x71; //AN6
     ADCON1 = 0XC0;

     //Configuramos la interrupción AD
     PIR1.ADIF = 0;  //flag a 0
     PIE1.ADIE = 1; //Se habilitan interrupciones AD
     INTCON.PEIE = 1; //Se habilitan interrupciones perifericas
     INTCON.GIE = 1;  //Se habilitan interrupciones en general

     //Configuramos Timer
     T0CON = 0x85; //Pre 64 ; Modo 16 bits
     INTCON.TMR0IF = 0; //Flag a 0
     INTCON.TMR0IE = 1;   //Se habilitan interrupciones Timer0

     TMR0H = (18661>>8);
     TMR0L = 18661;
     ADCON0.B2 = 1;
     
     while(1);
}