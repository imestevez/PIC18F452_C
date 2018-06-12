#line 1 "D:/Escritorio/Archivos HAE/Miercoles de 9 a 11/p10/c/p10c.c"
 unsigned int valor = 0x3000;
 char direccion = 0;
 unsigned int periodo = 0, i=0;


void interrupt(){
 if(INTCON.INT0IF){
 if(periodo>0)periodo--;
 INTCON.INT0IF = 0;
 }
 if(INTCON3.INT1IF){
 periodo++;
 INTCON3.INT1IF = 0;
 }
}
void main() {
 TRISC = 0;
 TRISB = 3;
 PORTC = 1;
 SPI1_Init();

 ADCON1 = 0x07;


 INTCON.INT0IF = 0;
 INTCON.INT0IE = 1;
 INTCON2.INTEDG0 = 1;

 INTCON3.INT1IF = 0;
 INTCON3.INT1IE = 1;
 INTCON2.INTEDG1 = 1;

 INTCON2.RBPU = 0;
 INTCON.GIE = 1;

 while(1){
 PORTC.B0 = 0;
 if(direccion == 0){
 SPI1_Write(valor>>8);
 SPI1_Write(valor);
 PORTC.B0 = 1;
 delay_us(6);
 valor++;
 for(i = 0; i<= periodo; i++)delay_us(10);
 }
 if(direccion == 1){
 SPI1_Write(valor>>8);
 SPI1_Write(valor);
 PORTC.B0 = 1;
 delay_us(6);
 valor--;
 for(i = 0; i<= periodo; i++)delay_us(10);
 }
 if(valor == 0x3FFF) direccion = 1;
 if(valor == 0x3000) direccion = 0;


 }

}
