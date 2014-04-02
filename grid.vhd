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
				pixel_y : in std_logic_vector(10 downto 0);
				btn : in std_logic_vector(3 downto 0);
				draw_grid : out std_logic

	);
end Grid;

architecture Behavioral of Grid is


signal rgb1,rgb2,rgb3,rgb4,rgb5,rgb6,rgb7,rgb8,rgb9,rgb10,rgb11,
rgb12,rgb13,rgb14,rgb15,rgb16 : std_logic_vector(7 downto 0);
signal drawBox1,drawBox2,drawBox3,drawBox4,drawBox5,drawBox6,drawBox7,drawBox8,drawBox9,
drawBox10,drawBox11,drawBox12,drawBox13,drawBox14,drawBox15,drawBox16 : std_logic;
--signal XPOS1,XPOS2,XPOS3,XPOS4,XPOS5,XPOS6,XPOS7,XPOS8,XPOS9,XPOS10,XPOS11,XPOS12,XPOS13,XPOS14,XPOS15

-- 4 bit array to hold all 16 values.
type value is array (3 downto 0) of unsigned(11 downto 0);
signal boxValues: value; 


begin

	--============================================================================
	------------------Entity Instantiations---------------------------------------
	--============================================================================
	Box1 : entity work.Box 

	generic map(
						XPOS => 128,
						YPOS => 48
					)
					
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(0),
					rgb_color => rgb1,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox1
	);

	Box2 : entity work.Box 

	generic map(
						XPOS => 226,
						YPOS => 48
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(1),
					rgb_color => rgb2,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox2
	);

	Box3 : entity work.Box 

	generic map(
						XPOS => 324,
						YPOS => 48
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(2),
					rgb_color => rgb3,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox3
	);

	Box4 : entity work.Box 

	generic map(
						XPOS => 422,
						YPOS => 48
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(3),
					rgb_color => rgb4,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox4
	);

	Box5 : entity work.Box 

	generic map(
						XPOS => 128,
						YPOS => 146
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(4),
					rgb_color => rgb5,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox5
	);

	Box6 : entity work.Box 

	generic map(
						XPOS => 226,
						YPOS => 146
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(5),
					rgb_color => rgb6,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox6
	);

	Box7 : entity work.Box 

	generic map(
						XPOS => 324,
						YPOS => 146
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(6),
					rgb_color => rgb7,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox7
	);

	Box8 : entity work.Box 

	generic map(
						XPOS => 422,
						YPOS => 146
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(7),
					rgb_color => rgb8,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox8
	);

	Box9 : entity work.Box 

	generic map(
						XPOS => 128,
						YPOS => 244
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(8),
					rgb_color => rgb9,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox9
	);

	Box10 : entity work.Box 

	generic map(
						XPOS => 226,
						YPOS => 244
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(9),
					rgb_color => rgb10,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox10
	);

	Box11 : entity work.Box 

	generic map(
						XPOS => 324,
						YPOS => 244
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(10),
					rgb_color => rgb11,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox11
	);

	Box12 : entity work.Box 

	generic map(
						XPOS => 422,
						YPOS => 244
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(11),
					rgb_color => rgb12,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox12
	);


	Box13 : entity work.Box 

	generic map(
						XPOS => 128,
						YPOS => 342
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(12),
					rgb_color => rgb13,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox13
	);


	Box14 : entity work.Box 

	generic map(
						XPOS => 226,
						YPOS => 342
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(13),
					rgb_color => rgb14,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox14
	);


	Box15 : entity work.Box 

	generic map(
						XPOS => 324,
						YPOS => 342
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(14),
					rgb_color => rgb15,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox15
	);

	Box16 : entity work.Box 

	generic map(
						XPOS => 422,
						YPOS => 342
					)
	port map(
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					value => boxValues(15),
					rgb_color => rgb16,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox16
	);
	
	
	

	




end Behavioral;

