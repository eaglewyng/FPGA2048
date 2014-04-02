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
				pixel_y : in std_logic_vector(9 downto 0);
				btn : in std_logic_vector(3 downto 0);
				draw_grid : out std_logic;
				rgbOut : out std_logic_vector(7 downto 0)

	);
end Grid;

architecture Behavioral of Grid is
signal gridOn : std_logic;

signal rgb1,rgb2,rgb3,rgb4,rgb5,rgb6,rgb7,rgb8,rgb9,rgb10,rgb11,
rgb12,rgb13,rgb14,rgb15,rgb16 : std_logic_vector(7 downto 0);
signal drawBox1,drawBox2,drawBox3,drawBox4,drawBox5,drawBox6,drawBox7,drawBox8,drawBox9,
drawBox10,drawBox11,drawBox12,drawBox13,drawBox14,drawBox15,drawBox16 : std_logic;

-- 16 wires of 12 bits each
type value is array (15 downto 0) of unsigned(11 downto 0);
signal boxValues: value; 


begin
---------------------------------------------------------------
-- 			Draw Grid Logic
---------------------------------------------------------------
gridOn <= '1' when ((unsigned(pixel_y) > 40 and unsigned(pixel_y) <= 48) or
							  (unsigned(pixel_y) > 138 and unsigned(pixel_y) <= 144) or
							  (unsigned(pixel_y) > 236 and unsigned(pixel_y) <= 244) or
							  (unsigned(pixel_y) > 334 and unsigned(pixel_y) <= 342) or
							  (unsigned(pixel_y) > 432 and unsigned(pixel_y) <= 440) or
							  (unsigned(pixel_x) > 120 and unsigned(pixel_x) <= 128) or
							  (unsigned(pixel_x) > 218 and unsigned(pixel_x) <= 226) or
							  (unsigned(pixel_x) > 316 and unsigned(pixel_x) <= 324) or
							  (unsigned(pixel_x) > 414 and unsigned(pixel_x) <= 422) or
							  (unsigned(pixel_x) > 512 and unsigned(pixel_x) <= 520)) else
				'0';

draw_grid <= gridOn;
---------------------------------------------------------------
--				Grid/Box Color Logic
---------------------------------------------------------------
rgbOut <= grid_color when gridOn = '1' else
			 rgb1 when drawbox1 = '1' else
			 rgb2 when drawbox2 = '1' else
			 rgb3 when drawbox3 = '1' else
			 rgb4 when drawbox4 = '1' else
			 rgb5 when drawbox5 = '1' else
			 rgb6 when drawbox6 = '1' else
			 rgb7 when drawbox7 = '1' else
			 rgb8 when drawbox8 = '1' else
			 rgb9 when drawbox9 = '1' else
			 rgb10 when drawbox10 = '1' else
			 rgb11 when drawbox11 = '1' else
			 rgb12 when drawbox12 = '1' else
			 rgb13 when drawbox13 = '1' else
			 rgb14 when drawbox14 = '1' else
			 rgb15 when drawbox15 = '1' else
			 rgb16 when drawbox16 = '1' else
			 "00000000";


--------------------------------------------------------------
--				Instantiate 16 boxes
--------------------------------------------------------------
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
