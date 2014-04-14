----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:32:53 04/14/2014 
-- Design Name: 
-- Module Name:    BoxDisplay - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BoxDisplay is
    Port ( pixel_x : in  STD_LOGIC_VECTOR (9 downto 0);
           pixel_y : in  STD_LOGIC_VECTOR (9 downto 0);
			  boxValue : in STD_LOGIC_VECTOR (15 downto 0);
           rgbOut : out  STD_LOGIC_VECTOR (7 downto 0);
			  drawOutput : out STD_LOGIC);
end BoxDisplay;

architecture Behavioral of BoxDisplay is

	signal drawBox : UNSIGNED(5 downto 0);
	signal drawNumber :  STD_LOGIC;

begin
	
	
	

end Behavioral;

