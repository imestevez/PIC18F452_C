
_interrupt:

;p7a.c,23 :: 		void interrupt(){
;p7a.c,24 :: 		x = ADRESH<<8;
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       _x+0 
	MOVF        R1, 0 
	MOVWF       _x+1 
;p7a.c,25 :: 		aux =ADRESL + x;
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
;p7a.c,26 :: 		if(auxAnterior != aux){
	MOVF        _auxAnterior+1, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt6
	MOVF        R2, 0 
	XORWF       _auxAnterior+0, 0 
L__interrupt6:
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt0
;p7a.c,27 :: 		vi = aux*resolucion;
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
;p7a.c,28 :: 		FloatToStr (vi, txt);
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
;p7a.c,29 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;p7a.c,30 :: 		Lcd_out(1,1,txt);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;p7a.c,32 :: 		}
L_interrupt0:
;p7a.c,33 :: 		delay_ms(1000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_interrupt1:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt1
	DECFSZ      R12, 1, 1
	BRA         L_interrupt1
	DECFSZ      R11, 1, 1
	BRA         L_interrupt1
	NOP
	NOP
;p7a.c,34 :: 		ADCON0.B2 =1;
	BSF         ADCON0+0, 2 
;p7a.c,35 :: 		auxAnterior = aux;
	MOVF        _aux+0, 0 
	MOVWF       _auxAnterior+0 
	MOVF        _aux+1, 0 
	MOVWF       _auxAnterior+1 
;p7a.c,36 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p7a.c,37 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt

_main:

;p7a.c,39 :: 		void main() {
;p7a.c,41 :: 		Lcd_init();
	CALL        _Lcd_Init+0, 0
;p7a.c,42 :: 		ADCON0 = 0x41;
	MOVLW       65
	MOVWF       ADCON0+0 
;p7a.c,43 :: 		ADCON1 = 0XC0;
	MOVLW       192
	MOVWF       ADCON1+0 
;p7a.c,44 :: 		TRISA.B0 = 1;
	BSF         TRISA+0, 0 
;p7a.c,47 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p7a.c,48 :: 		PIE1.ADIE = 1;
	BSF         PIE1+0, 6 
;p7a.c,49 :: 		INTCON.PEIE = 1;
	BSF         INTCON+0, 6 
;p7a.c,50 :: 		INTCON.GIE = 1;
	BSF         INTCON+0, 7 
;p7a.c,52 :: 		ADCON0.B2 = 1;
	BSF         ADCON0+0, 2 
;p7a.c,54 :: 		while(1){
L_main2:
;p7a.c,56 :: 		}
	GOTO        L_main2
;p7a.c,57 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
