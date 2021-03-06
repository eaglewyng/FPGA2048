----------------------------------------------------------------------------------
-- Engineers: Parker Ridd and Travis Chambers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Game is
	port	(
				clk : in std_logic;
				sw0 : in std_logic;
				btn : in std_logic_vector(3 downto 0);		
				seg : out std_logic_vector(6 downto 0);
				dp : out std_logic;
				an : out std_logic_vector(3 downto 0);
				vgaRed : out std_logic_vector(2 downto 0);
				vgaGreen : out std_logic_vector(2 downto 0);
				vgaBlue : out std_logic_vector(1 downto 0);
				HS : out std_logic;
				VS : out std_logic
			);

end Game;

architecture Behavioral of Game is

--GAME SIGNALS
signal rst : std_logic;
type state is (start, playing, endGame);
signal state_reg, state_next : state; 
signal rgbOut : std_logic_vector(7 downto 0);
signal rgbFromGrid : std_logic_vector(7 downto 0);
--INPUTS to GRID
signal grid_color : std_logic_vector(7 downto 0);

--outputs from GRID
signal isVictory : std_logic;
signal game_over : std_logic;
signal draw_grid : std_logic;

--outputs from VGA
signal blank : std_logic;

--wires between entities
signal pixel_x : std_logic_vector(9 downto 0);
signal pixel_y : std_logic_vector(9 downto 0);

--debouncing signals
	--function--
	function log2c(n: integer) return integer is
		variable m, p: integer;
	begin
		m := 0;
		p := 1;
		while p < n loop
			m := m + 1;
			p := p * 2;
		end loop;
		return m;
	end log2c;
	
	--HS and VS registers
	signal hs_reg, hs_next, vs_reg, vs_next : STD_LOGIC;
	signal hs_fromVGA, vs_fromVGA : STD_LOGIC;
	
	--============================================================================
	------------------Constant values---------------------------------------------
	--============================================================================
	constant COUNTER_SIZE : natural := 19;
	signal btn_int1Debounced, btn_int1Debounced_next, btn_int2Debounced, btn_int2Debounced_next : STD_LOGIC_VECTOR(3 downto 0);                 
   signal deb_counter_out, deb_counter_next : UNSIGNED(COUNTER_SIZE downto 0) := (OTHERS => '0'); --counter output
	signal btn_debounced, btn_debounced_next : STD_LOGIC_VECTOR(3 downto 0);
	signal counter_set : STD_LOGIC;
	signal ssd_data_in : STD_LOGIC_VECTOR(15 downto 0);
	
	
	



begin
	--============================================================================
	------------------Registers---------------------------------------------------
	--============================================================================
	
	rst <= not sw0;
	--state register
	process(clk, rst)
	begin
		if rst = '1' then
			state_reg <= start;
		elsif rising_edge(clk) then
			state_reg <= state_next;
			hs_reg <= hs_next;
			vs_reg <= vs_next;
		end if;
	end process;
	
	vs_next <= vs_fromVGA;
	hs_next <= hs_fromVGA;
	VS <= vs_reg;
	HS <= hs_reg;

	--FSM
	process(state_reg, sw0, game_over, isVictory)
	begin
		case state_reg is 
			when start =>
				--display blank grid (no boxes)
				grid_color <= "11101011";
				if (sw0 = '1') then
					state_next <= playing;
				else
					state_next <= start;
				end if;
			when playing =>
				--generate 2 boxes of value 2 at random squares in the grid
				--each button press will generate a new box and merge/move existing boxes
				grid_color <= "10001110";
				if (game_over = '1') then
					state_next <= endGame;
				else
					state_next <= playing;
				end if;
			when endGame =>
				--move back to start when sw0 = 0;
				grid_color <= "11101011";
				if (sw0 = '1') then
					state_next <= endGame;
					if (isVictory = '1') then
						grid_color <= "11000100";
					else
						grid_color <= "11101001";
					end if;
				else
					state_next <= start;
				end if;

			end case;
	end process;

	-------------------------------------------------------------
	--		Game Logic for VGA
	-------------------------------------------------------------
					  
	vgaRed <= rgbOut(7 downto 5);
	vgaGreen <= rgbOut(4 downto 2);
	vgaBlue <= rgbOut(1 downto 0);

	rgbOut <= rgbFromGrid when draw_grid = '1'  else
				 "00000000" when blank = '1' else
				 "11111111";

	-------------------------------------------------------------
	--			Entity Instantiations
	-------------------------------------------------------------
	Grid1 : entity work.Grid
	port map( 
				clk => clk,
				rst => rst,
				grid_color =>grid_color,
				pixel_x => pixel_x,
				pixel_y => pixel_y,
				btn => btn_debounced,
				draw_grid => draw_grid,
				rgbOut => rgbFromGrid,
				gameOver => game_over,
				score => ssd_data_in
				);

	SevenSeg : entity work.seven_segment_display
	port map(
				clk => clk,
				data_in => ssd_data_in, 
				dp_in => "1111",
				blank => "0000",
				seg => seg,
				dp => dp,
				an => an
				);

	VGA : entity work.vga_timing
	port map (
					clk => clk,
					rst => rst,
					HS => hs_fromVGA,
					VS => vs_fromVGA,
					pixel_x => pixel_x,
					pixel_y => pixel_y,
					last_column => open,
					last_row => open,
					blank => blank
				 );
				 
		--============================================================================
		------------------Debouncer Circuit-------------------------------------------
		--============================================================================
	process(clk, rst)
	begin
		if(rst = '1') then
			btn_int1debounced <= (others => '0');
			btn_int2debounced <= (others => '0');
			btn_debounced <= (others => '0');
			deb_counter_out <= (others => '0');
		elsif(clk'event and clk = '1') then
			btn_int1debounced <= btn_int1debounced_next;
			btn_int2debounced <= btn_int2debounced_next;
			btn_debounced <= btn_debounced_next;
			deb_counter_out <= deb_counter_next;
		end if;
	end process;
	
	counter_set <= '1' when btn_int2debounced /= btn_int1debounced else
						'0';
	deb_counter_next <= (others => '0') when counter_set = '1' else
								deb_counter_out + 1;
	
	btn_int1debounced_next <= btn;
	btn_int2debounced_next <= btn_int1debounced;
	btn_debounced_next <= btn_int2debounced when deb_counter_out(COUNTER_SIZE) = '1' else
								btn_debounced;

	end Behavioral;
