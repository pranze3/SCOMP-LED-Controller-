        ORG 0

Start:
        ; Set individual brightness values
        LOAD B0         
		OUT LED0_BRIGHT   ; LED0 = 32
        LOAD B1         
		OUT LED1_BRIGHT   ; LED1 = 64
        LOAD B2         
		OUT LED2_BRIGHT   ; LED2 = 96
        LOAD B3         
		OUT LED3_BRIGHT   ; LED3 = 128
        LOAD B4         
		OUT LED4_BRIGHT   ; LED4 = 160
        LOAD B5         
		OUT LED5_BRIGHT   ; LED5 = 192
        LOAD B6         
		OUT LED6_BRIGHT   ; LED6 = 224
        LOAD B7         
		OUT LED7_BRIGHT   ; LED7 = 255
        LOAD B8         
		OUT LED8_BRIGHT   ; LED8 = 255
        LOAD B9         
		OUT LED9_BRIGHT   ; LED9 = 255

        ; Enable all LEDs (selector = 0x03FF)
        LOAD AllLEDsMask
        OUT LED_SELECTOR

MainLoop:
        JUMP MainLoop

; --- Brightness Data ---
B0:     DW &H0F    ; 15
B1:     DW &H28    ; 40
B2:     DW &H41    ; 65
B3:     DW &H5A    ; 90
B4:     DW &H73    ; 115
B5:     DW &H8C    ; 140
B6:     DW &HA5    ; 165
B7:     DW &HBE    ; 190
B8:     DW &HD7    ; 215
B9:     DW &HFA    ; 250

AllLEDsMask:    DW &H03FF  ; Binary 1111111111 (all LEDs on)

; --- I/O Address Map (matches IO_DECODER.VHD) ---
LED0_BRIGHT:    EQU &H020
LED1_BRIGHT:    EQU &H021
LED2_BRIGHT:    EQU &H022
LED3_BRIGHT:    EQU &H023
LED4_BRIGHT:    EQU &H024
LED5_BRIGHT:    EQU &H025
LED6_BRIGHT:    EQU &H026
LED7_BRIGHT:    EQU &H027
LED8_BRIGHT:    EQU &H028
LED9_BRIGHT:    EQU &H029
LED_SELECTOR:   EQU &H001  ; LED enable (selector register)
