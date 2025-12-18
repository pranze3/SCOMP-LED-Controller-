; Project_Demo.asm
; Demo

ORG 0

Start:
        LOAD    LED0
        STORE   LEDAddress

NextLED:
        ; Set Brightness = 0
        LOADI   0
        STORE   Brightness

BrightnessLoop:
        ; Load current Brightness
        LOAD    Brightness
        ; Output brightness to current LED address
        OUT     LEDAddress
        ; Check if brightness == 255
        ADDI    -255
        JZERO   NextLEDPrep
        ; If not 255, increment and continue
        LOAD    Brightness
        ADDI    1
        STORE   Brightness
        JUMP    BrightnessLoop

NextLEDPrep:
        ; Load current LED address
        LOAD    LEDAddress
        ; Increment to next LED
        ADDI    1
        STORE   LEDAddress
        ; Check if we've reached LED9 + 1
        ADDI    -42		;2A to decimal
        JZERO   DoReset
        ; Go to next LED
        JUMP    NextLED

DoReset:
        ; Write 1 to RESET register to clear all LEDs
        LOADI   1
        OUT     RESET_REG

End:
        JUMP    End     ; Infinite loop

; =====================
; Constants
; =====================
LED0:           EQU     &H020     ; LED0_BRIGHT address
LED9:           EQU     &H029     ; LED9_BRIGHT address
RESET_REG:      EQU     &H02A     ; Reset register address

; =====================
; Variables
; =====================
Brightness:     DW      0       ; Current brightness (0–255)
LEDAddress:     DW      0       ; Current LED address

