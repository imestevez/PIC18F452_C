#line 1 "C:/Users/ivan/Documents/Informatica/3º Curso/2º Cuatrimestre/HAE/Prácticas/clase/p5/c/p5c.c"
#line 1 "c:/users/ivan/documents/informatica/3º curso/2º cuatrimestre/hae/prácticas/clase/p5/c/tecla12int.h"
#line 25 "c:/users/ivan/documents/informatica/3º curso/2º cuatrimestre/hae/prácticas/clase/p5/c/tecla12int.h"
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
#line 3 "C:/Users/ivan/Documents/Informatica/3º Curso/2º Cuatrimestre/HAE/Prácticas/clase/p5/c/p5c.c"
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

 if((cont%2) != 0) {
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

 TRISB = 0xF0;

 Lcd_Init ();
 ADCON1 = 0x07;

 INTCON2.RBPU = 0;
 x=PORTB;
 INTCON.RBIF = 0;
 INTCON.RBIE = 1;
 INTCON.GIE = 1;

 x=PORTB;
 INTCON.RBIF = 1;

 while(1);

}
