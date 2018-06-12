
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

float resolucion = (5.0/1023.0);
float vi;
char txt[14];

int x, aux, auxAnterior;

void interrupt(){
	 x = ADRESH<<8;
	 aux =ADRESL + x;
	 if(auxAnterior != aux){
		vi = aux*resolucion;
		FloatToStr (vi, txt);
		Lcd_Cmd(_LCD_CLEAR);
		Lcd_out(1,1,txt);

	 }
	 delay_ms(1000);
	 ADCON0.B2 =1;
	 auxAnterior = aux;
	 PIR1.ADIF = 0;
}

void main() {

     Lcd_init();
     ADCON0 = 0x41;
     ADCON1 = 0XC0;
     TRISA.B0 = 1;

     //Configuramos la interrupción AD
     PIR1.ADIF = 0;
     PIE1.ADIE = 1;
     INTCON.PEIE = 1;
     INTCON.GIE = 1;
     
     ADCON0.B2 = 1; //inicia conversion
     
     while(1);
}