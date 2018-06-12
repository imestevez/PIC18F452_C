
_interrupt:

;p7b.c,24 :: 		void interrupt(){
;p7b.c,25 :: 		if(INTCON.TMR0IF){
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt0
;p7b.c,26 :: 		ADCON0.B2 = 1;
	BSF         ADCON0+0, 2 
;p7b.c,27 :: 		TMR0H = (18661>>8);
	MOVLW       72
	MOVWF       TMR0H+0 
;p7b.c,28 :: 		TMR0L = 18661;
	MOVLW       229
	MOVWF       TMR0L+0 
;p7b.c,29 :: 		INTCON.TMR0IF = 0;
	BCF         INTCON+0, 2 
;p7b.c,30 :: 		}
L_interrupt0:
;p7b.c,32 :: 		if(PIR1.ADIF){
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt1
;p7b.c,33 :: 		aux =(ADRESH<<8);
	MOVF        ADRESH+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	MOVWF       _aux+0 
	MOVF        R1, 0 
	MOVWF       _aux+1 
;p7b.c,34 :: 		aux =ADRESL + aux;
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
;p7b.c,35 :: 		if(auxAnterior != aux){
	MOVF        _auxAnterior+1, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt7
	MOVF        R2, 0 
	XORWF       _auxAnterior+0, 0 
L__interrupt7:
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt2
;p7b.c,37 :: 		}
L_interrupt2:
;p7b.c,38 :: 		auxAnterior = aux;
	MOVF        _aux+0, 0 
	MOVWF       _auxAnterior+0 
	MOVF        _aux+1, 0 
	MOVWF       _auxAnterior+1 
;p7b.c,39 :: 		PIR1.ADIF = 0;
	BCF         PIR1+0, 6 
;p7b.c,40 :: 		}
L_interrupt1:
;p7b.c,41 :: 		}
L_end_interrupt:
L__interrupt6:
	RETFIE      1
; end of _interrupt

_main:

;p7b.c,43 :: 		void main() {
;p7b.c,44 :: 		TRISB.B0 = 1;
	BSF         TRISB+0, 0 
;p7b.c,45 :: 		TRISE.B1 = 1;
	BSF         TRISE+0, 1 
;p7b.c,46 :: 		Lcd_init();
	CALL        _Lcd_Init+0, 0
;p7b.c,47 :: 		ADCON0 = 0x71; //AN6
	MOVLW       113
	MOVWF       ADCON0+0 
;p7b.c,48 :: 		ADCON1 = 0xC0;
	MOVLW       192
	MOVWF       ADCON1+0 
;p7b.c,52 :: 		PIR1.ADIF = 0;  //flag a 0
	BCF         PIR1+0, 6 
;p7b.c,53 :: 		PIE1.ADIE = 1; //Se habilitan interrupciones AD
	BSF         PIE1+0, 6 
;p7b.c,57 :: 		INTCON.TMR0IF = 0; //Flag a 0
	BCF         INTCON+0, 2 
;p7b.c,58 :: 		INTCON.TMR0IE = 1;   //Se habilitan interrupciones Timer0
	BSF         INTCON+0, 5 
;p7b.c,61 :: 		INTCON1.INT0IF = 0;  //Flag a 0
	BCF         INTCON1+0, 1 
;p7b.c,62 :: 		INTCON1.INT0IE = 1; // Habilitamos interrupcion INT0
	BSF         INTCON1+0, 4 
;p7b.c,63 :: 		INTCON2.RBPU = 0; // Resistencia de pullup
	BCF         INTCON2+0, 7 
;p7b.c,64 :: 		INTCON2.INTEDG0 = 0; // Flanco de bajada
	BCF         INTCON2+0, 6 
;p7b.c,66 :: 		INTCON.PEIE = 1; //Se habilitan interrupciones perifericas
	BSF         INTCON+0, 6 
;p7b.c,67 :: 		INTCON.GIE = 1;  //Se habilitan interrupciones en general
	BSF         INTCON+0, 7 
;p7b.c,68 :: 		ADCON0.B2 = 1;
	BSF         ADCON0+0, 2 
;p7b.c,70 :: 		while(1);
L_main3:
	GOTO        L_main3
;p7b.c,71 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
