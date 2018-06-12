  unsigned int valor =  0x3000;
  char direccion = 0;
  unsigned int periodo = 0, i=0;


void interrupt(){
  if(INTCON.INT0IF){   //SW1
    if(periodo>0)periodo--;
    INTCON.INT0IF = 0;
  }
   if(INTCON3.INT1IF){   //SW2
     periodo++;
    INTCON3.INT1IF = 0;
  }
}
void main() {
     TRISC = 0;
     TRISB = 3;//RB0 Y RB1 entradas
     PORTC = 1;
     SPI1_Init();
     
     ADCON1 = 0x07; //E/S digitales
     
     //Interrupcion INT0
     INTCON.INT0IF = 0; // Flag a 0
     INTCON.INT0IE = 1; // se habilitan interrupciones INT0
     INTCON2.INTEDG0 = 1; // Flanco de subida
     //Interrupcion INT1
     INTCON3.INT1IF = 0; // Flag a 0
     INTCON3.INT1IE = 1; // se habilitan interrupciones INT1
     INTCON2.INTEDG1 = 1; // Flanco de subida
     
     INTCON2.RBPU = 0; //Resistencias de pullup
     INTCON.GIE = 1; //Interrupciones en general
     
     while(1){
     PORTC.B0 = 0;
         if(direccion == 0){ //incrementa
           SPI1_Write(valor>>8);
           SPI1_Write(valor);
           PORTC.B0 = 1;
           delay_us(6);
           valor++;
                for(i = 0; i<= periodo; i++)delay_us(10);
         }
          if(direccion == 1){ //decrementa
           SPI1_Write(valor>>8);
           SPI1_Write(valor);
           PORTC.B0 = 1;
           delay_us(6);
           valor--;
            for(i = 0; i<= periodo; i++)delay_us(10);
         }
         if(valor == 0x3FFF) direccion = 1;  //si llega al nivel maximo, se indica que decremente
         if(valor == 0x3000) direccion = 0; //si llega al nivel mínimo, se indica que incremente


  }

}