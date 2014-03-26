----------------------------------------------------------------------------------
-- Company: Parker Ridd and Travis Chambers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Grid is
	port (
				clk : in std_logic;
				rst : in std_logic;
				grid_color : in std_logic_vector(7 downto 0);
				pixel_x : in std_logic_vector(9 downto 0);
				pixel_y : in std_logic_vector(10 downto 0)
	
	);
end Grid;

architecture Behavioral of Grid is

type row is array (3 downto 0) of unsigned(1 downto 0);
type column is array (3 downto 0) of unsigned(10 downto 0);

begin

end Behavioral;

