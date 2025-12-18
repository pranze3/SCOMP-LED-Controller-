-- LEDController.VHD
-- 2025.04.05

-- Full VHDL file to implement PWM and Gamma correction to set LED brightness values 

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY LEDController IS
PORT(
    CS          : IN  STD_LOGIC; --led peripheral enable signal
    WRITE_EN    : IN  STD_LOGIC; --SCOMP IO_Write
    RESETN      : IN  STD_LOGIC; --RESET from SCOMP main system
    LEDs        : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); --out to LEDs
    IO_DATA     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); --IO_Data from SCOMP, brightness value
	 clk			 : in	 std_logic; --100kHz clock
	 led0_bright : in	 std_logic; --brightness address enable for led0
	 led1_bright : in  std_logic; --" " led1
	 led2_bright : in  std_logic; --" " led2
	 led3_bright : in  std_logic; --" " led3
	 led4_bright : in  std_logic; --" " led4
	 led5_bright : in  std_logic; --" " led5
	 led6_bright : in  std_logic; --" " led6
	 led7_bright : in  std_logic; --" " led7
	 led8_bright : in  std_logic; --" " led8
	 led9_bright : in  std_logic  --" " led9
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
	 signal led0_reg : std_logic_vector(7 downto 0) := (others => '1'); --led0 brightness value
	 signal led1_reg : std_logic_vector(7 downto 0) := (others => '1'); --led1 brightness value
	 signal led2_reg : std_logic_vector(7 downto 0) := (others => '1'); --led2 brightness value
	 signal led3_reg : std_logic_vector(7 downto 0) := (others => '1'); --led3 brightness value
	 signal led4_reg : std_logic_vector(7 downto 0) := (others => '1'); --led4 brightness value
	 signal led5_reg : std_logic_vector(7 downto 0) := (others => '1'); --led5 brightness value
	 signal led6_reg : std_logic_vector(7 downto 0) := (others => '1'); --led6 brightness value
	 signal led7_reg : std_logic_vector(7 downto 0) := (others => '1'); --led7 brightness value
	 signal led8_reg : std_logic_vector(7 downto 0) := (others => '1'); --led8 brightness value
	 signal led9_reg : std_logic_vector(7 downto 0) := (others => '1'); --led9 brightness value
	 signal selector : std_logic_vector(9 downto 0) := (others => '0'); --led selector, corresopnds to IO_Data(9 downto 0)
	 signal gamma    : std_logic_vector(9 downto 0) := (others => '1'); --sets corrected pwm value
	 signal counter  : std_logic_vector(7 downto 0) := (others => '0'); --counter to set duty cycle
	-- Gamma correction LUT (γ=2.2)
  TYPE gamma_lut_type IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  CONSTANT gamma_lut : gamma_lut_type := (
    x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"01",
    x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"01", x"02", x"02", x"02", x"02", x"02", x"02", x"02",
    x"03", x"03", x"03", x"03", x"03", x"04", x"04", x"04", x"04", x"05", x"05", x"05", x"05", x"06", x"06", x"06",
    x"06", x"07", x"07", x"07", x"08", x"08", x"08", x"09", x"09", x"09", x"0A", x"0A", x"0B", x"0B", x"0B", x"0C",
    x"0C", x"0D", x"0D", x"0D", x"0E", x"0E", x"0F", x"0F", x"10", x"10", x"11", x"11", x"12", x"12", x"13", x"13",
    x"14", x"14", x"15", x"16", x"16", x"17", x"17", x"18", x"19", x"19", x"1A", x"1A", x"1B", x"1C", x"1C", x"1D",
    x"1E", x"1E", x"1F", x"20", x"21", x"21", x"22", x"23", x"23", x"24", x"25", x"26", x"27", x"27", x"28", x"29",
    x"2A", x"2B", x"2B", x"2C", x"2D", x"2E", x"2F", x"30", x"31", x"31", x"32", x"33", x"34", x"35", x"36", x"37",
    x"38", x"39", x"3A", x"3B", x"3C", x"3D", x"3E", x"3F", x"40", x"41", x"42", x"43", x"44", x"45", x"46", x"47",
    x"49", x"4A", x"4B", x"4C", x"4D", x"4E", x"4F", x"51", x"52", x"53", x"54", x"55", x"57", x"58", x"59", x"5A",
    x"5B", x"5D", x"5E", x"5F", x"61", x"62", x"63", x"64", x"66", x"67", x"69", x"6A", x"6B", x"6D", x"6E", x"6F",
    x"71", x"72", x"74", x"75", x"77", x"78", x"79", x"7B", x"7C", x"7E", x"7F", x"81", x"82", x"84", x"85", x"87",
    x"89", x"8A", x"8C", x"8D", x"8F", x"91", x"92", x"94", x"95", x"97", x"99", x"9A", x"9C", x"9E", x"9F", x"A1",
    x"A3", x"A5", x"A6", x"A8", x"AA", x"AC", x"AD", x"AF", x"B1", x"B3", x"B5", x"B6", x"B8", x"BA", x"BC", x"BE",
    x"C0", x"C2", x"C4", x"C5", x"C7", x"C9", x"CB", x"CD", x"CF", x"D1", x"D3", x"D5", x"D7", x"D9", x"DB", x"DD",
    x"DF", x"E1", x"E3", x"E5", x"E7", x"EB", x"EC", x"EE", x"F0", x"F2", x"F4", x"F6", x"F8", x"FB", x"FD", x"FF"
  );
  
  
	 
