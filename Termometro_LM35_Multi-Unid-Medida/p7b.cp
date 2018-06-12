#line 1 "C:/Users/ivan/Documents/Informatica/3º Curso/2º Cuatrimestre/HAE/Prácticas/clase/p7/c/p7b.c"

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
char cont=0;



void interrupt(){
 if(INTCON.TMR0IF){
 ADCON0.B2 = 1;
 TMR0H = (18661>>8);
 TMR0L = 18661;
 INTCON.TMR0IF = 0;
 }

 if(PIR1.ADIF){
 aux =(ADRESH<<8);
 aux =ADRESL + aux;
 if(auxAnterior != aux){

 }
 auxAnterior = aux;
 PIR1.ADIF = 0;
 }
}

void main() {
 TRISB.B0 = 1;
 TRISE.B1 = 1;
 Lcd_init();
 ADCON0 = 0x71;
 ADCON1 = 0xC0;



 PIR1.ADIF = 0;
 PIE1.ADIE = 1;



 INTCON.TMR0IF = 0;
 INTCON.TMR0IE = 1;


 INTCON1.INT0IF = 0;
 INTCON1.INT0IE = 1;
 INTCON2.RBPU = 0;
 INTCON2.INTEDG0 = 0;

 INTCON.PEIE = 1;
 INTCON.GIE = 1;
 ADCON0.B2 = 1;

 while(1);
}
