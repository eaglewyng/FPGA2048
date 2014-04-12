----------------------------------------------------------------------------------
-- Company: Parker Ridd and Travis Chambers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Grid is
	port (
				clk : in std_logic;
				rst : in std_logic;
				grid_color : in std_logic_vector(7 downto 0);
				pixel_x : in std_logic_vector(9 downto 0);
				pixel_y : in std_logic_vector(9 downto 0);
				btn : in std_logic_vector(3 downto 0);
				draw_grid : out std_logic;
				rgbOut : out std_logic_vector(7 downto 0);
				gameOver : out std_logic

	);
end Grid;

architecture Behavioral of Grid is
	
	--grid signals
	signal gridOn : std_logic;
	signal rgbWire : std_logic_vector(7 downto 0);
	signal rgb1,rgb2,rgb3,rgb4,rgb5,rgb6,rgb7,rgb8,rgb9,rgb10,rgb11,
	rgb12,rgb13,rgb14,rgb15,rgb16 : std_logic_vector(7 downto 0);
	signal drawBox1,drawBox2,drawBox3,drawBox4,drawBox5,drawBox6,drawBox7,drawBox8,drawBox9,
	drawBox10,drawBox11,drawBox12,drawBox13,drawBox14,drawBox15,drawBox16 : std_logic;


	-- 16 wires of 12 bits each
	type value is array (15 downto 0) of unsigned(11 downto 0);
	signal boxValues, boxValues_next, boxValues_nextFinal: value;
	signal btn_edgedet, btn_edgedet_next : STD_LOGIC_VECTOR(3 downto 0);
	signal btn_posedge0, btn_posedge1, btn_posedge2, btn_posedge3 : STD_LOGIC;
	signal btn_posedge : STD_LOGIC_VECTOR(3 downto 0);

	--random number
	signal random_num : unsigned(3 downto 0);
	signal INrandom_num : std_logic_vector(3 downto 0);
	
	--state register
	type state_type is(randupdate, idle, merge1, move1, merge2, move2, merge3, move3);
	signal state_reg, state_next : state_type;
	
	signal btn_posedge_next : STD_LOGIC_VECTOR(3 downto 0);
	

