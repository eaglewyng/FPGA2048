----------------------------------------------------------------------------------
-- Engineer: Parker Ridd and Travis Chambers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity randomGenerator is
	generic ( width : integer := 4);
    Port ( 
				clk : in  STD_LOGIC;
				random_num : out  STD_LOGIC_VECTOR(width-1 downto 0) --output vector
			 );
			 
end randomGenerator;

architecture Behavioral of randomGenerator is

begin

process(clk)
variable rand_temp : std_logic_vector(width-1 downto 0):=("1000");
variable temp : std_logic := '0';
begin
if(rising_edge(clk)) then
temp := rand_temp(width-1) xor rand_temp(width-2);
rand_temp(width-1 downto 1) := rand_temp(width-2 downto 0);
rand_temp(0) := temp;
end if;
random_num <= rand_temp;
end process;

end Behavioral;

