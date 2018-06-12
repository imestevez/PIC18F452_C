
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

;p5c.c,23 :: 		void interrupt() {
;p5c.c,24 :: 		if(interrupcion == 0){
	MOVF        _interrupcion+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
;p5c.c,25 :: 		Lcd_Out(1,1,"Turno: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_p5c+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_p5c+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;p5c.c,26 :: 		interrupcion++;
	INCF        _interrupcion+0, 1 
;p5c.c,27 :: 		}else{cont++;}
	GOTO        L_interrupt12
L_interrupt11:
	INCF        _cont+0, 1 
L_interrupt12:
;p5c.c,29 :: 		if((cont%2) != 0)  {
	MOVLW       1
	ANDWF       _cont+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt13
;p5c.c,30 :: 		aux++;
	INCF        _aux+0, 1 
;p5c.c,31 :: 		if(aux>99) {aux = 0;}
	MOVF        _aux+0, 0 
	SUBLW       99
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt14
	CLRF        _aux+0 
L_interrupt14:
;p5c.c,32 :: 		}else{
	GOTO        L_interrupt15
L_interrupt13:
;p5c.c,33 :: 		cont = 0;
	CLRF        _cont+0 
;p5c.c,34 :: 		}
L_interrupt15:
;p5c.c,35 :: 		ByteToStr(aux, txt);
	MOVF        _aux+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _txt+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;p5c.c,36 :: 		Lcd_Out(1,8,txt);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;p5c.c,37 :: 		x = PORTB;
	MOVF        PORTB+0, 0 
	MOVWF       _x+0 
;p5c.c,38 :: 		INTCON.RBIF=0;
	BCF         INTCON+0, 0 
;p5c.c,39 :: 		}
L_end_interrupt:
L__interrupt20:
	RETFIE      1
; end of _interrupt

_main:

;p5c.c,40 :: 		void main() {
;p5c.c,42 :: 		TRISB = 0xF0;
	MOVLW       240
	MOVWF       TRISB+0 
;p5c.c,44 :: 		Lcd_Init ();
	CALL        _Lcd_Init+0, 0
;p5c.c,45 :: 		ADCON1 = 0x07;
	MOVLW       7
	MOVWF       ADCON1+0 
;p5c.c,47 :: 		INTCON2.RBPU = 0; //Habilitacmos resistencia pullup
	BCF         INTCON2+0, 7 
;p5c.c,48 :: 		x=PORTB; //para poder borrar el RBIF
	MOVF        PORTB+0, 0 
	MOVWF       _x+0 
;p5c.c,49 :: 		INTCON.RBIF = 0; //flag a 0
	BCF         INTCON+0, 0 
;p5c.c,50 :: 		INTCON.RBIE = 1;
	BSF         INTCON+0, 3 
;p5c.c,51 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p5c.c,53 :: 		x=PORTB; //para poder borrar el RBIF
	MOVF        PORTB+0, 0 
	MOVWF       _x+0 
;p5c.c,54 :: 		INTCON.RBIF = 1; //flag a 1
	BSF         INTCON+0, 0 
;p5c.c,56 :: 		while(1);
L_main16:
	GOTO        L_main16
;p5c.c,58 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
