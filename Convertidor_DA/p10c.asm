
_interrupt:

;p10c.c,6 :: 		void interrupt(){
;p10c.c,7 :: 		if(INTCON.INT0IF){   //SW1
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt0
;p10c.c,8 :: 		if(periodo>0)periodo--;
	MOVLW       0
	MOVWF       R0 
	MOVF        _periodo+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt21
	MOVF        _periodo+0, 0 
	SUBLW       0
L__interrupt21:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt1
	MOVLW       1
	SUBWF       _periodo+0, 1 
	MOVLW       0
	SUBWFB      _periodo+1, 1 
L_interrupt1:
;p10c.c,9 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;p10c.c,10 :: 		}
L_interrupt0:
;p10c.c,11 :: 		if(INTCON3.INT1IF){   //SW2
	BTFSS       INTCON3+0, 0 
	GOTO        L_interrupt2
;p10c.c,12 :: 		periodo++;
	INFSNZ      _periodo+0, 1 
	INCF        _periodo+1, 1 
;p10c.c,13 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;p10c.c,14 :: 		}
L_interrupt2:
;p10c.c,15 :: 		}
L_end_interrupt:
L__interrupt20:
	RETFIE      1
; end of _interrupt

_main:

;p10c.c,16 :: 		void main() {
;p10c.c,17 :: 		TRISC = 0;
	CLRF        TRISC+0 
;p10c.c,18 :: 		TRISB = 3;//RB0 Y RB1 entradas
	MOVLW       3
	MOVWF       TRISB+0 
;p10c.c,19 :: 		PORTC = 1;
	MOVLW       1
	MOVWF       PORTC+0 
;p10c.c,20 :: 		SPI1_Init();
	CALL        _SPI1_Init+0, 0
;p10c.c,22 :: 		ADCON1 = 0x07; //E/S digitales
	MOVLW       7
	MOVWF       ADCON1+0 
;p10c.c,25 :: 		INTCON.INT0IF = 0; // Flag a 0
	BCF         INTCON+0, 1 
;p10c.c,26 :: 		INTCON.INT0IE = 1; // se habilitan interrupciones INT0
	BSF         INTCON+0, 4 
;p10c.c,27 :: 		INTCON2.INTEDG0 = 1; // Flanco de subida
	BSF         INTCON2+0, 6 
;p10c.c,29 :: 		INTCON3.INT1IF = 0; // Flag a 0
	BCF         INTCON3+0, 0 
;p10c.c,30 :: 		INTCON3.INT1IE = 1; // se habilitan interrupciones INT1
	BSF         INTCON3+0, 3 
;p10c.c,31 :: 		INTCON2.INTEDG1 = 1; // Flanco de subida
	BSF         INTCON2+0, 5 
;p10c.c,33 :: 		INTCON2.RBPU = 0; //Resistencias de pullup
	BCF         INTCON2+0, 7 
;p10c.c,34 :: 		INTCON.GIE = 1; //Interrupciones en general
	BSF         INTCON+0, 7 
;p10c.c,36 :: 		while(1){
L_main3:
;p10c.c,37 :: 		PORTC.B0 = 0;
	BCF         PORTC+0, 0 
;p10c.c,38 :: 		if(direccion == 0){ //incrementa
	MOVF        _direccion+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main5
;p10c.c,39 :: 		SPI1_Write(valor>>8);
	MOVF        _valor+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;p10c.c,40 :: 		SPI1_Write(valor);
	MOVF        _valor+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;p10c.c,41 :: 		PORTC.B0 = 1;
	BSF         PORTC+0, 0 
;p10c.c,42 :: 		delay_us(6);
	MOVLW       3
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	NOP
	NOP
;p10c.c,43 :: 		valor++;
	INFSNZ      _valor+0, 1 
	INCF        _valor+1, 1 
;p10c.c,44 :: 		for(i = 0; i<= periodo; i++)delay_us(10);
	CLRF        _i+0 
	CLRF        _i+1 
L_main7:
	MOVF        _i+1, 0 
	SUBWF       _periodo+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main23
	MOVF        _i+0, 0 
	SUBWF       _periodo+0, 0 
L__main23:
	BTFSS       STATUS+0, 0 
	GOTO        L_main8
	MOVLW       6
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	NOP
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_main7
L_main8:
;p10c.c,45 :: 		}
L_main5:
;p10c.c,46 :: 		if(direccion == 1){ //decrementa
	MOVF        _direccion+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
;p10c.c,47 :: 		SPI1_Write(valor>>8);
	MOVF        _valor+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;p10c.c,48 :: 		SPI1_Write(valor);
	MOVF        _valor+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;p10c.c,49 :: 		PORTC.B0 = 1;
	BSF         PORTC+0, 0 
;p10c.c,50 :: 		delay_us(6);
	MOVLW       3
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	NOP
	NOP
;p10c.c,51 :: 		valor--;
	MOVLW       1
	SUBWF       _valor+0, 1 
	MOVLW       0
	SUBWFB      _valor+1, 1 
;p10c.c,52 :: 		for(i = 0; i<= periodo; i++)delay_us(10);
	CLRF        _i+0 
	CLRF        _i+1 
L_main13:
	MOVF        _i+1, 0 
	SUBWF       _periodo+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main24
	MOVF        _i+0, 0 
	SUBWF       _periodo+0, 0 
L__main24:
	BTFSS       STATUS+0, 0 
	GOTO        L_main14
	MOVLW       6
	MOVWF       R13, 0
L_main16:
	DECFSZ      R13, 1, 1
	BRA         L_main16
	NOP
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_main13
L_main14:
;p10c.c,53 :: 		}
L_main11:
;p10c.c,54 :: 		if(valor == 0x3FFF) direccion = 1;  //si llega al nivel maximo, se indica que decremente
	MOVF        _valor+1, 0 
	XORLW       63
	BTFSS       STATUS+0, 2 
	GOTO        L__main25
	MOVLW       255
	XORWF       _valor+0, 0 
L__main25:
	BTFSS       STATUS+0, 2 
	GOTO        L_main17
	MOVLW       1
	MOVWF       _direccion+0 
L_main17:
;p10c.c,55 :: 		if(valor == 0x3000) direccion = 0; //si llega al nivel mínimo, se indica que incremente
	MOVF        _valor+1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L__main26
	MOVLW       0
	XORWF       _valor+0, 0 
L__main26:
	BTFSS       STATUS+0, 2 
	GOTO        L_main18
	CLRF        _direccion+0 
L_main18:
;p10c.c,58 :: 		}
	GOTO        L_main3
;p10c.c,60 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
