-- IO DECODER for SCOMP
-- This eliminates the need for a lot of AND decoders or Comparators 
--    that would otherwise be spread around the top-level BDF

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY IO_DECODER IS

  PORT
  (
    IO_ADDR       : IN STD_LOGIC_VECTOR(10 downto 0);
    IO_CYCLE      : IN STD_LOGIC;
    SWITCH_EN     : OUT STD_LOGIC;
    TIMER_EN      : OUT STD_LOGIC;
    HEX0_EN       : OUT STD_LOGIC;
    HEX1_EN       : OUT STD_LOGIC;
	 LED0_BRIGHT	: OUT STD_LOGIC;
	 LED1_BRIGHT	: OUT STD_LOGIC;
	 LED2_BRIGHT	: OUT STD_LOGIC;
	 LED3_BRIGHT	: OUT STD_LOGIC;
	 LED4_BRIGHT	: OUT STD_LOGIC;
	 LED5_BRIGHT	: OUT STD_LOGIC;
	 LED6_BRIGHT	: OUT STD_LOGIC;
	 LED7_BRIGHT	: OUT STD_LOGIC;
	 LED8_BRIGHT	: OUT STD_LOGIC;
	 LED9_BRIGHT	: OUT STD_LOGIC;
	 LEDs_EN			: OUT STD_LOGIC
  );

END ENTITY;

ARCHITECTURE a OF IO_DECODER IS

  SIGNAL  ADDR_INT  : INTEGER RANGE 0 TO 2047;
  
begin

	ADDR_INT <= TO_INTEGER(UNSIGNED(IO_ADDR));	  
	SWITCH_EN    <= '1' WHEN (ADDR_INT = 16#000#) and (IO_CYCLE = '1') ELSE '0';
	TIMER_EN     <= '1' WHEN (ADDR_INT = 16#002#) and (IO_CYCLE = '1') ELSE '0';
	HEX0_EN      <= '1' WHEN (ADDR_INT = 16#004#) and (IO_CYCLE = '1') ELSE '0';
	HEX1_EN      <= '1' WHEN (ADDR_INT = 16#005#) and (IO_CYCLE = '1') ELSE '0';
	LEDs_EN          <= '1' WHEN (ADDR_INT = 16#001#) and (IO_CYCLE = '1') ELSE '0';
	LED0_BRIGHT      <= '1' WHEN (ADDR_INT = 16#020#) and (IO_CYCLE = '1') ELSE '0';
	LED1_BRIGHT      <= '1' WHEN (ADDR_INT = 16#021#) and (IO_CYCLE = '1') ELSE '0';
	LED2_BRIGHT      <= '1' WHEN (ADDR_INT = 16#022#) and (IO_CYCLE = '1') ELSE '0';
	LED3_BRIGHT      <= '1' WHEN (ADDR_INT = 16#023#) and (IO_CYCLE = '1') ELSE '0';
	LED4_BRIGHT      <= '1' WHEN (ADDR_INT = 16#024#) and (IO_CYCLE = '1') ELSE '0';
	LED5_BRIGHT      <= '1' WHEN (ADDR_INT = 16#025#) and (IO_CYCLE = '1') ELSE '0';
	LED6_BRIGHT      <= '1' WHEN (ADDR_INT = 16#026#) and (IO_CYCLE = '1') ELSE '0';
	LED7_BRIGHT      <= '1' WHEN (ADDR_INT = 16#027#) and (IO_CYCLE = '1') ELSE '0';
	LED8_BRIGHT      <= '1' WHEN (ADDR_INT = 16#028#) and (IO_CYCLE = '1') ELSE '0';
	LED9_BRIGHT      <= '1' WHEN (ADDR_INT = 16#029#) and (IO_CYCLE = '1') ELSE '0';
      
END a;
