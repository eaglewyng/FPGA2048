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
				gameOver : out std_logic;
				score : out std_logic_vector(15 downto 0)
	);
end Grid;

architecture Behavioral of Grid is
	
	--grid signals
	signal gridOn : std_logic;
	signal rgbWire : std_logic_vector(7 downto 0);
	signal drawBox1,drawBox2,drawBox3,drawBox4,drawBox5,drawBox6,drawBox7,drawBox8,drawBox9,
	drawBox10,drawBox11,drawBox12,drawBox13,drawBox14,drawBox15,drawBox16 : std_logic;
	signal box1x,box2x,box3x,box4x,box5x,box6x,box7x,box8x,box9x,
	box10x,box11x,box12x,box13x,box14x,box15x,box16x : UNSIGNED(9 downto 0);
	signal box1y,box2y,box3y,box4y,box5y,box6y,box7y,box8y,box9y,
	box10y,box11y,box12y,box13y,box14y,box15y,box16y : UNSIGNED(9 downto 0);
	signal drawBox_combined : STD_LOGIC_VECTOR(15 downto 0);
	signal boxValueToDraw : UNSIGNED(11 downto 0);
	signal boxXToDraw, boxYToDraw : UNSIGNED(9 downto 0);
	signal draw_number : STD_LOGIC;
	signal number_color : STD_LOGIC_VECTOR(7 downto 0);
	signal boxBGRGB : STD_LOGIC_VECTOR(7 downto 0);
	signal boxFinalRGB : STD_LOGIC_VECTOR(7 downto 0);
	
	--register to check merge against
	signal merge_reg, merge_next : STD_LOGIC_VECTOR(3 downto 0);
	
	--score register
	signal score_reg, score_next : UNSIGNED(15 downto 0);


	-- 16 wires of 12 bits each
	type value is array (15 downto 0) of unsigned(11 downto 0);
	signal boxValues, boxValues_next: value;
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
			state_reg <= randUpdate;
			btn_posedge <= (others => '0');
			score_reg <= (others => '0');
			merge_reg <= (others => '0');
		elsif(clk'event and clk = '1') then
			boxValues <= boxValues_next;
			btn_edgedet <= btn_edgedet_next;
			state_reg <= state_next;
			btn_posedge <= btn_posedge_next;
			score_reg <= score_next;
			merge_reg <= merge_next;
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
rgbWire <= boxFinalRGB when UNSIGNED(drawbox_combined) > 0 else
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
					posXPixOut => box1x,
					posYPixOut => box1y,
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
					posXPixOut => box2x,
					posYPixOut => box2y,
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
					posXPixOut => box3x,
					posYPixOut => box3y,
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
					posXPixOut => box4x,
					posYPixOut => box4y,
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
					posXPixOut => box5x,
					posYPixOut => box5y,
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
					posXPixOut => box6x,
					posYPixOut => box6y,
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
					posXPixOut => box7x,
					posYPixOut => box7y,
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
					posXPixOut => box8x,
					posYPixOut => box8y,
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
					posXPixOut => box9x,
					posYPixOut => box9y,
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
					posXPixOut => box10x,
					posYPixOut => box10y,
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
					posXPixOut => box11x,
					posYPixOut => box11y,
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
					posXPixOut => box12x,
					posYPixOut => box12y,
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
					posXPixOut => box13x,
					posYPixOut => box13y,
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
					posXPixOut => box14x,
					posYPixOut => box14y,
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
					posXPixOut => box15x,
					posYPixOut => box15y,
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
					posXPixOut => box16x,
					posYPixOut => box16y,
					--this signal is so we can tell whether we should actually draw the color
					--being output by the box or not!
					drawBox => drawBox16
	);
	
	
	

	process(btn_posedge, boxValues, state_reg, random_num, score_reg, btn_posedge3, btn_posedge2, btn_posedge1, btn_posedge0, merge_reg)
	begin
		boxValues_next <= boxValues;
		gameOver <= '0';
		state_next <= state_reg;
		btn_posedge_next <= btn_posedge;
		score_next <= score_reg;
		merge_next <= merge_reg;
		
		if(state_reg = idle) then
			merge_next <= (others => '0');
			if(unsigned(btn_posedge) > 0) then
				state_next <= merge1;
				score_next <= score_reg + 1;
			else
				btn_posedge_next <= btn_posedge3 & btn_posedge2 & btn_posedge1 & btn_posedge0;
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
				if(merge_reg(0) = '0') then
					if(boxValues(0) = boxValues(1) and boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= (others => '0');
						boxValues_next(2) <= boxValues(0) + boxValues(1);
						boxValues_next(3) <= boxValues(2) + boxValues(3);
						merge_next(0) <= '1';
					elsif(boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0);
						boxValues_next(2) <= boxValues(1);
						boxValues_next(3) <= boxValues(2) + boxValues(3);
						merge_next(0) <= '1';
					elsif(boxValues(1) = boxvalues(2)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0);
						boxValues_next(2) <= boxValues(1) + boxValues(2);
						boxValues_next(3) <= boxValues(3);
						merge_next(0) <= '1';
					elsif(boxValues(0) = boxValues(1)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(1) <= boxValues(0) + boxValues(1);
						boxValues_next(2) <= boxValues(2);
						boxValues_next(3) <= boxValues(3);
						merge_next(0) <= '1';
					end if;
				end if;
				
				--second row
				if(merge_reg(1) = '0') then
					if(boxValues(4) = boxValues(5) and boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= (others => '0');
						boxValues_next(6) <= boxValues(4) + boxValues(5);
						boxValues_next(7) <= boxValues(6) + boxValues(7);
						merge_next(1) <= '1';
					elsif(boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4);
						boxValues_next(6) <= boxValues(5);
						boxValues_next(7) <= boxValues(6) + boxValues(7);
						merge_next(1) <= '1';
					elsif(boxValues(5) = boxvalues(6)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4);
						boxValues_next(6) <= boxValues(5) + boxValues(6);
						boxValues_next(7) <= boxValues(7);
						merge_next(1) <= '1';
					elsif(boxValues(4) = boxValues(5)) then
						boxValues_next(4) <= (others => '0');
						boxValues_next(5) <= boxValues(4) + boxValues(5);
						boxValues_next(6) <= boxValues(6);
						boxValues_next(7) <= boxValues(7);
						merge_next(1) <= '1';
					end if;
				end if;
				
				--third row
				if(merge_reg(2) = '0') then
					if(boxValues(8) = boxValues(9) and boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= (others => '0');
						boxValues_next(10) <= boxValues(8) + boxValues(9);
						boxValues_next(11) <= boxValues(10) + boxValues(11);
						merge_next(2) <= '1';
					elsif(boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8);
						boxValues_next(10) <= boxValues(9);
						boxValues_next(11) <= boxValues(10) + boxValues(11);
						merge_next(2) <= '1';
					elsif(boxValues(9) = boxvalues(10)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8);
						boxValues_next(10) <= boxValues(9) + boxValues(10);
						boxValues_next(11) <= boxValues(11);
						merge_next(2) <= '1';
					elsif(boxValues(8) = boxValues(9)) then
						boxValues_next(8) <= (others => '0');
						boxValues_next(9) <= boxValues(8) + boxValues(9);
						boxValues_next(10) <= boxValues(10);
						boxValues_next(11) <= boxValues(11);
						merge_next(2) <= '1';
					end if;
				end if;
				
				--fourth row
				if(merge_reg(3) = '0') then
					if(boxValues(12) = boxValues(13) and boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= (others => '0');
						boxValues_next(14) <= boxValues(12) + boxValues(13);
						boxValues_next(15) <= boxValues(14) + boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12);
						boxValues_next(14) <= boxValues(13);
						boxValues_next(15) <= boxValues(14) + boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(13) = boxvalues(14)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12);
						boxValues_next(14) <= boxValues(13) + boxValues(14);
						boxValues_next(15) <= boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(12) = boxValues(13)) then
						boxValues_next(12) <= (others => '0');
						boxValues_next(13) <= boxValues(12) + boxValues(13);
						boxValues_next(14) <= boxValues(14);
						boxValues_next(15) <= boxValues(15);
						merge_next(3) <= '1';
					end if;
				end if;
			
			--left button
			when "0010" =>
				--first row
				if(merge_reg(0) = '0') then
					if(boxValues(0) = boxValues(1) and boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= boxValues(0) + boxValues(1);
						boxValues_next(1) <= boxValues(2) + boxValues(3);	
						boxValues_next(2) <= (others => '0');
						boxValues_next(3) <= (others => '0');
						merge_next(0) <= '1';
					elsif(boxValues(0) = boxValues(1)) then
						boxValues_next(0) <= boxValues(0) + boxValues(1);
						boxValues_next(1) <= boxValues(2);
						boxValues_next(2) <= boxValues(3);
						boxValues_next(3) <= (others => '0');	
						merge_next(0) <= '1';
					elsif(boxValues(1) = boxvalues(2)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(1) <= boxValues(1) + boxValues(2);
						boxValues_next(2) <= boxValues(3);
						boxValues_next(3) <= (others => '0');
						merge_next(0) <= '1';
					elsif(boxValues(2) = boxValues(3)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(1) <= boxValues(1);
						boxValues_next(2) <= boxValues(2) + boxValues(3);
						boxValues_next(3) <= (others => '0');
						merge_next(0) <= '1';
					end if;
				end if;
				
				--second row
				if(merge_reg(1) = '0') then
					if(boxValues(4) = boxValues(5) and boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= boxValues(4) + boxValues(5);
						boxValues_next(5) <= boxValues(6) + boxValues(7);	
						boxValues_next(6) <= (others => '0');
						boxValues_next(7) <= (others => '0');	
						merge_next(1) <= '1';
					elsif(boxValues(4) = boxValues(5)) then
						boxValues_next(4) <= boxValues(4) + boxValues(5);
						boxValues_next(5) <= boxValues(6);
						boxValues_next(6) <= boxValues(7);
						boxValues_next(7) <= (others => '0');
						merge_next(1) <= '1';					
					elsif(boxValues(5) = boxvalues(6)) then
						boxValues_next(4) <= boxValues(4);
						boxValues_next(5) <= boxValues(5) + boxValues(6);
						boxValues_next(6) <= boxValues(7);
						boxValues_next(7) <= (others => '0');
						merge_next(1) <= '1';
					elsif(boxValues(6) = boxValues(7)) then
						boxValues_next(4) <= boxValues(4);
						boxValues_next(5) <= boxValues(5);
						boxValues_next(6) <= boxValues(6) + boxValues(7);
						boxValues_next(7) <= (others => '0');
						merge_next(1) <= '1';
					end if;
				end if;
				
				--third row
				if(merge_reg(2) = '0') then
					if(boxValues(8) = boxValues(9) and boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= boxValues(8) + boxValues(9);
						boxValues_next(9) <= boxValues(10) + boxValues(11);	
						boxValues_next(10) <= (others => '0');
						boxValues_next(11) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(8) = boxValues(9)) then
						boxValues_next(8) <= boxValues(8) + boxValues(9);
						boxValues_next(9) <= boxValues(10);
						boxValues_next(10) <= boxValues(11);
						boxValues_next(11) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(9) = boxvalues(10)) then
						boxValues_next(8) <= boxValues(8);
						boxValues_next(9) <= boxValues(9) + boxValues(10);
						boxValues_next(10) <= boxValues(11);
						boxValues_next(11) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(10) = boxValues(11)) then
						boxValues_next(8) <= boxValues(8);
						boxValues_next(9) <= boxValues(9);
						boxValues_next(10) <= boxValues(10) + boxValues(11);
						boxValues_next(11) <= (others => '0');
						merge_next(2) <= '1';
					end if;
				end if;
				
				--fourth row
				if(merge_reg(3) = '0') then
					if(boxValues(12) = boxValues(13) and boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= boxValues(12) + boxValues(13);
						boxValues_next(13) <= boxValues(14) + boxValues(15);	
						boxValues_next(14) <= (others => '0');
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(12) = boxValues(13)) then
						boxValues_next(12) <= boxValues(12) + boxValues(13);
						boxValues_next(13) <= boxValues(14);
						boxValues_next(14) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(13) = boxvalues(14)) then
						boxValues_next(12) <= boxValues(12);
						boxValues_next(13) <= boxValues(13) + boxValues(14);
						boxValues_next(14) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(14) = boxValues(15)) then
						boxValues_next(12) <= boxValues(12);
						boxValues_next(13) <= boxValues(13);
						boxValues_next(14) <= boxValues(14) + boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					end if;
				end if;
				
			--down button
			when "0100" =>
				--first column
				if(merge_reg(0) = '0') then
					if(boxValues(0) = boxValues(4) and boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= (others => '0');
						boxValues_next(8) <= boxValues(0) + boxValues(4);
						boxValues_next(12) <= boxValues(8) + boxValues(12);
						merge_next(0) <= '1';
					elsif(boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0);
						boxValues_next(8) <= boxValues(4);
						boxValues_next(12) <= boxValues(8) + boxValues(12);
						merge_next(0) <= '1';
					elsif(boxValues(4) = boxValues(8)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0);
						boxValues_next(8) <= boxValues(4) + boxValues(8);
						boxValues_next(12) <= boxValues(12);
						merge_next(0) <= '1';
					elsif(boxValues(0) = boxValues(4)) then
						boxValues_next(0) <= (others => '0');
						boxValues_next(4) <= boxValues(0) + boxValues(4);
						boxValues_next(8) <= boxValues(8);
						boxValues_next(12) <= boxValues(12);
						merge_next(0) <= '1';
					end if;
				end if;
				
				--second column
				if(merge_reg(1) = '0') then
					if(boxValues(1) = boxValues(5) and boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= (others => '0');
						boxValues_next(9) <= boxValues(1) + boxValues(5);
						boxValues_next(13) <= boxValues(9) + boxValues(13);
						merge_next(1) <= '1';
					elsif(boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1);
						boxValues_next(9) <= boxValues(5);
						boxValues_next(13) <= boxValues(9) + boxValues(13);
						merge_next(1) <= '1';
					elsif(boxValues(5) = boxValues(9)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1);
						boxValues_next(9) <= boxValues(5) + boxValues(9);
						boxValues_next(13) <= boxValues(13);
						merge_next(1) <= '1';
					elsif(boxValues(1) = boxValues(5)) then
						boxValues_next(1) <= (others => '0');
						boxValues_next(5) <= boxValues(1) + boxValues(5);
						boxValues_next(9) <= boxValues(9);
						boxValues_next(13) <= boxValues(13);
						merge_next(1) <= '1';
					end if;
				end if;
				
				--third column
				if(merge_reg(2) = '0') then
					if(boxValues(2) = boxValues(6) and boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= (others => '0');
						boxValues_next(10) <= boxValues(2) + boxValues(6);
						boxValues_next(14) <= boxValues(10) + boxValues(14);
						merge_next(2) <= '1';
					elsif(boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2);
						boxValues_next(10) <= boxValues(6);
						boxValues_next(14) <= boxValues(10) + boxValues(14);
						merge_next(2) <= '1';
					elsif(boxValues(6) = boxValues(10)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2);
						boxValues_next(10) <= boxValues(6) + boxValues(10);
						boxValues_next(14) <= boxValues(14);
						merge_next(2) <= '1';
					elsif(boxValues(2) = boxValues(6)) then
						boxValues_next(2) <= (others => '0');
						boxValues_next(6) <= boxValues(2) + boxValues(6);
						boxValues_next(10) <= boxValues(10);
						boxValues_next(14) <= boxValues(14);
						merge_next(2) <= '1';
					end if;
				end if;
				
				--fourth column
				if(merge_reg(3) = '0') then
					if(boxValues(3) = boxValues(7) and boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= (others => '0');
						boxValues_next(11) <= boxValues(3) + boxValues(7);
						boxValues_next(15) <= boxValues(11) + boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3);
						boxValues_next(11) <= boxValues(7);
						boxValues_next(15) <= boxValues(11) + boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(7) = boxValues(11)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3);
						boxValues_next(11) <= boxValues(7) + boxValues(11);
						boxValues_next(15) <= boxValues(15);
						merge_next(3) <= '1';
					elsif(boxValues(3) = boxValues(7)) then
						boxValues_next(3) <= (others => '0');
						boxValues_next(7) <= boxValues(3) + boxValues(7);
						boxValues_next(11) <= boxValues(11);
						boxValues_next(15) <= boxValues(15);
						merge_next(3) <= '1';
					end if;
				end if;
				
			
			--up button
			when "1000" =>
				--first column
				if(merge_reg(0) = '0') then
					if(boxValues(0) = boxValues(4) and boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= boxValues(0) + boxValues(4);
						boxValues_next(4) <= boxValues(8) + boxValues(12);	
						boxValues_next(8) <= (others => '0');
						boxValues_next(12) <= (others => '0');
						merge_next(0) <= '1';
					elsif(boxValues(0) = boxValues(4)) then
						boxValues_next(0) <= boxValues(0) + boxValues(4);
						boxValues_next(4) <= boxValues(8);
						boxValues_next(8) <= boxValues(12);
						boxValues_next(12) <= (others => '0');
						merge_next(0) <= '1';
					elsif(boxValues(4) = boxvalues(8)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(4) <= boxValues(4) + boxValues(8);
						boxValues_next(8) <= boxValues(12);
						boxValues_next(12) <= (others => '0');
						merge_next(0) <= '1';
					elsif(boxValues(8) = boxValues(12)) then
						boxValues_next(0) <= boxValues(0);
						boxValues_next(4) <= boxValues(4);
						boxValues_next(8) <= boxValues(8) + boxValues(12);
						boxValues_next(12) <= (others => '0');
						merge_next(0) <= '1';
					end if;
				end if;
				
				--second column
				if(merge_reg(1) = '0') then
					if(boxValues(1) = boxValues(5) and boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= boxValues(1) + boxValues(5);
						boxValues_next(5) <= boxValues(9) + boxValues(13);	
						boxValues_next(9) <= (others => '0');
						boxValues_next(13) <= (others => '0');
						merge_next(1) <= '1';
					elsif(boxValues(1) = boxValues(5)) then
						boxValues_next(1) <= boxValues(1) + boxValues(5);
						boxValues_next(5) <= boxValues(9);
						boxValues_next(9) <= boxValues(13);
						boxValues_next(13) <= (others => '0');
						merge_next(1) <= '1';
					elsif(boxValues(5) = boxvalues(9)) then
						boxValues_next(1) <= boxValues(1);
						boxValues_next(5) <= boxValues(5) + boxValues(9);
						boxValues_next(9) <= boxValues(13);
						boxValues_next(13) <= (others => '0');
						merge_next(1) <= '1';
					elsif(boxValues(9) = boxValues(13)) then
						boxValues_next(1) <= boxValues(1);
						boxValues_next(5) <= boxValues(5);
						boxValues_next(9) <= boxValues(9) + boxValues(13);
						boxValues_next(13) <= (others => '0');
						merge_next(1) <= '1';
					end if;
				end if;
				
				--third column
				if(merge_reg(2) = '0') then
					if(boxValues(2) = boxValues(6) and boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= boxValues(2) + boxValues(6);
						boxValues_next(6) <= boxValues(10) + boxValues(14);	
						boxValues_next(10) <= (others => '0');
						boxValues_next(14) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(2) = boxValues(6)) then
						boxValues_next(2) <= boxValues(2) + boxValues(6);
						boxValues_next(6) <= boxValues(10);
						boxValues_next(10) <= boxValues(14);
						boxValues_next(14) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(6) = boxvalues(10)) then
						boxValues_next(2) <= boxValues(2);
						boxValues_next(6) <= boxValues(6) + boxValues(10);
						boxValues_next(10) <= boxValues(14);
						boxValues_next(14) <= (others => '0');
						merge_next(2) <= '1';
					elsif(boxValues(10) = boxValues(14)) then
						boxValues_next(2) <= boxValues(2);
						boxValues_next(6) <= boxValues(6);
						boxValues_next(10) <= boxValues(10) + boxValues(14);
						boxValues_next(14) <= (others => '0');
						merge_next(2) <= '1';
					end if;
				end if;
				
				--fourth column
				if(merge_reg(3) = '0') then
					if(boxValues(3) = boxValues(7) and boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= boxValues(3) + boxValues(7);
						boxValues_next(7) <= boxValues(11) + boxValues(15);	
						boxValues_next(11) <= (others => '0');
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(3) = boxValues(7)) then
						boxValues_next(3) <= boxValues(3) + boxValues(7);
						boxValues_next(7) <= boxValues(11);
						boxValues_next(11) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(7) = boxvalues(11)) then
						boxValues_next(3) <= boxValues(3);
						boxValues_next(7) <= boxValues(7) + boxValues(11);
						boxValues_next(11) <= boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					elsif(boxValues(11) = boxValues(15)) then
						boxValues_next(3) <= boxValues(3);
						boxValues_next(7) <= boxValues(7);
						boxValues_next(11) <= boxValues(11) + boxValues(15);
						boxValues_next(15) <= (others => '0');
						merge_next(3) <= '1';
					end if;
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
			
			case btn_posedge is
			
						--right button
			when "0001" =>
				--first row
				if(boxValues(2) > 0 and boxValues(3) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(1) <= boxValues(0);
					boxValues_next(2) <= boxValues(1);
					boxValues_next(3) <= boxValues(2);
				 elsif(boxValues(1) > 0 and boxValues(2) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(1) <= boxValues(0);
					boxValues_next(2) <= boxValues(1);
				elsif(boxValues(0) > 0 and boxValues(1) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(1) <= boxValues(0);			
				end if;
				
				
				--second row
				if(boxValues(6) > 0 and boxValues(7) = 0) then
					boxValues_next(4) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(4);
					boxValues_next(6) <= boxValues(5);
					boxValues_next(7) <= boxValues(6);
				 elsif(boxValues(5) > 0 and boxValues(6) = 0) then
					boxValues_next(4) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(4);
					boxValues_next(6) <= boxValues(5);
				elsif(boxValues(4) > 0 and boxValues(5) = 0) then
					boxValues_next(4) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(4);			
				end if;
				
				--third row
				if(boxValues(10) > 0 and boxValues(11) = 0) then
					boxValues_next(8) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(8);
					boxValues_next(10) <= boxValues(9);
					boxValues_next(11) <= boxValues(10);
				 elsif(boxValues(9) > 0 and boxValues(10) = 0) then
					boxValues_next(8) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(8);
					boxValues_next(10) <= boxValues(9);
				elsif(boxValues(8) > 0 and boxValues(9) = 0) then
					boxValues_next(8) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(8);			
				end if;
				
				--fourth row
				if(boxValues(14) > 0 and boxValues(15) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(13) <= boxValues(12);
					boxValues_next(14) <= boxValues(13);
					boxValues_next(15) <= boxValues(14);
				 elsif(boxValues(13) > 0 and boxValues(14) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(13) <= boxValues(12);
					boxValues_next(14) <= boxValues(13);
				elsif(boxValues(12) > 0 and boxValues(13) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(13) <= boxValues(12);			
				end if;
			
			--left button
			when "0010" =>
				--first row
				if(boxValues(1) > 0 and boxValues(0) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(2) <= boxValues(3);
					boxValues_next(1) <= boxValues(2);
					boxValues_next(0) <= boxValues(1);
				 elsif(boxValues(2) > 0 and boxValues(1) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(2) <= boxValues(3);
					boxValues_next(1) <= boxValues(2);
				elsif(boxValues(3) > 0 and boxValues(2) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(2) <= boxValues(3);			
				end if;
				
				--second row
				if(boxValues(5) > 0 and boxValues(4) = 0) then
					boxValues_next(7) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(7);
					boxValues_next(5) <= boxValues(6);
					boxValues_next(4) <= boxValues(5);
				 elsif(boxValues(6) > 0 and boxValues(5) = 0) then
					boxValues_next(7) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(7);
					boxValues_next(5) <= boxValues(6);
				elsif(boxValues(7) > 0 and boxValues(6) = 0) then
					boxValues_next(7) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(7);			
				end if;
				
				--third row
				if(boxValues(9) > 0 and boxValues(8) = 0) then
					boxValues_next(11) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(11);
					boxValues_next(9) <= boxValues(10);
					boxValues_next(8) <= boxValues(9);
				 elsif(boxValues(10) > 0 and boxValues(9) = 0) then
					boxValues_next(11) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(11);
					boxValues_next(9) <= boxValues(10);
				elsif(boxValues(11) > 0 and boxValues(10) = 0) then
					boxValues_next(11) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(11);			
				end if;
				
				--fourth row
				if(boxValues(13) > 0 and boxValues(12) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(14) <= boxValues(15);
					boxValues_next(13) <= boxValues(14);
					boxValues_next(12) <= boxValues(13);
				 elsif(boxValues(14) > 0 and boxValues(13) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(14) <= boxValues(15);
					boxValues_next(13) <= boxValues(14);
				elsif(boxValues(15) > 0 and boxValues(14) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(14) <= boxValues(15);			
				end if;
				
			--down button
			when "0100" =>
				--first column
				if(boxValues(8) > 0 and boxValues(12) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(4) <= boxValues(0);
					boxValues_next(8) <= boxValues(4);
					boxValues_next(12) <= boxValues(8);
				 elsif(boxValues(4) > 0 and boxValues(8) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(4) <= boxValues(0);
					boxValues_next(8) <= boxValues(4);
				elsif(boxValues(0) > 0 and boxValues(4) = 0) then
					boxValues_next(0) <= TO_UNSIGNED(0, 12);
					boxValues_next(4) <= boxValues(0);			
				end if;
				
				--second column
				if(boxValues(9) > 0 and boxValues(13) = 0) then
					boxValues_next(1) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(1);
					boxValues_next(9) <= boxValues(5);
					boxValues_next(13) <= boxValues(9);
				 elsif(boxValues(5) > 0 and boxValues(9) = 0) then
					boxValues_next(1) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(1);
					boxValues_next(9) <= boxValues(5);
				elsif(boxValues(1) > 0 and boxValues(5) = 0) then
					boxValues_next(1) <= TO_UNSIGNED(0, 12);
					boxValues_next(5) <= boxValues(1);			
				end if;
				
				--third column
				if(boxValues(10) > 0 and boxValues(14) = 0) then
					boxValues_next(2) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(2);
					boxValues_next(10) <= boxValues(6);
					boxValues_next(14) <= boxValues(10);
				 elsif(boxValues(6) > 0 and boxValues(10) = 0) then
					boxValues_next(2) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(2);
					boxValues_next(10) <= boxValues(6);
				elsif(boxValues(2) > 0 and boxValues(6) = 0) then
					boxValues_next(2) <= TO_UNSIGNED(0, 12);
					boxValues_next(6) <= boxValues(2);			
				end if;
				
				--fourth column				
				if(boxValues(11) > 0 and boxValues(15) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(7) <= boxValues(3);
					boxValues_next(11) <= boxValues(7);
					boxValues_next(15) <= boxValues(11);
				 elsif(boxValues(7) > 0 and boxValues(11) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(7) <= boxValues(3);
					boxValues_next(11) <= boxValues(7);
				elsif(boxValues(3) > 0 and boxValues(7) = 0) then
					boxValues_next(3) <= TO_UNSIGNED(0, 12);
					boxValues_next(7) <= boxValues(3);			
				end if;
				
			
			--up button
			when "1000" =>
				--first column
				if(boxValues(4) > 0 and boxValues(0) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(8) <= boxValues(12);
					boxValues_next(4) <= boxValues(8);
					boxValues_next(0) <= boxValues(4);
				 elsif(boxValues(8) > 0 and boxValues(4) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(8) <= boxValues(12);
					boxValues_next(4) <= boxValues(8);
				elsif(boxValues(12) > 0 and boxValues(8) = 0) then
					boxValues_next(12) <= TO_UNSIGNED(0, 12);
					boxValues_next(8) <= boxValues(12);			
				end if;
				
				--second column
				if(boxValues(5) > 0 and boxValues(1) = 0) then
					boxValues_next(13) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(13);
					boxValues_next(5) <= boxValues(9);
					boxValues_next(1) <= boxValues(5);
				 elsif(boxValues(9) > 0 and boxValues(5) = 0) then
					boxValues_next(13) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(13);
					boxValues_next(5) <= boxValues(9);
				elsif(boxValues(13) > 0 and boxValues(9) = 0) then
					boxValues_next(13) <= TO_UNSIGNED(0, 12);
					boxValues_next(9) <= boxValues(13);			
				end if;
				
				--third column
				if(boxValues(6) > 0 and boxValues(2) = 0) then
					boxValues_next(14) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(14);
					boxValues_next(6) <= boxValues(10);
					boxValues_next(2) <= boxValues(6);
				 elsif(boxValues(10) > 0 and boxValues(6) = 0) then
					boxValues_next(14) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(14);
					boxValues_next(6) <= boxValues(10);
				elsif(boxValues(14) > 0 and boxValues(10) = 0) then
					boxValues_next(14) <= TO_UNSIGNED(0, 12);
					boxValues_next(10) <= boxValues(14);			
				end if;	
				
				--fourth column
				if(boxValues(7) > 0 and boxValues(3) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(11) <= boxValues(15);
					boxValues_next(7) <= boxValues(11);
					boxValues_next(3) <= boxValues(7);
				 elsif(boxValues(11) > 0 and boxValues(7) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(11) <= boxValues(15);
					boxValues_next(7) <= boxValues(11);
				elsif(boxValues(15) > 0 and boxValues(11) = 0) then
					boxValues_next(15) <= TO_UNSIGNED(0, 12);
					boxValues_next(11) <= boxValues(15);			
				end if;
				
			when others =>
				state_next <= idle;
		end case;

		
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

	score <= STD_LOGIC_VECTOR(score_reg);
	
	--find the array index of the box to draw
	process(drawBox_combined, box1x,box2x,box3x,box4x,box5x,box6x,box7x,box8x,box9x,
		box10x,box11x,box12x,box13x,box14x,box15x,box16x, boxValues, box1y,box2y,box3y,box4y,box5y,box6y,box7y,box8y,box9y,
		box10y,box11y,box12y,box13y,box14y,box15y,box16y)
	begin
		case drawBox_combined is
			when "0000000000000001" =>
				boxValueToDraw <= boxValues(0);
				boxXToDraw <= box1x;
				boxYToDraw <= box1y;
			when "0000000000000010" =>
				boxValueToDraw <= boxValues(1);
				boxXToDraw <= box2x;
				boxYToDraw <= box2y;
			when "0000000000000100" =>
				boxValueToDraw <= boxValues(2);
				boxXToDraw <= box3x;
				boxYToDraw <= box3y;
			when "0000000000001000" =>
				boxValueToDraw <= boxValues(3);
				boxXToDraw <= box4x;
				boxYToDraw <= box4y;
			when "0000000000010000" =>
				boxValueToDraw <= boxValues(4);
				boxXToDraw <= box5x;
				boxYToDraw <= box5y;
			when "0000000000100000" =>
				boxValueToDraw <= boxValues(5);
				boxXToDraw <= box6x;
				boxYToDraw <= box6y;
			when "0000000001000000" =>
				boxValueToDraw <= boxValues(6);
				boxXToDraw <= box7x;
				boxYToDraw <= box7y;
			when "0000000010000000" =>
				boxValueToDraw <= boxValues(7);
				boxXToDraw <= box8x;
				boxYToDraw <= box8y;
			when "0000000100000000" =>
				boxValueToDraw <= boxValues(8);
				boxXToDraw <= box9x;
				boxYToDraw <= box9y;
			when "0000001000000000" =>
				boxValueToDraw <= boxValues(9);
				boxXToDraw <= box10x;
				boxYToDraw <= box10y;
			when "0000010000000000" =>
				boxValueToDraw <= boxValues(10);
				boxXToDraw <= box11x;
				boxYToDraw <= box11y;
			when "0000100000000000" =>
				boxValueToDraw <= boxValues(11);
				boxXToDraw <= box12x;
				boxYToDraw <= box12y;
			when "0001000000000000" =>
				boxValueToDraw <= boxValues(12);
				boxXToDraw <= box13x;
				boxYToDraw <= box13y;
			when "0010000000000000" =>
				boxValueToDraw <= boxValues(13);
				boxXToDraw <= box14x;
				boxYToDraw <= box14y;
			when "0100000000000000" =>
				boxValueToDraw <= boxValues(14);
				boxXToDraw <= box15x;
				boxYToDraw <= box15y;
			when "1000000000000000" =>
				boxValueToDraw <= boxValues(15);
				boxXToDraw <= box16x;
				boxYToDraw <= box16y;
			when others =>
				boxValueToDraw <= (others => '0');
				boxXToDraw <= (others => '0');
				boxYToDraw <= (others => '0');
		end case;
	end process;
	
	--drawing the box's background
	with boxValueToDraw select
		boxBGRGB <=
			"10001111" when "000000000000",
			"11111110" when "000000000010",
			"11111000" when "000000000100",
			"11110000" when "000000001000",
			"11100000" when "000000010000",
			"11001100" when "000000100000",
			"11011000" when "000001000000",
			"10011000" when "000010000000",
			"00011100" when "000100000000", 
			"00011111" when "001000000000",
			"00011011" when "010000000000",
			"00000011" when others;
			
	boxFinalRGB <= number_color when draw_number = '1' else
						boxBGRGB when UNSIGNED(drawBox_Combined) > 0 else
						"00000000";
	
	--drawing the numbers
	process(boxValueToDraw, pixel_x, pixel_y, boxXToDraw, boxYToDraw)
	begin
		draw_number <= '0';
		number_color <= "00000000";
		case boxValueToDraw is
			--0 
			when "000000000000" =>
			--don't draw anything
			
			--2
			when "000000000010" =>
			 if(boxXToDraw >= 30 and boxXToDraw < 60) then
				if (boxYToDraw >= 20 and boxYToDraw < 30) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 30 and boxYToDraw < 40) then
					if (boxXToDraw >= 30 and boxXToDraw < 42) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 40 and boxYToDraw < 50) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 50 and boxYToDraw < 60) then
					if (boxXToDraw >= 48 and boxXToDraw < 60) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 60 and boxYToDraw < 70) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			
			--4
			when "000000000100" =>
				if(boxXToDraw >= 30 and boxXToDraw < 60) then
					if (boxYToDraw >= 20 and boxYToDraw < 45) then
						if (boxXToDraw >= 50 and boxXToDraw < 60) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 45 and boxYToDraw < 55) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxYToDraw >= 55 and boxYToDraw < 70) then
						if (boxXToDraw >= 30 and boxXToDraw < 42) then 
							number_color <= "11111111";
							draw_number <= '1';
						elsif (boxXToDraw >= 48 and boxXToDraw < 60) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					end if;
				end if;
				
			--8
			when "000000001000" =>
				if(boxXToDraw >= 30 and boxXToDraw < 60) then
					if (boxYToDraw >= 20 and boxYToDraw < 30) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxYToDraw >= 30 and boxYToDraw < 40) then
						if (boxXToDraw >= 30 and boxXToDraw < 40) then
							number_color <= "11111111";
							draw_number <= '1';
						elsif (boxXToDraw >= 50 and boxXToDraw < 60) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 40 and boxYToDraw < 50) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxYToDraw >= 50 and boxYToDraw < 60) then
						if (boxXToDraw >= 30 and boxXToDraw < 40) then
							number_color <= "11111111";
							draw_number <= '1';
						elsif (boxXToDraw >= 50 and boxXToDraw < 60) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 60 and boxYToDraw < 70) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;

			--16
			when "000000010000" =>
			-- for the "1"
				if (boxXToDraw >= 15 and boxXToDraw < 43) then
					if (boxYToDraw >= 24 and boxYToDraw < 34) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxYToDraw >= 34 and boxYToDraw < 53) then
						if (boxXToDraw >= 24 and boxXToDraw < 34) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 53 and boxYToDraw < 64) then
						if (boxXToDraw >= 15 and boxXToDraw < 34) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					end if;
				-- for the "6"
				elsif (boxXToDraw >= 47 and boxXToDraw < 75) then
					if (boxYToDraw >= 24 and boxYToDraw < 32) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxYToDraw >= 32 and boxYToDraw < 40) then
						if (boxXToDraw >= 47 and boxXToDraw < 56) then	
							number_color <= "11111111";
							draw_number <= '1';
						elsif (boxXToDraw >= 66 and boxXToDraw < 75) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 40 and boxYToDraw < 48) then
						if (boxXToDraw >= 47 and boxXToDraw < 56) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 48 and boxYToDraw < 56) then
						if (boxXToDraw >= 47 and boxXToDraw < 56) then
							number_color <= "11111111";
							draw_number <= '1';
						end if;
					elsif (boxYToDraw >= 56 and boxYToDraw < 64) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;		
			
			--32
			when "000000100000" =>
			--for the "3"
			if (boxXToDraw >= 15 and boxXToDraw < 43) then
				if (boxYToDraw >= 24 and boxYToDraw < 32) then
					number_color <= "11111111";
					draw_number <= '1';					
				elsif (boxYToDraw >= 32 and boxYToDraw < 40) then
					if (boxXToDraw >= 34 and boxXToDraw < 43) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 40 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 56) then
					if (boxXToDraw >= 34 and boxXToDraw < 43) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 56 and boxYToDraw < 64) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "2"
			elsif (boxXToDraw >= 47 and boxXToDraw < 75) then
				if (boxYToDraw >= 24 and boxYToDraw < 32) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 32 and boxYToDraw < 40) then
					if (boxXToDraw >= 47 and boxXToDraw < 56) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 40 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 56) then
					if (boxXToDraw >= 66 and boxXToDraw < 75) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 56 and boxYToDraw < 64) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;			
			
			--64
			when "000001000000" =>
			-- for the "6"
			if (boxXToDraw >= 15 and boxXToDraw < 43) then
				if (boxYToDraw >= 24 and boxYToDraw < 32) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 32 and boxYToDraw < 40) then
					if (boxXToDraw >= 15 and boxXToDraw < 24) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 34 and boxXToDraw < 43) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 40 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 56) then
					if (boxXToDraw >= 15 and boxXToDraw < 24) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 56 and boxYToDraw < 64) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			-- for the "4"
			elsif (boxXToDraw >= 47 and boxXToDraw < 75) then
				if (boxYToDraw >= 24 and boxYToDraw < 40) then
					if (boxXToDraw >= 66 and boxXToDraw < 75) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 40 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 64) then
					if (boxXToDraw >= 47 and boxXToDraw < 56) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 66 and boxXToDraw < 75) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;
			end if;

			--128
			when "000010000000" =>
			--for the "1"
			if (boxXToDraw >= 16 and boxXToDraw < 25) then
				if (boxYToDraw >= 24 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			if (boxXToDraw >= 9 and boxXToDraw < 25) then
				if (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			if (boxXToDraw >= 9 and boxXToDraw < 32) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			--for the "2"
			if (boxXToDraw >= 34 and boxXToDraw < 56) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 34 and boxXToDraw < 43) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then 
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 47 and boxXToDraw < 56) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			--for the "8"
			if (boxXToDraw >= 58 and boxXToDraw < 81) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 42) then
					if (boxXToDraw >= 58 and boxXToDraw < 65) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 74 and boxXToDraw < 81) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 57) then
					if (boxXToDraw >= 58 and boxXToDraw < 65) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 74 and boxXToDraw < 81) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			
			-- 256
			when "000100000000" =>
			--for the "2"
			if (boxXToDraw >= 9 and boxXToDraw < 32) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 9 and boxXToDraw < 18) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 22 and boxXToDraw < 32) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "5"
			elsif (boxXToDraw >= 34 and boxXToDraw < 56) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 46 and boxXToDraw < 56) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 34 and boxYToDraw < 42) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "6"
			elsif (boxXToDraw >= 58 and boxXToDraw <= 81) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 58 and boxXToDraw <= 66) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 73 and boxXToDraw < 81) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 58 and boxXToDraw < 66) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			
			--512
			when "001000000000" =>
			-- for the "5"
			if (boxXToDraw >= 9 and boxXToDraw < 32) then
				if (boxYToDraw >= 24 and boxYToDraw <= 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 24 and boxXToDraw < 32) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 9 and boxXToDraw < 18) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			-- for the "1"
			elsif (boxXToDraw >= 34 and boxXToDraw < 56) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 57) then
					if (boxXToDraw >= 40 and boxXToDraw < 49) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					if (boxXToDraw >= 34 and boxXToDraw < 49) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;
			--for the "2"
			elsif (boxXToDraw >= 58 and boxXToDraw < 81) then
				if (boxYToDraw >= 24 and boxYToDraw < 33) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 33 and boxYToDraw < 41) then
					if (boxXToDraw >= 58 and boxXToDraw < 67) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 41 and boxYToDraw < 49) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 49 and boxYToDraw < 57) then
					if (boxXToDraw >= 72 and boxXToDraw < 81) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 57 and boxYToDraw < 66) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
			
			--1024
			when "010000000000" =>
			--for the "1"
			if (boxXToDraw >= 6 and boxXToDraw < 24) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 54) then
					if (boxXToDraw >= 12 and boxXToDraw < 18) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					if (boxXToDraw >= 6 and boxXToDraw < 18) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;
			--for the "0"
			elsif (boxXToDraw >= 26 and boxXToDraw < 44) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 54) then
					if (boxXToDraw >= 26 and boxXToDraw < 32) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 38 and boxXToDraw < 44) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "2"
			elsif (boxXToDraw >= 46 and boxXToDraw < 64) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 42) then
					if (boxXToDraw >= 46 and boxXToDraw < 52) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 54) then
					if (boxXToDraw >= 58 and boxXToDraw < 64) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "4"
			elsif (boxXToDraw >= 66 and boxXToDraw < 84) then
				if (boxYToDraw >= 30 and boxYToDraw < 42) then
					if (boxXToDraw >= 78 and boxXToDraw < 84) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 60) then
					if (boxXToDraw >= 66 and boxXToDraw < 72) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 78 and boxXToDraw < 84) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;
			end if;
			
			--2048
			when others =>
			--for the "2"
			if (boxXToDraw >= 6 and boxXToDraw < 24) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 42) then
					if (boxXToDraw >= 6 and boxXToDraw < 12) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 54) then
					if (boxXToDraw >= 18 and boxXToDraw < 24) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "0"
			elsif (boxXToDraw >= 26 and boxXToDraw < 44) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 54) then
					if (boxXToDraw >= 26 and boxXToDraw < 32) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 38 and boxXToDraw < 44) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			--for the "4"
			elsif (boxXToDraw >= 46 and boxXToDraw < 64) then
				if (boxYToDraw >= 30 and boxYToDraw < 42) then
					if (boxXToDraw >= 58 and boxXToDraw < 64) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 60) then
					if (boxXToDraw >= 46 and boxXToDraw < 52) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 58 and boxXToDraw < 64) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				end if;
			--for the "8"
			elsif (boxXToDraw >= 66 and boxXToDraw < 84) then
				if (boxYToDraw >= 30 and boxYToDraw < 36) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 36 and boxYToDraw < 42) then
					if (boxXToDraw >= 66 and boxXToDraw < 72) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 78 and boxXToDraw < 84) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 42 and boxYToDraw < 48) then
					number_color <= "11111111";
					draw_number <= '1';
				elsif (boxYToDraw >= 48 and boxYToDraw < 54) then
					if (boxXToDraw >= 66 and boxXToDraw < 72) then
						number_color <= "11111111";
						draw_number <= '1';
					elsif (boxXToDraw >= 78 and boxXToDraw < 84) then
						number_color <= "11111111";
						draw_number <= '1';
					end if;
				elsif (boxYToDraw >= 54 and boxYToDraw < 60) then
					number_color <= "11111111";
					draw_number <= '1';
				end if;
			end if;
		end case;
	end process;
	--combined box drawing logic

	drawBox_combined <= drawBox16 & drawBox15 & drawBox14 & drawBox13 & drawBox12 & drawBox11 & drawBox10 &
								drawBox9 & drawBox8 & drawBox7 & drawBox6 & drawBox5 & drawBox4 & drawBox3 & drawBox2 &
								drawBox1;
end Behavioral;

