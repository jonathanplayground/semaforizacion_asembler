; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

    
; PIC16F877A Configuration Bit Settings

; Assembly source line config statements

#include "p16f877a.inc"

; CONFIG
; __config 0x3F39
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
 
 BSF	STATUS,RP0
 BCF	STATUS,RP1
 CLRF	TRISC
 BCF	STATUS,RP0
 BCF	STATUS,RP1
 CLRF	PORTC
 
 MAIN_LOOP:
    
    CALL    viaEspera
    CALL    viaAncha
    CALL    viaEspera
    CALL    viaAngosta
    GOTO    MAIN_LOOP
    
viaEspera:
    BSF	    PORTC,0
    BSF	    PORTC,1	
    BSF	    PORTC,3
    BSF	    PORTC,4
    CALL    RET_1500mS
    RETURN
viaAncha:   
    BSF	    PORTC,0
    BCF	    PORTC,1
    BCF	    PORTC,3
    BSF	    PORTC,4
    CALL    RET_15S
    RETURN
viaAngosta:
    BCF	    PORTC,0
    BSF	    PORTC,1
    BSF	    PORTC,3
    BCF	    PORTC,4
    CALL    RET_10S
    RETURN
    
    
RET_1500mS:
    MOVLW   .30
    MOVWF   0X23
DEC_RET_1500mS:
    CALL    RET_50mS
    DECFSZ  0X23    
    GOTO    DEC_RET_1500mS
    RETURN

RET_10S:
    MOVLW   .2
    MOVWF   0X22
DEC_RET_10S:
    CALL    RET_5S
    DECFSZ  0X22
    GOTO    DEC_RET_10S
    RETURN	
    
RET_15S:
    MOVLW   .3
    MOVWF   0X21
DEC_RET_15S:
    CALL    RET_5S
    DECFSZ  0X21
    GOTO    DEC_RET_15S
    RETURN
    
RET_5S:
    MOVLW   .80
    MOVWF   0X20
DEC_RET_5S:
    CALL    RET_50mS
    DECFSZ  0X20    
    GOTO    DEC_RET_5S
    CLRF    TMR0
    RETURN
    
RET_50mS: 
    BSF	    STATUS,RP0
    BCF	    STATUS,RP1
    MOVLW   b'00000111'
    MOVWF   OPTION_REG
    BCF	    STATUS,RP0
    BCF	    STATUS,RP1
    CLRF    TMR0

LOOP:
    MOVF    TMR0,W
    XORLW   .195
    BTFSS   STATUS,Z
    GOTO    LOOP
    RETURN

    END