#line 1 "D:/Escritorio/Archivos HAE/Miercoles de 9 a 11/p7/b/p7b.c"
#line 1 "d:/escritorio/archivos hae/miercoles de 9 a 11/p7/b/tecla12int.h"
#line 25 "d:/escritorio/archivos hae/miercoles de 9 a 11/p7/b/tecla12int.h"
unsigned char tecla()
{

unsigned char columna=0, fila, aux1=0x10, aux2;

unsigned char teclado[4][3]={{49, 50, 51},{52, 53, 54},{55, 56, 57}, {42, 48, 35}};

delay_ms( 10 );

 for(fila=0; fila< 4 ; fila++)
 {
 if((PORTB&aux1)==0x00) break;
 aux1=(aux1<<1);
 }

 PORTB=0x01;

 while((PORTB& 0xF0 )!= 0xF0 )
 {
 PORTB=(PORTB<<1);
 columna++;
 }


 PORTB=0x00;

 do
 {delay_ms(2);
 }while((PORTB&0xF0)!=0xF0);



 aux2=teclado[fila][columna];
 return aux2;
}
#line 3 "D:/Escritorio/Archivos HAE/Miercoles de 9 a 11/p7/b/p7b.c"
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

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
 ADCON0 = 0x71;
 ADCON1 = 0XC0;


 PIR1.ADIF = 0;
 PIE1.ADIE = 1;
 INTCON.PEIE = 1;
 INTCON.GIE = 1;


 T0CON = 0x85;
 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;

 TMR0H = (18661>>8);
 TMR0L = 18661;
 ADCON0.B2 = 1;

 while(1);
}