begin

	--button edge detector
	--this is a positive edge detector, so we don't repeat moves unnecessarily
   btn_posedge0 <= (btn(0) xor btn_edgedet(0)) when (btn(0) = '0') else '0';
	btn_posedge1 <= (btn(1) xor btn_edgedet(1)) when (btn(1) = '0')  else '0';
	btn_posedge2 <= (btn(2) xor btn_edgedet(2)) when (btn(2) = '0') else '0';
	btn_posedge3 <= (btn(3) xor btn_edgedet(3)) when (btn(3) = '0') else '0';
	btn_edgedet_next <= btn;
	
	
	--============================================================================
	------------------Registers---------------------------------------------------
	--============================================================================
	process(clk, rst)
	begin
		if(rst = '1') then
			boxValues <= (others => (others => '0'));
			btn_edgedet <= (others => '0');
			state_reg <= idle;
			btn_posedge <= (others => '0');
		elsif(clk'event and clk = '1') then
			boxValues <= boxValues_next;
			btn_edgedet <= btn_edgedet_next;
			state_reg <= state_next;
			btn_posedge <= btn_posedge_next;
		end if;
	end process;
	

---------------------------------------------------------------
-- 			Draw Grid Logic
---------------------------------------------------------------

gridOn <= '1' when ((unsigned(pixel_y) > 40 and unsigned(pixel_y) <= 440) and
							(unsigned(pixel_x) > 120 and unsigned(pixel_x) <=520)) else
			'0';
draw_grid <= '1' when unsigned(rgbWire) > 0 else
				'0';
---------------------------------------------------------------
--				Grid/Box Color Logic
---------------------------------------------------------------
rgbWire <= rgb1 when drawbox1 = '1' else
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
			  grid_color when gridOn = '1' else
			  "00000000";
			 
rgbOut <= rgbWire;

--============================================================================
------------------Entity Instantiations---------------------------------------
--============================================================================
	Random1 : entity work.randomGenerator
	
	generic map(
						width => 4
					)
	port map (
					clk => clk,
					random_num => INrandom_num
				);
	random_num <= UNSIGNED(INrandom_num);

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
	
	
	

	process(btn_posedge, boxValues, state_reg, random_num)
	begin
		boxValues_next <= boxValues;
		gameOver <= '0';
		state_next <= state_reg;
		btn_posedge_next <= btn_posedge;
		
		if(state_reg = idle) then
			btn_posedge_next <= btn_posedge3 & btn_posedge2 & btn_posedge1 & btn_posedge0;
			if(unsigned(btn_posedge) > 0) then
				state_next <= merge1;
			end if;
		elsif(state_reg = merge1 or state_reg = merge2 or state_reg = merge3) then
			--next state logic
			if(state_reg = merge1) then
				state_next <= move1;
			elsif(state_reg = merge2) then
				state_next <= move2;
			else
				state_next <= move3;
			end if;
			case btn_posedge is
					
				--right button
				when "0001" =>
					--first row
					if(boxValues(0) = boxValues(1) and boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= (others => '0');
						boxValues_next(2) <= boxValues(0) + boxValues(1);
						boxValues_next(3) <= boxValues(2) + boxValues(3);	
					elsif(boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0);
						boxValues_next(2) <= boxValues(1);
						boxValues_next(3) <= boxValues(2) + boxValues(3);
					elsif(boxValues(1) = boxvalues(2)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0);
						boxValues_next(2) <= boxValues(1) + boxValues(2);
						boxValues_next(3) <= boxValues(3);
					elsif(boxValues(0) = boxValues(1)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0) + boxValues(1);
						boxValues_next(2) <= boxValues(2);
						boxValues_next(3) <= boxValues(3);				
					end if;
					
					--second row
					if(boxValues(4) = boxValues(5) and boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= (others => '0');
						boxValues_next(6) <= boxValues(4) + boxValues(5);
						boxValues_next(7) <= boxValues(6) + boxValues(7);	
					elsif(boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4);
						boxValues_next(6) <= boxValues(5);
						boxValues_next(7) <= boxValues(6) + boxValues(7);
					elsif(boxValues(5) = boxvalues(6)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4);
						boxValues_next(6) <= boxValues(5) + boxValues(6);
						boxValues_next(7) <= boxValues(7);
					elsif(boxValues(4) = boxValues(5)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4) + boxValues(5);
						boxValues_next(6) <= boxValues(6);
						boxValues_next(7) <= boxValues(7);
					end if;
					
					--third row
					if(boxValues(8) = boxValues(9) and boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= (others => '0');
						boxValues_next(10) <= boxValues(8) + boxValues(9);
						boxValues_next(11) <= boxValues(10) + boxValues(11);	
					elsif(boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8);
						boxValues_next(10) <= boxValues(9);
						boxValues_next(11) <= boxValues(10) + boxValues(11);
					elsif(boxValues(9) = boxvalues(10)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8);
						boxValues_next(10) <= boxValues(9) + boxValues(10);
						boxValues_next(11) <= boxValues(11);
					elsif(boxValues(8) = boxValues(9)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8) + boxValues(9);
						boxValues_next(10) <= boxValues(10);
						boxValues_next(11) <= boxValues(11);
					end if;
					
					--fourth row
					if(boxValues(12) = boxValues(13) and boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= (others => '0');
						boxValues_next(14) <= boxValues(12) + boxValues(13);
						boxValues_next(15) <= boxValues(14) + boxValues(15);	
					elsif(boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12);
						boxValues_next(14) <= boxValues(13);
						boxValues_next(15) <= boxValues(14) + boxValues(15);
					elsif(boxValues(13) = boxvalues(14)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12);
						boxValues_next(14) <= boxValues(13) + boxValues(14);
						boxValues_next(15) <= boxValues(15);
					elsif(boxValues(12) = boxValues(13)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12) + boxValues(13);
						boxValues_next(14) <= boxValues(14);
						boxValues_next(15) <= boxValues(15);
					end if;
				
				--left button
				when "0010" =>
					--first row
					if(boxValues(0) = boxValues(1) and boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= boxValues(0) + boxValues(1);
						boxValues_next(1) <= boxValues(2) + boxValues(3);	
						boxValues_next(2) <= (others => '0');
						boxValues_next(3) <= (others => '0');	
					elsif(boxValues(0) = boxValues(1)) then
						boxValues_next(0) <= boxValues(0) + boxValues(1);
						boxValues_next(1) <= boxValues(2);
						boxValues_next(2) <= boxValues(3);
						boxValues_next(3) <= (others => '0');					
					elsif(boxValues(1) = boxvalues(2)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(1) <= boxValues(1) + boxValues(2);
						boxValues_next(2) <= boxValues(3);
						boxValues_next(3) <= (others => '0');
					elsif(boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(1) <= boxValues(1);
						boxValues_next(2) <= boxValues(2) + boxValues(3);
						boxValues_next(3) <= (others => '0');
					end if;
					
					--second row
					if(boxValues(4) = boxValues(5) and boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= boxValues(4) + boxValues(5);
						boxValues_next(5) <= boxValues(6) + boxValues(7);	
						boxValues_next(6) <= (others => '0');
						boxValues_next(7) <= (others => '0');	
					elsif(boxValues(4) = boxValues(5)) then
						boxValues_next(4) <= boxValues(4) + boxValues(5);
						boxValues_next(5) <= boxValues(6);
						boxValues_next(6) <= boxValues(7);
						boxValues_next(7) <= (others => '0');					
					elsif(boxValues(5) = boxvalues(6)) then
						boxValues_next(4) <= boxValues(4);
						boxValues_next(5) <= boxValues(5) + boxValues(6);
						boxValues_next(6) <= boxValues(7);
						boxValues_next(7) <= (others => '0');
					elsif(boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= boxValues(4);
						boxValues_next(5) <= boxValues(5);
						boxValues_next(6) <= boxValues(6) + boxValues(7);
						boxValues_next(7) <= (others => '0');
					end if;
					
					--third row
					if(boxValues(8) = boxValues(9) and boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= boxValues(8) + boxValues(9);
						boxValues_next(9) <= boxValues(10) + boxValues(11);	
						boxValues_next(10) <= (others => '0');
						boxValues_next(11) <= (others => '0');	
					elsif(boxValues(8) = boxValues(9)) then
						boxValues_next(8) <= boxValues(8) + boxValues(9);
						boxValues_next(9) <= boxValues(10);
						boxValues_next(10) <= boxValues(11);
						boxValues_next(11) <= (others => '0');					
					elsif(boxValues(9) = boxvalues(10)) then
						boxValues_next(8) <= boxValues(8);
						boxValues_next(9) <= boxValues(9) + boxValues(10);
						boxValues_next(10) <= boxValues(11);
						boxValues_next(11) <= (others => '0');
					elsif(boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= boxValues(8);
						boxValues_next(9) <= boxValues(9);
						boxValues_next(10) <= boxValues(10) + boxValues(11);
						boxValues_next(11) <= (others => '0');
					end if;
					
					--fourth row
					if(boxValues(12) = boxValues(13) and boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= boxValues(12) + boxValues(13);
						boxValues_next(13) <= boxValues(14) + boxValues(15);	
						boxValues_next(14) <= (others => '0');
						boxValues_next(15) <= (others => '0');	
					elsif(boxValues(12) = boxValues(13)) then
						boxValues_next(12) <= boxValues(12) + boxValues(13);
						boxValues_next(13) <= boxValues(14);
						boxValues_next(14) <= boxValues(15);
						boxValues_next(15) <= (others => '0');					
					elsif(boxValues(13) = boxvalues(14)) then
						boxValues_next(12) <= boxValues(12);
						boxValues_next(13) <= boxValues(13) + boxValues(14);
						boxValues_next(14) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
					elsif(boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= boxValues(12);
						boxValues_next(13) <= boxValues(13);
						boxValues_next(14) <= boxValues(14) + boxValues(15);
						boxValues_next(15) <= (others => '0');
					end if;
					
				--down button
				when "0100" =>
					--first column
					if(boxValues(0) = boxValues(4) and boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= (others => '0');
						boxValues_next(8) <= boxValues(0) + boxValues(4);
						boxValues_next(12) <= boxValues(8) + boxValues(12);	
					elsif(boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0);
						boxValues_next(8) <= boxValues(4);
						boxValues_next(12) <= boxValues(8) + boxValues(12);
					elsif(boxValues(4) = boxValues(8)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0);
						boxValues_next(8) <= boxValues(4) + boxValues(8);
						boxValues_next(12) <= boxValues(12);
					elsif(boxValues(0) = boxValues(4)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0) + boxValues(4);
						boxValues_next(8) <= boxValues(8);
						boxValues_next(12) <= boxValues(12);
					end if;
					
					--second column
					if(boxValues(1) = boxValues(5) and boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= (others => '0');
						boxValues_next(9) <= boxValues(1) + boxValues(5);
						boxValues_next(13) <= boxValues(9) + boxValues(13);	
					elsif(boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1);
						boxValues_next(9) <= boxValues(5);
						boxValues_next(13) <= boxValues(9) + boxValues(13);
					elsif(boxValues(5) = boxValues(9)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1);
						boxValues_next(9) <= boxValues(5) + boxValues(9);
						boxValues_next(13) <= boxValues(13);
					elsif(boxValues(1) = boxValues(5)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1) + boxValues(5);
						boxValues_next(9) <= boxValues(9);
						boxValues_next(13) <= boxValues(13);
					end if;
					
					--third column
					if(boxValues(2) = boxValues(6) and boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= (others => '0');
						boxValues_next(10) <= boxValues(2) + boxValues(6);
						boxValues_next(14) <= boxValues(10) + boxValues(14);	
					elsif(boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2);
						boxValues_next(10) <= boxValues(6);
						boxValues_next(14) <= boxValues(10) + boxValues(14);
					elsif(boxValues(6) = boxValues(10)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2);
						boxValues_next(10) <= boxValues(6) + boxValues(10);
						boxValues_next(14) <= boxValues(14);
					elsif(boxValues(2) = boxValues(6)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2) + boxValues(6);
						boxValues_next(10) <= boxValues(10);
						boxValues_next(14) <= boxValues(14);
					end if;
					
					--fourth column				
					if(boxValues(3) = boxValues(7) and boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= (others => '0');
						boxValues_next(11) <= boxValues(3) + boxValues(7);
						boxValues_next(15) <= boxValues(11) + boxValues(15);	
					elsif(boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3);
						boxValues_next(11) <= boxValues(7);
						boxValues_next(15) <= boxValues(11) + boxValues(15);
					elsif(boxValues(7) = boxValues(11)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3);
						boxValues_next(11) <= boxValues(7) + boxValues(11);
						boxValues_next(15) <= boxValues(15);
					elsif(boxValues(3) = boxValues(7)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3) + boxValues(7);
						boxValues_next(11) <= boxValues(11);
						boxValues_next(15) <= boxValues(15);
					end if;
					
				
				--up button
				when "1000" =>
					--first column
					if(boxValues(0) = boxValues(4) and boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= boxValues(0) + boxValues(4);
						boxValues_next(4) <= boxValues(8) + boxValues(12);	
						boxValues_next(8) <= (others => '0');
						boxValues_next(12) <= (others => '0');	
					elsif(boxValues(0) = boxValues(4)) then
						boxValues_next(0) <= boxValues(0) + boxValues(4);
						boxValues_next(4) <= boxValues(8);
						boxValues_next(8) <= boxValues(12);
						boxValues_next(12) <= (others => '0');					
					elsif(boxValues(4) = boxvalues(8)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(4) <= boxValues(4) + boxValues(8);
						boxValues_next(8) <= boxValues(12);
						boxValues_next(12) <= (others => '0');
					elsif(boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(4) <= boxValues(4);
						boxValues_next(8) <= boxValues(8) + boxValues(12);
						boxValues_next(12) <= (others => '0');
					end if;
					
					--second column
					if(boxValues(1) = boxValues(5) and boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= boxValues(1) + boxValues(5);
						boxValues_next(5) <= boxValues(9) + boxValues(13);	
						boxValues_next(9) <= (others => '0');
						boxValues_next(13) <= (others => '0');	
					elsif(boxValues(1) = boxValues(5)) then
						boxValues_next(1) <= boxValues(1) + boxValues(5);
						boxValues_next(5) <= boxValues(9);
						boxValues_next(9) <= boxValues(13);
						boxValues_next(13) <= (others => '0');					
					elsif(boxValues(5) = boxvalues(9)) then
						boxValues_next(1) <= boxValues(1);
						boxValues_next(5) <= boxValues(5) + boxValues(9);
						boxValues_next(9) <= boxValues(13);
						boxValues_next(13) <= (others => '0');
					elsif(boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= boxValues(1);
						boxValues_next(5) <= boxValues(5);
						boxValues_next(9) <= boxValues(9) + boxValues(13);
						boxValues_next(13) <= (others => '0');
					end if;
					
					--third column
					if(boxValues(2) = boxValues(6) and boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= boxValues(2) + boxValues(6);
						boxValues_next(6) <= boxValues(10) + boxValues(14);	
						boxValues_next(10) <= (others => '0');
						boxValues_next(14) <= (others => '0');	
					elsif(boxValues(2) = boxValues(6)) then
						boxValues_next(2) <= boxValues(2) + boxValues(6);
						boxValues_next(6) <= boxValues(10);
						boxValues_next(10) <= boxValues(14);
						boxValues_next(14) <= (others => '0');					
					elsif(boxValues(6) = boxvalues(10)) then
						boxValues_next(2) <= boxValues(2);
						boxValues_next(6) <= boxValues(6) + boxValues(10);
						boxValues_next(10) <= boxValues(14);
						boxValues_next(14) <= (others => '0');
					elsif(boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= boxValues(2);
						boxValues_next(6) <= boxValues(6);
						boxValues_next(10) <= boxValues(10) + boxValues(14);
						boxValues_next(14) <= (others => '0');
					end if;
					
					--fourth column
					if(boxValues(3) = boxValues(7) and boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= boxValues(3) + boxValues(7);
						boxValues_next(7) <= boxValues(11) + boxValues(15);	
						boxValues_next(11) <= (others => '0');
						boxValues_next(15) <= (others => '0');	
					elsif(boxValues(3) = boxValues(7)) then
						boxValues_next(3) <= boxValues(3) + boxValues(7);
						boxValues_next(7) <= boxValues(11);
						boxValues_next(11) <= boxValues(15);
						boxValues_next(15) <= (others => '0');					
					elsif(boxValues(7) = boxvalues(11)) then
						boxValues_next(3) <= boxValues(3);
						boxValues_next(7) <= boxValues(7) + boxValues(11);
						boxValues_next(11) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
					elsif(boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= boxValues(3);
						boxValues_next(7) <= boxValues(7);
						boxValues_next(11) <= boxValues(11) + boxValues(15);
						boxValues_next(15) <= (others => '0');
					end if;
				when others =>
					state_next <= idle;
			end case;
		--what to do in move states
		elsif(state_reg = move1 or state_reg = move2 or state_reg = move3) then
			--update the state reg
			if(state_reg = move1) then
				state_next <= merge2;
			elsif(state_reg = move2) then
				state_next <= merge3;
			else
				state_next <= randupdate;
			end if;
		
		elsif(state_reg = randupdate) then
				btn_posedge_next <= btn_posedge3 & btn_posedge2 & btn_posedge1 & btn_posedge0;
				--next state logic
				state_next <= idle;
				if boxValues(to_integer(random_num)) = 0 then
					boxValues_next(to_integer(random_num)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 1)) = 0) then
						boxValues_next(to_integer(random_num + 1)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 2)) = 0) then
						boxValues_next(to_integer(random_num + 2)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 3)) = 0) then
						boxValues_next(to_integer(random_num + 3)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 4)) = 0) then
						boxValues_next(to_integer(random_num + 4)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 5)) = 0) then
						boxValues_next(to_integer(random_num + 5)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 6)) = 0) then
						boxValues_next(to_integer(random_num + 6)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 7)) = 0) then
						boxValues_next(to_integer(random_num + 7)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 8)) = 0) then
						boxValues_next(to_integer(random_num + 8)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 9)) = 0) then
						boxValues_next(to_integer(random_num + 9)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 10)) = 0) then
						boxValues_next(to_integer(random_num + 10)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 11)) = 0) then
						boxValues_next(to_integer(random_num + 11)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 12)) = 0) then
						boxValues_next(to_integer(random_num + 12)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 13)) = 0) then
						boxValues_next(to_integer(random_num + 13)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 14)) = 0) then
						boxValues_next(to_integer(random_num + 14)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 15)) = 0) then
						boxValues_next(to_integer(random_num + 15)) <= to_unsigned(2,12);
				elsif (boxValues(to_integer(random_num + 16)) = 0) then
						boxValues_next(to_integer(random_num + 16)) <= to_unsigned(2,12);
				else
						gameOver <= '1';
				end if;
	end if;
	end process;
	
	
	
	
	

	




end Behavioral;

