----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:07:57 01/29/2014 
-- Design Name: 
-- Module Name:    seven_segment_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_segment_display is
	 generic( COUNTER_BITS : natural := 15);
    Port ( clk : in  STD_LOGIC;
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           dp_in : in  STD_LOGIC_VECTOR (3 downto 0);
           blank : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC;
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end seven_segment_display;

architecture Behavioral of seven_segment_display is
	--make aliases for the in digits, because I know I will be confused if I don't
	alias digit0in : std_logic_vector(3 downto 0) is data_in(3 downto 0);
	alias digit1in : std_logic_vector(3 downto 0) is data_in(7 downto 4);
	alias digit2in : std_logic_vector(3 downto 0) is data_in(11 downto 8);
	alias digit3in : std_logic_vector(3 downto 0) is data_in(15 downto 12);
	--make signals for the binary counter
	signal  r_next: unsigned(COUNTER_BITS-1 downto 0);
	signal  r_reg: unsigned(COUNTER_BITS-1 downto 0) := (others =>'0');
	--make signal for the value to be displayed
	signal dispVal : std_logic_vector(3 downto 0);
	signal dp_inverted : std_logic_vector(3 downto 0);
	signal top2 : std_logic_vector(1 downto 0);
begin
	--binary conter--
	
	process(clk)
	begin
		if(clk' event and clk = '1') then
			r_reg <= r_next;
		end if;
	end process;
	--nxt state
	r_next <= r_reg + 1;
	
	
	top2 <= std_logic_vector(r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2));
	dp_inverted <= not dp_in;
	with top2 select
		dp <= dp_inverted(0) when "00",
				dp_inverted(1) when "01",
				dp_inverted(2) when "10",
				dp_inverted(3) when others;

	
	--anode select logic
	an(0) <= '1' when (blank(0) = '1') else
				'0' when (r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2) = "00") else 
				'1';
	an(1) <= '1' when (blank(1) = '1') else
				'0' when (r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2) = "01") else 
				'1';
	an(2) <= '1' when (blank(2) = '1') else
				'0' when (r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2) = "10") else 
				'1';
	an(3) <= '1' when (blank(3) = '1') else
				'0' when (r_reg(COUNTER_BITS-1 downto COUNTER_BITS-2) = "11") else 
				'1';
	
	--data_in select logic
	
	with top2 select
		dispVal <= digit0in when "00",
					  digit1in when "01",
					  digit2in when "10",
					  digit3in when others;
	
	--decode the selected logic into the digits
	with dispVal select
	seg <= "1000000" when "0000",
			 "1111001" when "0001",
			 "0100100" when "0010",
			 "0110000" when "0011",
			 "0011001" when "0100",
			 "0010010" when "0101",
			 "0000010" when "0110",
			 "1111000" when "0111",
			 "0000000" when "1000",
			 "0010000" when "1001",
			 "0001000" when "1010",
			 "0000011" when "1011",
			 "1000110" when "1100",
			 "0100001" when "1101",
			 "0000110" when "1110",
			 "0001110" when others;	

end Behavioral;

