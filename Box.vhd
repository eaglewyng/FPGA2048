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
		YPOS : in NATURAL(9 downto 0)
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
	signal background_color : STD_LOGIC_VECTOR(7 downto 0);
	signal number_color : STD_LOGIC_VECTOR(7 downto 0);
	signal draw_number : STD_LOGIC;
	
	--============================================================================
	------------------Constant Declarations---------------------------------------
	--============================================================================
	constant DIMENSIONS : UNSIGNED(9 downto 0) := 90;
	constant MAX_X : UNSIGNED(9 downto 0) := XPOS + DIMENSIONS - 1;
	constant MAX_Y : UNSIGNED(9 downto 0) := YPOS + DIMENSIONS - 1;
	
	
	
	
	
begin
	--============================================================================
	------------------Color Assignment Logic--------------------------------------
	--============================================================================
	with value select
		background_color <=
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
			
		
	process(value, pixel_x, pixel_y)
	begin
		case value is
			when 0 =>      
			when 2 =>
				 if(pixel_ux >= 30 and pixel_ux < 60) then
						if((pixel_uy >= 24 and pixel_uy < 30) or
							(pixel_uy >= 42 and pixel_uy < 48) or
							(pixel_uy >= 69 and pixel_uy < 66)) then
							number_color <= "00000000";
							drawNumber <= '1';
						end if;
				end if;
			when 4 =>
			when 8 =>         
			when 16 =>
			when 32 =>
			when 64 =>
			when 128 =>
			when 256 =>
			when 512 =>
			when 1024 =>
			when others =>
		end case;
	end process;
	
	
	--============================================================================
	------------------Display Logic-----------------------------------------------
	--============================================================================
	drawBox <= '1' when pixel_ux >= XPOS and pixel_ux <= MAX_X and pixel_uy >= YPOS and pixel_uy <= MAX_Y else
					'0';
	
		
	
	--============================================================================
	------------------Other Signal Assignments------------------------------------
	--============================================================================
	pixel_ux <= UNSIGNED(pixel_x);
	pixel_uy <= UNSIGNED(pixel_y);
	
end game_arch;

