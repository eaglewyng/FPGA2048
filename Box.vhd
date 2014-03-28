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
		XPOS : in NATURAL;
		YPOS : in NATURAL
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
	signal posXPix, posYPix : UNSIGNED(9 downto 0);
	signal background_color : STD_LOGIC_VECTOR(7 downto 0);
	signal number_color : STD_LOGIC_VECTOR(7 downto 0);
	signal draw_number : STD_LOGIC;
	
	--============================================================================
	------------------Constant Declarations---------------------------------------
	--============================================================================
	constant DIMENSIONS : UNSIGNED(9 downto 0) := TO_UNSIGNED(90, 10);
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
		draw_number <= '0';
		number_color <= "00000000";
		case value is
			when "000000000000" =>      
			when "000000000010" =>
				 if(posXPix >= 30 and posXPix < 60) then
						if((posYPix >= 24 and posYPix < 30) or
							(posYPix >= 42 and posYPix < 48) or
							(posYPix >= 69 and posYPix < 66)) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
				end if;
			when "000000000100" =>
				if(posXPix >= 36 and posXPix < 53) then
						if(posYPix >=42 and posYPix < 48) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
				elsif(posXPix >= 39 and posXPix < 36) then
						if(posYPix >= 42 and posYPix < 66) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
				elsif(posXPix >= 54 and posXPix < 60) then
						if(posYPix >= 24 and posYPix < 66) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
				end if;
				         
			when "000000001000" =>
				if(pixel_ux >= 30 and pixel_ux < 60) then
						if((pixel_uy >= 24 and pixel_uy < 30) or
							(pixel_uy >= 42 and pixel_uy < 48) or
							(pixel_uy >= 60 and pixel_uy < 66)) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
				end if;
			when "000000010000" =>
			when "000000100000" =>
			when "000001000000" =>
			when "000010000000" =>
			when "000100000000" =>
			when "001000000000" =>
			when "010000000000" =>
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
	posXPix <= pixel_ux - XPOS;
	posYPix <= pixel_uy - YPOS;
	
end game_arch;