BEGIN
    PROCESS (RESETN, CS)
    BEGIN
        IF (RESETN = '0') THEN
            -- Turn off LEDs at reset (a nice usability feature)
            selector <= (others =>'0');
        ELSIF (RISING_EDGE(CS)) THEN
            IF WRITE_EN = '1' THEN
                -- If SCOMP is sending data to this peripheral,
                -- use that data directly as the on/off values
                -- for the LEDs.
            selector <= IO_DATA(9 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;
	 
	 process (RESETN, led0_bright)
	 begin
		if (resetn = '0') then
			led0_reg <= (others => '1');
		elsif (rising_edge(led0_bright)) then
			if (WRITE_EN = '1') then
				led0_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led1_bright)
	 begin
		if (resetn = '0') then
			led1_reg <= (others => '1');
		elsif (rising_edge(led1_bright)) then
			if (WRITE_EN = '1') then
				led1_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led2_bright)
	 begin
		if (resetn = '0') then
			led2_reg <= (others => '1');
		elsif (rising_edge(led2_bright)) then
			if (WRITE_EN = '1') then
				led2_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led3_bright)
	 begin
		if (resetn = '0') then
			led3_reg <= (others => '1');
		elsif (rising_edge(led3_bright)) then
			if (WRITE_EN = '1') then
				led3_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led4_bright)
	 begin
		if (resetn = '0') then
			led4_reg <= (others => '1');
		elsif (rising_edge(led4_bright)) then
			if (WRITE_EN = '1') then
				led4_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led5_bright)
	 begin
		if (resetn = '0') then
			led5_reg <= (others => '1');
		elsif (rising_edge(led5_bright)) then
			if (WRITE_EN = '1') then
				led5_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led6_bright)
	 begin
		if (resetn = '0') then
			led6_reg <= (others => '1');
		elsif (rising_edge(led6_bright)) then
			if (WRITE_EN = '1') then
				led6_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led7_bright)
	 begin
		if (resetn = '0') then
			led7_reg <= (others => '1');
		elsif (rising_edge(led7_bright)) then
			if (WRITE_EN = '1') then
				led7_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led8_bright)
	 begin
		if (resetn = '0') then
			led8_reg <= (others => '1');
		elsif (rising_edge(led8_bright)) then
			if (WRITE_EN = '1') then
				led8_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (RESETN, led9_bright)
	 begin
		if (resetn = '0') then
			led9_reg <= (others => '1');
		elsif (rising_edge(led9_bright)) then
			if (WRITE_EN = '1') then
				led9_reg <= IO_Data(7 downto 0);
			end if;
		end if;
	 end process;
	 
	 process (clk, resetn)
	 begin
		if resetn = '0' then
			counter <= (others => '0');
		elsif (rising_edge(clk)) then
			counter <= counter + 1;
--			if counter > 255 then
--				counter <= 0;
--			end if;
		end if;	
	 end process;
	
	process (led0_reg, led1_reg, led2_reg, led3_reg, led4_reg, led5_reg, led6_reg, led7_reg, led8_reg, led9_reg, counter, selector)
	begin
		
		--LED0 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led0_reg))) then
		 gamma(0) <= '1';
		else
		 gamma(0) <= '0';
		end if;
		
		--LED1 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led1_reg))) then
		 gamma(1) <= '1';
		else
		 gamma(1) <= '0';
		end if; 
		
		--LED2 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led2_reg))) then
		 gamma(2) <= '1';
		else
		 gamma(2) <= '0';
		end if; 
		
		--LED3 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led3_reg))) then
		 gamma(3) <= '1';
		else
		 gamma(3) <= '0';
		end if; 
		
		--LED4 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led4_reg))) then
		 gamma(4) <= '1';
		else
		 gamma(4) <= '0';
		end if; 
		
		--LED5 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led5_reg))) then
		 gamma(5) <= '1';
		else
		 gamma(5) <= '0';
		end if; 
		
		--LED6 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led6_reg))) then
		 gamma(6) <= '1';
		else
		 gamma(6) <= '0';
		end if; 
		
		--LED7 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led7_reg))) then
		 gamma(7) <= '1';
		else
		 gamma(7) <= '0';
		end if;
	
	   --LED8 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led8_reg))) then
		 gamma(8) <= '1';
		else
		 gamma(8) <= '0';
		end if; 
		
		--LED9 check
		if counter < gamma_lut(NUMERIC_STD.to_integer(NUMERIC_STD.unsigned(led9_reg))) then
		 gamma(9) <= '1';
		else
		 gamma(9) <= '0';
		end if;
	end process;
	
	
    gen_leds: FOR i IN 0 TO 9 generate
	 begin
	 LEDs(i) <=  selector(i) and gamma(i);
	 END generate gen_leds;
	 
--	 FOR i IN 0 TO 9 loop
--	 begin
--	 LEDs(i) <=  selector(i) and gamma(i);
--	 END loop;
	 
END a;