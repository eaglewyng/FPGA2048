----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:11 03/26/2014 
-- Design Name: 
-- Module Name:    Box - Game_Arch 
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

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Box is
	generic(
		XPOS : in NATURAL(9 downto 0);
		YPOS : in NATURAL(9 downto 0);
		SQUAREPIXELWIDTH : in NATURAL(9 downto 0)
	);
	port(
		pixel_x : in STD_LOGIC_VECTOR(9 downto 0);
		pixel_y : in STD_LOGIC_VECTOR(9 downto 0);
		value : in UNSIGNED(10 downto 0);
		rgb_color : out STD_LOGIC_VECTOR(7 downto 0);
		--this signal is so we can tell whether we should actually draw the color
		--being output by the box or not!
		drawBox : out STD_LOGIC
	);
end Box;

	
architecture game_arch of Box is
	--============================================================================
	------------------Signal Declarations-----------------------------------------
	--============================================================================
	signal pixel_ux, pixel_uy : UNSIGNED(9 downto 0);
	
	--============================================================================
	------------------Constant Declarations---------------------------------------
	--============================================================================
	constant MAX_Y : UNSIGNED(9 downto 0) := XPOS + SQUAREPIXELWIDTH - 1;
	constant MAX_Y : UNSIGNED(9 downto 0) := YPOS + SQIAREPIXELWIDTH - 1;
	
	
begin
	--============================================================================
	------------------Color Assignment Logic--------------------------------------
	--============================================================================
	with value select
		rgb_color <=
			"10001111" when "00000000000",
			"11111110" when "00000000010",
			"11111000" when "00000000100",
			"11110000" when "00000001000",
			"11100000" when "00000010000",
			"11001100" when "00000100000",
			"11011000" when "00001000000",
			"10011000" when "00010000000",
			"00011100" when "00100000000",
			"00011111" when "01000000000",
			"00011011" when "10000000000",
			"00000011" when others;
	
	--============================================================================
	------------------Display Logic-----------------------------------------------
	--============================================================================
	
		
	
	--============================================================================
	------------------Other Signal Assignments------------------------------------
	--============================================================================
	pixel_ux <= UNSIGNED(pixel_x);
	pixel_uy <= UNSIGNED(pixel_y);
	
end game_arch;

