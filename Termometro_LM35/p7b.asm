
_tecla:

;tecla12int.h,25 :: 		unsigned char tecla() // Esta funcion devuelve el valor asociado a la tecla
;tecla12int.h,28 :: 		unsigned char columna=0, fila, aux1=0x10, aux2;
	CLRF        tecla_columna_L0+0 
	MOVLW       16
	MOVWF       tecla_aux1_L0+0 
	MOVLW       49
	MOVWF       tecla_teclado_L0+0 
	MOVLW       50
	MOVWF       tecla_teclado_L0+1 
	MOVLW       51
	MOVWF       tecla_teclado_L0+2 
	MOVLW       52
	MOVWF       tecla_teclado_L0+3 
	MOVLW       53
	MOVWF       tecla_teclado_L0+4 
	MOVLW       54
	MOVWF       tecla_teclado_L0+5 
	MOVLW       55
	MOVWF       tecla_teclado_L0+6 
	MOVLW       56
	MOVWF       tecla_teclado_L0+7 
	MOVLW       57
	MOVWF       tecla_teclado_L0+8 
	MOVLW       42
	MOVWF       tecla_teclado_L0+9 
	MOVLW       48
	MOVWF       tecla_teclado_L0+10 
	MOVLW       35
	MOVWF       tecla_teclado_L0+11 
;tecla12int.h,32 :: 		delay_ms(Debounce);// antes de empezar a escanear las filas y las columnas se
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_tecla0:
	DECFSZ      R13, 1, 1
	BRA         L_tecla0
	DECFSZ      R12, 1, 1
	BRA         L_tecla0
	NOP
;tecla12int.h,34 :: 		for(fila=0; fila<Rows; fila++) // escaneamos las filas para averiguar la fila
	CLRF        tecla_fila_L0+0 
L_tecla1:
	MOVLW       4
	SUBWF       tecla_fila_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tecla2
;tecla12int.h,36 :: 		if((PORTB&aux1)==0x00) break; //en la fila de la tecla pulsada hay un 0 y en
	MOVF        tecla_aux1_L0+0, 0 
	ANDWF       PORTB+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_tecla4
	GOTO        L_tecla2
L_tecla4:
;tecla12int.h,37 :: 		aux1=(aux1<<1);                //las demás hay un 1.
	RLCF        tecla_aux1_L0+0, 1 
	BCF         tecla_aux1_L0+0, 0 
;tecla12int.h,34 :: 		for(fila=0; fila<Rows; fila++) // escaneamos las filas para averiguar la fila
	INCF        tecla_fila_L0+0, 1 
;tecla12int.h,38 :: 		}
	GOTO        L_tecla1
L_tecla2:
;tecla12int.h,40 :: 		PORTB=0x01; // valor del puerto B para escanear la primera columna (columna=0).
	MOVLW       1
	MOVWF       PORTB+0 
;tecla12int.h,42 :: 		while((PORTB&MASK)!=MASK)// se escanean las columnas hasta que se encuentra la
L_tecla5:
	MOVLW       240
	ANDWF       PORTB+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       240
	BTFSC       STATUS+0, 2 
	GOTO        L_tecla6
;tecla12int.h,44 :: 		PORTB=(PORTB<<1);       //caso, las filas estarán todas a 1. Al escanear las
	MOVF        PORTB+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;tecla12int.h,45 :: 		columna++;            //columnas se produce un flanco de subida en el terminal
	INCF        tecla_columna_L0+0, 1 
;tecla12int.h,46 :: 		}                      //correspondiente a la fila de la tecla pulsada, lo que
	GOTO        L_tecla5
L_tecla6:
;tecla12int.h,49 :: 		PORTB=0x00; //condiciones del PORTB de espera a que se pulse una nueva tecla
	CLRF        PORTB+0 
;tecla12int.h,51 :: 		do // esperamos a que se deje de pulsar la tecla para enviar su valor.
L_tecla7:
;tecla12int.h,52 :: 		{delay_ms(2);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_tecla10:
	DECFSZ      R13, 1, 1
	BRA         L_tecla10
	DECFSZ      R12, 1, 1
	BRA         L_tecla10
	NOP
;tecla12int.h,53 :: 		}while((PORTB&0xF0)!=0xF0); //Al soltar la tecla, se produce un cambio de nivel
	MOVLW       240
	ANDWF       PORTB+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L_tecla7
;tecla12int.h,57 :: 		aux2=teclado[fila][columna];//devuelve el valor ASCII de la tecla pulsada
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        tecla_fila_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       tecla_teclado_L0+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(tecla_teclado_L0+0)
	ADDWFC      R1, 1 
	MOVF        tecla_columna_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;tecla12int.h,58 :: 		return aux2;
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
;tecla12int.h,59 :: 		}
L_end_tecla:
	RETURN      0
