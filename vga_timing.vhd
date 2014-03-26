----------------------------------------------------------------------------------
-- Company: Brigham Young University
-- Engineer: Parker Brian Ridd
-- 
-- Create Date:    10:24:17 02/04/2014 
-- Design Name: 
-- Module Name:    vga_timing - lab_arch 
-- Project Name: 	Lab 5
-- Target Devices: Nexsys 2 by Digilent
-- Tool versions: 
-- Description: VGA Controller for the lab 5 assignment
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



entity vga_timing is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           HS : out  STD_LOGIC;
           VS : out  STD_LOGIC;
           pixel_x : out  STD_LOGIC_VECTOR (9 downto 0);
           pixel_y : out  STD_LOGIC_VECTOR (9 downto 0);
           last_column : out  STD_LOGIC;
           last_row : out  STD_LOGIC;
           blank : out  STD_LOGIC);
end vga_timing;

architecture lab_arch of vga_timing is
	--create signals for pixel clock
	signal pixel_en, pxr_next : STD_LOGIC := '0';
	--create signals for horizontal counter
	signal hzr_reg, hzr_next: UNSIGNED(9 downto 0) := (others => '0');
	signal hz_lastColumn : STD_LOGIC := '0';
	--create signals for vertical counter
	signal ver_reg, ver_next : UNSIGNED(9 downto 0) := (others => '0');
	signal ver_lastRow : STD_LOGIC := '0';
begin


	--BASE MODULE OF PIXEL CLOCK
	process(clk, rst)
	begin
		if(rst = '1') then
			pixel_en <= '0';
		elsif(clk'event and clk = '1') then
			pixel_en <= pxr_next;
		end if;
	end process;
		--next state logic for pixel clock
	pxr_next <= 
		not pixel_en;
		
	--HORIZONTAL PIXEL COUNTER
	process(clk, rst)
	begin
		if(rst = '1') then
			hzr_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			hzr_reg <= hzr_next;
		end if;
	end process;
		--next state logic for horizontal counter
	hzr_next <=
		(others => '0') when (hzr_reg = 799) and (pixel_en = '1') else
		hzr_reg + 1 when pixel_en = '1' else
		hzr_reg;
		--output signal logic for horizontal counter
	hz_lastColumn <= 
		'1' when hzr_reg = 639 else
		'0';	
	HS <= '0' when (hzr_reg > 655) and (hzr_reg < 752) else
			'1';
	
	--VERTICAL PIXEL COUNTER
	process(clk, rst)
	begin
		if(rst = '1') then
			ver_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			ver_reg <= ver_next;
		end if;
	end process;
		--next state logic for vertical counter
	ver_next <=
		(others => '0') when (ver_reg = 520) and (hzr_reg = 799) and (pixel_en = '1') else
		ver_reg + 1 when (hzr_reg = 799) and (pixel_en = '1') else
		ver_reg;
		--output signal logic for vertical counter
	ver_lastRow <=
		'1' when ver_reg = 479 else
		'0';
	VS <= 
		'0' when (ver_reg > 489) and (ver_reg < 492) else
		'1';
		
	--LOGIC FOR THE BLANK SIGNAL
	blank <=
		'1' when (ver_reg > 479) else
		'1' when (hzr_reg > 639) else
		'0';
	
	--OTHER OUTPUT ASSIGNMENTS
	pixel_x <= std_logic_vector(hzr_reg);
	pixel_y <= std_logic_vector(ver_reg);
	last_column <= hz_lastColumn;
	last_row <= ver_lastRow;
	
end lab_arch;

