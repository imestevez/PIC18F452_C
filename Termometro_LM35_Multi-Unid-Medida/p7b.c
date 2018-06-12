
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
char cont=0;

void representar(){
     if(cont >= 4) cont = 1;
     if(cont <= 1){ vi = aux*resolucion;  }
     if(cont == 2){ vi = (aux*resolucion)+273.15;  }
     if(cont == 3){ vi = 1.8*(aux*resolucion)+32.0;}
     FloatToStr(vi, txt);
     Lcd_Cmd(_LCD_CLEAR);
     Lcd_out(1,1,txt);
}

void interrupt(){
     if(INTCON.TMR0IF){
        ADCON0.B2 = 1;
        TMR0H = (18661>>8);
        TMR0L = 18661;
        INTCON.TMR0IF = 0;
     }
     if(INTCON1.INT0IF) {
         cont++;
         representar();
         INTCON1.INT0IF = 0;
     }
      if(PIR1.ADIF){
         aux =(ADRESH<<8);
         aux =ADRESL + aux;
         if(auxAnterior != aux){
              representar();
         }
        auxAnterior = aux;
        PIR1.ADIF = 0;
     }
}

void main() {
     TRISB.B0 = 1;
     TRISE.B1 = 1;
     Lcd_init();
     ADCON0 = 0x71; //AN6
     ADCON1 = 0xC0;


     //Configuramos la interrupción AD
     PIR1.ADIF = 0;  //flag a 0
     PIE1.ADIE = 1; //Se habilitan interrupciones AD

     //Configuramos Timer
     T0CON = 0x85; //Pre 64 ; Modo 16 bits
     INTCON.TMR0IF = 0; //Flag a 0
     INTCON.TMR0IE = 1;   //Se habilitan interrupciones Timer0

     //Configuramos interrupcion INT0
     INTCON1.INT0IF = 0;  //Flag a 0
     INTCON1.INT0IE = 1; // Habilitamos interrupcion INT0
     INTCON2.RBPU = 0; // Resistencia de pullup
     INTCON2.INTEDG0 = 0; // Flanco de bajada

     INTCON.PEIE = 1; //Se habilitan interrupciones perifericas
     INTCON.GIE = 1;  //Se habilitan interrupciones en general

     TMR0H = (18661>>8);
     TMR0L = 18661;
     ADCON0.B2 = 1;

     while(1);
}