----------------------------------------------------------------------------------
-- Engineer: Parker Ridd and Travis Chambers
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
		posXPixOut : out UNSIGNED(9 downto 0);
		posYPixOut : out UNSIGNED(9 downto 0);
	
		--this signal is so we can tell whether we should actually draw the color
		--being output by the box or not!
		drawBox : out STD_LOGIC := '0'
	);
end Box;


architecture game_arch of Box is
	--============================================================================
	------------------Signal Declarations-----------------------------------------
	--============================================================================
	signal pixel_ux, pixel_uy : UNSIGNED(9 downto 0);
	signal posXPix, posYPix, posYPixInverted : UNSIGNED(9 downto 0);

	--============================================================================
	------------------Constant Declarations---------------------------------------
	--============================================================================
	constant DIMENSIONS : UNSIGNED(9 downto 0) := TO_UNSIGNED(90, 10);
	constant MAX_X : UNSIGNED(9 downto 0) := XPOS + DIMENSIONS - 1;
	constant MAX_Y : UNSIGNED(9 downto 0) := YPOS + DIMENSIONS - 1;





begin
	posXPixOut <= posXPix;
	posYPixOut <= posYPix;

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
	posYPixInverted <= pixel_uy - YPOS;
	posYPix <= 90 - posYPixInverted;
	
end game_arch;