; end of _tecla

_interrupt:

;p7b.c,22 :: 		void interrupt(){
;p7b.c,24 :: 		if(INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt11
;p7b.c,25 :: 		ADCON0.B2 = 1;
	BSF         ADCON0+0, 2 
;p7b.c,26 :: 		TMR0H = (18661>>8);
	MOVLW       72
	MOVWF       TMR0H+0 
;p7b.c,27 :: 		TMR0L = 18661;
	MOVLW       229
	MOVWF       TMR0L+0 
;p7b.c,28 :: 		}
L_interrupt11:
;p7b.c,29 :: 		if(PIR1.ADIF){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt12
;p7b.c,30 :: 		aux =(ADRESH<<8);
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       _aux+0 
	MOVF        R1, 0 
	MOVWF       _aux+1 
;p7b.c,31 :: 		aux =ADRESL + aux;
	MOVF        ADRESL+0, 0 
	ADDWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	MOVWF       _aux+0 
	MOVF        R3, 0 
	MOVWF       _aux+1 
;p7b.c,32 :: 		if(auxAnterior != aux){
	MOVF        _auxAnterior+1, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt19
	MOVF        R2, 0 
	XORWF       _auxAnterior+0, 0 
L__interrupt19:
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt13
;p7b.c,33 :: 		vi = aux*resolucion;
	MOVF        _aux+0, 0 
	MOVWF       R0 
	MOVF        _aux+1, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        _resolucion+0, 0 
	MOVWF       R4 
	MOVF        _resolucion+1, 0 
	MOVWF       R5 
	MOVF        _resolucion+2, 0 
	MOVWF       R6 
	MOVF        _resolucion+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _vi+0 
	MOVF        R1, 0 
	MOVWF       _vi+1 
	MOVF        R2, 0 
	MOVWF       _vi+2 
	MOVF        R3, 0 
	MOVWF       _vi+3 
;p7b.c,34 :: 		FloatToStr(vi, txt);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;p7b.c,35 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;p7b.c,36 :: 		Lcd_out(1,1,txt);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;p7b.c,37 :: 		}
L_interrupt13:
;p7b.c,38 :: 		auxAnterior = aux;
	MOVF        _aux+0, 0 
	MOVWF       _auxAnterior+0 
	MOVF        _aux+1, 0 
	MOVWF       _auxAnterior+1 
;p7b.c,39 :: 		}
L_interrupt12:
;p7b.c,40 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p7b.c,41 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p7b.c,42 :: 		}
L_end_interrupt:
L__interrupt18:
	RETFIE      1
; end of _interrupt

_main:

;p7b.c,44 :: 		void main() {
;p7b.c,46 :: 		Lcd_init();
	CALL        _Lcd_Init+0, 0
;p7b.c,47 :: 		ADCON0 = 0x71; //AN6
	MOVLW       113
	MOVWF       ADCON0+0 
;p7b.c,48 :: 		ADCON1 = 0XC0;
	MOVLW       192
	MOVWF       ADCON1+0 
;p7b.c,51 :: 		PIR1.ADIF = 0;  //flag a 0
	BCF         PIR1+0, 6 
;p7b.c,52 :: 		PIE1.ADIE = 1; //Se habilitan interrupciones AD
	BSF         PIE1+0, 6 
;p7b.c,53 :: 		INTCON.PEIE = 1; //Se habilitan interrupciones perifericas
	BSF         INTCON+0, 6 
;p7b.c,54 :: 		INTCON.GIE = 1;  //Se habilitan interrupciones en general
	BSF         INTCON+0, 7 
;p7b.c,57 :: 		T0CON = 0x85; //Pre 64 ; Modo 16 bits
	MOVLW       133
	MOVWF       T0CON+0 
;p7b.c,58 :: 		INTCON.TMR0IF = 0; //Flag a 0
	BCF         INTCON+0, 2 
;p7b.c,59 :: 		INTCON.TMR0IE = 1;   //Se habilitan interrupciones Timer0
	BSF         INTCON+0, 5 
;p7b.c,61 :: 		TMR0H = (18661>>8);
	MOVLW       72
	MOVWF       TMR0H+0 
;p7b.c,62 :: 		TMR0L = 18661;
	MOVLW       229
	MOVWF       TMR0L+0 
;p7b.c,63 :: 		ADCON0.B2 = 1;
	BSF         ADCON0+0, 2 
;p7b.c,65 :: 		while(1);
L_main14:
	GOTO        L_main14
;p7b.c,66 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
